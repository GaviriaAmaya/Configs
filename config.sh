#!/usr/bin/env bash
# Customized colors
setup_color() {
	if [ -t 1 ]; then
		RED=$(printf '\033[31m')
		GREEN=$(printf '\033[32m')
		YELLOW=$(printf '\033[33m')
		BLUE=$(printf '\033[34m')
		BOLD=$(printf '\033[1m')
		RESET=$(printf '\033[m')
	else
		RED=""
		GREEN=""
		YELLOW=""
		BLUE=""
		BOLD=""
		RESET=""
	fi
}

install_emacs() 
{
	sudo apt-get install emacs -y

	if [ ! -f ~/.emacs ];
	then
		touch ~/.emacs
		echo "(setq c-default-style \"bsd\"
					c-basic-offset 8
						tab-width 8
								indent-tabs-mode t)
		(require 'whitespace)
		(setq whitespace-style '(face empty lines-tail trailing))
		(global-whitespace-mode t)
		(setq column-number-mode t)
		;; set background
		(set-background-color \"misterioso\")
		;; show cursor position within line
		(column-number-mode 1)
		;; Configure backspace
		(global-set-key [(control ?h)] \'delete-backward-char)
		;; set line numbers
		(global-linum-mode 1) ; always show line numbers" >> ~/.emacs
	fi
}

install_vim()
{
	sudo apt-get install vim -y
	
	if [ ! -f ~/.vimrc ];
	then
		wget https://raw.githubusercontent.com/GaviriaAmaya/Configs/master/.vimrc
	fi
}

setup_color

# Taking user input for configure GitHub
echo "${BOLD}Set up GitHub username and email:"
read -p 'Could you tell me What is your GitHub e-mail?: ' email
read -p 'Now, Could you tell me your GitHub Username?: ' username

# Take user input for Text editor
choose_editor()
{
read -p "${BOLD}What editor you want to use? (Type one of these number options)${RESET}
${BLUE}GNU Emacs -> 1			${GREEN}Vim -> 2		${YELLOW}Both -> 3
${RESET}>>> " editor

while [ $editor -le 0 ] || [ $editor -gt 3 ] && [ $editor ];
do
echo "${RED}Sorry, that one is not an option{$RESET}"
read -p "${BOLD}What editor you want to use? (Type one of these number options)${RESET}
${BLUE}GNU Emacs -> 1			${GREEN}Vim -> 2		${YELLOW}Both -> 3
>>> " editor
done
}
choose_editor

echo "${RED}If your username or email was incorrect you can run manually the commands git config --global user.email [Your email] and
git config --global user.name [Your Name]. A future implementation will let you correct if it's the case${RESET}"

# Install and update general dependencies for new VMs
echo "${BLUE}Getting updates from ubuntu...${RESET}"
sudo apt-get update
echo "${GREEN}Dependencies updated!${RESET}"

if [ $editor -eq 1 ];
then
	echo "${BLUE}You choose GNU Emacs. Installing and configuring...${RESET}"
	install_emacs
	echo "${GREEN}GNU Emacs is now installed and configured!${RESET}"
elif [ $editor -eq 2 ];
then
	echo "${BLUE}You choose Vim. Installing and configuring...${RESET}"
	install_vim
	echo "${GREEN}Vim is now installed and configured!${RESET}"
elif [ $editor -eq 3 ];
then
	echo "${BLUE}Both of them will be installed.${RESET}"
	install_emacs
	install_vim
	echo "${GREEN}Both editors are ready${RESET}"
fi

# Verifying installation of Git
echo "${BLUE}Verifying Git package${RESET}"
if [ ! -x /usr/bin/git ];
then
	sudo apt-get install git -y
else
	sudo apt-get upgrade git -y
fi
echo "${GREEN}Git installed and updated${RESET}"

echo "Setting up your GitHub configuration..."
git config --global user.email "$email"
git config --global user.name "$username"
git config --global credential.helper 'cache --timeout=99999999'

# Clone and execute Betty install
echo "${BLUE}Cloning into Betty code style...${RESET}"
if [ ! -d "/home/vagrant/Betty" ];
then
	git clone https://github.com/holbertonschool/Betty.git
fi

sudo /home/vagrant/Betty/install.sh

echo "${GREEN}Betty C code style is set!${RESET}"

# Install OhMyZsh
echo "${BLUE}Installing OhMyZsh${RESET}"
if [ ! -x /usr/bin/zsh ];
then
	sudo apt-get install zsh -y
	wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
	sh install.sh --unattended
fi
echo "${GREEN}OhMyZsh is installed!${RESET}"

# Install pip3 and pycodestyle
echo "${BLUE}Getting pip and Python style${RESET}"
if [ ! -x /usr/bin/pip3 ];
then
	sudo apt-get install python3-pip -y
	sudo -H python3 -m pip install --upgrade pip
	sudo -H python3 -m pip install pycodestyle
fi

if [ ! -x /home/vagrant/.local/bin/pycodestyle ];
then
	sudo -H python3 -m pip install pycodestyle
fi

 "${GREEN}Pip and Pycode are now in your system!${RESET}"

# Set aliases for gcc, install, update, clear and remove
echo "${BLUE}Changing OhMyZsh Theme${RESET}"
sudo sed -i '/^ZSH_THEME=/cZSH_THEME="xiong-chiamiov-plus"' ~/.zshrc

echo "${BLUE}Setting aliases${RESET}"
echo "alias ins=\"sudo apt-get install\"" >> ~/.zshrc
echo "alias gcc=\"gcc Wall -Werror -Wextra -pedantic\"" >> ~/.zshrc
echo "alias purge=\"sudo apt-get autoremove\"" >> ~/.zshrc
echo "alias cl=\"clear\"" >> ~/.zshrc
echo "alias update=\"sudo apt-get update\"" >> ~/.zshrc

# Set zsh by default
if [ -x /usr/bin/zsh ];
then
	echo "${BLUE}Change the default shell to zsh${RESET}"
	sudo chsh -s /usr/bin/zsh
fi
echo "${GREEN}Done!${RESET}"

# Setting Time Zone. It will be updated to get a user location input
sudo timedatectl set-timezone America/Bogota

# Cleaning
rm ~/install.sh

# Settings finished
zsh
