https://knowledge.broadcom.com/external/article/158454/using-pgp-command-line.html

gpg -o /path/to/file/abc.zip -d /path/to/file/file.zip.gpg

gpg --full-generate-key
ssh-keygen -t rsa -b 4096
gpg --armor --export E57A47A92E961DEBC00C8F63109C47E878BB7891 > dev/UAT_CPF_SFTP_PGP.pub