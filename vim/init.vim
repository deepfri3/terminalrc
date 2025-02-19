" George Baker's (n)vim config
" Since: 2012

" Startup
filetype off
let g:running_windows = has("win16") || has("win32") || has("win64")
if g:running_windows
    let g:python3_host_prog='C:\Python38\Lib\venv\scripts\nt\python.exe'
else
    if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
      silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source ~/.config/nvim/init.vim
    endif
endif

" Specify a directory for plugins
if g:running_windows
    call plug#begin('~/AppData/Local/nvim/plugged')
else
    call plug#begin('~/.local/share/nvim/site/plugged')
endif

Plug 'neoclide/coc.nvim', {'branch': 'release'}
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
Plug 'chriskempson/base16-vim'
Plug 'gruvbox-community/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

call plug#end()

" Basics
set nocompatible " explicitly get out of vi-compatible mode
set fenc=utf-8 " UTF-8
set autoread

" switch syntax highlighting on, when terminal has colors
syntax enable
" enable syntax and plugins (for netrw)
filetype plugin on
set termguicolors
set t_ut=
" set default colorscheme and background
set background=dark
let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='1'
" favorite colorscheme :)
set background=dark
colorscheme gruvbox
" font is set by the shell program
hi Normal guibg=NONE ctermbg=NONE
hi Search cterm=NONE ctermbg=LightMagenta ctermfg=black
set colorcolumn=80 " highlights column 80
highlight ColorColumn ctermbg=0 guibg=gray14

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
function TabToggle()
    if &expandtab
        set softtabstop=4
        set shiftwidth=4
        set noexpandtab
    else
        set softtabstop=4
        set shiftwidth=4
        set expandtab
    end
endfunction
nmap <F9> mz:execute TabToggle()<CR>'z
set smartcase " ignore case if search pattern is all lower-case
set incsearch " show search matches as you type
set hlsearch  " highlight search terms
set scrolloff=8

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

if g:running_windows
    set undodir=~\AppData\Local\nvim\undodir " Keep undo history across sessions,
                                             " by storing in file.
else
    set undodir=~/.local/share/nvim/undodir " Keep undo history across sessions,
                                            " by storing in file.
endif
set viminfo+='100,f1 " Save up to 100 marks, enable capital marks

set history=1000         " remember more commands and search history
set title                " change the terminal's title
set noerrorbells         " don't beep
set showcmd              " Show incomplete cmds down the bottom
set showmode             " Show current mode down the bottom
set gcr=a:blinkon0       " Disable cursor blink
"set cmdheight=2          " Give more space for displaying messages.

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

set wildmenu 						 " better command-line completion
set wildmode=list:longest,full
"stuff to ignore when tab completing
set wildignore=tags,*.tags,.tags,*.map,*.o,*.obj,*~,*.swp,*.bak,*.pyc,*.class
set wildignore+=*.d,*.o,*.a,*.dsw,*.dsp,*.hgc,*.hrc,*.png,*.jpg,*.gif
set wildignore+=log/**
set wildignore+=tmp/**


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
"https://technotales.wordpress.com/2010/04/29/vim-splits-a-guide-to-doing-exactly-what-you-want/
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


" ## CTAGS mappings ##
"
" build ctags for current directory
if g:running_windows
    let g:tagbar_ctags_bin = "ctags.exe"
    map <leader>tag :!ctags -R .<CR><CR>
else
    " Change to the proj_root directory and execute ctags from proj_root
    command! MakeTags !ctags -R .
    nnoremap <leader>tag :call ProjRoot()<cr>:Dispatch ctags -R .<cr>
endif
" Open the definition in a vertical split
map <C-\> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
" C-] - go to definition = Ctrl-Left_MouseClick - Go to definition
" C-T - Jump back from the definition.(or :pop) =
" C-W C-] - Open the definition in a horizontal split


" ## Plugin mappings ##
"
" ++ VIM EXPLORER ++
let loaded_matchparen = 1
let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25
" Toggle netrw in sidebar
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
"
" ++ COC ++
set signcolumn=yes
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

command! -nargs=0 Prettier :CocCommand prettier.formatFile
" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" GoTo code navigation.
nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>rr <Plug>(coc-rename)
nmap <leader>g[ <Plug>(coc-diagnostic-prev)
nmap <leader>g] <Plug>(coc-diagnostic-next)
nmap <silent> <leader>gp <Plug>(coc-diagnostic-prev)
nmap <silent> <leader>gn <Plug>(coc-diagnostic-next)
nnoremap <leader>cr :CocRestart
" search for word on cursor
nnoremap <leader>prr :CocSearch <C-R>=expand("<cword>")<CR><CR>
"
" ++ UNDOTREE ++
nnoremap <leader>u :UndotreeShow<CR>
"
" ++ FUGITIVE ++
nmap <leader>gj :diffget //3<CR>
nmap <leader>gf :diffget //2<CR>
nmap <leader>gs :G<CR>
nnoremap <leader>gc :GCheckout<CR>
nnoremap <C-p> :GFiles<CR>
"
" ++ FZF - Fuzzy finder ++
" This is the default extra key bindings
"let g:fzf_action = {
            "\ 'ctrl-t': 'tab split',
            "\ 'ctrl-x': 'split',
            "\ 'ctrl-v': 'vsplit' }
" Default fzf layout
"let g:fzf_layout = { 'down': '50%'}
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
" https://github.com/junegunn/fzf.vim/issues/456
" Depending where it's installed
"set rtp+=~/.fzf
"set rtp+=/usr/local/opt/fzf
" Invoke fuzzy finder to find files
nnoremap <silent> <leader>t :Files <cr>
" List buffers
nnoremap <silent> <leader>b :Buffers<cr>
" Simple MRU search - v:oldfiles
nnoremap <silent> <leader><Enter> :History<cr>
" Search current buffer
nnoremap <silent> <leader>bl :BLines<cr>
" Search all open buffers
nnoremap <silent> <leader>ba :Lines<cr>
"
" ++ RIPGREP ++
" Use RG for grepping
set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --follow
let g:rg_command = 'rg --vimgrep -S'
if executable('rg')
    let g:rg_derive_root='true'
endif
let g:vrfr_rg = 'true'
nnoremap \ :Rg<CR>
nnoremap <leader>pw :Rg <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>ps :Rg<SPACE>
"
" ++ TAGBAR ++
" put cursor in tagbar when opened
let g:tagbar_autofocus = 1
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
let g:NERDTreeIgnore=['\.vim$', '\~$','\.cat$','\.agignore$']
" Automatically centers on cursor focus
let g:NERDTreeAutoCenter=1
" Pretty colors!
let g:NERDChristmasTree=1
" Open NERDTree positions
let g:NERDTreeWinPos='left'
" Closes the tree window after opening a file.
let g:NERDTreeQuitOnOpen=1
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
let g:buffergator_viewport_split_policy = 'B'
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
nmap <leader>bb :BuffergatorOpen<cr>
"
" ++ DISPATCH ++
autocmd FileType java let b:dispatch = 'javac %'
autocmd FileType python let b:dispatch = 'python %'
autocmd FileType cpp let b:dispatch = 'g++ % -o %.o'
autocmd FileType rs let b:dispatch = 'rustc %'
"
" ++ RUST ++
let g:rustfm_autosave = 1
"
" ++ AIRLINE ++
let g:airline_theme='gruvbox'


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
nmap <F5> :exec("Rg ".expand("<cword>"))<CR>
vnoremap <F5> y :exec("Rg ".expand("<C-R>""))<CR>


" ## Quickly edit/reload the vimrc file ##
" Works for both Linux/Windows
nmap <silent> <leader>ev :e ~/.config/nvim/init.vim<CR>
nmap <silent> <leader>sv :so ~/.config/nvim/init.vim<CR>


" ## Editing, Copying, Pasting, Files ##
"
" set clipboard instead of default
if g:running_windows
    set clipboard+=unnamed
else
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
nmap <silent> <leader>dt :%s/\s\+$//e<cr>
" add semicolon at end of line
nmap <silent> <leader>; <s-a>;<esc>|
" add colon at end of line
nmap <silent> <leader>: <s-a>:<esc>|


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Helper functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun
autocmd BufWritePre * :call TrimWhitespace()

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
augroup END

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
    call system('ctags -R .')
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
nmap <F6> :Tags<CR>


"//////////////////////////////////////
"// UNUSED CODE
"//////////////////////////////////////

" ++ AG - the silver searcher ++
"let g:ag_prg="ag --vimgrep --smart-case -p ~/.agignore"
" specify the project root direoctory path for searching
"let g:ag_working_path_mode="r"
" If 1, highlight the search terms after searching. Default: 0.
"let g:ag_highlight=1
"Format to recognize the matches. See 'errorformat' for more info.
"let g:ag_format="%f:%l:%c:%m"

"function! GoodMatch(items, str, limit, mmode, ispath, crfile, regex)
  ""Create a cache file if not yet exists
  "let cachefile = ctrlp#utils#cachedir().'/matcher.cache'

  "if !( filereadable(cachefile) && a:items == readfile(cachefile) )
    "call writefile(a:items, cachefile)
  "endif

  "if !filereadable(cachefile)
    "return []
  "endif

  "" a:mmode is currently ignored. In the future, we should probably do
  "" something about that. the matcher behaves like "full-line".
  "let cmd = g:path_to_matcher.' --limit '.a:limit.' --manifest '.cachefile.' '

  "if !( exists('g:ctrlp_dotfiles') && g:ctrlp_dotfiles )
    "let cmd = cmd.'--no-dotfiles '
  "endif

  "let cmd = cmd.a:str

  "return split(system(cmd), "\n")
"endfunction

"nnoremap <silent> <leader>t :FZF <cr>

" Fuzzy Finder helper functions
"function! s:buflist()
  "redir => ls
  "silent ls
  "redir END
  "return split(ls, '\n')
"endfunction

"function! s:bufopen(e)
  "execute 'buffer' matchstr(a:e, '^[ 0-9]*')
"endfunction

"function! s:all_files()
  "return extend(
  "\ filter(copy(v:oldfiles),
  "\        "v:val !~ 'fugitive:\\|NERD_tree\\|^/tmp/\\|.git/'"),
  "\ map(filter(range(1, bufnr('$')), 'buflisted(v:val)'), 'bufname(v:val)'))
"endfunction

" List buffers
"command! FZFbuf call fzf#run({
"\   'source':    reverse(<sid>buflist()),
"\   'sink':      function('<sid>bufopen'),
"\   'options':   '+m --ansi --color hl:197,hl+:10',
"\   'up':        '50%'
"\ })<CR>

"Simple MRU search - v:oldfiles
"command! FZFMruSimple call fzf#run({
"\  'source':  v:oldfiles,
"\  'sink':    'e',
"\  'options': '-m -x --ansi --color hl:197,hl+:10',
"\  'up':      '50%'})
"nnoremap <silent> <leader>b :FZFbuf<cr>

" Filtered v:oldfiles and open buffers
"command! FZFMruAll call fzf#run({
"\ 'source':  reverse(s:all_files()),
"\ 'sink':    'edit',
"\ 'options': '-m -x --ansi --color hl:197,hl+:10',
"\ 'up':      '50%' })
"nnoremap <silent> <Leader><Enter> :FZFMruSimple<cr>

" Narrow ag results within vim
"   CTRL-X, CTRL-V, CTRL-T to open in a new split, vertical split, tab respectively.
"   CTRL-A to select all matches and list them in quickfix window
"   CTRL-D to deselect all
" Ag without argument will list all the lines
"function! s:ag_to_qf(line)
  "let parts = split(a:line, ':')
  "return {'filename': parts[0], 'lnum': parts[1], 'col': parts[2],
        "\ 'text': join(parts[3:], ':')}
"endfunction

"function! s:ag_handler(lines)
  "if len(a:lines) < 2 | return | endif

  "let cmd = get({'ctrl-x': 'split',
               "\ 'ctrl-v': 'vertical split',
               "\ 'ctrl-t': 'tabe'}, a:lines[0], 'e')
  "let list = map(a:lines[1:], 's:ag_to_qf(v:val)')

  "let first = list[0]
  "execute cmd escape(first.filename, ' %#\')
  "execute first.lnum
  "execute 'normal!' first.col.'|zz'

  "if len(list) > 1
    "call setqflist(list)
    "copen
    "wincmd p
  "endif
"endfunction

"command! -nargs=* Ag call fzf#run({
"\ 'source':  printf('ag --vimgrep -p ~/.agignore --smart-case "%s"',
"\                   escape(empty(<q-args>) ? '^(?=.)' : <q-args>, '"\')),
"\ 'sink*':    function('<sid>ag_handler'),
"\ 'options': '--ansi +x --expect=ctrl-t,ctrl-v,ctrl-x --delimiter : --nth 4.. '.
"\            '--multi --bind ctrl-a:select-all,ctrl-d:deselect-all '.
"\            '--color hl:197,hl+:10',
"\ 'up':    '50%'
"\ })

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

