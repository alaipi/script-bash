#!/bin/bash

_logfile="loopdown.log"
_downloadlist="downloadlist.txt"
_SERVICE="youtube-dl"


if pidof -x "$_SERVICE" >/dev/null
	then
		echo -e "\n $_SERVICE is running,stop scripting \n "
		exit 1
	else
		echo -e "\n $_SERVICE stopped! scripting continue......\n"
fi


function pause(){
   read -p "$*"
}


function checklog() {

if [ ! -e "$_logfile" ]; then
    echo -e "\n Logfile does not exist and touch new one \n"
    touch $_logfile
else
    echo -e "\n Logfile exists and delete/renew\n"
    rm -f $_logfile;touch $_logfile
fi 
}

#選擇 proxy
function proxy() {
	echo " "
	echo " 2 proxy for choice : "
	echo " (1)Local Proxy = http://127.0.0.1:1082/ "
	echo " (2)HTTP Tinyproxy = http://10.1.1.1:9999/ "
	echo " (3)No Proxy needed"
	echo " "
	read -n1 -p " Plase choose proxy for download: " proxy

case $proxy in
	1) _proxy="http://127.0.0.1:1082/" ; echo -e "\n You choose proxy $_proxy \n" ;;
	2) _proxy="http://10.1.1.1:9999/" ; echo -e "\n You choose Tinyproxy $_proxy \n";;
	3) declare -- _proxy='""' ; echo -e "\n No proxy needed, direct connection \n" ;;
	*)
	echo "Invalid input..."
	exit 5;;
esac
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

while read -p "Input youtube URL you wanna download (EXIT if blank input): " downlist
do
	if [[ -z $downlist ]]
		then
			return 1
	fi
		echo $downlist >> $_downloadlist
		echo -e "\nAlready add $downlist into downlist!\n"
done
}

function resolution(){
	echo " "
	echo " "
	read -n5 -p "What format do you want to download [1080/720/best]?" answer1
	case $answer1 in
		1080)
			echo -e "\n\nok,download bestvideo[height<=1080]+bestaudio[ext=m4a] !!\n"
			format='bestvideo[height<=1080]+bestaudio[ext=m4a]';;
		720)
			echo -e "\n\nok,download bestvideo[height<=720]+bestaudio[ext=m4a] !!\n"
			format='bestvideo[height<=720]+bestaudio[ext=m4a]';;
		best)
			echo -e "\n\nok,download bestvideo+bestaudio!!\n"
			format="best";;
		*)
			echo -e "\n\nerror choice, exit"
			exit 1;;
	esac
}

function listornot(){
	read -n2 -p "Do you want to download playlist [Y/N]?" answer
	case $answer in
		Y | y)
			echo -e "\n\nok,download playlist!!\n"
			_PLAYLIST="--yes-playlist";;
		N | n)
			echo -e "\n\nok,no playlist!!\n"
			_PLAYLIST="--no-playlist";;
		*)
			echo -e "\n\nerror choice, exit\n"
			exit 2;;
	esac
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

#下載
function download() {
	function playlist_auto(){
	echo " "
	read -n4 -p "Video playlist start at: " _PLAYLISTSTART
	echo " "
	read -n4 -p "Video playlist end at: " _PLAYLISTEND
	echo " "
	youtube-dl -v -ciw --retries infinite -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $_PLAYLIST --merge-output-format $mergeformat --playlist-start $_PLAYLISTSTART --playlist-end $_PLAYLISTEND --write-sub --write-auto-sub --sub-lang=en --embed-sub -f $format --proxy $_proxy -a $_downloadlist >> $_logfile &
	}

	function playlist_all(){
	echo " "
	read -n4 -p "Video playlist start at: " _PLAYLISTSTART
	echo " "
	read -n4 -p "Video playlist end at: " _PLAYLISTEND
	echo " "
	youtube-dl -v -ciw --retries infinite -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $_PLAYLIST --merge-output-format $mergeformat --playlist-start $_PLAYLISTSTART --playlist-end $_PLAYLISTEND --write-sub --embed-sub --all-subs -f $format --proxy $_proxy -a $_downloadlist >> $_logfile &
	}
	
	function playlist_audio(){
	echo " "
	read -n4 -p "Audio playlist start at: " _PLAYLISTSTART
	echo " "
	read -n4 -p "Audio playlist end at: " _PLAYLISTEND
	echo " "
	youtube-dl -v -ciw --retries infinite -o '%(playlist)s/%(playlist_index)s - %(title)s.%(ext)s' $_PLAYLIST --playlist-start $_PLAYLISTSTART --playlist-end $_PLAYLISTEND -f bestaudio --extract-audio --audio-format mp3 --proxy $_proxy -a $_downloadlist >> $_logfile &
	}

echo " "
echo " Choose the format you want to download:"
echo " =======Video==============================================================================="
echo " (1)Download Video and the best Audio with all subs"
echo " (2)Download Video and the best Audio with auto generated English subtitle"
echo " =======Audio==============================================================================="
echo " (3)Download Audio stream and transfer to mp3 format(ffprobe video cannot work right now)"
echo " (4)Download defined audio playlist"
echo " ========Video Playlist====================================================================="
echo " (5)Download defined video playlist with all subtitles"
echo " (6)Download defined video playlist with auto generated English subtitle"
echo " "
read -n2 -p " Choose the format you want to download:" choice
echo " You choose method No.$choice to download youtube video/music"
#echo -e " Strating to download these files: \n"
#youtube-dl --get-filename --proxy $_proxy -a $_downloadlist
echo " "
#title=`youtube-dl -qe --proxy $_proxy -a $_downloadlist`;echo " youtube-dl is starting to download \" $title \" "
case $choice in
	1) youtube-dl -v -ciw --retries infinite $_PLAYLIST -o '%(playlist)s/%(playlist_index)s - %(title)s-%(height)s.%(ext)s' -f $format --merge-output-format $mergeformat --write-sub --embed-sub --all-subs --proxy "$_proxy" -a $_downloadlist &>> $_logfile &;;
	2) youtube-dl -v -ciw --retries infinite $_PLAYLIST -o '%(playlist)s/%(playlist_index)s - %(title)s-%(height)s.%(ext)s' -f $format --write-sub --write-auto-sub --sub-lang=en --embed-sub --merge-output-format $mergeformat --proxy "$_proxy" -a $_downloadlist &>> $_logfile &;;		
	3) youtube-dl -v -ciw --retries infinite $_PLAYLIST -o '%(playlist)s/%(playlist_index)s - %(title)s-%(height)s.%(ext)s' -f bestaudio --extract-audio --audio-format mp3 --proxy "$_proxy" -a $_downloadlist &>> $_logfile &;;
	4) playlist_audio;;
	5) playlist_all;;
	6) playlist_auto;;
	7) youtube-dl -v -ciw --retries infinite $_PLAYLIST -o '%(playlist)s/%(playlist_index)s - %(title)s-%(height)s.%(ext)s' -f $format --extract-audio --audio-format mp3 --proxy "$_proxy" -a $_downloadlist &>> $_logfile &;;
	*) 
		echo -e "\n\nerror choice, exit"
		exit 6
esac
}

function checkprocess() {
	echo -e "\n\n What process do you need? \n"
	echo " (1) Download Video "
	echo " (2) Download Audio "
	echo " (3) List available format "
	echo " (4) Update youtube-dl "
	echo " "
	read -n1 -p "Keyin number to choose process you need [1,2,3,4] ? " number
	echo " "
	case $number in
	1)
		checklog
		pause 'Press [Enter] key to continue...'
		echo " "
		proxy
		pause 'Press [Enter] key to continue...'
		echo " "
		downlist
		pause 'Press [Enter] key to continue...'
		echo " "
		resolution
		pause 'Press [Enter] key to continue...'
		echo " "
		listornot
		pause 'Press [Enter] key to continue...'
		echo " "
		mergeoutput
		pause 'Press [Enter] key to continue...'
		download
	;;

	2)
		checklog
		pause 'Press [Enter] key to continue...'
		echo " "
		proxy
		pause 'Press [Enter] key to continue...'
		echo " "
		downlist
		pause 'Press [Enter] key to continue...'
		echo " "
		listornot
		pause 'Press [Enter] key to continue...'
		download
	;;
	3)
		proxy
		pause 'Press [Enter] key to continue...'
		echo " "
		downlist
		pause 'Press [Enter] key to continue...'
		echo " "
		listornot
		pause 'Press [Enter] key to start list all available format...'
		echo " "
		youtube-dl -v $_PLAYLIST -F --proxy "$_proxy" --batch-file $_downloadlist
	;;
	4)
		proxy
		echo " "
		pause 'Press [Enter] key to start updating Youtube-dl...'
		echo " "
		youtube-dl -v --proxy "$_proxy" --update
	;;
	*)
		echo "Invalid input..."
		exit 9
	;;
esac
}

checkprocess
