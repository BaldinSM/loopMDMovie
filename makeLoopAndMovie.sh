#!/bin/bash
keyword=atoms
images=0
for i in *.png; do
  ((images+=1))
done
echo There are $images frames ...
((images*=2))

for j in *.png; do
  cp $j $keyword\_$(printf "%03d" $images).png
  # printf "%03d\n" $images
  ((images-=1))
done

ffmpeg -r 24 -i atoms_%03d.png loopmovie_100pdbframes_400frames-animation_speed0.05.webm
