#!/bin/bash

#add ssh
eval `ssh-agent` && ssh-add

# output color
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

COMMIT_MESSAGE="$1"


current_datetime=$(date +"%Y-%m-%d %H:%M:%S")
echo "Current date and time: $current_datetime"

if [ -z "$1" ]; then
  COMMIT_MESSAGE="repository sync - $current_datetime"
fi


echo "1. fetch"
git fetch

echo "2. git add ."
git add .

echo "3.  git commit..."
git commit -m "$COMMIT_MESSAGE"

echo "4. git rebase..."
git rebase

echo "5. git push..."
git push


[ $? -eq 0 ] && echo -e "${GREEN}----------------------------------------------> sync successful${NC}" || echo -e "${RED}-------------------------------------> sync failed${NC}"

exit 0
