#!/usr/bin/env zsh

# path
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
  [ -d /opt/homebrew ] && export PATH="/opt/homebrew/bin:$PATH"
  [ -d /opt/homebrew ] && FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"

# environment variables
  export LANG="en_US.UTF-8"
  export EDITOR="nvim"
  export NVIM_LOG_FILE="/dev/null"
  export NVIM_RPLUGIN_MANIFEST="/dev/null"
  export EZA_COLORS="sn=32:nb=92:xa=90:uu=30:da=90:di=34"
  export LESSHISTFILE="/dev/null"

# command aliases
  alias {vi,vim}="nvim"
  alias {git,g}="TZ=UTC git"
  alias diff="colordiff"
  alias curl="curl --silent --show-error"
  alias {grep,ugrep}="ugrep --ignore-files --smart-case"
  alias t="tree -C -a --dirsfirst -I .DS_Store -L 1"
  alias ll="eza -lA --group-directories-first --time-style=long-iso"
  alias tm="date +%Y%m%d-%H%M%S" # timestamp -> 20210724-022731

# zsh settings
  setopt extended_history inc_append_history hist_save_no_dups hist_reduce_blanks hist_ignore_space
  autoload -Uz compinit ; compinit -u -d ~/.cache/zsh/zcompcache
  autoload -Uz vcs_info ; zstyle ":vcs_info:git:*" formats " • %b"
  autoload -Uz select-word-style ; select-word-style bash
  PROMPT='$ '

# function to open project directory
  proj() {
    fd --exact-depth 2 --base-directory ~/Projects | fzf | read _d && cd ~/Projects/"${_d}"
  }

# function to build scoped history filename
  history-filename() {
    [[ $PWD =~ "^/(Volumes|mnt)/([^/]+)" ]] && local _append="-${match[1]}-${match[2]}"
    [[ $PWD =~ "^$HOME/Projects/([^/]+)/([^/]+)" ]] && local _append="-${match[1]}-${match[2]}"
    echo "history${_append}"
  }

# function to build tab title
  tab-title() {
    local _title="$(basename $PWD)"
    [[ $PWD = $HOME ]] && _title="~"
    if [[ $PWD =~ "^(/Volumes|mnt)/([^/]+)(/.)?" ]] ; then
      _title="${match[1]}/${match[2]}"
      [[ ${match[3]} != "" ]] && _title="$(basename $PWD) in ${_title}"
    elif [[ $PWD =~ "^$HOME/Projects/([^/]+)/([^/]+)(/.)?" ]] ; then
      _title="${match[1]}/${match[2]}"
      [[ ${match[3]} != "" ]] && _title="$(basename $PWD) in ${_title}"
    fi
    echo "${_title}"
  }

# zsh precmd
  precmd() {
    # clear history then import main or project-scoped or volume-scoped zsh history
    if [[ $HISTFILE != ~/.cache/zsh/"$(history-filename)" ]] ; then
      HISTSIZE=0     SAVEHIST=0     fc -p # clear history
      HISTSIZE=10000 SAVEHIST=10000 HISTFILE=~/.cache/zsh/"$(history-filename)"
      fc -R # import history
    fi

    # set the terminal tab title
    echo -n -e "\e]2;$(tab-title)\007"

    # display directory and vcs branch in the prompt
    vcs_info ; RPROMPT="%F{blue}$(tab-title)%F{8}${vcs_info_msg_0_}%F{reset}"
  }

# virtual machines
  open-vm-session() {
    local vm=$1 ; [ -z "${vm}" ] && return 1
    printf '\e]7;%s\a' "file://$HOST/opt/vm/${vm}"
    ssh "${vm}" DATE="'$(date 2>/dev/null)'" HOME="/home/$USER" zsh
    cd $HOME
  }
  # automatically open vm session for new terminal tabs
  [[ $PWD/ =~ ^/opt/vm/[^/]+/$ ]] && open-vm-session "$(basename $PWD)"

# fuzzy finder
  export FZF_DEFAULT_OPTS="--no-info --reverse --exact"
  export FZF_DEFAULT_COMMAND="fd --hidden --type=f"
  source <(fzf --zsh)

# custom server includes
  [ -f ~/.zshinclude ] && source ~/.zshinclude
