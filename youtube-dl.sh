#!/bin/bash
_logfile="./loopdown.log"
_downloadlist="./downloadlist.txt"

function checklog() {

if [ ! -e "$_logfile" ]; then
       echo " "
    echo " Logfile does not exist and touch new one"
    echo " "
    touch $_logfile
else
	echo " "
    echo " Logfile exists and delete/renew"
    echo " "
    rm -f $_logfile;touch $_logfile
fi 
}

function downlist(){


if [ ! -e "$_downloadlist" ]; then
    echo -e "\n Download list does not exist/touch new one \n"
	    touch $_downloadlist
		else
	echo -e "\n Download list exists ,delete and touch new one \n"
		rm -f $_downloadlist;touch $_downloadlist
fi


while read -p "Input youtube URL you wanna download(EXIT if empty value):" downlist
do
	if [[ -z $downlist ]]
		then
			return 1
	fi
		echo $downlist >> $_downloadlist 
done


#while read -p "Input youtube URL you wanna download:" -a downlist;do  
#	echo $downlist >> $_downloadlist
#	read -n1 -p "Do you want to continue [Y/N]?" answer
#	case $answer in
#		Y | y)
#			echo "fine ,continue";;
#		N | n)
#			echo "ok,good bye";;
#		*)
#			echo "error choice";;
#	esac
#	exit 0
#	done
}
#          
function download() {
echo " "
echo " Choose the format you want to download:"
echo " (1)Download 1080P Video and the best Audio with all subs (1080P only)"
echo " (2)Download Audio stream and transfer to mp3 format"
echo " (3)Download the best audio and video with all subs (for low resolution video)"
echo " (4)Download the best audio and video with auto generated English subtitle"
echo " (5)Download the best audio and video with auto generated English subtitle(mkv)"
echo " (6)Download playlist with the best quality and English subtitle"
echo " "
read choice
echo " You choose method No.$choice to download youtube video/music"
echo "  "
#echo " Input youtube URL you wanna download:"
echo " "
#title=`./youtube-dl -qe --proxy $_proxy -a $_downloadlist`;echo " youtube-dl is starting to download \" $title \" "
echo " "
case $choice in
	1) ./youtube-dl -ciw --retries infinite -o '%(title)s.%(ext)s' -f 'bestvideo[height<=1080]+bestaudio[ext=m4a]' --write-sub --embed-sub --all-subs --proxy $_proxy -a $_downloadlist >> $_logfile &;;
	2) ./youtube-dl -ciw --retries infinite -o '%(title)s.%(ext)s' --extract-audio --audio-format mp3 --proxy $_proxy -a $_downloadlist>> $_logfile &;;
	3) ./youtube-dl -ciw --retries infinite -o '%(title)s.%(ext)s' --write-sub --embed-sub --all-subs -f best --proxy $_proxy -a $_downloadlist >> $_logfile &;;
	4) ./youtube-dl -ciw --retries infinite -o '%(title)s.%(ext)s' --write-sub --write-auto-sub --sub-lang=en --embed-sub -f best --proxy $_proxy -a $_downloadlist >> $_logfile &;;
	5) ./youtube-dl -ciw --retries infinite -o '%(title)s.%(ext)s' --write-sub --write-auto-sub --sub-lang=en --embed-sub -f best --merge-output-format mkv --proxy $_proxy -a $_downloadlist >> $_logfile &;;	
	6) ./youtube-dl -ciw --retries infinite -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' --yes-playlist --write-sub --write-auto-sub --sub-lang=en --embed-sub -f best --proxy $_proxy -a $_downloadlist >> $_logfile &;;
esac
}

checklog
downlist
download
