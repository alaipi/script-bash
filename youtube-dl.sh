#!/bin/bash
_logfile="./loopdown.log"
_downloadlist="./downloadlist.txt"
_SERVICE="youtube-dl"


if pidof -x "$_SERVICE" >/dev/null
	then
		echo -e "\n $_SERVICE is running,stop scripting \n "
		exit 1
	else
		echo -e "\n $_SERVICE stopped"
		echo -e " continue scripting......\n"
fi


function pause(){
   read -p "$*"
}

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

#建立下載清單
function downlist(){


if [ ! -e "$_downloadlist" ]; then
    echo -e "\n Download list does not exist/touch new one \n"
	    touch $_downloadlist
		else
	echo -e "\n Download list exists ,delete and touch new one \n"
		rm -f $_downloadlist;touch $_downloadlist
fi


while read -p "Input youtube URL you wanna download(EXIT if blank input): " downlist
do
	if [[ -z $downlist ]]
		then
			return 1
	fi
		echo $downlist >> $_downloadlist
		echo -e "\nAlready add $downlist to downlist!\n"
done




}

#下載          
function download() {

	function resolution(){
	
	echo " "
	echo " "
	read -n5 -p "What format do you want to download [1080/720/best]?" answer1
	case $answer1 in
		1080)
			echo -e "\n\nok,download bestvideo[height<=1080]+bestaudio[ext=m4a] !!\n\n"
			format="'bestvideo[height<=1080]+bestaudio[ext=m4a]'";;
		720)
			echo -e "\n\nok,download bestvideo[height<=720]+bestaudio[ext=m4a] !!\n\n"
			format="'bestvideo[height<=720]+bestaudio[ext=m4a]'";;
		best)
			echo -e "\n\nok,download bestvideo+bestaudio!!\n\n"
			format="best";;
		*)
			echo " "
			echo " "
			echo "error choice, exit"
			exit 1;;
	esac
	}	
	
	function listornot(){
	
	read -n2 -p "Do you want to download playlist [Y/N]?" answer
	case $answer in
		Y | y)
			echo -e "\n\nok,download playlist!!\n\n"
			_PLAYLIST="--yes-playlist";;
		N | n)
			echo -e "\n\nok,no playlist!!\n\n"
			_PLAYLIST="--no-playlist";;
		*)
			echo -e "\n\nerror choice, exit\n\n"
			exit 2;;
	esac
	}
	
	function playlist(){
	echo " "
	read -p "Playlist video to start at:" _PLAYLISTSTART
	echo " "
	read -p "Playlist video to start at:" _PLAYLISTEND
	echo " "
	./youtube-dl -ciw --retries infinite -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $_PLAYLIST --merge-output-format $mergeformat --playlist-start $_PLAYLISTSTART --playlist-end $_PLAYLISTEND --write-sub --write-auto-sub --sub-lang=en --embed-sub -f $format --proxy $_proxy -a $_downloadlist >> $_logfile &
	}

	function mergeoutput(){
	
	read -n4 -p "What format do you want to merge [mp4/mkv]?" answer2
	case $answer2 in
		mp4 | MP4)
			echo -e "\n\nYou choose merge output to mp4 format!\n\n"
			mergeformat="mp4";;
		mkv | MKV)
			echo -e "\n\nYou choose merge output to mkv format!\n\n"
			mergeformat="mkv";;
		*)
			echo -e "\n\nerror choice, exit\n\n"
			exit 3;;
	esac
	}		

resolution
pause 'Press [Enter] key to continue...'
echo " "
listornot
pause 'Press [Enter] key to continue...'
echo " "
mergeoutput
pause 'Press [Enter] key to continue...'

echo " "
echo " Choose the format you want to download:"
echo " =======Video==============================================================================="
echo " (1)Download Video and the best Audio with all subs"
echo " (2)Download Video and the best Audio with auto generated English subtitle"
echo " ========MP3================================================================================"
echo " (3)Download Audio stream and transfer to mp3 format(ffprobe cannot work right now)"
echo " ========PLAYLIST==========================================================================="
echo " (4)Download defined playlist with the best quality and English subtitle"
echo " (5)Update Youtube-dl"
echo " (6)List available format"
echo " "
read -n2 -p "Choose the format you want to download:" choice
echo " You choose method No.$choice to download youtube video/music"
echo "  "
#echo " Input youtube URL you wanna download:"
echo " "
#title=`./youtube-dl -qe --proxy $_proxy -a $_downloadlist`;echo " youtube-dl is starting to download \" $title \" "
echo " "
case $choice in
	1) ./youtube-dl -v -ciw --retries infinite $_PLAYLIST -o '%(playlist)s/%(playlist_index)s - %(title)s-%(height)s.%(ext)s' -f $format --merge-output-format $mergeformat --write-sub --embed-sub --all-subs --proxy $_proxy -a $_downloadlist &>> $_logfile &;;
	2) ./youtube-dl -ciw --retries infinite $_PLAYLIST -o '%(playlist)s/%(playlist_index)s - %(title)s-%(height)s.%(ext)s' -f $format --write-sub --write-auto-sub --sub-lang=en --embed-sub --merge-output-format $mergeformat --proxy $_proxy -a $_downloadlist &>> $_logfile &;;		
	3) ./youtube-dl -v -ciw --retries infinite $_PLAYLIST -o '%(playlist)s/%(playlist_index)s - %(title)s-%(height)s.%(ext)s' -f $format --extract-audio --audio-format mp3 --proxy $_proxy -a $_downloadlist &>> $_logfile &;;	
	4) playlist;;
	5) ./youtube-dl --proxy $_proxy --update;;
	6) ./youtube-dl $_PLAYLIST -F --proxy $_proxy -a $_downloadlist;;
	*) 
		echo -e "\nerror choice, exit\n"
		exit 5
esac
}

checklog
pause 'Press [Enter] key to continue...'
echo " "
pause 'Press [Enter] key to continue...'
echo " "
downlist
pause 'Press [Enter] key to continue...'
echo " "
download
