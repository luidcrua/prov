#!/bin/bash

OUTPUT_PATH="output"
ATT_FILE="${OUTPUT_PATH}/challenges_attachments.csv"
ATT_PATH="${OUTPUT_PATH}/attachments"

if [ ! -d "${OUTPUT_PATH}" ]; then
    # Output directory doesn't exist
    echo "***** Directory ${OUTPUT_PATH} DOES NOT exist."
    exit 0
fi

if ! test -f "$ATT_FILE"; then
    # File doesn't exist
    echo "***** ${ATT_FILE} DOES NOT exist."
    exit 0
fi


sed -i 's/"//g' $ATT_FILE

if [ ! -d "${ATT_PATH}" ]; then
    # There's no attachments directory, let's create it
    mkdir ${ATT_PATH}
else
    # There's an attachments directory already, let's erase it and create it again 
    rm -R ${ATT_PATH}
    mkdir ${ATT_PATH}
fi

while read line; do
    # echo $line
    DOWN="wget https://app.ideadrop.co/${line} -P ${ATT_PATH}"
    echo $DOWN
    eval $DOWN
done < $ATT_FILE
