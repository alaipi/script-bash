#!/bin/bash
#from https://superuser.com/questions/777902/linux-monitor-logfile-for-a-string-and-execute-script
function fs { ls -l LOGFILE | awk '{print $5}' }
function lc { wc -l LOGFILE | awk '{print $1}' }
function sv { fileSize=$(fs) fileLength=$(lc)  }
function ov { nFileSize=$(fs) nFileLeng=$(fs)  }
sv
while true; do
    ov
    if [[ $nFileSize != $fileSize ]]; then
        newLines=$(tail -n $(($nFileLeng-$fileLength)))
        if [[ $(echo "$newLines" | grep "alarm start") ]]; then
            /foo/bar/script_alarm_start.sh
        elif [[ $(echo "$newLines" | grep "alarm end") ]]; then
            /foo/bar/script_alarm_end.sh
        fi
    fi
    sv
done
