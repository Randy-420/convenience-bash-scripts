#!/bin/bash
start=$(date +%s)

commitFile='update.txt'
debName="ftt"
tweak="Flex To Theos"
repoReleaseFolder="/var/mobile/tweaks/mine/repo/debs/"

./version.sh
error=$?
if [[ $error -ne 0 ]]; then
	echo "-STOPPED- with exit code: $error"
	exit
fi

rm -rf DEBs/*

make clean package

cp DEBs/* $repoReleaseFolder$debName.deb

git add .
if test -f "$commitFile"; then
	for line in $(<$commitFile); do
		if [[ $commitMsg == "" ]]; then
			commitMsg="${line}"
		else  
			commitMsg="$commitMsg
$line"
		fi 
	done
fi
while [[ $commitMsg == "" ]]; do
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
done
echo "" > $commitFile
git commit -m "$commitMsg"
git push

directory=$(pwd)
cd "$repoReleaseFolder";cd "../"
echo -e "-~-$tweak-~-\n$commitMsg\n" >> $commitFile
cd "$directory"

end=$(date +%s)
time=$(expr $end - $start)
echo "completed in $time seconds"