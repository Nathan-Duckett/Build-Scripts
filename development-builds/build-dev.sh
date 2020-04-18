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
    sudo apt update -qq > /dev/null
    sudo apt upgrade -yqq > /dev/null
}

function install_language_support () {
    # Java support based on provided version
    sudo apt install openjdk-$JAVA_VERSION-jdk maven -yqq > /dev/null

    # Python support based on provided version
    sudo apt install python$PYTHON_VERSION -yqq > /dev/null

    # Node.js support based on provided version
    curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | sudo -E bash -
    sudo apt install -yqq nodejs > /dev/null

    # Adding C/C++ and Ruby support
    sudo apt install gcc gpp make ruby -yqq > /dev/null
}

function install_eclipse () {
    wget "http://mirror.internode.on.net/pub/eclipse/technology/epp/downloads/release/$ECLIPSE_VERSION/R/eclipse-java-$ECLIPSE_VERSION-R-linux-gtk-x86_64.tar.gz"
    tar xvf eclipse-java-$ECLIPSE_VERSION-R-linux-gtk-x86_64.tar.gz
    rm -rf eclipse-java-$ECLIPSE_VERSION-R-linux-gtk-x86_64.tar.gz

    # Move eclipse to personal .apps folder
    mkdir $HOME/.apps/
    mv eclipse $HOME/.apps/

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

function install_vscode () {
    # Assumption that vscode is based permanently off this link (unsure of that)
    wget "https://go.microsoft.com/fwlink/?LinkID=760868"

    $CODE_FILENAME=$(ls | grep code)
    sudo apt install ./$CODE_FILENAME
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

function install_docker () {
    # Installing normal docker
    sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common -yqq > /dev/null

    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    sudo apt-get update -qq > /dev/null
    sudo apt-get install docker-ce docker-ce-cli containerd.io -yqq > /dev/null

    # Installing docker-compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    $VERSION_OUTPUT=$(docker-compose --version)

    if [ "$VERSION_OUTPUT" == "" ]; then
        echo "Docker-compose installation was unsuccessful"
    fi

    # Add bash completion
    sudo curl -L https://raw.githubusercontent.com/docker/compose/1.25.5/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
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

get_params
update_system
install_language_support
install_docker
install_eclipse
install_vscode