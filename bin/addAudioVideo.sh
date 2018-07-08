#!/bin/sh

lockFile=~/Videos/video.lock;

if [ -f $lockFile ]
then
	echo `xsel --clipboard`\n >> ~/Videos/songs.txt.tmp
else
	echo `xsel --clipboard`\n >> ~/Videos/songs.txt
fi
~/.bin/addSongs.sh
#/opt/youtube-to-mp3/YouTubeToMP3 `xsel --clipboard`
