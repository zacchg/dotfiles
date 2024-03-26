" unset vim settings
  set nocompatible noautoread hidden nobackup writebackup undofile viminfo='100,f0,<1000,s1000,:100,h
  let g:loaded_netrw=1 | let g:loaded_netrwPlugin=1
  autocmd! | " remove all autocmds

" configure paths
  let CreateDir = { _dir -> !isdirectory(_dir) && mkdir(_dir, 'p') }
  let $CACHE_DIR=expand('~/.cache/vim')
  let $CONFIG_DIR=expand('~/.config/vim')
  set viminfofile=$CACHE_DIR/viminfo | call CreateDir($CACHE_DIR)
  set   directory=$CACHE_DIR/swp     | call CreateDir(&directory)
  set   backupdir=$CACHE_DIR/backup  | call CreateDir(&backupdir)
  set     undodir=$CACHE_DIR/undo    | call CreateDir(&undodir)
  set     viewdir=$CACHE_DIR/view    | call CreateDir(&viewdir)
  set runtimepath=$CONFIG_DIR/runtime,$VIMRUNTIME

" indentation
  filetype plugin indent on
  setlocal ts=2 sw=2 sts=2 et
  autocmd Filetype text,json,sh,zsh,vim,css,js setlocal ts=2 sw=2 sts=2 et
  autocmd Filetype csv,go                      setlocal ts=4 sw=4 sts=4 noet
  autocmd BufNewFile,BufRead * setlocal formatoptions-=cro " don't continue comment on the next line

" layout, formatting, search, keys
  set encoding=utf-8 fileencoding=utf-8
  set backspace=indent,eol,start      " backspace through everything
  set scrolloff=5                     " show the following 5 lines while scrolling
  set number cursorline               " show the number column and highlight the current line
  set hlsearch noincsearch            " highlight all matches but don't search while typing
  set ignorecase smartcase            " case-insensitive searching unless contains uppercase
  set wildmenu wildmode=longest:full,full completeopt=menu,preview " completion
  set noshowcmd showtabline=2 laststatus=0 statusline=%f%=%c\ %l/%L\ " | " status line
  set timeoutlen=500                  " key combo timeout

" save and restore functions
  " forbid invalid filenames
  autocmd BufWritePre ["':;]* throw 'Forbidden filename: ' . expand('<afile>')
  " strip whitespace on save
  autocmd BufWritePre * :let b:w=winsaveview() | :%s/\s\+$//e | :call winrestview(b:w) | :unlet b:w
  " restore cursor to the last position
  autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif
