#! /bin/bash


BRed='\033[1;31m'
BGreen='\033[1;32m'
BYellow='\033[1;33m'
BCyan='\033[1;36m'

Red='\033[0;91m'
Green='\033[0;32m'
Yellow='\033[0;93m'
Cyan='\033[0;96m'
NC='\033[0m'


echo -e "Choose one of the following options:\n${BGreen}(1) Add${NC} ${BRed}(2) Delete${NC} ${BYellow}(3) Quit${NC} "
read ACTION

if [[ $ACTION -eq 1 ]]
then
    for u in $(cat $1)
    do
        echo -e ${Green}Creating user:${NC} $u
        useradd $u
        echo -e ${Green}Setting user password${NC}
        echo $u | sudo passwd $u --stdin > /dev/null

    done

elif [[ $ACTION -eq 2 ]]
then
    for u in $(cat $1)
    do
        echo -e ${Red}Deleting user:${NC} $u
        userdel $u -r 
    done

else
	echo -e "${Yellow}Bye!${NC}"
fi
