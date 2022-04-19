" No plugins vim config
" Created: 5/17/2021
" Author: George Baker

" Startup
" enter the current millenium
set nocompatible

" enable syntax and plugins (for netrw)
syntax enable
filetype plugin on

set colorcolumn=80 " highlights column 80
highlight ColorColumn ctermbg=0 guibg=gray14

set ruler " Show the line and column number of the cursor position,
          " separated by a comma.
set number " show line numbers
set relativenumber " show line numbers
set hidden " preserver buffers
set nowrap " dont wrap lines
set noerrorbells
set linebreak "wrap lines at convenient location
set showmatch " When a bracket is inserted, briefly jump to the matching
              " one. The jump is only done if the match can be seen on the
              " screen. The time to show the match can be set with
              " 'matchtime'.

set tabstop=4 softtabstop=4 " tab is 4 spaces
set shiftwidth=4 " number of spaces to use for autoindenting
set expandtab " use spaces instead of tabs
set smartindent " smart indent
"set backspace=indent,eel,start
set backspace=2 " Backspace deletes like most programs in insert mode
              " allow backspacing over everything in insert mode
set smartcase " ignore case if search pattern is all lower-case
set incsearch " show search matches as you type
set hlsearch  " highlight search terms
set scrolloff=8
set spelllang=en     " spelling in english
" correct spelling on previous word
"set spell spelllang=en_gb

" Open new split panes to right and bottom, which feels more
" natural than Vim’s default:
"set splitbelow
"set splitright

set autoread  " reload files edited outside of vim
set autowrite " write file when switching between buffers

set nobackup " disable vim backups
set noswapfile " disable swap file
set undofile " enable vim undo history
set undolevels=1000 " use many muchos levels of undo

silent execute '!mkdir -p ~/.vim/undodir'
set undodir=~/.vim/undodir " Keep undo history across sessions,
                                            " by storing in file.
set viminfo+='100,f1 " Save up to 100 marks, enable capital marks

set history=1000         " remember more commands and search history
set showcmd              " Show incomplete cmds down the bottom
set showmode             " Show current mode down the bottom
set gcr=a:blinkon0       " Disable cursor blink
set cmdheight=2          " Give more space for displaying messages.
set pastetoggle=<F2>

" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

set wildmenu 						 " better command-line completion
set wildmode=list:longest,full
"stuff to ignore when tab completing
set wildignore=tags,*.tags,.tags,*.map,*.o,*.obj,*~,*.swp,*.bak,*.pyc,*.class
set wildignore+=*.d,*.o,*.a,*.dsw,*.dsp,*.hgc,*.hrc,*.png,*.jpg,*.gif
set wildignore+=log/**
set wildignore+=tmp/**


set laststatus=2
set statusline=%f%m%r%h%w%=[%L][%{&ff}]%y[%p%%][%04l,%04v]
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
nmap <S-Z> :bp <BAR> bd #<cr>
map <silent> <leader>bd :Bclose<cr>
" List buffers
nnoremap <leader>bb :ls<CR>:b<space>
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
nmap <leader>swj :topleft  vnew<CR>
nmap <leader>swu :topleft  new<CR>
nmap <leader>sj :leftabove  vnew<CR>
nmap <leader>su :leftabove  new<CR>
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
inoremap <C-j> <esc>:m .+1<CR>==
inoremap <C-k> <esc>:m .-2<CR>==

" Copy to end of the line
noremap Y y$

" Keeping it centered
nnoremap n nzzzv
nnoremap N Nzzzv
"nnoremap J mzJ`z

" undo delimiters
inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" greatest remap ever
xnoremap <leader>p "_dP

" next greatest remap ever : asbjornHaland
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y gg"+yG

nnoremap <leader>d "_d
vnoremap <leader>d "_d

" Relative number makes it confusing for non vim users spectating...
function! ToggleRel()
    if &relativenumber == 0
        set relativenumber
    else
        set norelativenumber
    endif
endfunction
nnoremap <leader>r :call ToggleRel()<CR>


" ## GIT ##
"
" add all files
command! GAddAll !git add -A
" add tracked files
command! GAdd !git add -u
" Commit with a message
function! GitAddCommitWithMessageAndPush(option)
    let l:option = a:option
    let curline = getline('.')
    call inputsave()
    let l:msg = input('Enter commit message: ')
    call inputrestore()
    execute '!git add -'.a:option.' && git commit -m "'.l:msg.'" && git push'
endfunction
command! -nargs=* GCommit call GitAddCommitWithMessageAndPush()


" ## CTAGS mappings ##
"
" build ctags for current directory
command! MakeTags !ctags -R .
nnoremap <F11> :call ProjRoot()<cr> MakeTags
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
     \   exe "normal! g`\"" |
     \ endif
" reload file
nnoremap <leader>rr :edit<cr>
" complete path
imap <leader>fp <c-x><c-f>

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
nmap <F5> :exec("grep ".expand("<cword>"))<CR>
vnoremap <F5> y :exec("grep ".expand("<C-R>""))<CR>


" ## Quickly edit/reload the vimrc file ##
" Works for both Linux/Windows
nmap <silent> <leader>ev :e ~/.vimrc<CR>
nmap <silent> <leader>sv :so ~/.vimrc<CR>


" ## Formatting ##
"
" Show tabs and whitespace when needed
set listchars=tab:>-,trail:!,eol:$
nmap <silent> <leader>s :set nolist!<CR>
" remove end of line spaces;
nmap <silent> <leader>dt :%s/\s\+$//e<cr>
" add semicolon at end of line
nmap <silent> <leader>; <s-a>;<esc>|
" add colon at end of line
nmap <silent> <leader>: <s-a>:<esc>|


" AUTOCOMPLETE:
" The good stuff is documented in |ins-completion|
" HIGHLIGHTS:
" - ^x^n for JUST this file
" - ^x^f for filenames (works with our path trick!)
" - ^x^] for tags only
" - ^n for anything specified by the 'complete' option
" NOW WE CAN:
" - Use ^n and ^p to go back and forth in the suggestion list


" ++ VIM EXPLORER ++
let g:netrw_browse_split=4  " open in prior window
let g:netrw_banner = 0
"let g:netrw_winsize = 25
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+,\(^\|\s\s\)ntuser\.\S\+'
let g:netrw_localcopydircmd = 'cp -r'
" Toggle netrw in sidebar
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

" NOW WE CAN:
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings

" SNIPPETS:
" Read an empty HTML template and move cursor to title
"nnoremap ,html :-1read $HOME/.vim/.skeleton.html<CR>3jwf>a

" NOW WE CAN:
" - Take over the world!
"   (with much fewer keystrokes)

" BUILD INTEGRATION:
" Steal Mr. Bradley's formatter & add it to our spec_helper
" http://philipbradley.net/rspec-into-vim-with-quickfix
" Configure the `make` command to run RSpec
"set makeprg=bundle\ exec\ rspec\ -f\ QuickfixFormatter

" NOW WE CAN:
" - Run :make to run RSpec
" - :cl to list errors
" - :cc# to jump to error by number
" - :cn and :cp to navigate forward and back

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
