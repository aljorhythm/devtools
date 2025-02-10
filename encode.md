echo -n 'input' | openssl base64

echo -n 'input' | openssl base64

openssl base64 -in myfile.jpg -output myfile.jpg.b64

echo -n "$PUBLIC_KEY" | openssl base64 -d

gpg --full-generate-key
gpg --list-keys --keyid-format=long
 
gpg --output dev/PUBLIC_KEY --export B0A2A040B31536C5517DE7A7A7CA237E9A608E98
base64 -i dev/PUBLIC_KEY -o dev/PUBLIC_KEY.base64
 
gpg --output dev/PRIVATE_KEY --armor --export-secret-key B0A2A040B31536C5517DE7A7A7CA237E9A608E98
base64 -i dev/PRIVATE_KEY -o dev/PRIVATE_KEY.base64

git config commit.gpgSign true
