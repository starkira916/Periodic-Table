#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

NUMBER(){
  SEARCH_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $1;")
  if [[ -z $SEARCH_ELEMENT ]]
  then
  echo I could not find that element in the database.
  else
  PROPERTIES=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,type,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1;")
  echo $PROPERTIES | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR TYPE BAR MELTING_POINT BAR BOILING_POINT
  do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
  fi
}

LETTER(){
  SEARCH_ELEMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$1' OR name = '$1';")
  if [[ -z $SEARCH_ELEMENT ]]
  then
  echo I could not find that element in the database.
  else
  PROPERTIES=$($PSQL "SELECT atomic_number,symbol,name,atomic_mass,type,melting_point_celsius,boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol = '$1' OR name = '$1';")
  echo $PROPERTIES | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME BAR ATOMIC_MASS BAR TYPE BAR MELTING_POINT BAR BOILING_POINT
  do
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
  done
  fi
}

if [[ $1 ]] 
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
  NUMBER $1
  else
  LETTER $1
  fi
else
echo Please provide an element as an argument.
fi