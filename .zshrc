#!/usr/bin/env zsh

# paths
  HOMEBREW="/opt/homebrew"
  export PATH="${HOMEBREW}/bin:${HOMEBREW}/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
  export XDG_CONFIG_HOME="$HOME/.config"
  export XDG_CACHE_HOME="$HOME/.cache"
  export XDG_DATA_HOME="$HOME/.local/share"
  export XDG_RUNTIME_DIR="$HOME/.local/run"

# language paths
  export GOPATH="/opt/go"
  export NODE_PATH="/opt/npm"
  export BUNDLE_USER_HOME="/opt/ruby/bundle"
  export GEM_HOME="/opt/ruby/gem"
  export GEM_PATH="${GEM_HOME}"
  export GEM_SPEC_CACHE="${GEM_PATH}/specs"

# environment variables
  export EDITOR="vim"
  export VIMINIT='let $MYVIMRC="$HOME/.vimrc" | source $MYVIMRC'
  export LESSHISTFILE="/dev/null"
  export HOMEBREW_NO_ANALYTICS=1

# zsh settings
  skip_global_compinit=1
  SHELL_SESSIONS_DISABLE=1
  KEYTIMEOUT=1 # 10ms
  umask 077 # scope permissions of new files to this user

# zsh features
  autoload -Uz compinit          ; compinit -d "${XDG_CACHE_HOME}/zsh/zcompcache"
  autoload -Uz promptinit        ; promptinit
  autoload -Uz select-word-style ; select-word-style bash
  autoload -Uz colors            ; colors

# zsh history settings
  setopt extended_history inc_append_history share_history hist_verify
  setopt hist_save_no_dups hist_find_no_dups hist_ignore_space hist_reduce_blanks

# zsh history paths
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
  alias vim="nvim"
  alias git="TZ=UTC \git"
  alias g="git"
  alias diff="\colordiff"
  alias curl="noglob \curl --silent --show-error"
  alias be="bundle exec"
  alias tm="date +%Y%m%d-%H%M%S" # timestamp -> 20210724-022731

# fuzzy finder
  command -v fd >/dev/null && export FZF_DEFAULT_COMMAND="fd --type f"
  . ${HOMEBREW}/opt/fzf/shell/completion.zsh 2>/dev/null
  . ${HOMEBREW}/opt/fzf/shell/key-bindings.zsh 2>/dev/null

# prompt
  SPACESHIP_PROMPT_ORDER=(dir git line_sep jobs char)
  SPACESHIP_PROMPT_PREFIXES_SHOW=false
  SPACESHIP_CHAR_SYMBOL="❯ " SPACESHIP_GIT_SYMBOL=""
  SPACESHIP_DIR_COLOR="blue" SPACESHIP_GIT_BRANCH_COLOR="gray"
  SPACESHIP_CHAR_COLOR_SUCCESS="239"
  RPS1='' # fix ctrl+c error message from spaceship
  PS1='%1~ $ '

  if (($SHLVL <= 1)) ; then prompt spaceship ; fi

# shell includes
  [ -f ~/.zshincludes ] && . ~/.zshincludes

# reset path
  export PATH="${HOMEBREW}/bin:${HOMEBREW}/sbin:/usr/bin:/bin:/usr/sbin:/sbin"
  export PATH="${HOMEBREW}/opt/ruby/bin:${PATH}:${GOPATH}/bin"

# unset environment variables
  unset HOMEBREW SPACESHIP_ROOT SPACESHIP_VERSION
