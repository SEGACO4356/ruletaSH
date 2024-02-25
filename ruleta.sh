#!/bin/bash

#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

function ctrl_c(){
	echo -e "\n \t${redColour}[!] Saliendo...${endColour}\n"
	tput cnorm
	exit 1
}

#Ctrl_c

trap ctrl_c INT


function helpPanel(){
	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Uso:${endColour} ${purpleColour}$0${endColour}\n"
	echo -e "\t ${blueColour}-m) ${endColour}${grayColour}Dinero con el que se desea jugar${endColour}"
	echo -e "\t ${blueColour}-t)${endColour} ${grayColour}Tecnica a utilizar${endColour} ${purpleColour}(${endColour}${yellowColour}martingala${endColour}${purpleColour}/${endColour}${greenColour}inverseLaBrouchere${endColour}${purpleColour})${endColour}${endColour}\n"

	exit 1
}

function martingala(){
	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dinero actual${endColour} ${yellowColour}$money${endColour}${grayColour}$ ${endColour}"
	echo -ne "${yellowColour}[+]${endColour} ${grayColour}¿Con cuanto dinero quieres empezar? -> ${endColour}" && read initial_bet
	echo -ne "${yellowColour}[+]${endColoyr} ${grayColour}¿A que deseas apostar contínuamente? (par/impar) -> ${endColour}" && read par_impar

	echo -e "${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con la cantidad incial de${endColour} ${yellowColour}$initial_bet$ ${endColour}${grayColour}a${endColour} ${blueColour}$par_impar${endColour}"


#Backup initial
backup_bet=$initial_bet
play_counter=1
bad_plays=" "

tput civis


#Ciclo while
while true; do
	money=$(($money-$initial_bet))
#	echo -e "${yellowColour}[+]${endColour} ${grayColour}Acabas de apostar${endColour} ${yellowColour}$initial_bet$ ${endColour}${grayColour}y tienes${endColour} ${blueColour}$money$ ${endColour}"
	random_number=$(($RANDOM % 37))
	# echo -e "\n${yellowColour}[!]${endColour} ${greenColour}Ha salido el número${endColour} ${yellowColour}$random_number ${endColour} \n"


#Condicional cuando apostamos a par
if [ ! "$money" -le 0 ]; then
		if [ "$par_impar" == par ]; then
			if [ "$(($random_number % 2))" -eq 0 ]; then
				if [ "$random_number" -eq 0 ]; then
				#	echo -e "${redColour}[!] Salió 0 perdiste${endColour}"
					initial_bet=$(($initial_bet*2))
					bad_plays+="$random_number "
				# echo -e "${yellowColour}[+]${endColour} ${grayColour}Ahora mismo tienes${endColour} ${yellowColour}$money$ ${endColour}"

				else
				#	echo -e "${yellowColour}[+]${endColour} ${grayColour}El número es par ganaste${endColour}"
					reward=$(($initial_bet * 2))
				#	echo -e "${yellowColour}[+]${endColour} ${grayColour}Ganas un total de${endColour} ${yellowColour}$reward$ ${endColour}"
					money=$(($money+$reward))
				#	echo -e "${yellowColour}[+]${endColour} ${grayColour}Tienes${endColour} ${yellowColour}$money$ ${endColour}"
					initial_bet=$backup_bet
					bad_plays=""
					let max_money=$money
					
					if [ "$money" -gt "$max_money" ]; then
						
						let max_money=$money
					fi
					

				fi
		else
		#	echo -e "${yellowColour}[!]${endColour} ${redColour}El número es impar y pierdes${endColour}"
			initial_bet=$(($initial_bet*2))
			bad_plays+="$random_number "
		#	echo -e "${yellowColour}[+]${endColour} ${grayColour}Ahora mismo tienes${endColour} ${yellowColour}$money$ ${endColour}"
			fi
		fi
else
	#Nos quedamos sin dinero
	echo -e "\n${redColour}[!] Nos quedamos sin dinero${endColour}\n"

	echo -e "${yellowColour}[+]${endColour} ${grayColour}Han habido un total de${endColour} ${yellowColour}$play_counter${endColour} ${grayColour}jugadas${endColour}"

	echo -e "${yellowColour}[!]${endColour} ${grayColour}Se representarán las malas jugadas que han salido consecutivamente${endColour}"
	echo -e "${blueColour}[ $bad_plays ]${endColour}"
	echo -e "${yellowColour}[+]${endColour} ${grayColour}El máximo dinero que has ganado es:${endColour} ${greenColour}$max_money$ ${endColour}"

	tput cnorm; exit 0
fi
#Fin condicional impar

#Condicional cuando apostamos a impar
if [ ! "$money" -eq 0 ]; then
	if [ "$par_impar" == "impar" ];then
		if [ $(($random_number % 2)) -ne 0 ]; then
			if [ "$random_number" -eq 0 ]; then
				echo -e "Ha salido 0 perdiste"
				initial_bet=$(($initial_bet*2))
				bad_plays+="$random_number "
			else
				reward=$(($initial_bet*2))

				money=$(($reward+$money))
			
				initial_bet=$backup_bet
					
				bad_plays=" "

				let max_money=$money

				if [ "$max_money" -gt "$money" ]; then
					let max_money=$money
				fi
			fi
		
		

	else
#		echo -e "[!] Ha salido par, ¡Perdiste!"
		initial_bet=$(($initial_bet*2))	
		bad_plays+="$random_number "
	
		fi
	fi
else
	echo -e "${redColour}[!] Nos quedamos sin dinero${endColour}"
	echo -e "${yellowColour}[+]${endColour} ${grayColour}Se representarán las jugadas malas que han salido consecutivamente${endColour}"
	echo -e "[ $bad_plays ]"
	tput cnorm;	exit 0
fi
#Fin condicional impar

	let play_counter+=1
done

	tput cnorm
}

function inverseLaBrouchere(){
	echo -e "\n${yellowColour}[+]${endColour} ${grayColour}Dinero actual${endColour} ${yellowColour}$money${endColour}${grayColour}$ ${endColour}"
	echo -ne "${yellowColour}[+]${endColoyr} ${grayColour}¿A que deseas apostar contínuamente? (par/impar) -> ${endColour}" && read par_impar

	echo -e "${yellowColour}[+]${endColour} ${grayColour}Vamos a jugar con la cantidad incial de${endColour} ${yellowColour}$initial_bet$ ${endColour}${grayColour}a${endColour} ${blueColour}$par_impar${endColour}"


}
while getopts "m:t:h" args; do
	case $args in
		m) money="$OPTARG";;
		t) technique="$OPTARG";;
		h) helpPanel;;
	esac
done

if [ $money ] && [ $technique ]; then
		if [ "$technique" == "martingala" ]; then 
			martingala
		elif [ "$technique" == "inverseLaBrouchere" ]; then
			inverseLaBrouchere
		else
			echo -e "\n${redColour}[!] La técnica introducida no existe${endColour}"
			helpPanel
		fi
else
	helpPanel
fi

