#!/usr/bin/env zsh

# path
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
  if [ -d /opt/homebrew ] ; then
    export PATH="/opt/homebrew/bin:$PATH"
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
  fi
  export PROJECTS="/opt/Projects" ; [ -d "$HOME/Projects" ] && export PROJECTS="$HOME/Projects"

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
  autoload -Uz compinit          ; compinit -u -d ~/.cache/zsh/zcompcache
  autoload -Uz select-word-style ; select-word-style bash
  autoload -Uz vcs_info          ; zstyle ":vcs_info:git:*" formats "%b"
  bindkey -e
  PROMPT='$ '

# zsh precmd
  precmd() {
    # save dark/light appearance mode for app theming
    if [[ "$OSTYPE" = "darwin"* ]] ; then
      export APPEARANCE="$(defaults read -g AppleInterfaceStyle 2>/dev/null)"
    fi

    # display directory and vcs branch above the prompt
    vcs_info ; [[ ! -z "${vcs_info_msg_0_}" ]] && local vcs=" %F{8}• ${vcs_info_msg_0_}"
    print -rP $'\n'"%F{blue}%1~${vcs}%F{reset}"

    # import main, volume-scoped, or project-scoped zsh history
    [[ $PWD =~ "^/(Volumes|mnt)/([^/]+)" ]] && local h="-${match[2]}"
    [[ $PWD =~ "^$PROJECTS/([^/]+)/([^/]+)" ]] && local h="-${match[1]}-${match[2]}"
    if [[ $HISTFILE != ~/.cache/zsh/"history${h}" ]] ; then
      HISTSIZE=0     SAVEHIST=0     fc -p # clear history
      HISTSIZE=10000 SAVEHIST=10000 HISTFILE=~/.cache/zsh/"history${h}"
      fc -R # import history
    fi

    # set the terminal tab title
    local title="$(basename $PWD)"
    [[ $PWD =~ "^$PROJECTS/([^/]+)/([^/]+)" ]] && title="${match[1]}/${match[2]}"
    [[ "$OSTYPE" != "darwin"* ]] && title="$HOST • ${title}"
    echo -n -e "\e]2;${title}\007"
  }

# fuzzy finder
  export FZF_DEFAULT_OPTS="--no-info --reverse --exact"
  export FZF_DEFAULT_COMMAND="fd --hidden --type=f"
  source <(fzf --zsh)

# file permissions
  umask 077 # scope permissions of new files to only this user

# projects
  proj() {
    local dir="$({ cd $PROJECTS && find */* -maxdepth 0 -type d ; } | fzf)"
    [ ! -z "${dir}" ] && [ -d $PROJECTS/"${dir}" ] && cd $PROJECTS/"${dir}"
  }

# virtual machines
  open-vm-session() {
    local vm=$1 ; [ -z "${vm}" ] && return 1
    PWD=/opt/vm/"${vm}" update_terminal_cwd
    APPEARANCE="$(defaults read -g AppleInterfaceStyle 2>/dev/null)"
    ssh "${vm}" DATE="'$(date 2>/dev/null)'" APPEARANCE="${APPEARANCE}" zsh
    cd $HOME
  }
  # automatically open vm session for new terminal tabs
  [[ $PWD/ =~ ^/opt/vm/[^/]+/$ ]] && open-vm-session "$(basename $PWD)"

# custom server includes
  [ -f ~/.zshinclude ] && source ~/.zshinclude
