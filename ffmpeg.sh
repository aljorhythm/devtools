  857  ffmpeg -i /Users/joel.lim/Downloads/2100\,\ 2135\ joel\ \&\ yuru\ montage.mov -q:v 0 output.mp4
  859  ffmpeg -i /Users/joel.lim/Downloads/2100\,\ 2135\ joel\ \&\ yuru\ montage.mov -q:v 0 output.mp4
  884  for FILE in *.png; do echo ffmpeg -i $FILE -vf scale=1000:-1 $FILE; done
  885  for FILE in *.png; do echo ffmpeg -i $FILE -vf scale=1000:-1 $FILE_1000.png; done
  886  for FILE in *.png; do echo ffmpeg -i $FILE -vf scale=1000:-1 "$FILE"_1000.png; done
  887  for FILE in *.png; do ffmpeg -i $FILE -vf scale=1000:-1 "$FILE"_1000.png; done
  898  history | grep ffmpeg
 5967  ffmpeg -i logo-apex-charts.png scale=50:-1 logo-apex-charts-50.png
 5968  ffmpeg -i logo-apex-charts.png -vf scale=50:-1 logo-apex-charts-50.png
 5970  ffmpeg -i logo-github-actions.png -vf scale=50:-1 logo-github-actions-50.png
 5971  ffmpeg -i logo-react.png -vf scale=50:-1 logo-react-50.png
 5972  ffmpeg -i logo-firebase.png -vf scale=50:-1 logo-firebase-50.png
 5988  ffmpeg -i logo-firebase.png -vf scale=50:-1 logo-firebase-50.png
 5993  ffmpeg -i logo-playwright.png -vf scale=50:-1 logo-playwright-50.png
 6028  ffmpeg -i e2e.mov -pix_fmt rbg24 e2e.gif
 6029  ffmpeg -i e2e.mov -pix_fmt rgb24 e2e.gif
 6050* ffmpeg -i e2e.mov e2e-2.gif
 6054  ffmpeg -i e2e\ 480.mov -pix_fmt rgb24 e2e.gif
 6057  ffmpeg -i e2e.mov -r 16 -filter:v "setpts=0.5*PTS" e2e-fast.mov
 6059  ffmpeg -i e2e.mov -r 16 -filter:v "setpts=0.25*PTS" e2e-fast.mov
 6060  ffmpeg -i e2e-fast.mov e2e-fast.gif
 6064  ffmpeg -i e2e.mov -r 16 -filter:v "setpts=0.125*PTS" e2e-super-fast.mov
 6066  ffmpeg -i e2e-super-fast.mov e2e-super-fast.gif

ffmpeg -i e2e-full-720.mov -r 16 -filter:v "setpts=0.125*PTS" e2e-full-superfast.mov
ffmpeg -i e2e-full-superfast.mov e2e-superfast.gif

 ffmpeg -i logo-apex-charts.png scale=50:-1 logo-apex-charts-50.png