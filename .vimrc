" An example for a vimrc file.
"
" Maintainer:   Bram Moolenaar <Bram@vim.org>
" Last change:  2015 Mar 24
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"             for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"           for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup          " do not keep a backup file, use versions instead
else
  set backup            " keep a backup file (restore to previous version)
  set backupdir=~/.config/vim/backup//
  set directory=~/.config/vim/swap//
  set undofile          " keep an undo file (undo changes after closing)
endif
set history=50          " keep 50 lines of command line history
set ruler               " show the cursor position all the time
set showcmd             " display incomplete commands
set showmatch           " Show matching brackets.
set incsearch           " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent                " always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
                  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

if has("gui_running")
  set guifont=Monospace\ 10
  colorscheme torte
  set spell spelllang=en_us
endif

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=ucs-bom,utf8,prc

" Highlight search matches
set hlsearch

" Use spaces not tabs, and show them if exists
set list!
set listchars=tab:>-,trail:-,extends:>,precedes:<
set tabstop=2
set shiftwidth=2
set expandtab

" Tags configuration
set tags+=.tags

" Enable loading of local dir configurations
if filereadable("configure.vim")
  source configure.vim
endif

" No wrapping
set nowrap
set noundofile

" Allow leaving unnamed buffer with local modifications
set hidden

" Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

" Folding
set foldmethod=syntax
let g:xml_syntax_folding=1

" Colorscheme
let g:solarized_termcolors=256
colorscheme solarized

" If using a dark background within the editing area and syntax highlighting
" turn on this option as well
set background=dark

" Delete all buffers and quit, but for modified buffers ask what to do
command BufdoConfirmedDeletionAndQuit exe "bufdo confirm bdelete | quit"

map <F2> :NERDTreeToggle<CR>

:nnoremap <Tab>   :bnext<CR>
:nnoremap <S-Tab> :bnext<CR>

set visualbell
set cursorline

" if !exists("sphinx_colorcolumn_au")
"   autocmd! autocmd BufNewFile,BufRead *.rst set colorcolumn=120
"   let sphinx_colorcolumn_au = 1
" endif

