#!/bin/bash/

NAME=ShellScript

echo 'Learing shell' $NAME


NAME1=damu
NAME2=chandu

echo  $NAME1 "Hi" $NAME2 "How are you"

echo $NAME2 "I am doing good ,How are you" $NAME1


NAME1=$1
NAME2=$2

echo  $NAME1 "Hi" $NAME2 "How are you"

echo $NAME2 "I am doing good ,How are you" $NAME1


DATE=$(date)

echo 'Today date' $DATE