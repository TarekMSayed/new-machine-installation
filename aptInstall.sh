#!/bin/bash
DEPS_LIST=( "$@" )
DEPS_LIST_SIZE=${DEPS_LIST[0]}
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr 0)

for ((i=1 ; i <=$DEPS_LIST_SIZE; i++ ))
do
  PACKAGE_CONDITION=$(apt -qq list ${DEPS_LIST[i]})
  if [[ $PACKAGE_CONDITION == *"installed"* ]]; then
    echo "${GREEN}$i ${DEPS_LIST[i]} Already Installed$RESET"
  else
    echo "${GREEN}$i Installing ${DEPS_LIST[i]}$RESET"
    sudo apt-get install --assume-yes "${DEPS_LIST[i]}"
    while [[ $(apt -qq --installed list ${DEPS_LIST[i]}) != *"installed"* ]]; do
      if [[ ${DEPS_LIST[i]} == *"="* ]]; then
        if [[ $(apt -qq --installed list $(echo ${DEPS_LIST[i]} | grep -Po '.+(?==)')) == *"installed"* ]]; then
          echo "${GREEN}$i ${DEPS_LIST[i]} Installed$RESET"
          break
        fi
      fi
      echo "${RED}$i Retry Installing ${DEPS_LIST[i]} after 20 Seconds$RESET"
      # use escape password to escape installing failed packages
      read -rs -t 20 -p "${GREEN}Enter pass to Escape installing Package or Press Enter to Retry Now: $RESET" ESC
            if [[ $ESC == "pass" ]]; then
                echo -e "\n${RED}Escape package ${DEPS_LIST[i]}$RESET"
                break
            else
                echo -e "\n"
            fi
      sudo apt-get install --assume-yes "${DEPS_LIST[i]}"
    done
  fi
done
