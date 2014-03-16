#!/bin/bash
#
#

MKL_RED="\033[031m"
MKL_GREEN="\033[032m"
MKL_YELLOW="\033[033m"
MKL_BLUE="\033[034m"
MKL_CLR_RESET="\033[0m"


mklove_dir=$(pwd)
proj_dir=$1


function puts {
    echo -e "$*"
}

function fatal {
    puts "${MKL_RED}Fatal error: $*${MKL_CLR_RESET}"
    exit 1
}


#
# Check usage
#
if [[ ! -d $proj_dir ]]; then
    puts "mklove setup.sh"
    puts "Interactive utility for setting up mklove for your project"
    puts ""
    puts "Usage: ./setup.sh <your-project-directory>"
    exit 1
fi

puts "${MKL_GREEN}Welcome to mklove setup${MKL_CLR_RESET}"
puts ""

#
# Check that paths make sense
#
if [[ ! -f $mklove_dir/configure || ! -f $mklove_dir/Makefile.base ]]; then
    puts "${MKL_YELLOW}NOTE: setup.sh must be run from the mklove directory${MKL_CLR_RESET}"
    puts ""
    fatal "$mklove_dir does not look like the mklove directory"

fi

if [[ $mklove_dir == $proj_dir ]]; then
    fatal "setup.sh should be run from your project's directory, not the mklove directory"
fi



#
# Ask what parts of mklove are to be set up.
#
inst_conf=n
inst_mkb=n
while true ; do
    puts "${MKL_BLUE}What parts of mklove do you want to use in your project:${MKL_CLR_RESET}"
    puts " 1 - configure and Makefile.base"
    puts " 2 - configure only"
    puts " 3 - Makefile.base only"
    read -p "Choice(1)> " -e what

    [[ -z $what ]] && what=1

    case $what in
        1)
            inst_conf=y
            inst_mkb=y
            ;;
        2)
            inst_conf=y
            ;;
        3)
            inst_mkb=y
            ;;
        *)
            puts "${MKL_RED}Unknown option: $what${MKL_CLR_RESET}"
            continue
    esac
    break
done


#
# Ask for confirmation
#
puts ""
puts "${MKL_BLUE}Will set up your project with:${MKL_CLR_RESET}"
[[ $inst_conf == y ]] && puts " - configure script"
[[ $inst_mkb == y ]] &&  puts " - Makefile.base"
puts " - from mklove directory $mklove_dir"
puts " - to project directory $proj_dir"

read -p "Press enter to confirm or Ctrl-C to abort"

puts ""
puts "${MKL_BLUE}Creating $proj_dir/mklove/modules and copying files${MKL_CLR_RESET}"

mkdir -p "$proj_dir/mklove/modules" || fatal "Failed to create directory"

if [[ $inst_conf == y ]]; then
    cp -v "$mklove_dir/configure" "$proj_dir/" || fatal "Copy failure"
    cp -v "$mklove_dir/modules/configure.base" "$proj_dir/mklove/modules" || fatal "Copy failure"
    cp -v $mklove_dir/modules/configure.host_* "$proj_dir/mklove/modules" || fatal "Copy failure"

    # Let configure resolve initial dependencies
    puts ""
    puts "${MKL_BLUE}Calling ./configure --update-modules to resolve initial dependencies${MKL_CLR_RESET}"
    (cd "$proj_dir" && MKL_REPO_URL="$mklove_dir" ./configure --update-modules) || puts "${MKL_RED}Update modules failed${MKL_CLR_RESET}"
fi

if [[ $inst_mkb == y ]]; then
    cp -v "$mklove_dir/Makefile.base" "$proj_dir/mklove/" || fatal "Copy failure"
fi


puts ""
puts "${MKL_GREEN}Congratulations! mklove is now set up for your project${MKL_CLR_RESET}"
puts "Things to do in your project directory $proj_dir:"
[[ $inst_conf == y ]] && puts " - Create a configure.<yourprojectname> to add your own checks and --options"
[[ $inst_conf == y ]] && puts " - Use existing mklove configure modules by calling 'mkl_require <modname>' from configure.<yourprojectname>"
[[ $inst_conf == y ]] && puts " - You should ship your project with all required mklove modules included,
   do this by calling ./configure --update-modules"
[[ $inst_mkb == y ]]  && puts " - Create a Makefile including both Makefile.base and Makefile.config"
[[ $inst_mkb == y ]]  && puts " - Write your own targets in your Makefile, or use the available standard targets from Makefile.base"
puts ""
