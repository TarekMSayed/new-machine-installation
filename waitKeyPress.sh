#!/bin/bash
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr 0)
while [ true ] ; do
  read -t 360000 -n 1 -p "${GREEN}Press any key to continue. $RESET"
  if [[ $? = 0 ]] ; then
    break
  fi
done
