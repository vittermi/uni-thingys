#!/bin/bash

# Download .m3u8 files, made on the fly because I needed to download multiple files so not super user-friendly.
read -p "insert start lex #:" START
read -p "insert lex #:" END

read -p "Dowload lex $START - $END? [y/n]" answer
case "$answer" in
	[Nn]*) exit 0 ;;
esac

LINKS=/tmp/$$.tmp

# Gets all m3u8 source links and puts them in a temp txt file ($start must be > than $lex_n).
# Insert links manually (where I needed to download filenames are incremental), in the form lesson$i (put $i wherever
# there is an incremental value) if files are composed of two parts just write to links, one for part 1 and 1 for part 2
for i in $(seq $START $END)
do
	d="00$i" # use this variable if there are padded numbers
	if (($i > 10)); then
		d="0$i"
	fi
	echo "https://videolectures.unimi.it/vod/mp4:DBruschiSPLez$i.mp4/manifest.m3u8" >> $LINKS
done

cat $LINKS | while read line || [[ -n "$line" ]];
do
	youtube-dl "$line" --no-check-certificate # Uses youtube dl to download mp4 files from m3u8 source.
	NAME=${line%.mp4*}  # retain the part before .mp4
	NAME=${NAME##*:} # retain the part after the last colon

	mv manifest-manifest.mp4 "$NAME.mp4"
	echo "file $NAME.mp4 downloaded"
done

unlink "$LINKS"
echo "Files all downloaded."
