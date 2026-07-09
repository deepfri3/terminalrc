" George Baker's Vim config
" Since: 2012
"
" Links
" https://github.com/skwp/dotfiles/blob/master/vimrc
" http://nvie.com/posts/how-i-boosted-my-vim/
" http://amix.dk/vim/vimrc.html
" http://www.yolinux.com/TUTORIALS/LinuxTutorialAdvanced_vi.html
filetype off

" Startup
let s:colorful_term = (&term =~ "xterm") || (&term =~ "screen")
let g:running_windows = has("win16") || has("win32") || has("win64")
let g:running_nvim = has('nvim')

if g:running_windows
  " Load with Windows paths
  set runtimepath^=P:\\George\\vim\\windows\\vimfiles

  " Specify a directory for plugins
  if g:running_nvim
    call plug#begin('~\AppData\Local\nvim-data\site\plugged')
  else
    call plug#begin('~/vimfiles/plugged')
  endif
    " Make sure you use single quotes

  Plug 'chriskempson/base16-vim'

  call plug#end()
  :cd D:\OneDrive\OneDrive\ -\ Siemens\ AG
else
  " Load with Linux paths
  " set runtimepath^=~/pCloudDrive/George/vim/linux/vimfiles
endif

" Basics
set nocompatible " explicitly get out of vi-compatible mode
set fenc=utf-8 " UTF-8
let g:skip_loading_mswin=1 " Just in case :
set autoread

" switch syntax highlighting on, when terminal has colors
" set default colorscheme and background
syntax on " syntax highlighting on
syntax enable

if &term =~ '256color'
  " https://sunaku.github.io/vim-256color-bce.html
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

" use colorscheme per environment
if has("gui_running")
  "gVim"
  " Set extra options when running in GUI mode if has("gui_running")
  " universal colorscheme
  colorscheme base16-tomorrow-night
  " font set and size
  if g:running_windows
    " windows
    "set guifont=Source_Code_Pro_Medium:h9:cANSI
    "set guifont=Source_Code_Pro_Medium:h11:cANSI
    set guifont=Source\ Code\ Pro\ for\ Powerline:h9:cANSI
    "set guifont=Source\ Code\ Pro\ for\ Powerline:h11:cANSI
    "set guifont=Source\ Code\ Pro\ for\ Powerline:h13:cANSI
    "set guifont=Consolas:h9:cANSI
  else
    " linux
    "set guifont=Inconsolata\ for\ Powerline\ 10 " set default font
    "set guifont=Source\ Code\ Pro\ Regular\ 8
    set guifont=Source\ Code\ Pro\ Semibold\ 8
  endif
  " other gui options
  set guioptions-=T
  set guioptions+=e
  set guitablabel=%M\ %t
else
  "vim"
  "support base16 colorschemes
  set termguicolors
  if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
  endif "support base16 colorschemes
  " favorite colorschemes :)
  "colorscheme Tomorrow-Night
  colorscheme base16-tomorrow-night
  "colorscheme base16-phd
  "colorscheme base16-oceanicnext
  " font is set by the shell program
endif

set colorcolumn=80 " highlights column 80
highlight ColorColumn ctermbg=0 guibg=gray14

set ruler " Show the line and column number of the cursor position,
          " separated by a comma.
set number " show line numbers
set hidden " preserver buffers
set nowrap " dont wrap lines
set linebreak "wrap lines at convenient location
set showmatch " When a bracket is inserted, briefly jump to the matching
              " one. The jump is only done if the match can be seen on the
              " screen. The time to show the match can be set with
              " 'matchtime'.

set tabstop=4 softtabstop=4 " tab is 2 spaces
set shiftwidth=4 " number of spaces to use for autoindenting
set expandtab " use spaces instead of tabs
set smartindent " smart indent
set copyindent " copy the previous indentation on autoindenting
set backspace=indent,eol,start
              " allow backspacing over everything in insert mode
set showmatch " set show matching parenthesis
set smartcase " ignore case if search pattern is all lower-case
set incsearch " show search matches as you type
set hlsearch  " highlight search terms

" Open new split panes to right and bottom, which feels more natural than Vim’s default:
set splitbelow
set splitright

set autoread  " reload files edited outside of vim
set autowrite " write file when switching between buffers

"set backup " enable vim backups
set nobackup " disable vim backups
"set writebackup " enable vim backups
"set swapfile " enable swap file
set noswapfile "disable swap file
set undofile " enable vim undo history
set undolevels=1000 " use many muchos levels of undo

if g:running_windows
  " Windows
  silent !mkdir C:\vimfiles\undodir
  set undodir=C:\vimfiles\undodir " Keep undo history across sessions, by storing in file.
  "silent !mkdir C:\_vim\_undo C:\_vim\_backup C:\_vim\_swp
  "set undodir=C:\_vim\_undo\\ " Keep undo history across sessions, by storing in file.
  "set backupdir=C:\_vim\_backup\\ " backup files
  "set directory=C:\_vim\_swp\\ " swap files
  "set viminfo+='100,f1,nC:\\_vim\\_viminfo  "Save up to 100 marks, enable capital marks
  set viminfo+='100,f1,nC:\\vimfiles\\_viminfo  "Save up to 100 marks, enable capital marks
else
  " Linux
  silent execute '!mkdir -p ~/.vim/undodir'
  set undodir=~/.vim/undodir// " Keep undo history across sessions, by storing in file.
  "set undodir=~/.vimcache/.undo// " Keep undo history across sessions, by storing in file.
  "set backupdir=~/.vimcache/.backup// " backup files
  "set directory=~/.vimcache/.swp// " swap files
  set viminfo+='100,f1,n~/.vim/.viminfo  "Save up to 100 marks, enable capital marks
endif

set history=1000         " remember more commands and search history
set title                " change the terminal's title
set noerrorbells         " don't beep
set showcmd              " Show incomplete cmds down the bottom
set showmode             " Show current mode down the bottom
set gcr=a:blinkon0       " Disable cursor blink

set wildmenu 						 " better command-line completion
set wildmode=list:longest,full
"stuff to ignore when tab completing
set wildignore=tags,*.tags,.tags,*.map,*.o,*.obj,*~,*.swp,*.bak,*.pyc,*.class,*.d,*.o,*.a,*.dsw,*.dsp,*.hgc,*.hrc
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif             "

set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
"              | | | | |  |   |      |  |     |    |
"              | | | | |  |   |      |  |     |    + current column
"              | | | | |  |   |      |  |     +-- current line
"              | | | | |  |   |      |  +-- current % into file
"              | | | | |  |   |      +-- current syntax in square brackets
"              | | | | |  |   +-- current fileformat
"              | | | | |  +-- number of lines
"              | | | | +-- preview flag in square brackets
"              | | | +-- help flag in square brackets
"              | | +-- readonly flag in square brackets
"              | +-- modified flag in square brackets
"              +-- full path to file in the buffer

" To enable the saving and restoring of screen positions.
let g:screen_size_restore_pos = 1

" To save and restore screen for each Vim instance.
" This is useful if you routinely run more than one Vim instance.
" For all Vim to use the same settings, change this to 0.
let g:screen_size_by_vim_instance = 1

if has("gui_running")
  function! ScreenFilename()
    if has('amiga')
      return "s:.vimsize"
    elseif g:running_windows
      " Windows
      return 'C:\_vim\_vimsize'
    else
      " Linux
      return $HOME.'/.vim/.vimsize'
    endif
  endfunction

  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let f = ScreenFilename()
    if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
          return
        endif
      endfor
    endif
  endfunction

  function! ScreenSave()
    " Save window size and position.
    if has("gui_running") && g:screen_size_restore_pos
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
            \ (getwinposx()<0?0:getwinposx()) . ' ' .
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif
  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif
  autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
  autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
endif


" ## Ease of use ##
"
" map escape to F3
map <F3> <Esc>
map! <F3> <Esc>
" remap leader key '\'
let mapleader = ","
let g:C_MapLeader = ','
" remap ':' to ';' to save keystrokes
nnoremap ; :
" Fast saving
nmap <leader>w :w!<cr>


" ## Navigation mappings ##
"
" Do not allow arrow keys!!! Real vimmers don't use them!!!
map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>
" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" Go back and forth between buffers
nmap <S-J> :bp<CR>
nmap <S-K> :bn<CR>
" Delete buffer in current frame w/o closing frame
nmap <S-Z> :bp <BAR> bd #<cr>
map <silent> <leader>bd :Bclose<cr>
" List buffers
"nnoremap <leader>bb :ls<CR>:b<space>
" Create new buffer
nmap <leader>T :enew<cr>
" Change to local/current directory of buffer
nnoremap <silent> <leader>cd :lchdir %:p:h<CR>
" Close frame
nmap <leader>df :close<cr>
" Define the project root directory for building, running, and navigating
" Assume getcwd() == "$VIEWROOT/<viewtag>/XLS_Linux/linux-apps/pmiApp"
let g:proj_root=getcwd()
" Function to change dir to project root dir
function! ProjRoot()
  execute 'cd' fnameescape(g:proj_root)
  echo 'Project Root: '.getcwd()
endfunction
" Change to the proj_root directory
noremap <silent> <F12> :call ProjRoot()<cr>
" Easy vim splits
"https://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/
nmap <leader>swh :topleft  vnew<CR>
nmap <leader>swl :botright vnew<CR>
nmap <leader>swk :topleft  new<CR>
nmap <leader>swj :botright new<CR>
nmap <leader>sh :leftabove  vnew<CR>
nmap <leader>sl :rightbelow vnew<CR>
nmap <leader>sk :leftabove  new<CR>
nmap <leader>sj :rightbelow new<CR>
" resize current buffer by +/- 5
" expand right
nnoremap <leader>srh :vertical resize -5<cr>
" expand down
nnoremap <leader>srj :resize +5<cr>
" expand up
nnoremap <leader>srk :resize -5<cr>
" expand left
nnoremap <leader>srl :vertical resize +5<cr>
" equalize buffers
nnoremap <leader>seq <C-W>=

" enable file type specific settings
if has('autocmd')
  "autocmd filetype cpp source $DROPBOX/George/vim/vimfiles/bundle/syntax/cpp.vim
  autocmd filetype cpp source $DROPBOX/George/vim/vimfiles/bundle/syntastic/syntax_checkers/cpp/cpplint.vim
  "autocmd filetype c source $DROPBOX/George/vim/vimfiles/bundle/syntax/c.vim
  autocmd filetype c source $DROPBOX/George/vim/vimfiles/bundle/syntastic/syntax_checkers/c/pc_lint.vim
  "autocmd filetype py source $DROPBOX/George/vim/vimfiles/bundle/syntax/python.vim
  autocmd filetype py source $DROPBOX/George/vim/vimfiles/bundle/syntastic/syntax_checkers/python/python.vim
  "autocmd filetype pl source $DROPBOX/George/vim/vimfiles/bundle/syntax/perl.vim
  autocmd filetype pl source $DROPBOX/George/vim/vimfiles/bundle/syntastic/syntax_checker/perl/perl.vim
  "autocmd filetype xml source $DROPBOX/George/vim/vimfiles/bundle/syntax/xml.vim
  autocmd filetype xml source $DROPBOX/George/vim/vimfiles/bundle/syntastic/syntax_checkers/xmllint.vim
  "autocmd filetype sh source $DROPBOX/George/vim/vimfiles/bundle/syntax/sh.vim
  autocmd filetype sh source $DROPBOX/George/vim/vimfiles/bundle/syntastic/syntax_checkers/sh/shellcheck.vim
endif

" ## CTAGS mappings ##
"
" build ctags for current directory
if g:running_windows
  " Windows
  "let g:tagbar_ctags_bin = "C:\\_ctags\\ctags.exe"
  let g:tagbar_ctags_bin = "ctags.exe"
  map <F11> :!ctags -R .<CR><CR>
else
  " Linux
  " Change to the proj_root directory and execute ctags from proj_root
  nnoremap <F11> :call ProjRoot()<cr>:Dispatch ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>:Dispatch gtags<cr>:call ProjRoot()<cr>
  "nnoremap <F11> :call ProjRoot()<cr>:Dispatch! ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>:Dispatch! gtags<cr>:call ProjRoot()<cr>
  "nnoremap <F11> :call ProjRoot()<cr>:Dispatch ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>
  "nnoremap <F11> :call ProjRoot()<cr>:Dispatch! ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>:call ProjRoot()<cr>
endif
" C-] - go to definition = Ctrl-Left_MouseClick - Go to definition
" C-T - Jump back from the definition.(or :pop) = Ctrl-Right_MouseClick - Jump back from definition
" C-W C-] - Open the definition in a horizontal split
" Open the definition in a vertical split
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
":tag start-of-tag-name_TAB
"  Vim supports tag name completion. Start the typing the tag name and then type the TAB key and name completion will complete the tag name for you.
":tag /search-string
"  Jump to a tag name found by a search.
":tselect <function-name>
"  When multiple entries exist in the tags file, such as a function declaration in a header
"  file and a function definition (the function itself), the operator can choose by issuing this command.
"  The user will be presented with all the references to the function and the user will be prompted to enter the number associated with the appropriate one.
map <leader>ts :tselect <CR>/
":tags 	 - Show tag stack (history)
":4pop 	 - Jump to a particular position in the tag stack (history). (jump to the 4th from bottom of tag stack (history).
":4tag   - jump to the 4th from top of tag stack)
":tnext  - Jump to next matching tag (Also short form :tn and jump two :2tnext)
map <leader>tn :tnext<cr>
":tprevious	- Jump to previous matching tag. (Also short form :tp and jump two :2tp)
map <leader>tp :tprevious<cr>
":tfirst 	  - Jump to first matching tag. (Also short form :tf, :trewind, :tr)
map <leader>tf :tfirst<cr>
":tlast 	  - Jump to last matching tag. (Also short form :tl)
map <leader>tl :tlast<cr>


" ## Plugin mappings ##
"
" ++ SYNTASTIC ++
" Check syntax on file open
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_open=1
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'passive_filetypes': ['Ruby', 'c', 'cpp', 'python', 'sh', 'java', 'lisp'],
                           \ 'active_filetypes': [] }
" When syntax errors are detected a flag will be shown in the statusline
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
"
" ++ TAGBAR ++
" put cursor in tagbar when opened
let g:tagbar_autofocus = 0
" close tagbar when you jump to a tag
let g:tagbar_autoclose = 1
" open tagbar on the left
let g:tagbar_left = 1
" open/close tagbar
nmap <F9> :TagbarToggle<CR>
" Remove extra space
let g:tagbar_compact = 1
let g:tagbar_updateonsave_maxlines=10000
"
" ++ NERDTREE ++
" NERDTree ignore files
let g:NERDTreeIgnore=['\.vim$', '\~$','\.cat$']
" Automatically centers on cursor focus
let g:NERDTreeAutoCenter=1
" Pretty colors!
let g:NERDChristmasTree=1
" Open NERDTree positions
let g:NERDTreeWinPos='left'
" Closes the tree window after opening a file.
let g:NERDTreeQuitOnOpen=0
" Toggle NERDTree Open/Close
nmap <F8> :NERDTreeToggle<CR>
"
" ++ SURROUND ++
" Surround line with Parens:
nmap <leader>) yss)
nmap <leader>( yss(
" Surround selection with Parens:
vmap <leader>) S)
vmap <leader>( S(
" Surround line with brackets:
nmap <leader>] yss]
nmap <leader>[ yss[
" Surround selection with brackets:
vmap <leader>] S]
vmap <leader>[ S[
" Surround line with quotes:
nmap <leader>" yss"
" Surround selection with quotes:
vmap <leader>" S"
" Surround line with single quote:
nmap <leader>' yss'
" Surround selection with single quote:
vmap <leader>' S'
"
" ++ SUPERTAB ++
"let g:SuperTabDefaultCompletionType = "context"
"
" ++ SNIPMATE ++
imap <C-L> <Plug>snipMateNextOrTrigger
smap <C-L> <Plug>snipMateNextOrTrigger
imap <C-K> <Plug>snipMateTrigger
imap <C-H> <Plug>snipMateBack
smap <C-H> <Plug>snipMateBack
imap <C-J> <Plug>snipMateShow
vmap <C-J> <Plug>snipMateVisual
"
" ++ NUMBERS ++
" Enable numbers by default
let g:enable_numbers=0
" Toggle numbers on/off
nnoremap <F10> :NumbersToggle<CR>
" Numbers dont belong here
let g:numbers_exclude = ['unite', 'tagbar', 'startify', 'gundo', 'vimshell', 'w3m', 'nerdtree', 'buffergator', 'grep', 'Grep']
"
" ++ CTRLP ++
if g:running_windows
  " Trigger
  nmap <leader>t <C-p>
  " Find using tags file
  nmap <leader>tag :CtrlPBufTag<CR>
  " Open buffer List
  nmap <leader>bb :CtrlPBuffer<CR>
endif
" Open jump List
nmap <leader>j :CtrlPMRUFiles<CR>
" Open List buf + mru + fil
nmap <leader>m :CtrlPMixed<CR>
" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg|dsw|dsp)$',
\}
" format of the matching window
let g:ctrlp_match_window = 'top,order:btt,min:1,max:25,results:25'
" Set this to 1 to show only MRU files in the current working directory
let g:ctrlp_mruf_relative = 1
" Specify the number of recently opened files you want CtrlP to remember: >
let g:ctrlp_mruf_max = 30
" Do not clear cache on vim exit
let g:ctrlp_clear_cache_on_exit = 0
" Enable/Disable per-session caching:
"  0 - Disable caching, 1 - Enable caching, n - When bigger than 1, disable caching and use the number as the limit to enable caching again.
"  Note: you can quickly purge the cache by pressing <F5> while inside CtrlP.
let g:ctrlp_use_caching = 1
" Set this to 0 to enable cross-session caching by not deleting the cache files upon exiting Vim:
if g:running_windows
  " Windows
  let g:ctrlp_cache_dir = 'C:\vimfiles\_ctrlp'
else
  " Linux
  let g:ctrlp_cache_dir = $HOME.'/.vim/ctrlp'
endif
" Command-T matcher extenstions for CtrP
" Set the directory to store the cache files:
if g:running_windows
  " JazzCore - https://github.com/JazzCore/ctrlp-cmatcher/
  "let g:ctrlp_match_func = {'match' : 'matcher#cmatch' }
"else
  "FelikZ - https://github.com/FelikZ/ctrlp-py-matcher
  let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
endif
"
" ++ TABULAR ++
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a,, :Tabularize /,\zs<CR>
vmap <Leader>a,, :Tabularize /,\zs<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
nmap <Leader>a# :Tabularize /#define\s\+\w*\zs<CR>
vmap <Leader>a# :Tabularize /#define\s\+\w*\zs<CR>
nmap <Leader>a// :Tabularize /\/\/<CR>
vmap <Leader>a// :Tabularize /\/\/<CR>
nmap <Leader>a" :Tabularize /"<CR>
vmap <Leader>a" :Tabularize /"<CR>
"
" ++ VIM-AIRLINE ++
" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
" Enable use of powerline fonts
"let g:airline_powerline_fonts = 1
" Always show the statusline
set laststatus=2
"
" ++ BUFFERGATOR ++
" Use the right side of the screen
let g:buffergator_viewport_split_policy = 'T'
" I want my own keymappings...
let g:buffergator_suppress_keymaps = 1
" autoupdate buffer list in catalog
let g:buffergator_autoupdate = 1
" show only the buffer name
let g:buffergator_display_regime = "basename"
" show the full directory path
"let g:buffergator_show_full_directory_path = 0
" keep catalog window open
let g:buffergator_autodismiss_on_select = 1
" Go to the previous buffer open
nmap <leader>kk :BuffergatorMruCyclePrev<cr>
" Go to the next buffer open
nmap <leader>jj :BuffergatorMruCycleNext<cr>
" View the entire list of buffers open
nmap <leader>bl :BuffergatorOpen<cr>
"
" ++ GREP ++
" Search these files by default
let Grep_Default_Filelist = '*.c* *.h*'
" Skip these files by default
let Grep_Skip_Files = '*.bak *~ tags *.o *.a *.keep'
" Grep for selection in open buffers
nnoremap <silent> <leader>gb :GrepBuffer<CR>
" Grep for selection recursively
nnoremap <silent> <leader>gr :Rgrep<CR>
" The output of the grep command will be listed in the Vim quickfix window.
" You can use the :cnext and :cprev commands to the jump to the next or
" previous output line.
nnoremap <silent> <leader>gn :cnext<CR>
nnoremap <silent> <leader>gp :cprev<CR>
" You can use the :colder and :cnewer commands to go between multiple
" grep quickfix output windows.
nnoremap <silent> <leader>ng :cnewer<CR>
nnoremap <silent> <leader>pg :colder<CR>
" The quickfix window need not be opened always to use the grep output.
" You can close the quickfix window and use the quickfix commands to jump
" to the grep matches.  Use the :copen command to open the quickfix
" window again.
nnoremap <silent> <leader>gc :colder<CR>
"
" ++ FZF - Fuzzy finder ++
if !g:running_windows
  "
  " This is the default extra key bindings
  let g:fzf_action = {
    \ 'ctrl-t': 'tab split',
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit' }
  " Default fzf layout
  let g:fzf_layout = { 'up': '50%'}
  " add fzf directory to runtime path
  set rtp+=$DROPBOX/George/Linux/common/fzf
  " Invoke fuzzy finder to find files
  "nnoremap <silent> <leader>t :FZF <cr>
  nnoremap <silent> <leader>t :Files <cr>
  " List buffers
  "nnoremap <silent> <leader>bb :FZFbuf<cr>
  nnoremap <silent> <leader>bb :Buffers<cr>
  " Simple MRU search - v:oldfiles
  "nnoremap <silent> <Leader><Enter> :FZFMru<cr>
  nnoremap <silent> <Leader><Enter> :History<cr>
endif
"
" ++ Ag - the silver searcher ++
if !g:running_windows
  let g:ag_prg="ag --vimgrep --smart-case --path-to-agignore ~/.agignore"
  " specify the project root direoctory path for searching
  let g:ag_working_path_mode="r"
  " If 1, highlight the search terms after searching. Default: 0.
  let g:ag_highlight=1
  "Format to recognize the matches. See 'errorformat' for more info.
  let g:ag_format="%f:%l:%c:%m"
endif


" ## Search function mappings ##
"
" search on the selected text in visual mode
vnoremap g/ y/<C-R>"<CR>
" clear highlighted
nmap <silent> ,/ :nohlsearch<CR>
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
" Search for current word using Ag
nmap <F5> :exec("Ag ".expand("<cword>"))<CR>
vnoremap <F5> y :exec("Ag ".expand("<C-R>""))<CR>
" Search for current word in tags
nmap <F6> :exec("Tags ".expand("<cword>"))<CR>


" ## CCASE ##
"
if g:running_windows
  " cleartool in windows
  let g:ccaseCmd = '!cleartool'
else
  " rcleartool in linux
  let g:ccaseCmd = 'Dispatch rcleartool'
endif


" ## Quicly edit/reload the vimrc file ##
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>


" ## Editing, Copying, Pasting, Files ##
"
" set clipboard instead of default
  if g:running_windows
  " windows
  set clipboard+=unnamed
else
  " linux
  set clipboard=unnamedplus
endif
" map a shortcut to make current buffer/file writeable
nmap <leader>wr :!chmod a+w %<CR><Esc>
" map a shortcut to make current buffer/file read-only
nmap <leader>ro :!chmod a-w %<CR><Esc>
" map a shortcut to copy to the system-wide buffer (clipboard)
map <leader>cp "+yy
" map a shortcut to paste from the system-wide buffer (clipboard)
map <leader>pa "*p
" map a shortcut to break a line
nmap <silent> <leader>br 0ji<CR><Esc>
" Return to last edit position when opening files (You want this!)
autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" copy current file name (relative/absolute) to system clipboard (Linux version)
if has("unix")
  " relative path (src/foo.txt)
  nnoremap <leader>cf :let @+=expand("%")<CR>
  " absolute path (/something/src/foo.txt)
  nnoremap <leader>cF :let @+=expand("%:p")<CR>
  " filename (foo.txt)
  nnoremap <leader>ct :let @+=expand("%:t")<CR>
  " directory name (/something/src)
  nnoremap <leader>ch :let @+=expand("%:p:h")<CR>
  " current line number
  nnoremap <leader>cl :let @+=line(".")<CR>
  " breakpoint for gdb
  nnoremap <leader>bp :let @+="break ".expand("%").":".line(".")<CR>
endif
" reload file
nnoremap <leader>rr :edit<cr>
" complete path
imap <leader>fp <c-x><c-f>


" ## Formatting ##
"
" Show tabs and whitespace when needed
set listchars=tab:>-,trail:!,eol:$
nmap <silent> <leader>s :set nolist!<CR>
" remove end of line spaces;
nmap <silent> <leader>dt :%s/\s\+$//<cr>
" add semicolon at end of line
nmap <silent> <leader>; <s-a>;<esc>|
" add colon at end of line
nmap <silent> <leader>: <s-a>:<esc>|



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! CmdLine(str)
  exe "menu Foo.Bar :" . a:str
  emenu Foo.Bar
  unmenu Foo
endfunction

function! VisualSelection(direction) range
  let l:saved_reg = @"
  execute "normal! vgvy"

  let l:pattern = escape(@", '\\/.*$^~[]')
  let l:pattern = substitute(l:pattern, "\n$", "", "")

  if a:direction == 'b'
      execute "normal ?" . l:pattern . "^M"
  elseif a:direction == 'gv'
      call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
  elseif a:direction == 'replace'
      call CmdLine("%s" . '/'. l:pattern . '/')
  elseif a:direction == 'f'
      execute "normal /" . l:pattern . "^M"
  endif

  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

" Returns true if paste mode is enabled
function! HasPaste()
  if &paste
    return 'PASTE MODE  '
  endif
  return ''
endfunction

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")

  if buflisted(l:alternateBufNum)
    buffer #
  else
    bnext
  endif

  if bufnr("%") == l:currentBufNum
    new
  endif

  if buflisted(l:currentBufNum)
    execute("bdelete! ".l:currentBufNum)
  endif
endfunction

function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)
  "Create a cache file if not yet exists
  let cachefile = ctrlp#utils#cachedir().'/matcher.cache'

  if !( filereadable(cachefile) && a:items == readfile(cachefile) )
    call writefile(a:items, cachefile)
  endif

  if !filereadable(cachefile)
    return []
  endif

  " a:mmode is currently ignored. In the future, we should probably do
  " something about that. the matcher behaves like "full-line".
  let cmd = g:path_to_matcher.' --limit '.a:limit.' --manifest '.cachefile.' '

  if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
    let cmd = cmd.'--no-dotfiles '
  endif

  let cmd = cmd.a:str

  return split(system(cmd), "\n")
endfunction

" Fuzzy Finder helper functions
function! s:buflist()
  redir => ls
  silent ls
  redir END
  return split(ls, '\n')
endfunction

function! s:bufopen(e)
  execute 'buffer' matchstr(a:e, '^[ 0-9]*')
endfunction

function! s:all_files()
  return extend(
  \ filter(copy(v:oldfiles),
  \        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
  \ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
endfunction

" List buffers
command! FZFbuf call fzf#run({
\   'source':    reverse(<sid>buflist()),
\   'sink':      function('<sid>bufopen'),
\   'options':   '+m --ansi --color hl:197,hl+:10',
\   'up':        '50%'
\ })<CR>

"" List buffers
"command! FZFbuf call fzf#run({
"\   'source':  reverse(<sid>buflist()),
"\   'sink':    function('<sid>bufopen'),
"\   'options': '+m',
"\   'down':    len(<sid>buflist()) + 2
"\ })<CR>

"Simple MRU search - v:oldfiles
command! FZFMruSimple call fzf#run({
\  'source':  v:oldfiles,
\  'sink':    'e',
\  'options': '-m -x --ansi --color hl:197,hl+:10',
\  'up':      '50%'})

" Filtered v:oldfiles and open buffers
command! FZFMruAll call fzf#run({
\ 'source':  reverse(s:all_files()),
\ 'sink':    'edit',
\ 'options': '-m -x --ansi --color hl:197,hl+:10',
\ 'up':      '50%' })

" Tags in project
" This version better handles same tags across different files.
function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction
command! TagsSink call s:tags_sink()

function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .')
  endif

  call fzf#run({
  \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  \            '| grep -v ^!',
  \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index '.
  \            '--color hl:197,hl+:10',
  \ 'up':      '50%',
  \ 'sink':    function('s:tags_sink')})
endfunction
command! Tags call s:tags()

" Narrow ag results within vim
"   CTRL-X, CTRL-V, CTRL-T to open in a new split, vertical split, tab respectively.
"   CTRL-A to select all matches and list them in quickfix window
"   CTRL-D to deselect all
" Ag without argument will list all the lines
function! s:ag_to_qf(line)
  let parts = split(a:line, ':')
  return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        \ 'text': join(parts[3:], ':')}
endfunction

function! s:ag_handler(lines)
  if len(a:lines) < 2 | return | endif

  let cmd = get({'ctrl-x': 'split',
               \ 'ctrl-v': 'vertical split',
               \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  let first = list[0]
  execute cmd escape(first.filename, ' %#\')
  execute first.lnum
  execute 'normal!' first.col.'|zz'

  if len(list) > 1
    call setqflist(list)
    copen
    wincmd p
  endif
endfunction

"command! -nargs=* Ag call fzf#run({
"\ 'source':  printf('ag --vimgrep --path-to-agignore ~/.agignore --smart-case "%s"',
"\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
"\ 'sink*':    function('<sid>ag_handler'),
"\ 'options': '--ansi +x --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
"\            '--multi --bind ctrl-a:select-all,ctrl-d:deselect-all '.
"\            '--color hl:197,hl+:10',
"\ 'up':    '50%'
"\ })

"//////////////////////////////////////
"// UNUSED CODE
"//////////////////////////////////////

" ## Tab navigation ##
"
"nnoremap th  :tabfirst<CR>
"nnoremap tj  :tabnext<CR>
"nnoremap tk  :tabprev<CR>
"nnoremap tl  :tablast<CR>
" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
"map <leader>te :tabedit <c-r>=expand("%:p:h")<CR>/
"nnoremap <leader>tm  :tabm<Space>
"map <leader>td :tabclose<CR>
"map <leader>tn :tabnew<CR>
"nnoremap <S-h> gT
"nnoremap <S-l> gt

" Open the definition in a new tab
"map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>

" ++ TAGBAR ++
"autocmd FileType c,cpp,py,rb,java,lisp,sh nested :TagbarOpen
"autocmd FileType * nested :call tagbar#autoopen(0)

" ++ SUPERTAB ++
" fixes keymap conflict with snipMate
"let g:SuperTabMappingForward = '<c-space>'
"let g:SuperTabMappingBackward = '<s-c-space>'

" ## pmiApp development stuff ##

" ## compiling ##
"
" ++ XLS PMI ++
"nnoremap <F2> :let @+="\"[BTQ00290096]: ...\""<cr>
"" Build the PMI debug x86
"nnoremap <F7> :Buildx86<cr><cr>
"" Build the PMI debug x86 w/ warning capture
"nnoremap <F4> :Buildx86w<cr><cr>
"" Build the PMI ARM
"nnoremap <leader>ba :BuildARM<cr><cr>
"" Build the PMI ARM w/ warning capture
"nnoremap <leader>baw :BuildARMw<cr><cr>
"" Build the PMI ARM
"nnoremap <leader>da :BuildDARM<cr><cr>
"" Build the PMI ARM w/ warning capture
"nnoremap <leader>daw :BuildDARMw<cr><cr>
"" Clean all builds
"nnoremap <leader>mc :MakeClean<cr><cr>
"" Run the PMI
""nnoremap <F5> :call RunPMI("debug")<cr>


"function! RunPMI(loglevel)
  ""execute 'cd' fnameescape(g:proj_root.'/pmiApp/codeblocks/bin/Debug/')
  "execute 'cd' fnameescape(g:proj_root.'/project/bin/Debug/')
  "let level = 'debug'
  "if(a:loglevel != level)
    "let level = a:loglevel
  "endif
  "let run_command = './pmiApp_x86 -l'.level.' | tee log_console_x86_$(date +%Y%m%d)_$(date +%H%M%S).txt'
  "echo 'Run pmiApp: '.run_command
  "call VimuxOpenRunner()
  "call VimuxSendText("C-c")
  "call VimuxRunCommand(run_command)
  ""call VimuxRunCommand('./pmiApp_x86 -l'.level.' | tee log_console_x86_$(date +%Y%m%d)_$(date +%H%M%S).txt')
  ""call VimuxRunCommand('./pmiApp_x86 -ldebug')
"endfunction

"command! BuildARM call BuildPMI('rao')
"command! Buildx86 call BuildPMI('dxo')
"command! BuildDARM call BuildPMI('dao')
"command! BuildARMw call BuildPMI('raow')
"command! Buildx86w call BuildPMI('dxow')
"command! BuildDARMw call BuildPMI('daow')
"command! MakeClean call BuildPMI('clean')
"function! BuildPMI(buildtype)
  ""execute 'cd' fnameescape(g:proj_root.'/pmiApp/codeblocks/')
  ""execute 'cd' fnameescape(g:proj_root.'/codeblocks/')
  "execute 'cd' fnameescape(g:proj_root.'/project/')
  "if (a:buildtype == 'rao')
    "echo 'Build pmiApp: Release_ARM'
    "Make -j4 TARGET=1 RELEASE=1  2>&1 | grep -E 'error:|undefined reference'
  "elseif (a:buildtype == 'dao')
    "echo 'Build pmiApp: Debug_ARM'
    "Make -j4 TARGET=1  2>&1 | grep -E 'error:|undefined reference'
  "elseif (a:buildtype == 'dxo')
    "echo 'Build pmiApp: Debug_x86'
    "Make -j4  2>&1 | grep -E 'error:|undefined reference'
  "elseif (a:buildtype == 'raow')
    "echo 'Build pmiApp: Release_ARM w/ warnings'
    "Make -j4 TARGET=1 RELEASE=1  2>&1 | grep -E 'error:|warning:|Error|failed' | grep -E '/CPC/Build/' | tee compile_arm_release.txt
  "elseif (a:buildtype == 'daow')
    "echo 'Build pmiApp: Debug_ARM w/ warnings'
    "Make -j4 TARGET=1  2>&1 | grep -E 'error:|warning:|Error|failed' | grep -E '/CPC/Build/' | tee compile_arm_debug.txt
  "elseif (a:buildtype == 'dxow')
    "echo 'Build pmiApp: Debug_x86 w/ warnings'
    "Make -j4  2>&1 | grep -E 'error:|warning:|Error|failed' | grep -E '/CPC/Build/' | tee compile_x86.txt
  "elseif (a:buildtype == 'clean')
    "echo 'Build pmiApp: clean all builds'
    "Make clean 2>&1
  "endif
  "call ProjRoot()
"endfunction

