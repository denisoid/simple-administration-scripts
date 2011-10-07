#!/bin/bash


# Sets the maximum size of the password the script will generate
MAXSIZE=12

# Holds valid password characters. I choose alpha-numeric + the shift-number keyboard keys
# I put escape chars on all the non alpha-numeric characters just for precaution
array1=(
w e r t y u p a s d f h j k z x c v b m Q W E R T Y U P A D
F H J K L Z X C V B N M 2 3 4 7 8 ! @ $ % \# \& \* \= \- \+ \?
)

# Used in conjunction with modulus to keep random numbers in range of the array size
MODNUM=${#array1[*]}

# Keeps track of the number characters in the password we have generated
pwd_len=0

while [ $pwd_len -lt $MAXSIZE ]
do
  index=$(($RANDOM%$MODNUM))
  password="${password}${array1[$index]}"
  ((pwd_len++))
done
echo $password 
