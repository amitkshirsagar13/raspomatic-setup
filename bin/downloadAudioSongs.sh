#!/bin/sh

lockFile=~/Music/audio.lock;

if [ -f $lockFile ]
then
	exit;
else
	echo "Start new downloads";
fi
logfile=~/Music/audio_download.log;
downloadFile=~/Music/songs.txt;
downloadFileTmp=~/Music/songs.txt.tmp;
echo "================================================================================================" >> $logfile;
echo File processing started at `date +"%Y-%m-%d %T"` >> $logfile;
if [ -f $downloadFile ]
then
	touch $lockFile;
	~/.bin/youtube-dl -f bestaudio -c -a $downloadFile --restrict-filenames -o '/home/poomit/Music/Downloaded/%(title)s.%(ext)s' >> $logfile;
	rm $downloadFile;
	rm $lockFile;
	mv $downloadFileTmp $downloadFile;
else
        echo "No file $downloadFile for Processing" >> $logfile;
fi
echo File processing completed at `date +"%Y-%m-%d %T"` >> $logfile;
echo -e '\a';
echo -e '\a';
echo -e '\a';
echo "================================================================================================" >> $logfile;

