#!/bin/bash

SAMPLE_RATE=22050

while getopts d: option
do
case "${option}"
in
d) DIR=${OPTARG};;
esac
done

echo $DIR

# fetch_clip(videoID, startTime, endTime)
fetch_clip() {
  echo "$5: Fetching $1 ($2 to $3)..."
  outname="$DIR/$5"
  if [ -f "${outname}.wav.gz" ]; then
    echo "Already have it."
    return
  fi

  youtube-dl https://youtube.com/watch?v=$1 \
    --quiet --extract-audio --audio-format wav \
    --output "$outname.%(ext)s"
  if [ $? -eq 0 ]; then
    # If we don't pipe `yes`, ffmpeg seems to steal a
    # character from stdin. I have no idea why.
    yes | ffmpeg -loglevel quiet -i "./$outname.wav" -ar $SAMPLE_RATE \
      -ss "$2" -to "$3" "./${outname}_out.wav"
    mv "./${outname}_out.wav" "./$outname.wav"
#    gzip "./$outname.wav"
  else
    # Give the user a chance to Ctrl+C.
    sleep 1
  fi
}

COUNTER=0
grep -E '^[^#]' | while read line
do
  fetch_clip $({ echo "$line" ; echo $COUNTER; } | sed -E 's/, / /g')
  ((COUNTER++))
done
