-- init.lua
-- Converted from init.vim (George Baker, 2021), modernized to native Lua

-- Leader must be set before plugins/keymaps load
vim.g.mapleader = ","
vim.g.C_MapLeader = ","

--------------------------------------------------------------------------------
-- Bootstrap lazy.nvim
--------------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------------------
-- Plugins
--------------------------------------------------------------------------------
require("lazy").setup({
	-- tpope essentials (no good reason to replace these)
	"tpope/vim-fugitive",
	"tpope/vim-surround",
	"tpope/vim-dispatch",
	"mbbill/undotree",

	-- Tabular (restored)
	{ "godlygeek/tabular", cmd = "Tabularize" },

	-- Colors
	-- { "gruvbox-community/gruvbox", lazy = false, priority = 1000 },
	{ "morhetz/gruvbox", lazy = false, priority = 1000 },

	-- Statusline: airline -> lualine
	{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

	-- Commenting: nerdcommenter -> Comment.nvim
	{ "numToStr/Comment.nvim", opts = {} },

	-- File tree: NERDTree -> nvim-tree
	{ "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

	-- Fuzzy finder: fzf/fzf.vim -> telescope
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		},
	},

	-- Syntax: treesitter
    {
      "nvim-treesitter/nvim-treesitter",
      branch = "main",
      lazy = false,
      build = ":TSUpdate",
    },

	-- LSP + completion (replaces tagbar's role for code intel; keep ctags too)
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"L3MON4D3/LuaSnip",
	"saadparwaiz1/cmp_luasnip",
})

--------------------------------------------------------------------------------
-- General options
--------------------------------------------------------------------------------
local opt = vim.opt

opt.mouse = "" -- "this is vim!"
opt.termguicolors = true
vim.cmd.colorscheme("gruvbox")

opt.colorcolumn = "85"
vim.api.nvim_set_hl(0, "ColorColumn", { ctermbg = "LightGray", bg = "gray14" })

opt.ruler = true
opt.number = true
opt.relativenumber = true
opt.hidden = true
opt.wrap = false
opt.linebreak = true
opt.showmatch = true

-- virtual tabstops using spaces
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true

opt.backspace = { "indent", "eol", "start" }
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true
opt.scrolloff = 8

opt.splitbelow = true
opt.splitright = true

opt.autoread = true
opt.autowrite = true

opt.backup = false
opt.swapfile = false
opt.undofile = true
opt.undolevels = 1000
local undodir = vim.fn.expand("~/.local/nvim/undodir")
vim.fn.mkdir(undodir, "p")
opt.undodir = undodir

opt.shada = "'100,f1"

opt.history = 1000
opt.showcmd = true
opt.showmode = false -- lualine shows the mode now
opt.guicursor = "a:blinkon0"
opt.cmdheight = 1

opt.path:append("**")

opt.wildmenu = true
opt.wildmode = { "list:longest", "full" }
opt.wildignore = {
	"tags",
	"*.tags",
	".tags",
	"*.map",
	"*.o",
	"*.obj",
	"*~",
	"*.swp",
	"*.bak",
	"*.pyc",
	"*.class",
	"*.d",
	"*.a",
	"*.dsw",
	"*.dsp",
	"*.hgc",
	"*.hrc",
	"*.png",
	"*.jpg",
	"*.gif",
	"log/**",
	"tmp/**",
	"package/**",
}

opt.laststatus = 2
opt.clipboard = "unnamedplus"
opt.listchars = { tab = ">-", trail = "!", nbsp = "%", eol = "$" }

--------------------------------------------------------------------------------
-- Helper functions
--------------------------------------------------------------------------------
local map = vim.keymap.set

vim.g.proj_root = vim.fn.getcwd()
local function proj_root()
	vim.cmd("cd " .. vim.fn.fnameescape(vim.g.proj_root))
	print("Project Root: " .. vim.fn.getcwd())
end

local function tab_toggle(spaces)
	if spaces == 2 or spaces == 4 then
		opt.softtabstop = spaces
		opt.shiftwidth = spaces
		if vim.o.expandtab then
			opt.expandtab = false
			print("TabToggle using tabs (" .. spaces .. ")")
		else
			opt.expandtab = true
			print("TabToggle using spaces (" .. spaces .. ")")
		end
	else
		print("Invalid number of spaces")
	end
end
vim.api.nvim_create_user_command("TabToggle2", function()
	tab_toggle(2)
end, {})
vim.api.nvim_create_user_command("TabToggle4", function()
	tab_toggle(4)
end, {})

local function toggle_quickfix_height()
	local info = vim.fn.getwininfo(vim.fn.win_getid())[1]
	if info.quickfix == 1 then
		vim.cmd(vim.fn.winheight(0) == 10 and "resize 50" or "resize 10")
	else
		vim.cmd("copen 10")
	end
end

local function toggle_rel()
	opt.relativenumber = not vim.o.relativenumber
end

local function trim_whitespace()
	local view = vim.fn.winsaveview()
	vim.cmd([[keeppatterns %s/\s\+$//e]])
	vim.fn.winrestview(view)
end

--------------------------------------------------------------------------------
-- Ease of use
--------------------------------------------------------------------------------
map({ "n", "v", "o" }, "<F3>", "<Esc>")
map("i", "<F3>", "<Esc>")
map("c", "<F3>", "<Esc>")
map("n", "<leader>w", ":w!<cr>")

--------------------------------------------------------------------------------
-- Navigation
--------------------------------------------------------------------------------
for _, k in ipairs({ "<up>", "<down>", "<left>", "<right>" }) do
	map({ "n", "v", "o" }, k, "<nop>")
end

map("", "<C-h>", "<C-w>h")
map("", "<C-j>", "<C-w>j")
map("", "<C-k>", "<C-w>k")
map("", "<C-l>", "<C-w>l")

map("n", "<S-J>", ":bp<CR>")
map("n", "<S-K>", ":bn<CR>")
map("", "<leader>bd", ":Bclose<cr>", { silent = true })
map("n", "<leader>b", ":ls<CR>:b<space>")
map("n", "<leader>bv", ":ls<CR>:vsp<space>|<space>b<space>")
map("n", "<leader>bs", ":ls<CR>:sp<space>|<space>b<space>")
map("n", "<leader>T", ":enew<cr>")
map("n", "<leader>cd", ":lchdir %:p:h<CR>", { silent = true })
map("n", "<leader>df", ":close<cr>")
map("", "<F12>", proj_root, { silent = true })
map("n", "<leader>phw", [[:h <C-R>=expand("<cword>")<CR><CR>]])

map("n", "<leader>swl", ":botright vnew<CR>")
map("n", "<leader>sw.", ":botright new<CR>")
map("n", "<leader>sl", ":rightbelow vnew<CR>")
map("n", "<leader>s.", ":rightbelow new<CR>")
map("n", "<leader>swj", ":topleft vnew<CR>")
map("n", "<leader>swu", ":topleft new<CR>")
map("n", "<leader>sj", ":leftabove vnew<CR>")
map("n", "<leader>su", ":leftabove new<CR>")

map("n", "<leader>-", ":vertical resize -5<cr>")
map("n", "<leader>+", ":vertical resize +5<cr>")
map("n", "<leader>-d", ":resize -5<cr>")
map("n", "<leader>+u", ":resize +5<cr>")
map("n", "<leader>rp", ":resize 50<cr>")
map("n", "<leader>seq", "<C-W>=")

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

map("n", "<F10>", toggle_quickfix_height)

map("n", "Y", "y$")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")

map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", "!", "!<c-g>u")
map("i", "?", "?<c-g>u")

map("n", "k", [[(v:count > 5 ? "m'" . v:count : "") . 'k']], { expr = true })
map("n", "j", [[(v:count > 5 ? "m'" . v:count : "") . 'j']], { expr = true })

map("v", "<leader>p", '"_dP')
map("n", "<leader>r", toggle_rel)

vim.api.nvim_create_user_command("Vb", "normal! \22", {})
map("n", "<leader>vb", ":Vb<CR>")

map("t", "<Esc>", [[<C-\><C-n>]])

--------------------------------------------------------------------------------
-- Git
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command("GAdd", function(o)
	vim.cmd("!git add -" .. o.args)
end, { nargs = "*" })

vim.api.nvim_create_user_command("GCommit", function()
	local msg = vim.fn.input("Enter commit message: ")
	vim.cmd('!git commit -m "' .. msg .. '"')
end, { nargs = "*" })

vim.api.nvim_create_user_command("GPush", "!git push", {})
vim.api.nvim_create_user_command("Gsb", "!git status --short --branch", {})

map("n", "<leader>gj", ":diffget //3<CR>")
map("n", "<leader>gf", ":diffget //2<CR>")
map("n", "<leader>gs", ":G<CR>")
map("n", "<leader>gc", ":GCheckout<CR>")

--------------------------------------------------------------------------------
-- CTAGS (kept alongside LSP)
--------------------------------------------------------------------------------
vim.api.nvim_create_user_command("MakeTags", "!ctags -R .", {})
map("n", "<F1>", function()
	proj_root()
	vim.cmd("Dispatch ctags -R --c++-kinds=+p --fields=+iaS --extras=+q .")
	proj_root()
end)
map("", "<C-\\>", [[:vsp <CR>:exec("tag ".expand("<cword>"))<CR>]])
map("", "<leader>ts", ":tselect <CR>/")
map("", "<leader>tn", ":tnext<cr>")
map("", "<leader>tp", ":tprevious<cr>")
map("", "<leader>tf", ":tfirst<cr>")
map("", "<leader>tl", ":tlast<cr>")

--------------------------------------------------------------------------------
-- Editing / copying / files
--------------------------------------------------------------------------------
map("n", "<leader>wr", ":!chmod a+w %<CR><Esc>")
map("n", "<leader>ro", ":!chmod a-w %<CR><Esc>")
map("", "<leader>cp", '"+yy')
map("", "<leader>pa", '"*p')
map("n", "<leader>br", "0ji<CR><Esc>", { silent = true })

map("n", "<leader>cf", [[:let @"=expand("%")<CR>]])
map("n", "<leader>cF", [[:let @"=expand("%:p")<CR>]])
map("n", "<leader>ct", [[:let @"=expand("%:t")<CR>]])
map("n", "<leader>ch", [[:let @"=expand("%:p:h")<CR>]])
map("n", "<leader>cl", [[:let @"=line(".")<CR>]])
map("n", "<leader>bp", [[:let @"="break ".expand("%").":".line(".")<CR>]])
map("n", "<leader>rr", ":edit<cr>")
map("i", "<leader>fp", "<c-x><c-f>")

--------------------------------------------------------------------------------
-- Search (telescope-backed where it makes sense)
--------------------------------------------------------------------------------
map("v", "g/", [[y/<C-R>"<CR>]])
map("n", ",/", ":nohlsearch<CR>", { silent = true })
map("v", "*", ":call VisualSelection('f')<CR>", { silent = true })
map("v", "#", ":call VisualSelection('b')<CR>", { silent = true })

--------------------------------------------------------------------------------
-- Edit / reload config
--------------------------------------------------------------------------------
map("n", "<leader>ev", ":e $MYVIMRC<CR>", { silent = true })
map("n", "<leader>sv", ":source $MYVIMRC<CR>", { silent = true })

--------------------------------------------------------------------------------
-- Formatting
--------------------------------------------------------------------------------
map("n", "<leader>s", ":set nolist!<CR>", { silent = true })
map("n", "<leader>dt", [[:%s/\s\+$//e<cr>]], { silent = true })
map("n", "<leader>;", "<s-a>;<esc>", { silent = true })
map("n", "<leader>:", "<s-a>:<esc>", { silent = true })

--------------------------------------------------------------------------------
-- netrw (still used by <leader>E / <leader>e)
--------------------------------------------------------------------------------
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_keepdir = 0
vim.g.netrw_mousemaps = 0
map("n", "<leader>E", ":Lexplore <bar> :vertical resize 50<CR>")
map("n", "<leader>e", ":Lexplore %:p:h<bar> :vertical resize 50<CR>")

--------------------------------------------------------------------------------
-- Surround
--------------------------------------------------------------------------------
map("n", "<leader>)", "yss)")
map("n", "<leader>(", "yss(")
map("v", "<leader>)", "S)")
map("v", "<leader>(", "S(")
map("n", "<leader>]", "yss]")
map("n", "<leader>[", "yss[")
map("v", "<leader>]", "S]")
map("v", "<leader>[", "S[")
map("n", '<leader>"', 'yss"')
map("v", '<leader>"', 'S"')
map("n", "<leader>'", "yss'")
map("v", "<leader>'", "S'")

--------------------------------------------------------------------------------
-- Tabular (restored)  -- NOTE: <leader> is ',', so these are ,a& ,a= etc.
--------------------------------------------------------------------------------
map({ "n", "v" }, "<Leader>a&", ":Tabularize /&<CR>")
map({ "n", "v" }, "<Leader>a=", ":Tabularize /=<CR>")
map({ "n", "v" }, "<Leader>a:", ":Tabularize /:<CR>")
map({ "n", "v" }, "<Leader>a::", ":Tabularize /:\\zs<CR>")
map({ "n", "v" }, "<Leader>a,", ":Tabularize /,<CR>")
map({ "n", "v" }, "<Leader>a,,", ":Tabularize /,\\zs<CR>")
map({ "n", "v" }, "<Leader>a<Bar>", ":Tabularize /<Bar><CR>")
map({ "n", "v" }, "<Leader>a#", ":Tabularize /#define\\s\\+\\w*\\zs<CR>")
map({ "n", "v" }, "<Leader>a//", ":Tabularize /\\/\\/<CR>")
map({ "n", "v" }, '<Leader>a"', ':Tabularize /"<CR>')

--------------------------------------------------------------------------------
-- Plugin setup: lualine (airline replacement)
--------------------------------------------------------------------------------
require("lualine").setup({
	options = {
		theme = "gruvbox",
		icons_enabled = true,
		section_separators = "",
		component_separators = "",
	},
	sections = {
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 1 } },
		lualine_x = { "encoding", "fileformat", "filetype" },
	},
})

--------------------------------------------------------------------------------
-- Plugin setup: nvim-tree (NERDTree replacement)
--------------------------------------------------------------------------------
require("nvim-tree").setup({
	view = { side = "left", width = 50 },
	filters = { custom = { "\\.vim$", "\\.cat$" } },
	renderer = { highlight_git = true },
})
map("n", "<F8>", ":NvimTreeToggle<CR>")

--------------------------------------------------------------------------------
-- Plugin setup: telescope (fzf replacement)
--------------------------------------------------------------------------------
local telescope = require("telescope")
telescope.setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			"--ignore-file",
			vim.fn.expand("~/.rgignore"),
		},
		layout_strategy = "bottom_pane",
		layout_config = { height = 0.5 },
		mappings = {
			i = {
				["<C-t>"] = require("telescope.actions").select_tab,
				["<C-x>"] = require("telescope.actions").select_horizontal,
				["<C-v>"] = require("telescope.actions").select_vertical,
			},
		},
	},
})
pcall(telescope.load_extension, "fzf")

local tb = require("telescope.builtin")
map("n", "<leader>t", tb.find_files, { silent = true })
map("n", "<leader>bb", tb.buffers, { silent = true })
map("n", "<leader><Enter>", tb.oldfiles, { silent = true })
map("n", "<leader>bl", tb.current_buffer_fuzzy_find, { silent = true })
map("n", "<leader>ba", tb.live_grep, { silent = true })
map("n", "<F4>", tb.tags, { silent = true })
map("n", "<leader>a", tb.live_grep, { silent = true }) -- rg live grep
map("n", "<leader>pw", tb.grep_string, { silent = true }) -- rg word under cursor
map("n", "<leader>ps", tb.live_grep, { silent = true }) -- rg live grep
map("n", "<F5>", tb.grep_string, { silent = true }) -- rg word under cursor
map("v", "<F5>", tb.grep_string, { silent = true })

--------------------------------------------------------------------------------
-- Plugin setup: treesitter
--------------------------------------------------------------------------------
require("nvim-treesitter").setup()

local ts_langs = { "c", "cpp", "lua", "python", "bash", "vim", "vimdoc", "yaml", "json" }

-- install parsers (async); safe to call on every startup
require("nvim-treesitter").install(ts_langs)

-- enable highlighting + treesitter indentation per-buffer
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
    if lang and vim.treesitter.language.add(lang) then
      pcall(vim.treesitter.start, args.buf)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

--------------------------------------------------------------------------------
-- Plugin setup: LSP + completion
--------------------------------------------------------------------------------
require("mason").setup()

local cmp = require("cmp")
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Apply cmp completion capabilities to EVERY server via the native 0.11+ API.
-- nvim-lspconfig is still installed and still supplies each server's built-in
-- defaults (cmd, root markers, filetypes) through vim.lsp.config; we simply no
-- longer call its deprecated require('lspconfig')[server].setup() framework.
vim.lsp.config("*", { capabilities = capabilities })

-- mason-lspconfig v2 auto-installs these AND auto-enables them for you
-- (it calls vim.lsp.enable() internally), so no manual enable loop is needed.
require("mason-lspconfig").setup({
  ensure_installed = { "clangd", "lua_ls" },
})

cmp.setup({
  snippet = {
    expand = function(args) require("luasnip").lsp_expand(args.body) end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"]      = cmp.mapping.confirm({ select = true }),
    ["<Tab>"]     = cmp.mapping.select_next_item(),
    ["<S-Tab>"]   = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- LSP keymaps on attach
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local o = { buffer = ev.buf, silent = true }
    map("n", "gd", vim.lsp.buf.definition, o)
    map("n", "gr", vim.lsp.buf.references, o)
    map("n", "gi", vim.lsp.buf.implementation, o)
    map("n", "K",  vim.lsp.buf.hover, o)
    map("n", "<leader>rn", vim.lsp.buf.rename, o)
    map("n", "<leader>ca", vim.lsp.buf.code_action, o)
    map("n", "[d", vim.diagnostic.goto_prev, o)
    map("n", "]d", vim.diagnostic.goto_next, o)
  end,
})

--------------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------------
local grp = vim.api.nvim_create_augroup("UserConfig", { clear = true })

vim.api.nvim_create_autocmd("BufReadPost", {
	group = grp,
	callback = function()
		local mark = vim.api.nvim_buf_get_mark(0, '"')
		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(0) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	group = grp,
	callback = trim_whitespace,
})

--------------------------------------------------------------------------------
-- Remaining Vimscript helpers kept as-is
--------------------------------------------------------------------------------
vim.cmd([[
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
      execute "normal ?" . l:pattern . "\r"
  elseif a:direction == 'gv'
      call CmdLine("vimgrep " . '/'. l:pattern . '/' . ' **/*.')
  elseif a:direction == 'replace'
      call CmdLine("%s" . '/'. l:pattern . '/')
  elseif a:direction == 'f'
      execute "normal /" . l:pattern . "\r"
  endif
  let @/ = l:pattern
  let @" = l:saved_reg
endfunction

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
]])
