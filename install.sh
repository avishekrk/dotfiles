#!/bin/bash

#install script for dotfiles

#emacs:just copy the init.el files to the right folder

PRELUDE_DIR="${HOME}/.emacs.d/personal/"
EMACS_DIR="${HOME}/.emacs.d/"

if [ -d ${PRELUDE_DIR} ]
then
    echo "${PRELUDE_DIR} exists installing inti.el there:"
    cp -v init.el ${PRELUDE_DIR}
elif [ -d ${EMACS_DIR} ]
then
    echo "${EMACS_DIR} exists installing init.el there:"
    cp -v init.el ${EMACS_DIR}
else
    echo "Neither ${PRELUDE_DIR} or ${EMACS_DIR} exists making ${EMACS_DIR}"
    mkdir -vp ${EMACS_DIR}
    cp -v init.el ${EMACS_DIR}
fi
