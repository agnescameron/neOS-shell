#!/bin/bash

run_home () {
  if [ "$input" == "ls" ]; then
    echo `ls ~`
  elif [ "$input" == "add" ]; then
    echo "adding"
  else
    echo "invalid command, for a list of possible commands, type help"
  fi
}

run_local_group () {
  if [ "$input" == "ls" ]; then
    file="friend_nodes.txt"
    while IFS= read line
      do
      echo "$line"
    done <"$file"
  elif [ "$input" == "add" ]; then
    echo "adding"
  else
    echo "invalid command, for a list of possible commands, type help"
  fi
}

run_interplanetary () {
    if [ "$input" == "ls" ]; then
    echo `ipfs bitswap stat`
  elif [ "$input" == "add" ]; then
    echo "adding"
  else
    echo "invalid command, for a list of possible commands, type help"
  fi
}

#handles commands specific to the process state
process_state () {
  if [ "$state" == 0 ]; then
    run_home $input
  elif [ "$state" == 1 ]; then
    run_local_group $input
  else
    run_interplanetary $input  
  fi
}


#sets the printstate variable, to output state name to user
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
        echo "commands are:"
  		else
  			print_state $state
  			echo "move up one layer, now on $printstate layer"
        echo "commands are:"
  		fi
	elif [ "$input" == "cd_" ]; then
		let state--
    dirnum=0
		if [ "$state" == -1 ]; then
  			let state++
  			echo "can't go any lower than this"
  			print_state $state
  			echo "now on $printstate layer"
        echo "commands are:"
  		else
  			print_state $state
  			echo "moved down one layer, now on $printstate layer"
        echo "commands are:"
  		fi
  	elif [ "$input" == "help" ]; then
  		echo "help text"
  	else
  		process_state $state $input
	fi
done