#!/bin/bash

# Algunos colores porque por que no 

# Reset
NC='\033[0m'              # No-Color

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

: << '###COMENTARIO'
algo algo, esto no se ejecuta
###COMENTARIO

#0. Para descargar archivos de google drive usando wget https://stackoverflow.com/a/39087286
# wget "https://drive.google.com/uc?export=download&id=1mTAp0Cl64SkRGwOp2GmROEtdRzf2Xz82"

echo -e "
${BCyan}Paso 0. Descargando todos o el que falte:
${BGreen}atpplayers.in superliga.in weather_cordoba.in${NC}"

# Lo hago solo si alguno de los archivos no existe 

if [ ! -f ./atpplayers.in ]; then
  echo -e "${BYellow}atpplayers.in not found, descargando ${NC}"
  echo -e "${BGreen}wget -O atpplayers.in 'https://drive.google.com/uc?export=download&id=1mTAp0Cl64SkRGwOp2GmROEtdRzf2Xz82'${NC}"
  wget -O atpplayers.in "https://drive.google.com/uc?export=download&id=1mTAp0Cl64SkRGwOp2GmROEtdRzf2Xz82"
fi

# Pero descarga con un nombre de archivo basura. 
# -O para decidir el nombre del archivo 

if [ ! -f ./superliga.in ]; then
  echo -e "${BYellow}superliga.in not found, descargando${NC}"
  echo -e  "${BGreen}wget -O superliga.in 'https://drive.google.com/uc?export=download&id=1rGgD_rOPnxNlgma3FHmd8Ng3TuE68o7C'${NC}"
  wget -O superliga.in "https://drive.google.com/uc?export=download&id=1rGgD_rOPnxNlgma3FHmd8Ng3TuE68o7C"
fi

if [ ! -f ./weather_cordoba.in ]; then
  echo -e "${BYellow}weather_cordoba.in not found, descargando${NC}"
  echo -e "${BGreen}wget -O weather_cordoba.in 'https://drive.google.com/uc?export=download&id=1RwKgTyY25DZphAU2vsKMtvb4PI_CtoIc' ${NC}"
  wget -O weather_cordoba.in "https://drive.google.com/uc?export=download&id=1RwKgTyY25DZphAU2vsKMtvb4PI_CtoIc"
fi

# Tambien puedo usar curl, hay sutiles diferencias https://daniel.haxx.se/docs/curl-vs-wget.html
# curl -o atpplayers.in "<link>"
# Si el archivo es de texto plano se suele usar curl directamente. Wget se necesita en otros casos.

# 1. Grepeo el model y como se repite por nucleo solo agarro las primeras dos lineas. Puedo hacer tambien cat | grep 
echo -e "
${BCyan}Ejercicio 1:
${BGreen}cat /proc/cpuinfo | egrep 'model name' | head${NC}"
cat /proc/cpuinfo | egrep 'model name' | head

# 2. Como 1 linea se repite 1 vez por nucleo entonces tengo este numero de nucleos
echo -e "
${BCyan}Ejercicio 2:
${BGreen}cat /proc/cpuinfo | egrep 'model name' | wc -l${NC}"
cat /proc/cpuinfo | egrep 'model name' | wc -l 

# 3. Descargo heroes.csv si no existe
if [ ! -f ./heroes.csv ]; then
echo -e "
${BYellow}heroes.csv not found, descargando. ${NC}"
echo -e ${BGreen}"curl -o heroes.csv 'https://raw.githubusercontent.com/dariomalchiodi/superhero-datascience/master/content/data/heroes.csv'"}
curl -o heroes.csv "https://raw.githubusercontent.com/dariomalchiodi/superhero-datascience/master/content/data/heroes.csv"
fi

# wget -o heroes.csv "https://raw.githubusercontent.com/dariomalchiodi/superhero-datascience/master/content/data/heroes.csv"
# *Por que curl anda y wget no?*

# Solo quiero los nombres que estan en la primera columna y todas las filas excepto la primera
# awk -F ';' 'NR > 1 {print $2}' heroes.csv

# Paso todo lo capturado a minuscula
# awk -F ';' 'NR > 1 {print tolower($2)}' heroes.csv

# Hay lineas que solo son espacios, seleccion aquellas que no comienzan con espacios
# awk -F ';' 'NR > 1 && $2 !~ /^[[:space:]]*$/ {print tolower($2)}' heroes.csv

# Para eliminar los espacios en blanco puedo usar gsub. 
# El string gsub(/[[:space:]]+/) es una expresion regular que dice cualquier cantidad de espacios consecutivos. A eso lo reemplazo por el string vacio "" en la columna 2, luego lo imprimo en minuscula
# awk -F ';' 'NR > 1 && $2 !~ /^[[:space:]]*$/ {gsub(/[[:space:]]+/, "", $2); print tolower($2)}' heroes.csv

echo -e "
${BCyan}Ejercicio 3:
${BGreen}awk -F ';' 'NR > 1 && $2 !~ /^[[:space:]]*$/ {gsub(/[[:space:]]+/, "", $2); print tolower($2)}' heroes.csv | head ${NC}"

awk -F ';' 'NR > 1 && $2 !~ /^[[:space:]]*$/ {gsub(/[[:space:]]+/, "", $2); print tolower($2)}' heroes.csv | head

# 5. Para sortear segun el numero en la columan j puedo hacer
# sort -k j <file.in>, entonces en mi caso me queda 
# sort -k 5 weather_cordoba.in

# Ademas como la temperatura son numeros, debo usar -n
# sort -k -n 5 weather_cordoba.in

# Ahora si quiero ver solo la fecha de cada dia, puedo pipearlo en awk, pues la fecha esta en las columnas 1 2 y 3 
# sort -k -n 5 weather_cordoba.in | awk -F ' ' '{print "año: "$1", mes: "$2", dia: "$3}'

# 5. Es mas simple, ordenar segun su posicion en el ranking (ranking columna 3)
# Como ahora el ranking es numerico, debo usar -n

echo -e "
${BCyan}Ejercicio 5:
${BGreen}sort -k 3 -n atpplayers.in | head${NC}"
sort -k 3 -n atpplayers.in | head

# 6. 
# Sort ademas de sortear por 1 criterio puede sortear por varios, primero considerando el primero, luego el segundo, y asi 
# sort -k<columna_inicial>[,<columna_final>][<modificador>]
# es decir
# sort -k 2,2nr -k 10,10nr
# O bien como la inicial es igual a la final
# sort -k 2nr -k 10nr
# El n es que uso una ordenacion numerica y no lexicografica, el r significa que voy de mayor a menor

# Entonces, con awk puedo crear una columna con la diferencia y usar el puntaje como primer criterio y la difeencia como seguno criterio en sort para resolver el ejercicio
# awk '{diferencia=$7-$8; print $0, "diff:" diferencia}' superliga.in | sort -k2,2nr -k10,10nr 

# Ahora deberia borrar las columnas auxiliares que use, lo hago reemplazando la ultima columna con el string vacio. La ultima columna en awk se simboliza con la variable NF
# awk '{diferencia=$7-$8; print $0, "diff:" diferencia}' superliga.in | sort -k2,2nr -k10,10nr | awk '{$NF=""; print}' superliga.in 

# Aparentemente esto funciona pero me deja la ultima columna con un espacio vacio. Lo puedo borrar con sed

echo -e "
${BCyan}Ejercicio 6:
${BGreen}awk '{diferencia=\$7-\$8; print \$0, \"diff:\" diferencia}' superliga.in | sort -k2,2nr -k10,10nr | awk '{\$NF=\"\"; print}' superliga.in | sed 's/ *$//' | head ${NC}"
awk '{diferencia=$7-$8; print $0, "diff:" diferencia}' superliga.in | sort -k2,2nr -k10,10nr | awk '{$NF=""; print}' superliga.in | sed 's/ *$//' | head

# 7. ip muestra cosas, demasiadas. Me interesa mac address que buscando esta en la parte donde ddice link/ether. Grepeo con solo eso

echo -e "
${BCyan}Ejercicio 7:
${BGreen}ip link show | grep link/ether ${NC}"
ip link show | grep link/ether

#8. 
echo -e "
${BCyan}Ejercicio 8:"
# veo si el directorio de testeo de las peliculas existe, si no lo creo
# seteo directorio como variable
DIR_PELIS=./peliculas
if [ ! -d "${DIR_PELIS}" ]; then
  echo -e "${BYellow}El directorio de peliculas no existe, creando."
  echo -e "${BGreen}mkdir ${DIR_PELIS}"
  mkdir "${DIR_PELIS}"
  echo -e "${BYellow}Poblando directorio de archivos modelo"
  echo -e "${BGreen}touch fma_S01E{1..10}_es.srt"
  touch ${DIR_PELIS}/fma_S01E{1..10}_es.srt
fi

# Borra el _es al final del archivo usando una substitucion como en sed
echo -e "${BYellow}Renombrando archivos, ${DIR_PELIS}/<peli>_es.srt --> ${DIR_PELIS}/<peli>.srt"

echo -e "${BGreen}for peli in \${DIR_PELIS}/*; do if echo "\${peli}" | grep -q '_es.srt'; then nuevo_nombre_peli=\${peli/_es.srt/.srt}; mv "\${peli}" "\${nuevo_nombre_peli}"; fi done"

echo -e "${Yellow}             Renombres:"
for peli in ${DIR_PELIS}/*; do 
  if echo "${peli}" | grep -q '_es.srt'; then # Si la peli tiene _es.srt en el nombre esto da 1 (TRUE)
    nuevo_nombre_peli=${peli/_es.srt/.srt} # usando sustitucion como en sed
    echo -e "${Yellow}             ${peli} --> ${nuevo_nombre_peli}"
    mv "${peli}" "${nuevo_nombre_peli}"; 
  fi
done


