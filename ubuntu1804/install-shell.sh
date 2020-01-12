#/bin/sh

### README:
### When using this script for a WSL instance or to access on windows you must
### install powerline fonts to support the console. Visit https://github.com/powerline/fonts.git
### to get started. For windows you can use:
### git clone https://github.com/powerline/fonts.git then .\install.ps1


sudo apt install zsh git fonts-powerline

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

touch ~/.aliases

curl https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark --output ~/.dircolors
cat >> ~/.zshrc << EOF
source ~/.aliases

# Prevent User prompt on local machine
prompt_context(){}

# Stop WSL Bell sounds
unsetopt beep

# Set colours for LS
eval `dircolors ~/.dircolors`
EOF