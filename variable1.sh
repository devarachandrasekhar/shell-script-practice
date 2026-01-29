#!/bin/bash

# echo "enter your username"

# read -s username

# echo "your user name is" $username

number=$1

if [ $number -gt 0 ]

then 
  echo "The given number $number is greater then 0"
else
  echo "The given number $number is less then 0"