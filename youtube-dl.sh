#!/bin/bash
echo " "
echo " Choose the format you want to download"
echo " (1)Download 1080P Video and best Audio with all subs"
echo " (2)Download Audio stream and transfer to mp3 formaet"
echo " (3)Download best audio and best audio with all subs(for low resolution video"
echo " "
read choice

echo "Input youtube URL you wanna download"
echo " "
read URL

echo " youtube-dl is starting to download what you want!!!!!"
echo " "
case $choice in
       1) youtube-dl -f 'bestvideo[height<=1080]+bestaudio[ext=m4a]' --write-sub --embed-sub --all-subs $URL;;
       2) youtube-dl --extract-audio --audio-format mp3 $URL;;
       3) youtube-dl --write-sub --embed-sub --all-subs -f best $URL;;
esac
