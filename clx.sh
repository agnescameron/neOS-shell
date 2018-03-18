#!/bin/bash

#this is a small, speculative experiment to re-imagine
#the shell for a worldwide filesystem
#here, the shell exponentiates, moving between meta-levels
#of control (here HOME, LOCAL, INTERPLANETARY)
#using the 'exponential directory' syntax

handle_home_cd () {
  echo ${words[1]}
}

#handles commands for HOME neOS
#most similar to the normal shell
#also includes ipfs-style file sharing
run_home () {
  if [ "$input" == "ls" ]; then
    echo `ls ~`
  elif [ "$input" == "add" ]; then
    echo "adding"
  elif [[ "$input" == "cd"* ]]; then
    words=($input)
    handle_home_cd $words
  else
    echo "invalid command, for a list of possible commands, type help"
  fi
}

#handles commands for the local group
#this includes:
#ssh into 'friend machines'
#the RSS field (modification)
#adding/removing friend nodes
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

#handles commands in interplanetary mode
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

#prints from a file
print_from_file () {
  IFS=''
  echo "
  "
  cat "$state.txt" | while read data; do
    echo "   $data"
    sleep .06
  done
    echo "
  "
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

# start here
echo "_________________________________________"
echo "_________________________________________"
echo "
 ##### welcome to the neOS shell. #######
 ##### to move up a layer, use cd^  #####
 ##### to move down a layer, use cd_ ####"
echo "_________________________________________"
echo "
 # for layer-specific help, type 'help' #
 # for 'meta-help' type 'meta-help' #####"
echo "_________________________________________"
echo "_________________________________________"
#initialise variables
state=0
dirstate="~"

#main loop
while :
do
	print_state $state
	printf "$printstate > "
	read input

  #tests if changing level (meta-change).
  #functions above handle operations specific to each level
  #also offers meta help (specific help given by just typing 'help')
	if [ "$input" == "cd^" ]; then
  		let state++
      dirstate="~"
  		if [ "$state" == 3 ]; then
  			let state--
  			echo "can't go any higher than this"
  			print_state $state
  			echo "now on $printstate layer"
        echo "commands are:"
  		else
  			print_state $state
  			echo "move up one layer, now on $printstate layer"
        print_from_file "$state"
        echo "commands are:"
  		fi
	elif [ "$input" == "cd_" ]; then
		let state--
    dirstate="~"
		if [ "$state" == -1 ]; then
  			let state++
  			echo "can't go any lower than this"
  			print_state $state
  			echo "now on $printstate layer"
        echo "commands are:"
  		else
  			print_state $state
  			echo "moved down one layer, now on $printstate layer"
        print_from_file "$state"
        echo "commands are:"
  		fi    
  	elif [ "$input" == "meta-help" ]; then
  		echo "help text"
  	else
  		process_state $state $input
	fi
done