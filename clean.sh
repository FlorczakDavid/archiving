#!/bin/sh
DOWNLOAD_FOLDER_NAME=$1
ARCHIVES_FOLDER_NAME=$2
TMP_FOLDER_NAME=$3

GREEN='\033[0;32m'
NC='\033[0m' 

echo "> Bash script starting at: $(date +'%Y-%m-%dT%H:%M:%S.%3N%z')"
echo "Script full path: $(pwd)/clean.sh"

echo "> Removing download directory '${DOWNLOAD_FOLDER_NAME}'…" 
rm -r $DOWNLOAD_FOLDER_NAME
echo "${GREEN}Done${NC}"

echo "> Deleting old archives from '${ARCHIVES_FOLDER_NAME}'… " 
> tmp/headers.txt
ARCHIVES=($(ls -t $ARCHIVES_FOLDER_NAME))
if [ ${#ARCHIVES[@]} -gt 2 ]
then
    for file in ${ARCHIVES[@]:2}
    do
        rm $ARCHIVES_FOLDER_NAME/$file
    done
fi
echo "${GREEN}Done${NC}"

echo "> Emptying temporary directory '${TMP_FOLDER_NAME}'…" 
rm ${TMP_FOLDER_NAME}/*
echo "${GREEN}Done${NC}" 
echo "> Bash script ending at: $(date +'%Y-%m-%dT%H:%M:%S.%3N%z')"
echo "Bye!"
