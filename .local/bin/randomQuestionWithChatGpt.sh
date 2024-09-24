#!/bin/bash

# Asegúrate de que el usuario pasa el argumento para el número de veces
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Uso: ./auto_siguiente.sh <número_de_veces> [tiempo_entre_preguntas] <texto>"
    exit 1
fi

# Cantidad de veces que se ejecutará el bucle
repeticiones=$1
# Tiempo de espera entre preguntas (en segundos), default a 60 si no se especifica
tiempo_entre_preguntas=${3:-60}
# Texto a escribir (siguiente o next)
texto=$2
contador=0

echo "Comenzando en 3 segundos. Cambia al chat durante este tiempo..."
sleep 3

while [ $contador -lt $repeticiones ]; do
    # Cambia al chat donde tienes la conversación abierta
    xdotool search --name "Chat" windowactivate

    # Escribe el texto especificado
    xdotool type "$texto"
    
    # Espera 1 segundo antes de presionar Enter
    sleep 1
    xdotool key Return

    # Incrementa el contador
    contador=$((contador + 1))

    # Espera el tiempo especificado entre preguntas
    sleep "$tiempo_entre_preguntas"
done

echo "Proceso completado. Se ejecutó $repeticiones veces."
