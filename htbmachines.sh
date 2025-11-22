#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
 echo -e "\n\n${redColour}[!] Saliendo...${endColour}"
 exit 1

}

#ctrl+c
trap ctrl_c INT

#Variable globales
main_URL="https://htbmachines.github.io/bundle.js"

function helpPanel ()
{
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Uso:${endColour}"
  echo -e "${blueColour}\tu)${endColour}${grayColour} Actualizar archivos necesarios${endColour}"
  echo -e "${blueColour}\tm)${endColour}${grayColour} Busca por un el nombre de una maquina${endColour}"
  echo -e "${blueColour}\ti)${endColour}${grayColour} Busca por la IP de una maquina${endColour}"
  echo -e "${blueColour}\td)${endColour}${grayColour} Busca por la dificultad de una maquina${endColour}"
  echo -e "${blueColour}\to)${endColour}${grayColour} Busca por el sistema operativo de la maquina ${endColour}"
  echo -e "${blueColour}\ty)${endColour}${grayColour} Obtener link de la resolucion de una maquina en Youtube${endColour}"
  echo -e "${blueColour}\th)${endColour}${grayColour} Mostrar el panel de ayuda${endColour}\n"
  }


function updateFiles(){
if [ ! -f "bundle.js" ]; then

  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los archivos necesarios no existen.${endColour}\n"
  sleep 1
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Descargando archivos necesarios.${endColour}\n"
 curl -s $main_URL > bundle.js
 js-beautify bundle.js | sponge bundle.js
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Archivos necesarios descargados.${endColour}\n"
else
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los archivos necesarios existen.${endColour}\n"
  sleep 1
  echo -e "\n${yellowColour}[+]${endColour}${grayColour} Comprobando actualizaciones.${endColour}\n"
  curl -s $main_URL > .copy.js
  js-beautify .copy.js | sponge .copy.js
  oldHash=$(md5sum bundle.js | awk '{print $1}')
  newHash=$(md5sum .copy.js | awk '{print $1}')
  if [ "$newHash" == "$oldHash" ]; then
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Los archivos estan actualizados.${endColour}\n"
  else
    cp .copy.js bundle.js && rm .copy.js 
    echo -e "\n${yellowColour}[+]${endColour}${grayColour} Archivos fueron actualizados.${endColour}\n"
  fi
fi
}

function searchMachine(){
  machineName="$1" 
  name=$(cat bundle.js | iconv -f UTF-8 -t ASCII//TRANSLIT | grep "name: \"$machineName\"" | awk 'NF{print $NF}' | tr -d "\"" | tr -d ",")
  if [ ! $name ]; then
  echo -e "\n${redColour}[!]${endColour}${grayColour} El nombre de la maquina listada no existe.${endColour} ${redColour}[!]${endColour}"
  else
   echo -e "\n${yellowColour}[+]${endColour}${grayColour} Listando las propiedades de la maquina${endColour} ${purpleColour}$name${endColour}${grayColour}.${endColour}"
  cat bundle.js | iconv -f UTF-8 -t ASCII//TRANSLIT | awk "/name: \"$name\"/,/resuelta/" | grep -vE "id: sf()|sku|like|resuelta" | tr -d "\"" | tr -d "," | sed 's|^ *||' | sed 's/./\u&/' | bat --style=plain --paging=never
 fi

}

function searchIP(){
  searchIP="$1"
  IPName=$(cat bundle.js | grep "$searchIP" -B 3 | grep "name" | awk 'NF{print $NF}' | tr -d "\"" | tr -d ",")

  if [ ! $IPName ]; then
   echo -e "\n${redColour}[!]${endColour}${grayColour} La IP listada no existe.${endColour} ${redColour}[!]${endColour}"
  else
   echo -e "\n${yellowColour}[+]${endColour}${grayColour} El nombre de la maquina es${endColour} ${purpleColour}$IPName${endColour}${grayColour}.${endColour}"
searchMachine $IPName
  fi

}

function YoutubeLink(){
  machineName="$1"
  link=$(cat bundle.js | awk "/name: \"$machineName\"/,/resuelta/" | grep -vE "id: sf()|sku|like|resuelta" | tr -d "\"" | tr -d "," | sed 's|^ *||' | grep "youtube" | awk 'NF{print $NF}' | bat --style=plain --paging=never)

  if [ ! "$link" ]; then
  echo -e "\n${redColour}[!]${endColour}${grayColour} El nombre de la maquina listada no existe.${endColour} ${redColour}[!]${endColour}"
  else
   echo -e "\n${grayColour} El link de youtube de la resolucion de la maquina ${purpleColour}$machineName${endColour} ${grayColour}es${endColour} ${purpleColour}$link${endColour}"
  fi

}

function searchDifficulty(){
  difficulty="$1"
  results=$(cat bundle.js | iconv -f UTF-8 -t ASCII//TRANSLIT | grep "dificultad: \"$difficulty\"" -B5  | grep "name:" | awk 'NF{print $NF}' | tr -d " " | tr -d "\"" | tr -d "," | column)

  if [ ! "$results" ]; then
  echo -e "\n${redColour}[!]${endColour}${grayColour} La dificultad no existe.${endColour} ${redColour}[!]${endColour}"
  else
  echo -e "${yellowColour}[+]${endColour}${grayColour} Las maquina listadas como dificultad ${endColour} ${purpleColour}$difficulty${endColour} ${grayColour} son las siguientes:${endColour}"
  echo -e "$results"
  fi
}

function searchOS(){
  OS="$1"
  OS_results=$(cat bundle.js | grep "so: \"$OS\"" -B 4 | grep "name:" | awk '{print $2}' | tr -d "\"" | tr -d "," | column)

  if [ ! "$OS_results" ]; then
  echo -e "\n${redColour}[!]${endColour}${grayColour} La dificultad no existe.${endColour} ${redColour}[!]${endColour}"
  else
    if [ $OS == "Linux" ]; then
     echo -e "${yellowColour}[+]${endColour}${grayColour} Las maquina listadas con el sistema operativo${endColour} ${greenColour}$OS${endColour}${grayColour} son las siguientes:${endColour}"
     echo -e "$OS_results"
    elif [ $OS == "Windows" ]; then
     echo -e "${yellowColour}[+]${endColour}${grayColour} Las maquina listadas con el sistema operativo${endColour} ${blueColour}$OS${endColour}${grayColour} son las siguientes:${endColour}"
     echo -e "$OS_results"
     
    fi
  fi
}

function getOSDifficulty(){
  difficulty="$1"
  OS="$2"
  OS_results=$(cat bundle.js | iconv -f UTF-8 -t ASCII//TRANSLIT | grep "so: \"$OS\"" -B 4 | grep "name:" | awk '{print $2}' | tr -d "\"" | tr -d "," | column)
  results=$(cat bundle.js | iconv -f UTF-8 -t ASCII//TRANSLIT |grep "dificultad: \"$difficulty\"" -B5  | grep "name:" | awk 'NF{print $NF}' | tr -d " " | tr -d "\"" | tr -d "," | column)

  if [ ! "$OS_results" ] && [ ! "$results" ]; then
   echo -e "\n${redColour}[!]${endColour}${grayColour} El OS${endColour} ${purpleColour}$OS${endColour} ${grayColour}ni la dificultad${endColour} ${purpleColour}$difficulty${endColour} ${grayColour}existen.${endColour} ${redColour}[!]${endColour}\n"

 elif [ ! "$OS_results" ] && [  "$results" ]; then
  echo -e "\n${redColour}[!]${endColour}${grayColour} La dificultad${endColour} ${purpleColour}$dificultad${endColour} ${grayColour}es correcta, pero el OS${endColour} ${purpleColour}$OS${endColour} ${grayColour}no existe.${endColour}  ${redColour}[!]${endColour}\n"

  elif [  "$OS_results" ] && [ ! "$results" ]; then
  echo -e "\n${redColour}[!]${endColour}${grayColour} El OS${endColour} ${purpleColour}$OS${endColour} ${grayColour}es correcto, pero la dificultad${endColour} ${purpleColour}$difficulty${endColour} ${grayColour}no existe.${endColour}  ${redColour}[!]${endColour}\n"

  elif [  "$OS_results" ] && [  "$results" ]; then
  echo -e "\n${grayColour} Las maquina listadas bajos el OS ${endColour} ${purpleColour}$OS${endColour} ${grayColour}y la dificultad${endColour} ${purpleColour}$difficulty${endColour} ${grayColour}son las siguientes:${endColour}\n"
cat bundle.js | iconv -f UTF-8 -t ASCII//TRANSLIT | grep "dificultad: \"$difficulty\"" -B5  | grep "so: \"$OS\"" -B 4 | grep "name:" | awk '{print $2}' | tr -d /\"/ | tr -d /,/ | column
  fi
}



#Indicadores
declare -i parameter_counter=0 


#Chivatos
declare -i chivato_difficulty=0
declare -i chivato_os=0

while getopts 'm:ui:y:d:o:h' arg; do
 case $arg in 
   m) machineName=$OPTARG; let parameter_counter+=1;;
   u) let parameter_counter+=2;;
   i) ipAddress=$OPTARG; let parameter_counter+=3;;
   y) machineName=$OPTARG; let parameter_counter+=4;;
   d) difficulty=$OPTARG; chivato_difficulty=1; let parameter_counter+=5;;
   o) OS=$OPTARG; chivato_os=1; let parameter_counter+=6;;
   h) ;;  
 esac
done

if [ $parameter_counter -eq 1 ]; then
  searchMachine $machineName

elif [ $parameter_counter -eq 2 ]; then
 updateFiles
elif [ $parameter_counter -eq 3 ]; then
 searchIP $ipAddress
elif [ $parameter_counter -eq 4 ]; then
  YoutubeLink $machineName
elif [ $parameter_counter -eq 5 ]; then
  searchDifficulty $difficulty
elif [ $parameter_counter -eq 6 ]; then 
  searchOS $OS
elif [ $chivato_difficulty -eq 1 ] && [ $chivato_os -eq 1 ]; then
  getOSDifficulty $difficulty $OS
else
  helpPanel
fi
