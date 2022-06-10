#!/usr/bin/env zsh

# paths
  HOMEBREW="/opt/homebrew"
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_CACHE_HOME="$HOME/.cache"
  export XDG_DATA_HOME="$HOME/.local/share"
  export XDG_RUNTIME_DIR="$HOME/.local/run"

# language paths
  export GOPATH="$HOME/go"
  export RUBIES_PATH="$HOME/.local/ruby/rubies"
  export BUNDLE_USER_HOME="$HOME/.local/ruby/bundle"
  export GEM_HOME="$HOME/.local/ruby/gem"
  export GEM_PATH="${GEM_HOME}"
  export GEM_SPEC_CACHE="${GEM_PATH}/specs"
  export N_PREFIX="$HOME/.local/n"
  export NODE_PATH="$HOME/.local/npm"

# git overrides
  [ -f "$HOME/.gitconfig_global" ] && \
    export GIT_CONFIG_GLOBAL="$HOME/.gitconfig_global"

# environment variables
  export LANG="en_US.UTF-8"
  export EDITOR="vim"
  export VIMINIT='let $MYVIMRC="$HOME/.vimrc" | source $MYVIMRC'
  export FZF_DEFAULT_COMMAND="fd --type f"
  export LESSHISTFILE="/dev/null"
  export HOMEBREW_NO_ANALYTICS=1

# zsh settings
  skip_global_compinit=1
  SHELL_SESSIONS_DISABLE=1
  KEYTIMEOUT=1 # 10ms
  bindkey -e
  umask 077 # scope permissions of new files to this user

# zsh features
  autoload -Uz compinit          ; compinit -d "${XDG_CACHE_HOME}/zsh/zcompcache"
  autoload -Uz promptinit        ; promptinit
  autoload -Uz select-word-style ; select-word-style bash
  autoload -Uz colors            ; colors

# zsh history
  setopt extended_history inc_append_history share_history hist_verify
  setopt hist_save_no_dups hist_find_no_dups hist_ignore_space hist_reduce_blanks
  HISTSIZE=1000 SAVEHIST=1000
  HISTFILE="${XDG_CACHE_HOME}/zsh/history-prepend" # permanent history items
  fc -R
  HISTFILE="${XDG_CACHE_HOME}/zsh/history"

# aliases for listing directories
  alias exa="\exa --group-directories-first --color=auto --time-style=long-iso"
  alias ll="exa -la --ignore-glob='.DS_Store'"
  alias l1="exa -1a --ignore-glob='.DS_Store'"
  alias t="\tree -I .git -C -a --dirsfirst -L 1"
  alias t.="t -L 1"
  alias t..="t -L 2"
  alias t...="t -L 3"

# command aliases
  alias vim="\nvim"
  alias git="TZ=UTC \git"
  alias g="git"
  alias diff="\colordiff"
  alias curl="noglob \curl --silent --show-error"
  alias be="bundle exec"
  alias tm="\date +%Y%m%d-%H%M%S" # timestamp -> 20210724-022731

# fuzzy finder
  if [ -d /usr/share/fzf ] ; then
    . /usr/share/fzf/completion.zsh 2>/dev/null
    . /usr/share/fzf/key-bindings.zsh 2>/dev/null
  elif [ -d "${HOMEBREW}"/opt/fzf/shell ] ; then
    . "${HOMEBREW}"/opt/fzf/shell/completion.zsh 2>/dev/null
    . "${HOMEBREW}"/opt/fzf/shell/key-bindings.zsh 2>/dev/null
  fi

# prompt
  case $OSTYPE in
    linux*) SPACESHIP_HOST_SHOW="always" ;;
  esac
  SPACESHIP_PROMPT_ORDER=(time jobs dir git_branch host line_sep line_sep char)
  SPACESHIP_PROMPT_PREFIXES_SHOW=false SPACESHIP_GIT_BRANCH_SUFFIX=" "
  SPACESHIP_TIME_SHOW=true SPACESHIP_TIME_FORMAT="↓" SPACESHIP_TIME_COLOR="gray"
  SPACESHIP_CHAR_SYMBOL="" SPACESHIP_CHAR_COLOR_SUCCESS="239"
  SPACESHIP_GIT_SYMBOL="" SPACESHIP_GIT_BRANCH_COLOR="gray"
  SPACESHIP_DIR_COLOR="blue"

  PS1='%1~ $ '
  (($SHLVL <= 1)) && prompt spaceship
  RPS1='' # fix ctrl+c error message from spaceship

# path
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
  # homebrew
  [ -d "${HOMEBREW}" ] && export PATH="${HOMEBREW}/bin:${HOMEBREW}/sbin:$PATH"
  # node
  export PATH="${N_PREFIX}/bin:$PATH"
  # go
  export PATH="$PATH:${GOPATH}/bin"
  # ruby
  _ruby_dir=$(find "${RUBIES_PATH}" -maxdepth 1 -type d 2>/dev/null | sort | tail -n1)
  [ ! -z "${_ruby_dir}" ] && export PATH="${_ruby_dir}/bin:$PATH"
  # nix
  export PATH="$HOME/.nix-profile/bin:/nix/var/nix/profiles/default/bin:$PATH"

# shell includes
  [ -f ~/.zshincludes ] && . ~/.zshincludes

# unset environment variables
  unset HOMEBREW SPACESHIP_ROOT SPACESHIP_VERSION
