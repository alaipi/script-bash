#!/bin/bash
 
# The following function prints a text using custom color
# -c or --color define the color for the print. See the array colors for the available options.
# -n or --noline directs the system not to print a new line after the content.
# Last argument is the message to be printed.
cecho () {
 
    declare -a colors;
    colors=(\
        ['black']='\033[47m'\
        ['red']='\033[31m'\
        ['green']='\033[32m'\
        ['yellow']='\033[93m'\
        ['blue']='\033[34m'\
        ['magenta']='\033[35m'\
        ['cyan']='\033[36m'\
        ['white']='\033[37m'\
    );
 
    local defaultMSG="No message passed.";
    local defaultColor="black";
    local defaultNewLine=true;
 
    while [[ $# -gt 1 ]];
    do
    key="$1";
 
    case $key in
        -c|--color)
            color="$2";
            shift;
        ;;
        -n|--noline)
            newLine=false;
        ;;
        *)
            # unknown option
        ;;
    esac
    shift;
    done
 
    message=${1:-$defaultMSG};   # Defaults to default message.
    color=${color:-$defaultColor};   # Defaults to default color, if not specified.
    newLine=${newLine:-$defaultNewLine};
 
    echo -en "${colors[$color]}";
    echo -en "$message";
    if [ "$newLine" = true ] ; then
        echo;
    fi
    tput sgr0; #  Reset text attributes to normal without clearing screen.
 
    return;
}
 
warning () {
 
    cecho -c 'yellow' "$@";
}
 
error () {
 
    cecho -c 'red' "$@";
}
 
information () {
 
    cecho -c 'blue' "$@";
}

cecho -n -c 'yellow' "TEST"