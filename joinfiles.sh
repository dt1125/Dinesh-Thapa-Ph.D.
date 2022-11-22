#!/bin/bash

if [ "$#" -ne 4 ]
then
	echo "provide 4 arguments to this command"
	echo "Usage: $1 file1 file2 resultfile operation(+/-)"
	echo -e "Example:\n \t $1 file1.dat file2.dat file3.dat +"
	exit 0
fi

file1=$1 #"file1.dat"
file2=$2 #"file2.dat"
file3=$3 #"file3.dat"
o=$4

#if file3 exists remove.
if [ -f "$file3" ]
then
	rm $file3
fi
i=0
while IFS=" " read -r c1 c2 && IFS=" " read -r c3 c4 <&3; 
do
        
	if [ -z "$c1" ]
	then
		echo "escape empty line in $file1"
		continue 1
	fi

	if [ -z "$c3" ]
	then
		echo "escape empty line in $file2"
		continue 1
	fi
        #echo "$i, $c1:$c2:$c3:$c4"

	if [ $o == "+" ]
        then
            result=$(echo "scale=4; $c2 + $c4" | bc)	    
        else
            result=$(echo "scale=4; $c2 - $c4" | bc)
        fi
        
	#write result in file
	echo "$c1" "$result">> "$file3"
        let i++
        
done < "$file1" 3< "$file2"

if [ $o == "+" ]
then
	echo "saved all x1, y1+y2 in $file3"
else
	echo "saved all x1, y1-y2 in $file3"
fi

