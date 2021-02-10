#!/bin/bash

####################################################
# Script to assist with starting a new box/room.
#
# Assumes you have nmap or rustscan installed.
#    Rustscan is installed via docker. Feel free to 
#    change command if needed.
# 
# Version: 0.1
# Created by: bw
# Inspiration:
# 		https://twitter.com/Theonly_Hoff
# 		https://github.com/evildrummer/RoomPrepper
####################################################

#################### USAGE #########################
# RoomStart Help
#
# ./roomstart.sh [options]
#
# options:
# 		-h|--help 					show brief help
# 		-p|--platform				specify a platform
#		  -n|--name					  specify a room/box name
# 		-s|--scan			 		  specify a scanning tool (nmap / rustscan)
# 		-i|--ip					    specify an ip
####################################################

# Set colors
RED='\033[0;31m'
YEL='\033[0;33m'
GRE='\033[0;32m'
# No Color
NC='\033[0m'

# Set arguments
while test $# -gt 0; do
     case "$1" in
          -h|--help)
               echo ""
               echo -e "${YEL}RoomStart - Help"
               echo ""
               echo "./roomstart.sh [options]"
               echo ""
               echo "options:"
               echo "   -h|--help 			show brief help"
               echo "   -p|--platform*               specify a platform"
               echo "   -n|--name*			specify a room/box name"
               echo "   -s|--scan			specify a scanning tool (nmap / rustscan)"
               echo "   -i|--ip			specify an ip"
               echo ""
               echo -e "   * - required${NC}"
               exit 0
               ;;
          -p|--platform)
	         shift
               if test $# -gt 0; then
                    export PLATFORM=$1
               else
                    echo ""
                    echo -e "   ${RED}ERROR: ${NC}No platform specified"
                    exit 1
               fi
               shift
               ;;
          -n|--name)
               shift
               if test $# -gt 0; then
                    export NAME=$1
               else
                    echo ""
                    echo -e "   ${RED}ERROR: ${NC}No room/box name specified"
                    exit 1
               fi
               shift
               ;;
          -s|--scanner)
               shift
               if test $# -gt 0; then
                    export SCANNER=$1
               else
                    echo ""
                    echo -e "   ${RED}ERROR: ${NC}No scanner specified"
                    exit 1
               fi
               shift
               ;;
          -i|--ip)
               shift
               if test $# -gt 0; then
                    export IP=$1
               else
                    echo ""
                    echo -e "   ${RED}ERROR: ${NC}No IP specified"
                    exit 1
               fi
               shift
               ;;
          *)
               echo ""
               echo -e "   ${RED}ERROR: ${NC}Incorrect options found"
               echo -e "   ${YEL}Use -h|--help to view options"
               exit 2
               ;;
     esac
done

# Functions

f_Start(){
	echo ""
     echo -e "${YEL}################################################"
	echo "#    ___                  ______           __  #";
     echo "#   / _ \___  ___  __ _  / __/ /____ _____/ /_ #";
     echo "#  / , _/ _ \/ _ \/  ' \_\ \/ __/ _ \/ __/ __/ #";
     echo "# /_/|_|\___/\___/_/_/_/___/\__/\_,_/_/  \__/  #";
     echo "#                                              #";
	echo -e "################################################${NC}"
     echo ""
     sleep 2
}

f_Ping(){

     if [ -z $IP ]; then
          :
     else
          echo -e "${YEL}##################"
          echo -e "###### PING ######"
          echo -e "##################${NC}"
          echo ""
          PING_OUT=$(ping -q -W 2 -c 1 "$IP" 2>/dev/null)
          until echo "$PING_OUT" | grep -q "$UP"; do
               echo -e "   ${RED}Host is down${NC}"
               sleep 2
               PING_OUT=$(ping -q -W 1 -c 1 "$IP" 2>/dev/null)
          done
          echo -e "   ${GRE}Host is up${NC}"
          echo ""
     fi
}

f_FolderCreation(){
	
     PLAT_DIR=/home/$USER/$PLATFORM

	echo -e "${YEL}###################"
	echo -e "##### FOLDERS #####"
	echo -e "###################${NC}"
	echo ""

	if [ ! -d $PLAT_DIR ]; then
          echo -e "   ${GRE}Creating platform directory"
          mkdir $PLAT_DIR
	else
		echo -e "   ${GRE}Platform directory exists"
	fi

     if [ ! -d $PLAT_DIR/$NAME ]; then
          echo -e "   ${GRE}Creating room/box name directory"
          mkdir $PLAT_DIR/$NAME
     else
          echo -e "   ${GRE}Room/Box name directory exists"
     fi

     echo ""
     echo -e "   ${GRE}Folder Location: ${NC}$PLAT_DIR/$NAME"
     echo ""
     sleep 3
}

f_ScannerFunc(){

     ##### Scanning commands - Change if needed #####
     RUST_CMD="sudo docker run -it --rm --name rustscan rustscan/rustscan -a $IP -- -A -sC -sV"
     NMAP_CMD="nmap -oN $PLAT_DIR/$NAME/nmap.txt -T4 -A -sC -sV -p- $IP"

     echo -e "${YEL}###################"
     echo -e "##### SCANNER #####"
     echo -e "###################${NC}"

     if [ -z $SCANNER ]; then
          echo ""
          echo -e "   ${YEL}INFO: ${NC}No scanner specified"
     else
          if [ -z $IP ]; then
               echo ""
               echo -e "   ${RED}ERROR: ${NC}No IP specified to scan"
          else
               if [ $SCANNER == 'rustscan' ]; then
                    echo ""
                    $RUST_CMD
               elif [ $SCANNER == 'nmap' ]; then
                    echo ""
                    $NMAP_CMD
               else
                    echo ""
                    echo -e "   ${RED}ERROR: ${NC}Scanner not supported"
               fi
          fi
     fi
}

## Check if required arguments exists

if [ -z $PLATFORM ] && [ -z $NAME ]; then
     echo ""
     echo -e "${RED}ERROR: ${NC}Platform not set"
     echo -e "${RED}ERROR: ${NC}Room/Box name not set"
     echo -e "   ${YEL}-p|--platform       specify a platform"
     echo -e "   ${YEL}-n|--name           specify a room/box name"
     exit
elif [ -z $PLATFORM ]; then
	echo ""
	echo -e "${RED}ERROR: ${NC}Platform not set"
     echo -e "   ${YEL}-p|--platform       specify a platform"
	exit
elif [ -z $NAME ]; then
	echo ""
	echo -e "${RED}ERROR: ${NC}Room/Box name not set"
	echo -e "   ${YEL}-n|--name           specify a room/box name"
	exit
else
	f_Start
	f_FolderCreation
     f_Ping
     f_ScannerFunc
fi
