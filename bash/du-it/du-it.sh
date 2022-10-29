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

echo -e "Choose one of the following options:\n${BRed}(1) Delete${NC} ${BCyan}(2) Update${NC} ${BYellow}(3) UpdateDC${NC} Quit(any) "
read ACTION

if [[ $ACTION -eq 1 ]]; then
	for n in $*; do

		if [[ "$n" == "$(sudo docker ps -a | grep $n | awk '{ print $NF }')" ]]; then

			sudo docker ps -a | grep $n | awk '{ print $2 }' >/dev/null >$n.tmp
			echo -e ">>>${Red}Stopping $n...${NC}"
			sudo docker stop $n >/dev/null
			echo -e "${BGreen}Done!${NC}"
			echo -e ">>>${Red}Removing $n...${NC}"
			sudo docker rm $n >/dev/null
			echo -e "${BGreen}Done!${NC}"
			echo -e ">>>${Red}Removing the image used by $n...${NC}"
			sudo docker rmi $(cat $n.tmp) >/dev/null
			echo -e "${BGreen}Done!${NC}"

			echo -e "$>>>{Red}Cleaning up...${NC}"
			rm *.tmp
			echo -e "${BGreen}Done!${NC}"

		else
			echo -e "${BRed}$n doesn't exist!${NC}"
		fi
	done

elif [[ $ACTION -eq 2 ]]; then
	for n in $*; do

		if [[ "$n" == "$(sudo docker ps -a | grep $n | awk '{ print $NF }')" ]]; then

			sudo docker ps -a | grep $n | awk '{ print $2 }' >/dev/null >$n.tmp
			echo -e "$>>>{Cyan}Stopping $n...${NC}"
			sudo docker stop $n >/dev/null
			echo -e "${Green}Done!${NC}"
			echo -e "$>>>{Cyan}Removing $n...${NC}"
			sudo docker rm $n >/dev/null
			echo -e "${Green}Done!${NC}"
			echo -e "$>>>{Cyan}Removing the image used by $n...${NC}"
			sudo docker rmi $(cat $n.tmp) >/dev/null
			echo -e "${Green}Done!${NC}"

			echo -e "$>>>{Cyan}Creating $n...${NC}"
			sudo docker-compose -f ~/$n/docker-compose.yml up -d >/dev/null

			echo -e "$>>>{Cyan}Cleaning up...${NC}"
			rm *.tmp
			echo -e "${Green}Done!${NC}"

		else
			echo -e "${BRed}$n doesn't exist!${NC}"
		fi
	done

elif [[ $ACTION -eq 3 ]]; then
	for n in $*; do

		echo -e "${Yellow}>>>Navigating to $n...${NC}"
		builtin cd ~/$n/
		echo -e "${Yellow}>>>Pulling the new image...${NC}"
		sudo docker-compose pull > /dev/null
		echo -e "${Green}Done!${NC}"
		echo -e "${Yellow}>>>Recreating $n...${NC}"
		sudo docker-compose up -d > /dev/null
		echo -e "${Green}Done!${NC}"

	done

else
	echo -e "Bye!"

fi
