#!/usr/bin/env bash

# Verificar que se haya proporcionado una expresión regular como argumento
if [ "$#" -eq 0 ]; then
  echo "Por favor, proporciona una expresión regular como argumento para ejecutar jkdiff."
  exit 1
fi

# Obtener la expresión regular del primer argumento
regex="$1"
shift

# Obtener la lista de archivos modificados por el commit
files=$(git diff --cached --name-only --diff-filter=ACM)

# Filtrar los archivos con la expresión regular proporcionada
filtered_files=()
for file in $files; do
  if [[ $file =~ $regex ]]; then
    filtered_files+=("$file")
  fi
done

# Verificar si hay archivos para comparar
if [ ${#filtered_files[@]} -eq 0 ]; then
  exit 0
fi

# Ejecutar jkdiff con los archivos obtenidos
jkdiff_cmd=("jkdiff" "files" "${filtered_files[@]}")
"${jkdiff_cmd[@]}"

echo

# Salir con el estado de salida del último comando ejecutado
exit $?
