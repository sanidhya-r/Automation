#!/bin/bash

# when consoling, tput setaf is used to set color of the text that will be echoed.
# yellow - 3
# green - 2
# red - 1
# reset - 0

tput setaf 3; echo "Inititating feature setup"; tput sgr0

# setting path for project folders
FRUIT_PATH=${pwd}"fruits/"
VEGETABLE_PATH=${pwd}"vegetables/"

# adding bolierplate templates
MODEL_LOGIC_TEMPLATE="./automator/modelLogic.tpl"
CONFIG_TEMPLATE="./automator/config.tpl"

# trap ctrl-c interrupt and call cleanup
trap ctrl_c INT

ctrl_c(){
    tput setaf 3; echo -e "\nTerminating Process...\n"; tput sgr0
    
    # call cleanUp function to clean and exit
    cleanUp
}

# Ask user if it is a fruit model or a vegetable model
acceptModel(){

	# This is optional, useful when using for a git project.
	#______________________________________
    echo "Enter repository branch name."
    unset BRANCH_NAME
    while [ -z "${BRANCH_NAME}" ]; do
        read -r BRANCH_NAME
    done
	#_______________________________________
    
    echo -e "Select one by typing the number:\n  1. Vegetable Model\n  2. Fruit Model"
    unset MODEL_TYPE
    while [ -z "${MODEL_TYPE}" ]; do
        read -r MODEL_TYPE
    done

    if [[ ${MODEL_TYPE} -ne 1 && ${MODEL_TYPE} -ne 2 ]]
    then
        tput setaf 1; echo "Wrong input, try again"; tput sgr0
        acceptModel
    fi
		
	# Call next function
    acceptModelData
}

# Ask for crop name, model name, localization keys etc
acceptModelData(){

    MODEL_OPTIONS=("apple" "banana" "capsicum" "chilli" "coffee" "cucumber" "grape" "guava" "mango" "orange" "pomegranate" "tomato")
    
    OPTIONS_LENGTH=${#CROP_OPTIONS[@]}

    # splitting digits of array length
    a=$((OPTIONS_LENGTH % 10))
    OPTIONS_LENGTH=$((OPTIONS_LENGTH / 10))
    b=$((OPTIONS_LENGTH % 10))

    # Sorting the options list
    IFS=$'\n' MODEL_OPTIONS=($(sort <<<"${MODEL_OPTIONS[*]}"))
    unset IFS

    echo "Select a Model from the list"
    select CHOICE in "${MODEL_OPTIONS[@]}" "Other..."; do 
        case "$REPLY" in
            [1-9]|[1-${b}][0-${a}])
                modelConfirmationMenu
                ;;
            $((${#MODEL_OPTIONS[@]}+1))) 
                echo "Enter name of the crop"
                unset CHOICE
                while [ -z "${CHOICE}" ]; do
                    read -r CHOICE
                done
                modelConfirmationMenu
                ;;
            *) 
                tput setaf 1; echo "Invalid option. Try again!"; tput sgr0
                break
                ;;
        esac
    done

    echo "Enter cron time. [ Please enter time as following, example: 09:00]"
    unset TIME
    while [ -z "${TIME}" ]; do
        read -r TIME
    done
	
	# Useful when your project is git controlled and you need to make new branches to add a new feature.
	#__________________________________________________
    CURRENT_BRANCH=$(git symbolic-ref --short -q HEAD)
    if [[ ${CURRENT_BRANCH} != ${BRANCH_NAME} ]]; then
    		if [[ ${CURRENT_BRANCH} != "staging" ]]; then
       			git stash
        		git checkout staging
        		git pull origin staging
        		git checkout -b ${BRANCH_NAME}
    		else
        		git pull origin staging
        		git checkout -b ${BRANCH_NAME}
    		fi
	fi
	#__________________________________________________

    # setting model specific path and model email layout
    case ${MODEL_TYPE} in
        1)
            MODEL_PATH="${VEGETABLE_PATH}"
            MODEL_TYPE="Vegetable"
            ;;
        2)
            MODEL_PATH="${FRUIT_PATH}"
            MODEL_TYPE="Fruit"
            ;;
    esac
    
    IDENTIFIER="${MODEL}_${MODEL_TYPE}"
    CRON_IDENTIFIER="${MODEL_TYPE}_${MODEL}_CRON"
    # Capitalising each word in sentence case
    MODEL_NAME_ACTUAL=$(echo "${MODEL}" | perl -pe 's/\S+/\u$&/g')
    # Camelcasing the name to follow coding paradigms
    MODEL=$(echo "${MODEL}" | perl -nE 'say lcfirst join "", map {ucfirst lc} split /[^[:alnum:]]+/')

    createDir
}

# Create project directory based on the above parameters
createDir(){

    # check if dir alraedy exists
    if [[ -e ${MODEL_PATH} ]]
    then
        # prompt error and callback to input function acceptCrop()
        tput setaf 1; echo "Directory alraedy exists, try again"; tput sgr0
        acceptCropData
    else
        mkdir -p "${MODEL_PATH}"

        eval "echo \"$(cat "${MODEL_LOGIC_TEMPLATE}")\"" > "${MODEL_PATH}/${MODEL_NAME}.js"
        if [ $? -eq 0 ]; then
            tput setaf 2; echo "Created model logic with given data"; tput sgr0
        else
            tput setaf 1; echo "Could not insert template code for model logic."; tput sgr0
            cleanUp
        fi

        eval "echo \"$(cat "${CONFIG_TEMPLATE}")\"" > "${MODEL_PATH}/config.js"
        if [ $? -eq 0 ]; then
            tput setaf 2; echo "Created config with given data"; tput sgr0
        else
            tput setaf 1; echo "Could not insert template code for config.js"; tput sgr0
            cleanUp
        fi

        tput setaf 3; echo "Formatting Code. Please wait..."; tput sgr0
        npx prettier --write "${MODEL_PATH}"
        if [ $? -eq 0 ]; then
            tput setaf 2; echo "Formatting Done."; tput sgr0
        else
            tput setaf 1; echo "Failed to prettify."; tput sgr0
            cleanUp
        fi

        tput setaf 2; echo "[OK] The model has been added to your directory"; tput sgr0
    fi
}

modelConfirmationMenu(){
    echo "You have chosen ${CHOICE}"
    tput setaf 3; echo "Enter 'y' for confirmation and 'n' for selecting again"; tput sgr0
    read -r CONFIRMATION
    case ${CONFIRMATION} in 
        [Yy]*)
            MODEL=${CHOICE}
            break
            ;;
        [Nn]*)
            break
            ;;
        *)
            tput setaf 1; echo "Please enter a valid option"; tput sgr0
            break
            ;;
    esac
}

# Clean Up function using GIT
cleanUp(){
    tput setaf 3; echo "Cleaning up before exiting"; tput sgr0
    git clean -df
    git checkout .
    tput setaf 2; echo "Undid changes. Exiting..."; tput sgr0
    exit
}

# CleanUp function using bash
cleanUpWithBash(){
    tput setaf 3; echo "Cleaning up before exiting"; tput sgr0
    rm -f {PATH_TO_FILE}
    rm -rf {PATH_TO_DIRECTORY}
    tput setaf 2; echo "Undid changes. Exiting..."; tput sgr0
    exit
}