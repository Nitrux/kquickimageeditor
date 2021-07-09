#!/bin/bash

set -x

apt -qq update
apt -qq -yy install equivs curl git wget gnupg2

### Replace Travis containers' sources file

apt-cache policy

wget -qO /etc/apt/sources.list.d/sources.list https://raw.githubusercontent.com/Nitrux/iso-tool/development/configs/files/sources.list.debian.unstable

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
	04EE7237B7D453EC \
	648ACFD622F3D138 > /dev/null

apt -qq update

### Install Dependencies

DEBIAN_FRONTEND=noninteractive apt -qq -yy install devscripts debhelper gettext lintian build-essential automake autotools-dev cmake extra-cmake-modules

mk-build-deps -i -t "apt-get --yes" -r

### Clone repo

git clone https://invent.kde.org/libraries/kquickimageeditor.git

mv kquickimageeditor/* .

rm -rf kquickimageeditor examples LICENSES koko-* README.md

### Build Deb

mkdir source
mv ./* source/ # Hack for debuild
cd source
debuild -b -uc -us
