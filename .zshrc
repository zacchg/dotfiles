#!/usr/bin/env zsh

# path
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
  if [ -d /opt/homebrew ] ; then
    export PATH="/opt/homebrew/bin:$PATH"
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
  fi
  if [ -d /etc/nix ] && [ -d /etc/nixos ] ; then
    export PATH="$HOME/.local/state/nix/profile/bin:/etc/profiles/per-user/$USER/bin:$PATH"
    export PATH="/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin:$PATH"
    export PATH="/run/wrappers/bin:$HOME/.nix-profile/bin:/nix/profile/bin:$PATH"
  fi

# environment variables
  export LANG="en_US.UTF-8"
  export EDITOR="nvim"
  export VIMINIT='let $MYVIMRC="$HOME/.vimrc" | source $MYVIMRC'
  export NVIM_LOG_FILE="/dev/null"
  export NVIM_RPLUGIN_MANIFEST="/dev/null"
  export LESSHISTFILE="/dev/null"

# command aliases
  alias {vim,nvim}="nvim -i NONE"
  alias {git,g}="TZ=UTC git"
  alias diff="colordiff"
  alias curl="curl --silent --show-error"
  alias ugrep="ugrep --ignore-files --smart-case"
  alias t="tree -C -a --dirsfirst -I .DS_Store -L 1"
  alias ll="eza -lA --group-directories-first --time-style=long-iso"
  alias tm="date +%Y%m%d-%H%M%S" # timestamp > 20210724-022731

# functions
  dtm() { \cp -a "$1" "$1-$(date +%Y%m%d-%H%M%S)" && \ls -1d "$1" "$1"-* }
  proj() {
    local d=$({ cd ~/Projects && find ./*/* -maxdepth 0 -type d ; } | cut -c 3- | fzf)
    [ ! -z "${d}" ] && [ -d ~/Projects/"${d}" ] && cd ~/Projects/"${d}"
  }

# zsh settings
  setopt extended_history inc_append_history hist_verify
  setopt hist_save_no_dups hist_ignore_space hist_reduce_blanks
  autoload -Uz compinit          ; compinit -u -d ~/.cache/zsh/zcompcache
  autoload -Uz select-word-style ; select-word-style bash
  autoload -Uz vcs_info          ; zstyle ":vcs_info:git:*" formats "%b"
  bindkey -e
  PROMPT='$ '

# zsh precmd
  precmd() {
    # save dark/light appearance mode for app theming
    export APPEARANCE="light"
    if [[ "$OSTYPE" = "darwin"* ]] ; then
      if [[ "Dark" = $(defaults read -g AppleInterfaceStyle 2>/dev/null) ]] ; then
        export APPEARANCE="dark"
      fi
    elif [[ $(date +%H) =~ "^(0[1-8]|19|2.)$" ]] ; then
      export APPEARANCE="dark"
    fi

    # display hostname, directory, and vcs branch in the prompt
    vcs_info ; local branch="${vcs_info_msg_0_}"
    [ ! -z "${branch}" ] && local vcs="%F{reset} %F{14}• ${branch}"
    [[ "$OSTYPE" != "darwin"* ]] && local host="%F{green}%m %F{14}• "
    print -rP $'\n'"${host}%F{blue}%1~${vcs}%F{reset}"$'\n'

    # import main, project-scoped, or volume-scoped zsh history
    [[ $PWD =~ "^/(Volumes|mnt)/([^/]+)" ]] && local f="-${match[2]}"
    [[ $PWD =~ "^$HOME/Projects/([^/]+)/([^/]+)" ]] && local f="-${match[1]}-${match[2]}"
    if [[ $HISTFILE != ~/.cache/zsh/"history${f}" ]] ; then
      HISTSIZE=0    SAVEHIST=0    fc -p # clear history
      HISTSIZE=10000 SAVEHIST=10000 HISTFILE=~/.cache/zsh/"history${f}"
      fc -R # import history
    fi

    # set the terminal tab title
    local t=$(basename $PWD)
    [[ $PWD =~ "^$HOME/Projects/([^/]+)/([^/]+)" ]] && local t="${match[1]}/${match[2]}"
    echo -n -e "\e]2;${t}\007"
  }

# fuzzy finder
  export FZF_DEFAULT_OPTS="--no-info --reverse"
  if [[ $APPEARANCE = "dark" ]] ; then
    export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --color='fg:14,fg+:15,bg:234,pointer:15'"
  fi
  export FZF_CTRL_T_COMMAND="fd --hidden --ignore --type=f"
  eval "$(fzf --zsh)"

# file permissions
  umask 077 # scope permissions of new files to only this user

# custom server or project includes
  [ -f ~/.zshinclude ] && source ~/.zshinclude
