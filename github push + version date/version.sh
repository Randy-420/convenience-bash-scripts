#!/bin/bash
control="control"
controlFind="Version:"
controlVersion=0

makefile="Makefile"
makefileFind="PACKAGE_VERSION="
makefileVersion=0

f() { v=("${BASH_ARGV[@]}"); }

updateVersion(){
	file=$1
	shift 1
	findMe=$1

	oldVersion=$(sed -n "/^$findMe/p" $file)
	oldV=$(echo $oldVersion | sed -n "s/^$findMe//p")

	IFS="." read -r -a v <<< $oldVersion
echo "${#v[@]}"
	if [[ ${#v[@]} == 1 || ${#v[@]} == 0 ]]; then
		return
	fi

	if [[ $file == $control ]]; then
		oldControlVersion=$(echo "$oldV" | sed -n "s/ //pg")
		newVersion=$(echo "${findMe} $(date +%F)" | sed -n "s/-/\./g; s/ //pg")
		controlVersion=$(echo "$newVersion" | sed -n "s/^$findMe//pg")
	else
		oldMakefileVersion=$oldV
		newVersion=$(echo "${findMe}$(date +%F)" | sed -n "s/-/\./pg")
		makefileVersion=$(echo "$newVersion" | sed -n "s/^$findMe//pg")
	fi

		sed -i "/$oldVersion/ { c \\$newVersion
}" $file
}

updateVersion $makefile $makefileFind
updateVersion $control $controlFind
#echo "-$oldControlVersion- : -$controlVersion-
#-$oldMakefileVersion- : -$makefileVersion-

#"
if ([[ $controlVersion == $makefileVersion ]] && [[ $oldControlVersion != $controlVersion ]] && [[ $oldMakefileVersion != $makefileVersion ]]) || ([[ $makefileVersion == 0 ]] && [[ $oldControlVersion != $controlVersion ]]); then
	echo -e "\n\n\e[1;32mVERSION INCREMENTATION SUCCESSFUL\e[0m\n\e[31m$oldControlVersion\e[0m => \e[1;34m$controlVersion\n\n\e[0m"
else
	echo -e "\e[31mVERSION INCREMENTATION FAILED\e[0m
CONTROL: $controlVersion
MAKEFILE: $makefileVersion"
	return 1
fi