#!/bin/bash

NEXUS_ADDRESS=$1
REPO=$2

if [[ -z $NEXUS_ADDRESS || -z $REPO ]]; then
  echo "[ERROR] Missing nexus address or repo name."
  echo "Usage: $0 nexus_adress $nexus_repo"
  echo "Example: $0 http://nexus.example.com:8081 my-maven-repo"
  exit 1
fi

which lftp > /dev/null
if [[ $? -ne 0 ]]; then
  echo "[ERROR] lftp is not installed here."
  echo "Please install lftp, and then rerun the script."
  echo "On CenOS run: sudo yum install lftp"
  echo "On other Linux OSs - find your own command."
  exit 2

FULL_URL="${NEXUS_ADDRESS}/service/rest/repository/browse/${REPO}"
mkdir repo; cd repo
lftp $FULL_URL -e 'mirror .'

LIST_OF_DIRS=""
for i in `find -type d`; do
  IS_EMPTY=`ls -A -- $i`
  if [[ -z $IS_EMPTY ]]; then
    LIST_OF_DIRS="${LIST_OF_DIRS} `echo $i | sed 's/\.\///1'`"
  fi
done

for dir in $LIST_OF_DIRS; do
  files=`lftp ${FULL_URL} -e "ls dir; exit"| awk '{print $3}' | grep -v '\.\.'`
  if [[ -n $files ]]; then
    for file in $files; do
      lftp ${FULL_URL} -e "mget -d $file; exit"
    done
  fi
done

echo "[INFO] Downloaded all artifacts from ${NEXUS_ADDRESS} repository ${REPO}"
