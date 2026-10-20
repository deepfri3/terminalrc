-- init.lua
-- Converted from init.vim (George Baker, 2021), modernized to native Lua (2026)

-- Leader must be set before plugins/keymaps load
vim.g.mapleader = ","
vim.g.C_MapLeader = ","

local grp = vim.api.nvim_create_augroup("UserConfig", { clear = true })
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
    -- Dead simple plugin to center the currently focused buffer to the middle of the screen.
    { "shortcuts/no-neck-pain.nvim", version = "*"},
    -- Tagbar
    {
      "preservim/tagbar",   -- majutsushi/tagbar was moved here and is the maintained fork
      cmd = "TagbarToggle",
      init = function()
        vim.g.tagbar_autofocus  = 1      -- put cursor in tagbar when opened
        vim.g.tagbar_autoclose  = 1      -- close tagbar when you jump to a tag
        vim.g.tagbar_left       = 0      -- open tagbar on the left
        vim.g.tagbar_compact    = 1      -- remove extra space
        vim.g.tagbar_updateonsave_maxlines = 10000
      end,
    },
	-- Tabular (restored)
	{ "godlygeek/tabular", cmd = "Tabularize" },
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {},
    },
	-- Colors
    -- Gruvbox written in native lua
    { "ellisonleao/gruvbox.nvim", priority = 1000 , config = true, opts = ...},

	-- Statusline: airline -> lualine
	{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

	-- File tree: NERDTree -> nvim-tree
	{ "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

	-- Fuzzy finder: fzf/fzf.vim -> telescope
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      },
    },
    -- Trouble
    {
      "folke/trouble.nvim",
      opts = {
        keys = {
          -- Filter on errors
          e = {
            action = function(view)
              view:filter({
                function(item)
                  return item.text:find("error:") ~= nil
                end,
            function(item)
              return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
            end,
              },
              { toggle = true, template = "{hl:Title}Filter:{hl} errors" })
            end,
            desc = "Filter on errors"
          },
          -- Filter on warnings
          w = {
            action = function(view)
              view:filter({
                function(item)
                  return item.text:find("warning:") ~= nil
                end,
            function(item)
              return item.filename:find((vim.loop or vim.uv).cwd(), 1, true)
            end,
              },
              { toggle = true, template = "{hl:Title}Filter:{hl} warnings" })
            end,
            desc = "Filter on warnings"
          }
        },
      },
      cmd = "Trouble",
      keys = {
        {
          "<leader>xx",
          "<cmd>Trouble diagnostics toggle<cr>",
          desc = "Diagnostics (Trouble)",
        },
        {
          "<leader>xX",
          "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
          desc = "Buffer Diagnostics (Trouble)",
        },
        {
          "<leader>cs",
          "<cmd>Trouble symbols toggle focus=false<cr>",
          desc = "Symbols (Trouble)",
        },
        {
          "<leader>cl",
          "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
          desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
          "<leader>xL",
          "<cmd>Trouble loclist toggle<cr>",
          desc = "Location List (Trouble)",
        },
        {
          "<leader>xQ",
          "<cmd>Trouble qflist toggle<cr>",
          desc = "Quickfix List (Trouble)",
        },
      },
    },
    {
      "gl1tchc0d3r/typstwriter.nvim",
      ft = { "typst" },
      config = function()
        require("typstwriter").setup({
          -- Configuration options (see Configuration page)
        })
      end,
    }
})

--------------------------------------------------------------------------------
-- General options
--------------------------------------------------------------------------------
local opt = vim.opt

opt.mouse = "" -- "this is vim!"
opt.termguicolors = true
vim.cmd.colorscheme("gruvbox")

opt.colorcolumn = "88"
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
	"*.o",
	"*~",
	"*.swp",
	"*.bak",
	"*.pyc",
	"*.class",
	"*.d",
	"*.a",
	"log/**",
	"package/**",
}

opt.laststatus = 2
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

-- Highlight log keywords in terminals, inspired by MobaXTerm and
-- https://github.com/fei6409/log-highlight.nvim
vim.api.nvim_create_autocmd("TermOpen", {
  group = grp,
  callback = function()
    vim.cmd([[
      syn keyword LogError E ERROR error
      syn keyword LogWarn  W WARN[ING] warn[ing]
      syn keyword LogInfo  I INFO info

      hi LogBlue ctermfg=lightblue guifg=#92bcfc

      hi def link LogError ErrorMsg
      hi def link LogWarn  WarningMsg
      hi def link LogInfo  LogBlue
    ]])
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  group = grp,
  callback = function() vim.hl.hl_op() end,
})

local osc52 = require("vim.ui.clipboard.osc52")
-- Paste from Neovim's own register. OSC 52 paste through tmux often doesn't work or hangs.
local function paste()
  return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
end
vim.g.clipboard = {
  name = "OSC 52",
  copy  = { ["+"] = osc52.copy("+"), ["*"] = osc52.copy("*") },
  paste = { ["+"] = paste,           ["*"] = paste },
}
opt.clipboard = "unnamedplus"

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
-- map("n", "<leader>b", ":ls<CR>:b<space>")
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

map("t", "<Esc><Esc>", [[<C-\><C-n>]])

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
    -- assumes using universal ctags
	vim.cmd("Dispatch ctags -R --kinds-C++=+p --fields=+iaS --extras=+q --fields-C++=+{properties} .")
	proj_root()
end)
-- map("", "<C-\\>", [[:vsp <CR>:exec("tag ".expand("<cword>"))<CR>]])
map("", "<C-\\>", [[:exec("tag ".expand("<cword>"))<CR>]])
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
-- Search
--------------------------------------------------------------------------------
map("v", "g/", [[y/<C-R>"<CR>]])
map("n", ",/", ":nohlsearch<CR>", { silent = true })
map("v", "*", ":call VisualSelection('f')<CR>", { silent = true })
map("v", "#", ":call VisualSelection('b')<CR>", { silent = true })

-- Grep
--
-- Neovim uses ripgrep by default and falls back to grep if it's not available. In both cases,
-- the default options to those programs could be improved.
if vim.fn.executable("rg") == 1 then
  -- default: "rg --vimgrep -uu "
  --
  -- -u: ripgrep won't filter based on .gitignore files
  -- -uu: ripgrep will search hidden files and directories
  --
  -- Changes
  --  * Respect .gitignore
  --  * Include hidden files (like .gitlab-ci.yml, .clang-format, etc.)
  vim.o.grepprg = "rg --vimgrep --smart-case --hidden -g '!.git' "
else
  -- default: "grep -HIn $* /dev/null"
  --
  -- Changes
  --  * Recursive (follow symlinks)
  --  * Search current directory and all below
  --  * Exclude common files and directories (this is where ripgrep is especially better)
  vim.o.grepprg = "grep -HInR $* . /dev/null --exclude=tags --exclude-dir=.git --exclude-dir=build --exclude-dir=CMakeItems --exclude-dir=externals --exclude-dir=.cache"
end
vim.opt.grepformat = "%f:%l:%c:%m"

-- :Rg <pattern>  -> quickfix, then auto-open
vim.api.nvim_create_user_command("Rg", function(opts)
  vim.cmd("silent grep! " .. opts.args)
  vim.cmd("copen")
end, { nargs = "+" })

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
        section_separators = { left = '', right = ''},
		-- section_separators = "",
        component_separators = { left = '', right = ''},
		-- component_separators = "",
	},
	sections = {
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = { { "filename", path = 4 } },
		lualine_x = { "encoding", "fileformat", "filetype" },
	},
})

--------------------------------------------------------------------------------
-- Plugin setup: Undotree
--------------------------------------------------------------------------------
map({"n", "v"}, "<Leader>ut", "<cmd>UndotreeToggle<CR>")

--------------------------------------------------------------------------------
-- Plugin setup: TagBar
--------------------------------------------------------------------------------
map("n", "<F9>", "<cmd>TagbarToggle<CR>", { silent = true })

--------------------------------------------------------------------------------
-- Plugin setup: nvim-tree (NERDTree replacement)
--------------------------------------------------------------------------------
require("nvim-tree").setup({
	view = { side = "left", width = 40 },
	filters = {
        custom = { "\\.vim$", "\\.cat$" },
        dotfiles = false,      -- also show dotfiles if you want
        git_ignored = false,   -- show .gitignore'd files (newer key)
    },
	renderer = { highlight_git = "all" },
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
            "--hidden",
            "--glob", "!.git/*",
			"--ignore-file", vim.fn.expand("~/.rgignore"),
		},
        sorting_strategy = "ascending",
		layout_strategy = "vertical",
		layout_config = {
            height = 0.5,
            mirror = true,
        },
		mappings = {
			i = {
				["<C-t>"] = require("telescope.actions").select_tab,
				["<C-x>"] = require("telescope.actions").select_horizontal,
				["<C-v>"] = require("telescope.actions").select_vertical,
			},
		},
	},
    pickers = {
        find_files = {
            find_command = {
                "rg",
                "--files",
                "--hidden",
                "--glob", "!.git/*",
                "--ignore-file", vim.fn.expand("~/.rgignore"),
            },
        },
    },
})
pcall(telescope.load_extension, "fzf")

local tb = require("telescope.builtin")
map("n", "<leader>ff", tb.find_files, { silent = true })
map("n", "<leader>fg", tb.live_grep, { silent = true })
map("n", "<leader>fb", tb.buffers, { silent = true })
map("n", "<leader><Enter>", tb.oldfiles, { silent = true })
map("n", "<leader>bl", tb.current_buffer_fuzzy_find, { silent = true })
map("n", "<F4>", tb.tags, { silent = true })
map("n", "<F5>", tb.grep_string, { silent = true }) -- rg word under cursor
map("v", "<F5>", tb.grep_string, { silent = true })

--------------------------------------------------------------------------------
-- Native treesitter highlighting (no plugin, no tree-sitter CLI)
-- Works for bundled langs (c, lua, markdown, query, vim, vimdoc) out of the box.
-- Other langs work once their .so is in ~/.config/nvim/parser/ and queries in
-- ~/.config/nvim/queries/<lang>/. Falls back to regex syntax if absent.
--------------------------------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NativeTreesitter", { clear = true }),
  callback = function(args)
    -- Skip scratch/special buffers (Telescope prompt, results, preview, etc.)
    -- but keep help buffers so :help still gets vimdoc highlighting.
    local bt = vim.bo[args.buf].buftype
    if bt ~= "" and bt ~= "help" then return end

    local ft = vim.bo[args.buf].filetype
    local lang = vim.treesitter.language.get_lang(ft) or ft
    -- language.add returns false (0.11) / nil (0.12) if no parser is found
    local ok = pcall(vim.treesitter.language.add, lang)
    if ok then
      pcall(vim.treesitter.start, args.buf, lang)  -- highlighting; disables regex syntax
    end
    -- No treesitter indentexpr: your smartindent/autoindent handles it.
  end,
})

--------------------------------------------------------------------------------
-- Plugin setup: LSP + completion
--------------------------------------------------------------------------------
-- Every server is defined inline with vim.lsp.config(name, {...}). Because we
-- set the table ourselves, vim.lsp.enable(name) never needs to look for an
-- lsp/<name>.lua file on the runtimepath -- this whole block is the config.

-- Shared defaults applied to every server (merged over per-server tables).
vim.lsp.config("*", {
  root_markers = { ".git" },
})

-- 1) Server definitions ------------------------------------------------------

vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
  },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
  root_markers = {
    ".clangd", ".clang-tidy", ".clang-format",
    "compile_commands.json", "compile_flags.txt",
    "Makefile", "configure.ac", ".git",
  },
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rust-project.json", ".git" },
})

vim.lsp.config("gopls", {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
  root_markers = { "go.work", "go.mod", ".git" },
  settings = { gopls = { analyses = { unusedparams = true }, staticcheck = true } },
})

vim.lsp.config("lua_ls", {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc", ".stylua.toml", ".git" },
  settings = { Lua = { telemetry = { enable = false } } },
})

-- Python: pick whichever single-binary server you have. ty is Astral's
-- (checker + LSP in one binary); pyrefly is Meta's. Both avoid the Node.js
-- runtime that basedpyright drags in.
vim.lsp.config("ty", {
  cmd = { "ty", "server" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ty.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
})

-- vim.lsp.config("pyrefly", {                    -- enable instead of ty if you prefer
--   cmd = { "pyrefly", "lsp" },
--   filetypes = { "python" },
--   root_markers = { "pyrefly.toml", "pyproject.toml", ".git" },
-- })

-- 2) Enable only the servers whose binary is actually on PATH ---------------
-- degrades to ctags + treesitter instead of erroring at startup.
local function enable_if(bin, name)
  if vim.fn.executable(bin) == 1 then vim.lsp.enable(name) end
end

enable_if("clangd",              "clangd")
enable_if("rust-analyzer",       "rust_analyzer")
enable_if("gopls",               "gopls")
enable_if("lua-language-server", "lua_ls")
enable_if("ty",                  "ty")
-- enable_if("pyrefly",          "pyrefly")

-- 4) Keymaps on attach -------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = grp,
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Native completion for this client in this buffer
    if client and client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    local o = { buffer = ev.buf, silent = true }
    map("n", "<leader>gd", vim.lsp.buf.definition, o)
    map("n", "<leader>gr", vim.lsp.buf.references, o)
    map("n", "<leader>gi", vim.lsp.buf.implementation, o)
    map("n", "<leader>gh", vim.lsp.buf.hover, o)
    map("n", "<leader>rn", vim.lsp.buf.rename, o)
    map("n", "<leader>ca", vim.lsp.buf.code_action, o)
    map("i", "<C-Space>", function() vim.lsp.completion.get() end, o)
  end,
})

--------------------------------------------------------------------------------
-- Enable/Disable Diagnostics
--------------------------------------------------------------------------------
map("n", "<leader>dd", function()
  local on = vim.diagnostic.is_enabled()
  vim.diagnostic.enable(not on)
  vim.notify("Diagnostics " .. (on and "disabled" or "enabled"))
end, { silent = true })

--------------------------------------------------------------------------------
-- Autocommands
--------------------------------------------------------------------------------
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
