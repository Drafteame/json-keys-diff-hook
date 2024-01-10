#!/usr/bin/env bash

match=".*"
staged_files=()

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

# Filter files with the specified regular expression
filtered_files=()
for file in "${staged_files[@]}"; do
  if [[ $file =~ $match ]]; then
    filtered_files+=("$file")
  fi
done

# Check if there are filtered files
if [ ${#filtered_files[@]} -eq 0 ]; then
  exit 0
fi

# Execute jkdiff with the filtered files
jkdiff_cmd=("jkdiff" "files" "${filtered_files[@]}")
"${jkdiff_cmd[@]}"

# Exit with the exit status of the last executed command
exit $?
