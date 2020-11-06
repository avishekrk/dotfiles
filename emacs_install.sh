#!/bin/bash

SRC="${HOME}/src"
EMACS_VERSION="26.2"

echo Installing: emacs
mkdir "${SRC}/utils/emacs"
curl "https://ftp.gnu.org/pub/gnu/emacs/emacs-${EMACS_VERSION}.tar.gz" --output "${SRC}/utils/emacs/emacs-${EMACS_VERSION}.tar.gz"
tar -zxvf "${SRC}/utils/emacs/emacs-${EMACS_VERSION}.tar.gz" -C "${SRC}/utils/emacs"
cd "${SRC}/utils/emacs/emacs-${EMACS_VERSION}"
./configure
make && sudo make install
