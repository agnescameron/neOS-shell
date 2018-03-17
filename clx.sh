#!/bin/bash

print_state () {
	if [ "$state" == 0 ]; then
		printstate="HOME"
	elif [ "$state" == 1 ]; then
		printstate="LOCAL GROUP"
	else
		printstate="INTERPLANETARY"
	fi
}

# A sample Bash script, by Ryan
echo "welcome to the neOS shell.
to move up a layer, use cd^
to move down a layer, use cd_"

dirnum=0
state=0
while :
do
	print_state $state
	printf "$printstate > "
	read input


	if [ "$input" == "cd^" ]; then
  		let state++
      dirnum=0
  		if [ "$state" == 3 ]; then
  			let state--
  			echo "can't go any higher than this"
  			print_state $state
  			echo "now on $printstate layer"
  		else
  			print_state $state
  			echo "move up one layer, now on $printstate layer"
  		fi
	elif [ "$input" == "cd_" ]; then
		let state--
    dirnum=0
		if [ "$state" == -1 ]; then
  			let state++
  			echo "can't go any lower than this"
  			print_state $state
  			echo "now on $printstate layer"
  		else
  			print_state $state
  			echo "moved down one layer, now on $printstate layer"
  		fi
    elif [ "$input" == "cd .." ]; then
      let dirnum++
    elif [ "$input" == "cd ~" ]; then  
      let dirnum=0
    elif [ "$input" == "ls" ]; then
      echo `ls`
  	elif [ "$input" == "help" ]; then
  		echo "help text"
  	else
  		echo "not a valid command. for a list of neOS commands, type 'help'"
	fi
done