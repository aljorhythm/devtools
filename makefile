setup:
	cp .zshrc .zshrc.out
	sh 03\ set_up_bash_profile.sh
	cp .zshrc.out ~/.zshrc
	cp .vimrc ~/.vimrc

backup:
	sh backup_backup.sh

install:
	sh backup_install.sh
