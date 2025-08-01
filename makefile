setup:
	cp .zshrc .zshrc.out
	sh 03_set_up_bash_profile.sh
	cp .zshrc.out ~/.zshrc
	cp .vimrc ~/.vimrc
	cp .vimrc ~/.ideavimrc
	cp .gitignore_global ~/.gitignore_global
	git config --global core.excludesFile ~/.gitignore_global

backup:
	sh backup_backup.sh

install:
	sh backup_install.sh
