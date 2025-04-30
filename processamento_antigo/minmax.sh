#!/bin/bash

if [ "$2" = "lat" ]
then
	A=`sort -nk2 $1 | head -n1 | awk '{print $2}'` # maxlat
	B=`sort -nk2 $1 | tail -n1 | awk '{print $2}'` # minlat
	echo $A $B
elif [ "$2" = "lon" ]
then
	file=$1
	s=$3
	n=$4
	A=`awk -v n=$n -v file=$file '{if($2==n){print}}' $file | sort -nk1 | head -n1 | awk '{print $1}'` # minlon norte
	B=`awk -v n=$n -v file=$file '{if($2==n){print}}' $file | sort -nk1 | tail -n1 | awk '{print $1}'` # maxlon norte
	C=`awk -v s=$s -v file=$file '{if($2==s){print}}' $file | sort -nk1 | head -n1 | awk '{print $1}'` # minlon sul
	D=`awk -v s=$s -v file=$file '{if($2==s){print}}' $file | sort -nk1 | tail -n1 | awk '{print $1}'` # maxlon sul
	
	# Variaveis extras para o bash nao implicar na condicao
	dif1=`bc <<< "scale=0; ($B - $A) * 10 / 1"`
	dif2=`bc <<< "scale=0; ($D - $C) * 10 / 1"`
	if [ $dif1 -le $dif2 ]
	then
		echo $A $B
	else
		echo $C $D
	fi 
fi
