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
fi

FULL_URL="${NEXUS_ADDRESS}/service/rest/repository/browse/${REPO}"
mkdir repo; cd repo
# Mirroring the dirs structure into the current location
lftp $FULL_URL -e 'mirror .; exit'

# Listing all dirs which do not contain sub dirs
# (Meaning - in Nexus repository they contain the actual files to download, such as jar files)
LIST_OF_DIRS=""
for i in `find -type d`; do
  IS_EMPTY=`ls -A -- $i`
  if [[ -z $IS_EMPTY ]]; then
    LIST_OF_DIRS="${LIST_OF_DIRS} `echo $i | sed 's/\.\///1'`"
  fi
done

# The actual files downloading part
# It downloads every file/artifacts to the relevant location exactly the same as in the Nexus repo.
for dir in $LIST_OF_DIRS; do
  files=`lftp ${FULL_URL} -e "ls ${dir}; exit"| awk '{print $3}' | grep -v '\.\.'`
  if [[ -n $files ]]; then
    for file in $files; do
      lftp ${FULL_URL} -e "mget -d $file; exit"
    done
  fi
done

echo "[INFO] Downloaded all artifacts from ${NEXUS_ADDRESS} repository ${REPO}"
