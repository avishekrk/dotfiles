#ZSH_TMUX_AUTOSTART=true

source /usr/local/share/antigen/antigen.zsh
# Load the oh-my-zsh's library.
antigen use oh-my-zsh

# Bundles from the default repo (robbyrussell's oh-my-zsh).
antigen bundle git
antigen bundle pip
antigen bundle lein
antigen bundle command-not-found
antigen bundle colored-man-pages
antigen bundle dotenv
antigen bundle docker
antigen bundle dirhistory
antigen bundle git-extras
antigen bundle tmux
antigen bundle httpie
antigen bundle jsontools
antigen bundle pep8
antigen bundle pyenv
antigen bundle python
antigen bundle web-search


# Syntax highlighting bundle.
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen theme https://github.com/jhwhite/the-time-lord

antigen apply

export PIP_CONFIG_FILE="~/.pip/pip.conf"

source ~/.aliases

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/akumar67/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/akumar67/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/akumar67/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/akumar67/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
