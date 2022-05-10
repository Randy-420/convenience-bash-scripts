#!/bin/bash
start=$(date +%s)

commitFile='update.txt'

. ./gen.sh

git add .

if test -f "$commitFile"; then
	while read line; do  
		if [[ $commitMsg == "" ]]; then
			commitMsg="${line}"
		else  
			commitMsg="$commitMsg
$line"
		fi 
	done < $commitFile
fi
while [[ $commitMsg == "" ]];
do
	if [[ $commitMsg == "" ]]; then
		echo "Enter your commit message: "
		while read tmsg; do
			if [[ $tmsg == "" ]]; then
				break
			fi
			if [[ "$commitMsg" == "" ]]; then
				commitMsg="$tmsg"
			else
				commitMsg="$commitMsg
$tmsg"
			fi
		done
	fi
done
echo "" > $commitFile
git commit -m "$commitMsg"
git push

end=$(date +%s)
time=$(expr $end - $start)
echo "completed in $time seconds"