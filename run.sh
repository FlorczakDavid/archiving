#!/bin/sh
URLS_FILENAME=$1
DOWNLOAD_FOLDER_NAME=$2
ARCHIVES_FOLDER_NAME=$3

BLUE='\033[0;34m'
GREEN='\033[0;32m'
NC='\033[0m' 
UNDERLINE=`tput smul`
NO_UNDERLINE=`tput rmul`

echo "> Bash script starting at: $(date +'%Y-%m-%dT%H:%M:%S.%3N%z')"
echo "Script full path: $(pwd)/run.sh"

for url in `cat ${URLS_FILENAME}`
do
    echo "> Downloading ${BLUE}${UNDERLINE}$url${NC}"
    FILE_NAME=$(echo $url | sed 's/.*\///')
    curl $url > tmp/$FILE_NAME --head > tmp/$FILE_NAME.headers -s
done
echo "${GREEN}Done${NC}"

echo "> Copying JSON files from 'tmp' to '${DOWNLOAD_FOLDER_NAME}'…" 
mkdir $DOWNLOAD_FOLDER_NAME
for file in tmp/*.json
do
    FILE_NAME=$(echo $file | sed 's/.*\///')
    cp -p $file ./${DOWNLOAD_FOLDER_NAME}/$FILE_NAME
done
echo "${GREEN}Done${NC}"

echo "> Compiling HTTP response headers from 'tmp' to '${DOWNLOAD_FOLDER_NAME}'… " 
> tmp/headers.txt
for file in tmp/*.headers
do
    FILE_NAME=$(echo $file | sed 's/.*\///')
    echo "### ${FILE_NAME}:" >> tmp/headers.txt
    cat $file >> tmp/headers.txt
done
echo "${GREEN}Done${NC}"

echo "> Compressing all files in '${DOWNLOAD_FOLDER_NAME}' to '${ARCHIVES_FOLDER_NAME}'…" 

mkdir archives
ARCHIVE_NAME=$(date +'%Y-%m-%dT%H-%M-%S')
tar cf - tmp | gzip --best - > "${ARCHIVES_FOLDER_NAME}/D${ARCHIVE_NAME}.tar.gz" 
echo "${GREEN}Done${NC} (archive file name: D${ARCHIVE_NAME})" 
echo "> Bash script ending at: $(date +'%Y-%m-%dT%H:%M:%S.%3N%z')"
echo "Bye!"
