#!/bin/bash

### Author: Nathan Duckett
### This script is designed to help build a development system from scratch
### This can instantly load all required software into the machine assuming
### it is running ubuntu based operating systems.

# =====================================
# Define Global Variables - Default and shouldn't change apart from script updates.
# =====================================
ECLIPSE_VERSION="2020-03"


# =====================================
# Define Script Functions
# =====================================

# Function to get parameters from cli arguments
function get_params () {
    # =====================================
    # Parameter parsing for bash script
    # =====================================
    PARAMS=""
    while (( "$#" )); do
    case "$1" in
        -jv|--java-version)
        JAVA_VERSION=$2
        shift 2
        ;;
        -pv|--python-version)
        PYTHON_VERSION=$2
        shift 2
        ;;
        -nv|--node-version)
        NODE_VERSION=$2
        shift 2
        ;;
        -no-vm|--no-virtual-machine)
        NO_VM="true"
        shift
        ;;
        --) # end argument parsing
        shift
        break
        ;;
        -*|--*=) # unsupported flags
        echo "Error: Unsupported flag $1" >&2
        exit 1
        ;;
        *) # preserve positional arguments
        PARAMS="$PARAMS $1"
        shift
        ;;
    esac
    done
    # set positional arguments in their proper place
    eval set -- "$PARAMS"
}

function update_system () {
    sudo apt update -qq >/dev/null 2>/dev/null
    sudo apt upgrade -yqq >/dev/null 2>/dev/null
}

function install_language_support () {
    # Utility installation
    sudo apt install git wget curl -yqq >/dev/null 2>/dev/null

    # Java support based on provided version
    sudo apt install openjdk-$JAVA_VERSION-jdk maven -yqq >/dev/null 2>/dev/null

    # Python support based on provided version
    sudo apt install python$PYTHON_VERSION -yqq >/dev/null 2>/dev/null

    # Node.js support based on provided version
    curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash - >/dev/null
    sudo apt install -yqq nodejs >/dev/null 2>/dev/null

    # Adding C/C++ and Ruby support
    sudo apt install gcc gpp make ruby -yqq >/dev/null 2>/dev/null
}

function install_eclipse () {
    wget -q "http://mirror.internode.on.net/pub/eclipse/technology/epp/downloads/release/$ECLIPSE_VERSION/R/eclipse-java-$ECLIPSE_VERSION-R-linux-gtk-x86_64.tar.gz" > /dev/null
    tar xvf eclipse-java-$ECLIPSE_VERSION-R-linux-gtk-x86_64.tar.gz > /dev/null
    rm -rf eclipse-java-$ECLIPSE_VERSION-R-linux-gtk-x86_64.tar.gz

    # Move eclipse to personal .apps folder
    mkdir $HOME/.apps/
    mv eclipse/ $HOME/.apps/

    # Create desktop shortcut
    cat > $HOME/Desktop/Eclipse.desktop << EOF
    [Desktop Entry]
    Version=$ECLIPSE_VERSION
    Name=Eclipse
    Comment=Eclipse IDE for Java Development
    Exec=$HOME/.apps/eclipse/eclipse
    Icon=$HOME/.apps/eclipse/icon.xpm
    Terminal=false
    Type=Application
    Categories=Development;Application;
EOF
    # EOF can't be indented due to linux formatting
    sudo chmod +x $HOME/Desktop/Eclipse.desktop
}

function install_scene_builder () {
    wget -q https://gluonhq.com/products/scene-builder/thanks/?dl=/download/scene-builder-linux-deb/ -O scene_builder.deb >/dev/null
    sudo apt install ./scene_builder.deb -yqq >/dev/null 2>/dev/null
    rm scene_builder.deb
    cp /etc/scenebuilder/scenebuilder.desktop ~/Desktop/
}

function install_netbeans () {
    wget -q https://apache.inspire.net.nz/netbeans/netbeans/11.3/Apache-NetBeans-11.3-bin-linux-x64.sh -O netbeans.sh >/dev/null
    bash netbeans.sh >/dev/null
    rm netbeans.sh
}

function install_vscode () {
    # Assumption that vscode is based permanently off this link (unsure of that)
    wget -q "https://go.microsoft.com/fwlink/?LinkID=760868" -O code.deb >/dev/null

    CODE_FILENAME=$(ls | grep code)
    sudo apt install ./$CODE_FILENAME -yqq >/dev/null 2>/dev/null
    rm -rf $CODE_FILENAME

    cat > $HOME/Desktop/VSCode.desktop << EOF
    [Desktop Entry]
    Name=Visual Studio Code
    Comment=Code Editing. Redefined.
    Exec=/usr/bin/code
    Icon=/usr/share/pixmaps/com.visualstudio.code.png
    Terminal=false
    Type=Application
    Categories=Development;Application;
EOF
    # EOF can't be indented due to linux formatting
    sudo chmod +x $HOME/Desktop/VSCode.desktop
}

function install_docker_deprecated () {
    ###
    ### This code was deprecated on 30/06/2020 as support for Ubuntu 20.04 machines can be replaced
    ### with package installation as shown in install_docker. This code is for historical purposes
    ### on machines <20.04 (e.g. 18.04LTS)
    ###

    # Installing normal docker
    sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -yqq >/dev/null 2>/dev/null

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" -yqq >/dev/null 2>/dev/null
    sudo apt-get update -qq >/dev/null 2>/dev/null
    sudo apt-get install docker-ce docker-ce-cli containerd.io -yqq >/dev/null 2>/dev/null

    # Installing docker-compose
    sudo curl -s -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose > /dev/null
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    # Add bash completion
    sudo curl -s -L https://raw.githubusercontent.com/docker/compose/1.25.5/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose >/dev/null
}

function install_docker() {

    # Installing normal docker
    sudo apt install docker.io -y

    # Installing docker-compose
    sudo curl -s -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose > /dev/null
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

    # Add bash completion
    sudo curl -s -L https://raw.githubusercontent.com/docker/compose/1.25.5/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose >/dev/null
}

function check_install_vm () {
    print_green "==> Installing VM Guest Additions"
    sudo apt install virtualbox-guest-x11 -yqq >/dev/null 2>/dev/null
}

function print_green () {
    echo -e '\e[32m'
    echo "$1"
    echo -e '\e[0m'
}

function print_red () {
    echo -e '\e[31m'
    echo "$1"
    echo -e '\e[0m'
}

# =====================================
# Check values exist otherwise set them
# =====================================
if [ "$JAVA_VERSION" == "" ]; then
    JAVA_VERSION="8"
fi

if [ "$PYTHON_VERSION" == "" ]; then
    PYTHON_VERSION="3.8"
fi

if [ "$NODE_VERSION" == "" ]; then
    NODE_VERSION="13"
fi

# =====================================
# Begin Script contents
# =====================================

get_params $@
print_green "==> Updating the System"
update_system
print_green "==> Installing Applications"
print_green "--==> Installing programming language support"
install_language_support
print_green "--==> Installing docker support"
install_docker
print_green "--==> Installing Eclipse IDE"
install_eclipse
print_green "--==> Installing Scene Builder"
install_scene_builder
print_green "--==> Installing Netbeans IDE"
install_netbeans
print_green "--==> Installing VSCode"
install_vscode
# Check if not VM to skip Vbox Additions, otherwise install
if [ "$NO_VM" == "false" ]; then
    check_install_vm
fi
