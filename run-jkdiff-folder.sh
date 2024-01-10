#!/usr/bin/env bash

match="json$"

# Parse command-line options
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --match=*)
      match="${1#*=}"
      ;;
    --match)
      match="$2"
      shift
      ;;
    *)
      # Assume the remaining arguments are staged files
      staged_files+=("$1")
      ;;
  esac
  shift
done

function file_matches() {
  local file="$1"
  [[ $file =~ $match ]]
}

# Variable para almacenar los paths a los folders que contienen archivos coincidentes
saved_folders=()

# Iterate over staged files
for file in "${staged_files[@]}"; do
  # Check if the file matches the regular expression
  if file_matches "$file"; then
    # Obtain the folder containing the file
    folder=$(dirname "$file")

    # Check if the folder is already saved
    if [[ ! " ${saved_folders[@]} " =~ " ${folder} " ]]; then
      saved_folders+=("$folder")
    fi
  fi
done

# Check if there are saved folders
if [ ${#saved_folders[@]} -eq 0 ]; then
  exit 0
fi

# Iterate over saved folders and execute jkdiff
for saved_folder in "${saved_folders[@]}"; do
  jkdiff_cmd=("jkdiff" "folder" "$saved_folder" "-p" "$match")
  "${jkdiff_cmd[@]}"
done

# Exit with the exit status of the last executed command
exit $?
