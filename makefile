setup:
	cp .zshrc .zshrc.out
	sh 03_set_up_bash_profile.sh
	cp .zshrc.out ~/.zshrc
	cp .vimrc ~/.vimrc
	cp .vimrc ~/.ideavimrc

backup:
	sh backup_backup.sh

install:
	sh backup_install.sh
