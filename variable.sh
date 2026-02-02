#!/bin/bash/

NAME=ShellScript

echo 'Learing' $NAME

VAR1=$1
VAR2=$2

echo "$VAR1"
echo "all variables $@"
echo "no of variables $#"
echo "script name $0"


for i in {1..10}
do
  echo $I
done