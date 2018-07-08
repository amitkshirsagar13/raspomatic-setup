#!/bin/sh

lockFile=~/Music/audio.lock;

if [ -f $lockFile ]
then
	echo `xsel --clipboard`\n >> ~/Music/songs.txt.tmp
else
	echo `xsel --clipboard`\n >> ~/Music/songs.txt
fi

#/opt/youtube-to-mp3/YouTubeToMP3 `xsel --clipboard`
