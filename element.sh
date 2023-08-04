#!/bin/bash

#PSQL for queries
PSQL="psql -X --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#Check for elements
if [[ -z $1  ]]
then
	echo "Please provide an element as an argument."
else
	if [[ $1 =~ [0-9]+ ]]
	then	#Make select element N°
		ELEMENT=$($PSQL "select * from elements 
					INNER JOIN properties USING(atomic_number) 
					INNER JOIN types USING(type_id) where atomic_number=$1")	
	else	#Make select element symbol/name
		ELEMENT=$($PSQL "select * from elements 
					INNER JOIN properties USING(atomic_number) 
					INNER JOIN types USING(type_id) 
					WHERE symbol=INITCAP('$1') or name=INITCAP('$1')")	

	fi
	#Chech if ELEMENT not exist
	if [[ -z $ELEMENT ]]
	then
		echo "I could not find that element in the database."
	#IF ELEMENT exist
	else	#ELEMENT components
		echo "$ELEMENT" | while IFS="|" read TYPE_ID AN SYMBOL NAME AM MP BP TYPE 
		do
			echo "The element with atomic number $AN is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AM amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius." 
		done
	fi
fi



