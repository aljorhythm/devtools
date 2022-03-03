history + cut
```
history | grep 'minikube\|kubectl' | cut -c 8- | uniq -u | grep -v history
```

resize images
```
for FILE in *.png; do ffmpeg -i $FILE -vf scale=1000:-1 "$FILE"_1000.png; done
```