#!/bin/bash

# Convert video with quality settings
ffmpeg -i /Users/joel.lim/Downloads/2100\,\ 2135\ joel\ \&\ yuru\ montage.mov -q:v 0 output.mp4
ffmpeg -i /Users/joel.lim/Downloads/2100\,\ 2135\ joel\ \&\ yuru\ montage.mov -q:v 0 output.mp4

# Scale PNG files
for FILE in *.png; do
	echo ffmpeg -i "$FILE" -vf scale=1000:-1 "$FILE"
done

for FILE in *.png; do
	echo ffmpeg -i "$FILE" -vf scale=1000:-1 "$FILE"_1000.png
done

for FILE in *.png; do
	echo ffmpeg -i "$FILE" -vf scale=1000:-1 "$FILE"_1000.png
done

for FILE in *.png; do
	ffmpeg -i "$FILE" -vf scale=1000:-1 "$FILE"_1000.png
done

# Search history for ffmpeg commands
# history | grep ffmpeg

# Scale logo images to 50px width
ffmpeg -i logo-apex-charts.png scale=50:-1 logo-apex-charts-50.png
ffmpeg -i logo-apex-charts.png -vf scale=50:-1 logo-apex-charts-50.png
ffmpeg -i logo-github-actions.png -vf scale=50:-1 logo-github-actions-50.png
ffmpeg -i logo-react.png -vf scale=50:-1 logo-react-50.png
ffmpeg -i logo-firebase.png -vf scale=50:-1 logo-firebase-50.png
ffmpeg -i logo-firebase.png -vf scale=50:-1 logo-firebase-50.png
ffmpeg -i logo-playwright.png -vf scale=50:-1 logo-playwright-50.png

# Convert MOV to GIF
ffmpeg -i e2e.mov -pix_fmt rbg24 e2e.gif
ffmpeg -i e2e.mov -pix_fmt rgb24 e2e.gif
ffmpeg -i e2e.mov e2e-2.gif
ffmpeg -i e2e\ 480.mov -pix_fmt rgb24 e2e.gif

# Speed up video and convert to GIF
ffmpeg -i e2e.mov -r 16 -filter:v "setpts=0.5*PTS" e2e-fast.mov
ffmpeg -i e2e.mov -r 16 -filter:v "setpts=0.25*PTS" e2e-fast.mov
ffmpeg -i e2e-fast.mov e2e-fast.gif
ffmpeg -i e2e.mov -r 16 -filter:v "setpts=0.125*PTS" e2e-super-fast.mov
ffmpeg -i e2e-super-fast.mov e2e-super-fast.gif

# Convert full video
ffmpeg -i e2e-full-720.mov -r 16 -filter:v "setpts=0.125*PTS" e2e-full-superfast.mov
ffmpeg -i e2e-full-superfast.mov e2e-superfast.gif

# Scale logo
ffmpeg -i logo-apex-charts.png scale=50:-1 logo-apex-charts-50.png
