#!/bin/bash

#install script for dotfiles

#emacs:just copy the init.el files to the right folder

echo "Installing EMACS"

PRELUDE_DIR="${HOME}/.emacs.d/personal/"
EMACS_DIR="${HOME}/.emacs.d/"

if [ -d ${PRELUDE_DIR} ]
then
    echo "${PRELUDE_DIR} exists installing inti.el there:"
    cp -v ./emacs/init.el ${PRELUDE_DIR}
elif [ -d ${EMACS_DIR} ]
then
    echo "${EMACS_DIR} exists installing init.el there:"
    cp -v ./emacs/init.el ${EMACS_DIR}
else
    echo "Neither ${PRELUDE_DIR} or ${EMACS_DIR} exists making ${EMACS_DIR}"
    mkdir -vp ${EMACS_DIR}
    cp -v ./emacs/init.el ${EMACS_DIR}
fi


echo "Installing aliases"

cp -v ./shell/.aliases ${HOME}
touch ${HOME}/.bashrc
echo "source .aliases" >> ${HOME}/.bashrc
source ~/.bashrc

echo "Installing sqliterc"
cp -v ./sqlite/.sqliterc ${HOME}
