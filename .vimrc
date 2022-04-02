" unset vim settings
  if &compatible | set nocompatible | endif
  let g:loaded_netrw=1 | let g:loaded_netrwPlugin=1
  autocmd! | " remove all autocmds

" configure paths
  if has('nvim') | let $VIMAPP='nvim' | else | let $VIMAPP='vim' | endif
  let $XDG_DATA_HOME=expand('$XDG_CACHE_HOME/$VIMAPP/data')
  set viminfofile=~/.cache/$VIMAPP/viminfo | call mkdir(expand('~/.cache/$VIMAPP'), 'p')
  set directory=~/.cache/$VIMAPP/swp       | call mkdir(&directory, 'p')
  set backupdir=~/.cache/$VIMAPP/backup    | call mkdir(&backupdir, 'p')
  set undodir=~/.cache/$VIMAPP/undo        | call mkdir(&undodir, 'p')
  set viewdir=~/.cache/$VIMAPP/view        | call mkdir(&viewdir, 'p')
  set runtimepath=~/.cache/$VIMAPP/runtime,$VIMRUNTIME

" swap, backup, etc.
  set noautoread hidden nobackup writebackup undofile viminfo='100,f0,<100,s100,:100,h

" indent
  filetype plugin indent on
  autocmd Filetype sh,zsh,vim,text setlocal et ts=2 sw=2 sts=2
  autocmd Filetype go setlocal noet ts=4 sw=4 sts=4
  autocmd BufNewFile,BufRead *  setlocal formatoptions-=cro " don't continue comment on the next line

" theme
  set background=light | if strftime('%H') < 8 || strftime('%H') > 17 | set background=dark | endif
  if &background ==? 'dark'
    autocmd colorscheme paramount highlight Normal ctermbg=8
  endif
  try | colorscheme paramount | catch | endtry

" layout, formatting, search
  set backspace=indent,eol,start     " backspace through everything
  set scrolloff=5                    " show the following 5 lines while scrolling
  set nojoinspaces                   " one space on shift+j
  set number numberwidth=1           " number column
  set cursorline                     " highlight current line
  set hlsearch noincsearch           " highlight all matches but don't search while typing
  set ignorecase smartcase           " case-insensitive searching unless contains uppercase
  set wildmenu wildmode=longest:full,full completeopt=menu,preview " completion
  set noshowcmd showtabline=2 laststatus=0 statusline=%f%=%c\ %l/%L\ " | " status line

" keys
  set timeoutlen=500 ttimeoutlen=100 " key combo timeouts
  map <S-k> <Nop>|                   " disable help lookup for the word under the cursor

" save and restore functions
  " forbid invalid filenames
  autocmd BufWritePre ["':;]* throw 'Forbidden filename: ' . expand('<afile>')
  " strip whitespace on save
  autocmd BufWritePre * :let b:w=winsaveview() | :%s/\s\+$//e | :call winrestview(b:w) | :unlet b:w
  " restore cursor to the last position
  autocmd BufReadPost *
  \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit' | exe "normal! g`\"" | endif

