setup:
	cp .zshrc ~/.zshrc
	cp .vimrc ~/.vimrc

backup:
	sh backup_backup.sh

install:
	sh backup_install.sh
