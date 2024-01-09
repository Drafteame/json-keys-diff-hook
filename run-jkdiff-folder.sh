#!/usr/bin/env bash

# Verificar que se haya proporcionado una expresión regular como argumento
if [ "$#" -eq 0 ]; then
  echo "Por favor, proporciona una expresión regular como argumento."
  exit 1
fi

# Obtener la expresión regular del primer argumento
regex="$1"
shift

# Obtener la lista de archivos modificados por el commit
files=$(git diff --cached --name-only --diff-filter=ACM)

# Variable para almacenar los paths a los folders que contienen archivos coincidentes
saved_folders=()

# Iterar los archivos modificados
for file in $files; do
  # Comparar el archivo con la expresión regular
  if [[ $file =~ $regex ]]; then
    # Obtener el folder que contiene el archivo
    folder=$(dirname "$file")

    # Verificar si el folder ya está guardado
    if [[ ! " ${saved_folders[@]} " =~ " ${folder} " ]]; then
      saved_folders+=("$folder")
    fi
  fi
done

# Verificar si hay folders para comparar
if [ ${#saved_folders[@]} -eq 0 ]; then
  exit 0
fi

# Iterar los folders guardados y ejecutar jkdiff
for saved_folder in "${saved_folders[@]}"; do
  jkdiff_cmd=("jkdiff" folder "$saved_folder" "-p" "$regex")
  "${jkdiff_cmd[@]}"
  echo
done

# Salir con el estado de salida del último comando ejecutado
exit $?
