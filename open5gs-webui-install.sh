#!/bin/bash

# Refer to Node.js install script
#
# Run as root or insert `sudo -E` before `bash`:
#
# curl -fsSL https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -
#   or
# wget -qO- https://open5gs.org/open5gs/assets/webui/install | sudo -E bash -
#

PACKAGE="open5gs"
VERSION="2.4.8"

print_status() {
    echo
    echo "## $1"
    echo
}

if test -t 1; then # if terminal
    ncolors=$(which tput > /dev/null && tput colors) # supports color
    if test -n "$ncolors" && test $ncolors -ge 8; then
        termcols=$(tput cols)
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

print_bold() {
    title="$1"
    text="$2"

    echo
    echo "${red}================================================================================${normal}"
    echo "${red}================================================================================${normal}"
    echo
    echo -e "  ${bold}${yellow}${title}${normal}"
    echo
    echo -en "  ${text}"
    echo
    echo "${red}================================================================================${normal}"
    echo "${red}================================================================================${normal}"
}

bail() {
    echo 'Error executing command, exiting'
    exit 1
}

exec_cmd_nobail() {
    echo "+ $1"
    bash -c "$1"
}

exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

uninstall() {
if [ -f /lib/systemd/system/${PACKAGE}-webui.service ]; then
    STATUS="$(systemctl is-active open5gs-webui.service)"
    if [ "${STATUS}" = "active" ]; then
        exec_cmd_nobail "deb-systemd-invoke stop open5gs-webui"
    fi

    STATUS="$(systemctl is-enabled open5gs-webui.service)"
    if [ "${STATUS}" = "enabled" ]; then
        exec_cmd_nobail "systemctl disable open5gs-webui"
    fi

    exec_cmd_nobail "rm -f /lib/systemd/system/${PACKAGE}-webui.service"
    exec_cmd_nobail "systemctl daemon-reload"
fi

if [ -d /usr/lib/node_modules/${PACKAGE} ]; then
    exec_cmd_nobail "rm -rf /usr/lib/node_modules/${PACKAGE}"
fi

}

preinstall() {

PRE_INSTALL_PKGS=""

if [ ! -x /usr/bin/lsb_release ]; then
    PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} lsb-release"
fi

if [ ! -x /usr/bin/node ] && [ ! -x /usr/bin/wget ]; then
    PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} nodejs"
fi

if [ ! -x /usr/bin/curl ] && [ ! -x /usr/bin/wget ]; then
    PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} curl"
fi

if [ ! -x /usr/bin/gpg ]; then
    PRE_INSTALL_PKGS="${PRE_INSTALL_PKGS} gnupg"
fi

print_status "Populating apt-get cache..."
exec_cmd 'apt-get update'

if [ "X${PRE_INSTALL_PKGS}" != "X" ]; then
    print_status "Installing packages required for setup:${PRE_INSTALL_PKGS}..."
    exec_cmd "apt-get install -y${PRE_INSTALL_PKGS} > /dev/null 2>&1"
fi

DISTRO=$(lsb_release -c -s)

check_alt() {
    if [ "X${DISTRO}" == "X${2}" ]; then
        echo
        echo "## You seem to be using ${1} version ${DISTRO}."
        echo "## This maps to ${3} \"${4}\"... Adjusting for you..."
        DISTRO="${4}"
    fi
}

check_alt "SolydXK"       "solydxk-9" "Debian" "stretch"
check_alt "Kali"          "sana"     "Debian" "jessie"
check_alt "Kali"          "kali-rolling" "Debian" "jessie"
check_alt "Sparky Linux"  "Tyche"    "Debian" "stretch"
check_alt "Sparky Linux"  "Nibiru"   "Debian" "buster"
check_alt "MX Linux 17"   "Horizon"  "Debian" "stretch"
check_alt "MX Linux 18"   "Continuum" "Debian" "stretch"
check_alt "MX Linux 19"   "patito feo" "Debian" "buster"
check_alt "Linux Mint"    "maya"     "Ubuntu" "precise"
check_alt "Linux Mint"    "qiana"    "Ubuntu" "trusty"
check_alt "Linux Mint"    "rafaela"  "Ubuntu" "trusty"
check_alt "Linux Mint"    "rebecca"  "Ubuntu" "trusty"
check_alt "Linux Mint"    "rosa"     "Ubuntu" "trusty"
check_alt "Linux Mint"    "sarah"    "Ubuntu" "xenial"
check_alt "Linux Mint"    "serena"   "Ubuntu" "xenial"
check_alt "Linux Mint"    "sonya"    "Ubuntu" "xenial"
check_alt "Linux Mint"    "sylvia"   "Ubuntu" "xenial"
check_alt "Linux Mint"    "tara"     "Ubuntu" "bionic"
check_alt "Linux Mint"    "tessa"    "Ubuntu" "bionic"
check_alt "Linux Mint"    "tina"     "Ubuntu" "bionic"
check_alt "Linux Mint"    "tricia"   "Ubuntu" "bionic"
check_alt "LMDE"          "betsy"    "Debian" "jessie"
check_alt "LMDE"          "cindy"    "Debian" "stretch"
check_alt "elementaryOS"  "luna"     "Ubuntu" "precise"
check_alt "elementaryOS"  "freya"    "Ubuntu" "trusty"
check_alt "elementaryOS"  "loki"     "Ubuntu" "xenial"
check_alt "elementaryOS"  "juno"     "Ubuntu" "bionic"
check_alt "elementaryOS"  "hera"     "Ubuntu" "bionic"
check_alt "Trisquel"      "toutatis" "Ubuntu" "precise"
check_alt "Trisquel"      "belenos"  "Ubuntu" "trusty"
check_alt "Trisquel"      "flidas"   "Ubuntu" "xenial"
check_alt "Uruk GNU/Linux" "lugalbanda" "Ubuntu" "xenial"
check_alt "BOSS"          "anokha"   "Debian" "wheezy"
check_alt "BOSS"          "anoop"    "Debian" "jessie"
check_alt "BOSS"          "drishti"  "Debian" "stretch"
check_alt "bunsenlabs"    "bunsen-hydrogen" "Debian" "jessie"
check_alt "bunsenlabs"    "helium"   "Debian" "stretch"
check_alt "Tanglu"        "chromodoris" "Debian" "jessie"
check_alt "PureOS"        "green"    "Debian" "sid"
check_alt "Devuan"        "jessie"   "Debian" "jessie"
check_alt "Devuan"        "ascii"    "Debian" "stretch"
check_alt "Devuan"        "beowulf"  "Debian" "buster"
check_alt "Devuan"        "ceres"    "Debian" "sid"
check_alt "Deepin"        "panda"    "Debian" "sid"
check_alt "Deepin"        "unstable" "Debian" "sid"
check_alt "Deepin"        "stable"   "Debian" "buster"
check_alt "Pardus"        "onyedi"   "Debian" "stretch"
check_alt "Liquid Lemur"  "lemur-3"  "Debian" "stretch"

if [ "X${DISTRO}" == "Xdebian" ]; then
  print_status "Unknown Debian-based distribution, checking /etc/debian_version..."
  NEWDISTRO=$([ -e /etc/debian_version ] && cut -d/ -f1 < /etc/debian_version)
  if [ "X${NEWDISTRO}" == "X" ]; then
    print_status "Could not determine distribution from /etc/debian_version..."
  else
    DISTRO=$NEWDISTRO
    print_status "Found \"${DISTRO}\" in /etc/debian_version..."
  fi
fi

if [ "X${DISTRO}" == "Xbuster" ]; then
    if [ -f "/etc/apt/sources.list.d/mongodb-org.list" ]; then
        print_status 'Removing Launchpad PPA Repository for MongoDB...'
        exec_cmd "rm -f /etc/apt/sources.list.d/mongodb-org.list"
    fi

    print_status 'Adding the MongoDB signing key to your keyring...'

    if [ -x /usr/bin/curl ]; then
        exec_cmd 'curl -s https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -'
    else
        exec_cmd 'wget -qO- https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -'
    fi

    print_status "Creating apt sources list file for the MongoDB repo..."

    exec_cmd "echo 'deb http://repo.mongodb.org/apt/debian buster/mongodb-org/4.2 main' > /etc/apt/sources.list.d/mongodb-org.list"

    if [ ! -x /usr/bin/mongod ]; then
        MONGODB_INSTALL_PKGS="${MONGODB_INSTALL_PKGS} mongodb-org"
    fi
else
    if [ ! -x /usr/bin/mongod ]; then
        MONGODB_INSTALL_PKGS="${MONGODB_INSTALL_PKGS} mongodb"
    fi
fi

if [ "X${MONGODB_INSTALL_PKGS}" != "X" ]; then
    print_status "Populating apt-get cache..."
    exec_cmd 'apt-get update'

    print_status "Installing packages required for setup:${MONGODB_INSTALL_PKGS}..."
    exec_cmd "apt-get install -y${MONGODB_INSTALL_PKGS} > /dev/null 2>&1"
fi
}

install() {
print_status "Download the Open5GS Source Code (v${VERSION})..."
if [ -x /usr/bin/curl ]; then
    exec_cmd "curl -sLf 'https://github.com/open5gs/${PACKAGE}/archive/v${VERSION}.tar.gz' | tar zxf -"
    RC=$?
else
    exec_cmd "wget -qO- /dev/null 'https://github.com/open5gs/${PACKAGE}/archive/v${VERSION}.tar.gz' | tar zxf -"
    RC=$?
fi

if [[ $RC != 0 ]]; then
    print_status "Failed to download: https://github.com/open5gs/${PACKAGE}/archive/v${VERSION}.tar.gz"
    exit 1
fi

print_status "Build the Open5GS WebUI..."
exec_cmd "cd ./${PACKAGE}-${VERSION}/webui && npm ci --no-optional && npm run build"

print_status "Install the Open5GS WebUI..."
exec_cmd "mv ./${PACKAGE}-${VERSION}/webui /usr/lib/node_modules/${PACKAGE}"
exec_cmd_nobail "chown -R open5gs:open5gs /usr/lib/node_modules/${PACKAGE}"

exec_cmd "cat << EOF > /lib/systemd/system/open5gs-webui.service
[Unit]
Description=Open5GS WebUI
Wants=mongodb.service mongod.service

[Service]
Type=simple

WorkingDirectory=/usr/lib/node_modules/open5gs
Environment=NODE_ENV=production
ExecStart=/usr/bin/node server/index.js
Restart=always
RestartSec=2

[Install]
WantedBy=multi-user.target
EOF"

exec_cmd_nobail "systemctl daemon-reload"
exec_cmd "systemctl enable open5gs-webui"
exec_cmd "deb-systemd-invoke start open5gs-webui"

exec_cmd "rm -rf ./${PACKAGE}-${VERSION}"
}

postinstall() {

print_status "Default Administrator Account [Username:admin, Password:1423]..."

exec_cmd "cat << EOF > ./account.js
db = db.getSiblingDB('open5gs')
cursor = db.accounts.find()
if ( cursor.count() == 0 ) {
    db.accounts.insert({ salt: 'f5c15fa72622d62b6b790aa8569b9339729801ab8bda5d13997b5db6bfc1d997', hash: '402223057db5194899d2e082aeb0802f6794622e1cbc47529c419e5a603f2cc592074b4f3323b239ffa594c8b756d5c70a4e1f6ecd3f9f0d2d7328c4cf8b1b766514effff0350a90b89e21eac54cd4497a169c0c7554a0e2cd9b672e5414c323f76b8559bc768cba11cad2ea3ae704fb36abc8abc2619231ff84ded60063c6e1554a9777a4a464ef9cfdfa90ecfdacc9844e0e3b2f91b59d9ff024aec4ea1f51b703a31cda9afb1cc2c719a09cee4f9852ba3cf9f07159b1ccf8133924f74df770b1a391c19e8d67ffdcbbef4084a3277e93f55ac60d80338172b2a7b3f29cfe8a36738681794f7ccbe9bc98f8cdeded02f8a4cd0d4b54e1d6ba3d11792ee0ae8801213691848e9c5338e39485816bb0f734b775ac89f454ef90992003511aa8cceed58a3ac2c3814f14afaaed39cbaf4e2719d7213f81665564eec02f60ede838212555873ef742f6666cc66883dcb8281715d5c762fb236d72b770257e7e8d86c122bb69028a34cf1ed93bb973b440fa89a23604cd3fefe85fbd7f55c9b71acf6ad167228c79513f5cfe899a2e2cc498feb6d2d2f07354a17ba74cecfbda3e87d57b147e17dcc7f4c52b802a8e77f28d255a6712dcdc1519e6ac9ec593270bfcf4c395e2531a271a841b1adefb8516a07136b0de47c7fd534601b16f0f7a98f1dbd31795feb97da59e1d23c08461cf37d6f2877d0f2e437f07e25015960f63', username: 'admin', roles: [ 'admin' ], "__v" : 0})
}
EOF"
exec_cmd "mongo open5gs ./account.js"
exec_cmd "rm -f ./account.js"
}

## Defer setup until we have the complete script
uninstall
preinstall
install
postinstall
