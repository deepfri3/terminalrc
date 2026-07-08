" Created: 5/17/2021
" Author: George Baker

" Startup
" enter the current millenium
set nocompatible

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
endif

" Specify a directory for plugins
call plug#begin('~/.local/share/nvim/site/plugged')

Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-dispatch'
Plug 'mbbill/undotree'
Plug 'preservim/nerdcommenter'
Plug 'BurntSushi/ripgrep'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" on-demand loading
Plug 'majutsushi/tagbar', { 'on':  'TagbarToggle' }
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Colors
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" enable syntax and plugins (for netrw)
syntax enable
filetype plugin on

set mouse= " this is vim!

"set background=dark
if has('nvim')
    set termguicolors
    colorscheme gruvbox
endif
set colorcolumn=85 " highlights column 85
"highlight ColorColumn ctermbg=0 guibg=gray14
highlight ColorColumn ctermbg=LightGray guibg=gray14

set ruler " Show the line and column number of the cursor position,
          " separated by a comma.
set number " show line numbers
set relativenumber " show line numbers
set hidden " preserver buffers
set nowrap " dont wrap lines
set linebreak "wrap lines at convenient location
set showmatch " When a bracket is inserted, briefly jump to the matching
              " one. The jump is only done if the match can be seen on the
              " screen. The time to show the match can be set with
              " 'matchtime'.

" virtual tabstops using spaces
set tabstop=4
set softtabstop=4 " tab is 4 spaces
set shiftwidth=4 " number of spaces to use for autoindenting
set expandtab " use spaces instead of tabs
set smartindent " smart indent
" allow toggling between local and default mode
function! TabToggle(spaces)
    echo "TabToggle width: ".a:spaces
    if a:spaces == "4"
        if &expandtab
            echo "TabToggle using tabs"
            set softtabstop=4
            set shiftwidth=4
            set noexpandtab
        else
            echo "TabToggle using spaces"
            set softtabstop=4
            set shiftwidth=4
            set expandtab
        endif
    elseif a:spaces == "2"
        if &expandtab
            echo "TabToggle using tabs"
            set softtabstop=2
            set shiftwidth=2
            set noexpandtab
        else
            echo "TabToggle using spaces"
            set softtabstop=2
            set shiftwidth=2
            set expandtab
        endif
    else
        echo "Invalid number of spaces"
    endif
endfunction
command! TabToggle2 :call TabToggle(2)
command! TabToggle4 :call TabToggle(4)
set backspace=indent,eol,start
              " allow backspacing over everything in insert mode
set ignorecase
set smartcase " ignore case if search pattern is all lower-case
set incsearch " show search matches as you type
set hlsearch  " highlight search terms
set scrolloff=8

if !has('nvim')
    set pastetoggle=<F2>
endif
cabbrev vb vert sb

" Open new split panes to right and bottom, which feels more
" natural than Vim’s default:
set splitbelow
set splitright

set autoread  " reload files edited outside of vim
set autowrite " write file when switching between buffers

set nobackup " disable vim backups
set noswapfile " disable swap file
set undofile " enable vim undo history
set undolevels=1000 " use many muchos levels of undo

if has('nvim')
    silent execute '!mkdir -p ~/.local/nvim/undodir'
    set undodir=~/.local/nvim/undodir " Keep undo history across sessions,
else
    silent execute '!mkdir -p ~/.vim/undodir'
    set undodir=~/.vim/undodir " Keep undo history across sessions,
endif
                                            " by storing in file.
set viminfo+='100,f1 " Save up to 100 marks, enable capital marks

set history=1000         " remember more commands and search history
set showcmd              " Show incomplete cmds down the bottom
set showmode             " Show current mode down the bottom
set gcr=a:blinkon0       " Disable cursor blink
set cmdheight=1          " Give more space for displaying messages.

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

set wildmenu                          " better command-line completion
set wildmode=list:longest,full
"stuff to ignore when tab completing
set wildignore=tags,*.tags,.tags,*.map,*.o,*.obj,*~,*.swp,*.bak,*.pyc,*.class
set wildignore+=*.d,*.o,*.a,*.dsw,*.dsp,*.hgc,*.hrc,*.png,*.jpg,*.gif
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=package/**
"set wildignore+=artifacts/**

set laststatus=2
set statusline=%{FugitiveStatusline()}%f%m%r%h%w%=[%{&ff}]%y[%p%%][%04l(%04L),%04v]
"                                      | | | | |     |      |  |     |   |      |
"                                      | | | | |     |      |  |     |   |      +-- current column
"                                      | | | | |     |      |  |     |   +-- number of lines
"                                      | | | | |     |      |  |     +-- current line
"                                      | | | | |     |      |  +-- current % into file
"                                      | | | | |     |      +-- current syntax in square brackets
"                                      | | | | |     +-- current fileformat (dos/unix)
"                                      | | | | +-- preview flag in square brackets
"                                      | | | +-- help flag in square brackets
"                                      | | +-- readonly flag in square brackets
"                                      | +-- modified flag in square brackets
"                                      +-- full path to file in the buffer


" ## Ease of use ##
"
" map escape to F3
map <F3> <Esc>
map! <F3> <Esc>
" remap leader key '\'
let mapleader = ","
let g:C_MapLeader = ','
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
map <silent> <leader>bd :Bclose<cr>
" List buffers and select
nnoremap <leader>b :ls<CR>:b<space>
" List buffers, select and open in vertical split
nnoremap <leader>bv :ls<CR>:vsp<space>\|<space>b<space>
" List buffers, select and open in horizontal split
nnoremap <leader>bs :ls<CR>:sp<space>\|<space>b<space>
" Create new buffer
nmap <leader>T :enew<cr>
" Change to local/current directory of buffer
nnoremap <silent> <leader>cd :lchdir %:p:h<CR>
" Close frame
nmap <leader>df :close<cr>
" Define the project root directory for building, running, and navigating
let g:proj_root=getcwd()
" Function to change dir to project root dir
function! ProjRoot()
  execute 'cd' fnameescape(g:proj_root)
  echo 'Project Root: '.getcwd()
endfunction
" Change to the proj_root directory
noremap <silent> <F12> :call ProjRoot()<cr>
" search help for current word
nnoremap <leader>phw :h <C-R>=expand("<cword>")<CR><CR>
" Easy vim splits
nmap <leader>swl :botright vnew<CR>
nmap <leader>sw. :botright new<CR>
nmap <leader>sl :rightbelow vnew<CR>
nmap <leader>s. :rightbelow new<CR>
nmap <leader>swj :topleft  vnew<CR>
nmap <leader>swu :topleft  new<CR>
nmap <leader>sj :leftabove  vnew<CR>
nmap <leader>su :leftabove  new<CR>
" resize current buffer by +/- 5
" expand right and left
nnoremap <leader>- :vertical resize -5<cr>
nnoremap <leader>+ :vertical resize +5<cr>
" expand down and up
nnoremap <leader>-d :resize -5<cr>
nnoremap <leader>+u :resize +5<cr>
nnoremap <leader>rp :resize 50<cr>
" equalize buffers
nnoremap <leader>seq <C-W>=
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" Open quickfix toggle between 10 and 50 high
"noremap <F10> :copen 25<cr>"
function! ToggleQuickfixHeight()
    if getwininfo(win_getid())[0].quickfix
        if winheight(0) == 10
            resize 50
        else
            resize 10
        endif
    else
        copen 10
    endif
endfunction
nnoremap <F10> :call ToggleQuickfixHeight()<CR>

" Copy to end of the line
nnoremap Y y$
" Center forwards/backwards search jumps
nnoremap n nzzzv
nnoremap N Nzzzv
"nnoremap J mzJ`z

" Not sure what these things do ???
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u
nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" delete and paste register from visual mode
vnoremap <leader>p "_dP

" Relative number makes it confusing for non vim users spectating...
function! ToggleRel()
    if &relativenumber == 0
        set relativenumber
    else
        set norelativenumber
    endif
endfunction
nnoremap <leader>r :call ToggleRel()<CR>

" Add keymap for entering visual block mode
command! Vb normal! <C-v>
nnoremap <leader>vb :Vb<CR>

tnoremap <Esc> <C-\><C-n>

" ## GIT ##
"
" Add files
function! GitAdd(option)
    let l:option = a:option
    execute '!git add -'.a:option
endfunction
command! -nargs=* GAdd call GitAdd(<q-args>)
" Commit with a message
function! GitAddCommitWithMessage(option)
    let l:option = a:option
    let curline = getline('.')
    call inputsave()
    let l:msg = input('Enter commit message: ')
    call inputrestore()
    "execute '!git add -'.a:option.' && git commit -m "'.l:msg.'"'
    execute '!git commit -m "'.l:msg.'"'
endfunction
command! -nargs=* GCommit call GitAddCommitWithMessage(<q-args>)
" Push to remote
command! GPush !git push
command! Gsb !git status --short --branch


" ## CTAGS mappings ##
"
" build ctags for current directory
command! MakeTags !ctags -R .
"nnoremap <F11> :call ProjRoot()<cr>:MakeTags<cr>
nnoremap <F1> :call ProjRoot()<cr>:Dispatch ctags -R --c++-kinds=+p --fields=+iaS --extras=+q .<cr>:call ProjRoot()<cr>
" C-] - go to definition = Ctrl-Left_MouseClick - Go to definition
" C-T - Jump back from the definition.(or :pop) = Ctrl-Right_MouseClick - Jump back from definition
" C-W C-] - Open the definition in a horizontal split
" Open the definition in a vertical split
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
":tag start-of-tag-name_TAB
"  Vim supports tag name completion. Start the typing the tag name and then type the TAB key and name completion will complete the tag name for you.
":tag /search-string
"  Jump to a tag name found by a search.
":tselect <function-name>
"  When multiple entries exist in the tags file, such as a function declaration in a header
"  file and a function definition (the function itself), the operator can choose by issuing this command.
"  The user will be presented with all the references to the function and the user will be prompted to enter the number associated with the appropriate one.
map <leader>ts :tselect <CR>/
":tags      - Show tag stack (history)
":4pop      - Jump to a particular position in the tag stack (history). (jump to the 4th from bottom of tag stack (history).
":4tag   - jump to the 4th from top of tag stack)
":tnext  - Jump to next matching tag (Also short form :tn and jump two :2tnext)
map <leader>tn :tnext<cr>
":tprevious    - Jump to previous matching tag. (Also short form :tp and jump two :2tp)
map <leader>tp :tprevious<cr>
":tfirst       - Jump to first matching tag. (Also short form :tf, :trewind, :tr)
map <leader>tf :tfirst<cr>
":tlast       - Jump to last matching tag. (Also short form :tl)
map <leader>tl :tlast<cr>


" ## Editing, Copying, Pasting, Files ##
"
" set clipboard instead of default
set clipboard=unnamedplus
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
     \   exe "normal! g`\"" |
     \ endif
" copy current file name (relative/absolute) to system clipboard (Linux version)
" relative path (src/foo.txt)
nnoremap <leader>cf :let @"=expand("%")<CR>
" absolute path (/something/src/foo.txt)
nnoremap <leader>cF :let @"=expand("%:p")<CR>
" filename (foo.txt)
nnoremap <leader>ct :let @"=expand("%:t")<CR>
" directory name (/something/src)
nnoremap <leader>ch :let @"=expand("%:p:h")<CR>
" current line number
nnoremap <leader>cl :let @"=line(".")<CR>
" breakpoint for gdb
nnoremap <leader>bp :let @"="break ".expand("%").":".line(".")<CR>
" reload file
nnoremap <leader>rr :edit<cr>
" complete path
imap <leader>fp <c-x><c-f>

" ## Search function mappings ##
"
cnoreabbrev Ag Ag!
nnoremap <leader>a :Ag!<Space>
" search on the selected text in visual mode
vnoremap g/ y/<C-R>"<CR>
" clear highlighted
nmap <silent> ,/ :nohlsearch<CR>
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :call VisualSelection('f')<CR>
vnoremap <silent> # :call VisualSelection('b')<CR>
if executable("rg")
" Search for current word using Ag
    nmap <F5> :exec("Rg ".expand("<cword>"))<CR>
    vnoremap <F5> y :exec("Rg ".expand("<C-R>""))<CR>
elseif executable("ag")
" Search for current word using Ag
    nmap <F5> :exec("Ag ".expand("<cword>"))<CR>
    vnoremap <F5> y :exec("Ag ".expand("<C-R>""))<CR>
else
    " Search for current word using grep
    " https://dev.to/iggredible/how-to-search-and-open-files-in-vim-without-plugins-d52
    nmap <F5> :exec("vim /".expand("<cword>")."/ **/*\.cpp")<cr>
    vnoremap <F5> y :exec("vim /".expand("<C-R>"")."/ **/*\.cpp")<cr>
    nmap <leader>fh :exec("vim /".expand("<cword>")."/ **/*\.h")<cr>
    vnoremap <leader>fh :exec("vim /".expand("<C-R>"")."/ **/*\.h")<cr>
endif


" ## Quickly edit/reload the vimrc file ##
" Works for both Linux/Windows
nmap <silent> <leader>ev :e ~/.vimrc<CR>
nmap <silent> <leader>sv :so ~/.vimrc<CR>


" ## Formatting ##
"
" Show tabs and whitespace when needed
set listchars=tab:>-,trail:!,nbsp:%,eol:$
nmap <silent> <leader>s :set nolist!<CR>
" remove end of line spaces;
nmap <silent> <leader>dt :%s/\s\+$//e<cr>
" add semicolon at end of line
nmap <silent> <leader>; <s-a>;<esc>|
" add colon at end of line
nmap <silent> <leader>: <s-a>:<esc>|
" add/remove cpp block comment
"noremap + :s/^/\/\//<cr>
"noremap - :s/^\/\///<cr>
" add/remove sh/py block comment
"noremap <leader>+ :s/^/#/<cr>
"noremap <leader>- :s/^#//<cr>


" ## Plugin mappings ##
"
" ++ TAGBAR ++
nmap <F9> :TagbarToggle<CR>
let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_sort = 0
"
" ++ VIM EXPLORER ++
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_keepdir = 0
let g:netrw_mousemaps = 0
" Toggle netrw in sidebar
"nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <leader>E :Lexplore <bar> :vertical resize 50<CR>
nnoremap <leader>e :Lexplore %:p:h<bar> :vertical resize 50<CR>
"
" ++ SYNTASTIC ++
" Check syntax on file open
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_check_on_open=0
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'passive_filetypes': ['Ruby', 'c', 'cpp', 'python', 'sh', 'java', 'lisp', 'yaml'],
                           \ 'active_filetypes': [] }
" When syntax errors are detected a flag will be shown in the statusline
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
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
" NERDTree size
let g:NERDTreeWinSize=50
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
" ++ CTRLP ++
" Trigger
"nmap <leader>t <C-p>
" Find using tags file
"nmap <leader>tag :CtrlPBufTag<CR>
" Open buffer List
"nmap <leader>bb :CtrlPBuffer<CR>
" Open jump List
nmap <leader>j :CtrlPMRUFiles<CR>
" Open List buf + mru + fil
nmap <leader>m :CtrlPMixed<CR>
" Setup some default ignores
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.(git|hg|svn)|\_site)$',
  \ 'file': '\v\.(exe|so|dll|class|png|jpg|jpeg|dsw|dsp)$',
\}
" format of the matching window
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:50,results:50'
" Set this to 1 to show only MRU files in the current working directory
let g:ctrlp_mruf_relative = 0
" Specify the number of recently opened files you want CtrlP to remember: >
let g:ctrlp_mruf_max = 50
" Do not clear cache on vim exit
let g:ctrlp_clear_cache_on_exit = 1
" Enable/Disable per-session caching:
"  0 - Disable caching, 1 - Enable caching, n - When bigger than 1, disable caching and use the number as the limit to enable caching again.
"  Note: you can quickly purge the cache by pressing <F5> while inside CtrlP.
let g:ctrlp_use_caching = 1
" Set this to 0 to enable cross-session caching by not deleting the cache files upon exiting Vim:
let g:ctrlp_cache_dir = $HOME.'/.vim/ctrlp'
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
" ++ BUFFERGATOR ++
" Use the right side of the screen
let g:buffergator_viewport_split_policy = 'R'
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
nmap <leader>bg :BuffergatorOpen<cr>
" View the entire list of buffers close
nmap <leader>bc :BuffergatorClose<cr>
"
" ++ FZF - Fuzzy finder ++
" This is the default extra key bindings
let g:fzf_action = {
\ 'ctrl-t': 'tab split',
\ 'ctrl-x': 'split',
\ 'ctrl-v': 'vsplit' }
" Default fzf layout
let g:fzf_layout = { 'down': '50%'}
"let g:fzf_layout = { 'window' : { 'width': 0.8, 'height': 0.8 } }
" add fzf directory to runtime path
"set rtp+=~/.local/bin
" Invoke fuzzy finder to find files
nnoremap <silent> <leader>t :Files <cr>
" List buffers
nnoremap <silent> <leader>bb :Buffers<cr>
" Simple MRU search - v:oldfiles
nnoremap <silent> <leader><Enter> :History<cr>
" Search current buffer
nnoremap <silent> <leader>bl :BLines<cr>
" Search all open buffers
nnoremap <silent> <leader>ba :Lines<cr>
" Search all open buffers
"#nnoremap <silent> <F9> :BTags<cr>
" Search all open buffers
nnoremap <silent> <F4> :Tags<cr>
"
" ++ Ag - the silver searcher ++
"let g:ag_prg="ag --vimgrep --smart-case --path-to-ignore ~/.agignore"
let g:ag_prg="ag --vimgrep --path-to-ignore ~/.agignore"
" specify the project root direoctory path for searching
let g:ag_working_path_mode="r"
" If 1, highlight the search terms after searching. Default: 0.
let g:ag_highlight=0
"Format to recognize the matches. See 'errorformat' for more info.
let g:ag_format="%f:%l:%c:%m"
"
" ++ FUGITIVE ++
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gs :G<CR>
nnoremap <leader>gc :GCheckout<CR>
"
" ++ RIP GREP ++
"let g:rg_binary="rg --files --hidden --follow --glob '!.git' --ignore-file ~/.agignore"
let g:rg_binary="rg --ignore-file ~/.agignore --no-ignore --vimgrep -i -S"
if executable('rg')
    "let g:rg_derive_root='true'
endif
"let g:vrfr_rg = 'true'
nnoremap <leader>pw :Rg <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>ps :Rg<SPACE>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

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
