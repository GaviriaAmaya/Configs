# Configurations

This are my own configuration for Virtual Machines. It will be renovated when needed

## General overview

This script install and configure the Vm like this:

1. Update dependencies
2. Install or update git
3. Install emacs and configure an .emacs file at home directory with some presets. Also, configured vim with some cool presets too
4. Install Betty, a C programming styleguide based on Linux Kernel and C90
5. Install OhMyZsh and configure xiong-chiamiov-plus theme\
![xiong-chiamov theme](./img/xiong-chiamiov-plus.PNG "Loaded theme for OhMyZsh(By now)")
6. Install pip3 and pycodestyle
7. Setting up some interesting aliases:
| Name | Original command
| - |:-:
| ins | sudo apt-get install
| gcc | gcc Wall -Werror -Wextra -pedantic
| purge | sudo apt-get autoremove
| cl | clear
| update | sudo apt-get update
8. "Tell me who you are?" from git is now configured. At the beginning of the configuration, a terminal form will appear to customize your GitHub Username and Email. Also, setup a rule to save the credentials for many time

## Future (Not so far) modifications

- Install npm
- Install node
- Install React
- Bootstrap and other stuff
- ~~Set the Git mail and name globally, through input~~
- Add options to OhMyZsh Themes
- ~~Install and configure Vim (Even can be added an option to install emacs, vim or both)~~
- Implement timezone from the user

## Implementation

First, you can download this:\
`wget https://raw.githubusercontent.com/GaviriaAmaya/Configs/master/config.sh`

Then, run the bash script:\
`./config.sh`

Dedicated to [Mariana](https://github.com/marianaplazas) and four kittens
