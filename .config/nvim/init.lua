--
-- " space=page down, shift space=page up
-- nnoremap <Space> <C-d>
-- nnoremap <S-Space> <C-u>
-- 
-- 
-- " move vertically by visual line
-- nnoremap j gj
-- nnoremap k gk
-- 
-- filetype indent on      " load filetype-specific indent files
-- set wildmenu            " visual autocomplete for command menu
-- 
-- 
-- " Remap common typos
-- command Q q
-- command QA qa
-- command Qa qa
-- command W w
-- command WA wa
-- command Wa wa
-- command WQ wq
-- command Wq wq


vim.g.mapleader = '\\'
vim.g.maplocalleader = '\\'

vim.opt.mouse = 'a'
-- share system clipboard
vim.opt.clipboard = 'unnamedplus'
-- line numbers
vim.opt.number = true
-- vim.opt.spell = true
vim.syntax = true
vim.opt.ruler = true

vim.opt.swapfile = false
vim.opt.signcolumn = "yes:2"
vim.opt.autowriteall = true
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    command = "wa"
})


vim.fn.sign_define(
  "LspDiagnosticsSignError",
  { texthl = "LspDiagnosticsSignError", text = "🚫", numhl = "LspDiagnosticsSignError" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignWarning",
  { texthl = "LspDiagnosticsSignWarning", text = "⚠️", numhl = "LspDiagnosticsSignWarning" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignHint",
  { texthl = "LspDiagnosticsSignHint", text = "❕", numhl = "LspDiagnosticsSignHint" }
)
vim.fn.sign_define(
  "LspDiagnosticsSignInformation",
  { texthl = "LspDiagnosticsSignInformation", text = "ℹ", numhl = "LspDiagnosticsSignInformation" }
)

vim.keymap.set('n', '<Space>', '<C-d>')
vim.keymap.set('n', '<S-Space>', '<C-u>')

-- move vertically by visual line
vim.keymap.set('n', 'j', 'gj')
vim.keymap.set('n', 'k', 'gk')

vim.cmd([[colorscheme lunaperche]])
-- vim.colorscheme = 'lunaperche'
vim.filetype.indent = 'on'
-- vim.wildmenu = true


vim.cmd([[ nnoremap <C-p> :find ./**/*]])
vim.cmd([[ nnoremap <C-;> :lua vim.diagnostic.goto_next()<CR>]])
vim.cmd([[ nnoremap <C-'> :lua vim.diagnostic.goto_prev()<CR>]])



-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300


-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.cmd([[command Link :exe "!stashlink.py " . expand("%") . " " . line(".") . " | pbcopy <CR>"]])
-- command Link :exe "!stashlink.py " . expand("%") . " " . line(".") . " | pbcopy"
--
-- vim.api.nvim_command('exe !stashlink.py ' .. expand('%') .. ' ' .. line('.') .. ' | pbcopy')
-- local function Link_command() 
-- 	vim.cmd([[:exe "!stashlink.py " . expand("%") . " " . line(".") . " | pbcopy"]])
-- end

--  http://www.panozzaj.com/blog/2016/03/21/ignore-urls-and-acroynms-while-spell-checking-vim/
-- Don't mark URL-like things as spelling errors
-- vim.cmd([[ syn match UrlNoSpell '\w\+:\/\/[^[:space:\]\]\+' contains=@NoSpell ]])
--vim.cmd("syn match UrlNoSpell '\\w\\+:\/\/[^[:space:]]\\+' contains=@NoSpell")
-- Don't count acronyms / abbreviations as spelling errors
-- (all upper-case letters, at least three characters)
-- Also will not count acronym with 's' at the end a spelling error
-- Also will not count numbers that are part of this
-- Recognizes the following as correct:
vim.cmd([[ syn match AcronymNoSpell '\<\(\u\|\d\)\{3,}s\?\>' contains=@NoSpell ]])

-- toggle paste
vim.cmd([[nma <leader>p :set paste!<CR>]])
-- line numbers toggle
vim.cmd([[nma <leader>n :set invnumber<CR>]])
-- wrapping toggle
vim.cmd([[nma <leader>w :set wrap!<CR>]])
-- remove search highlights
vim.cmd([[nma <leader>h :noh<CR>]])
-- remove search highlights
vim.cmd([[nma <leader>t :set expandtab!<CR>]])


--vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
--  pattern = {"*.c", "*.h"},
--  callback = function(ev)
--	  -- print(string.format('event fired: %s', vim.inspect(ev)))
--    vim.lsp.start({
--	    name = 'clangd',
--	    cmd = {'clangd'},
--	    root_dir = vim.fs.dirname(vim.fs.find({'compile_commands.json'}, { upward = false })[1]),
--    })
--  end
--})


 vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
	 pattern = { "*.tightbeam" },
	 command = "setlocal nospell syntax=swift",
 })

 vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
	 pattern = { "*.dt" },
	 command = "setlocal syntax=dts",
 })



vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
	 callback = function(event)
	 end
})

-- vim.api.nvim_create_autocmd("Comment", {
--   command = "setlocal spell",
-- })


-- local util = require 'lspconfig.util'
--
function util_get_active_client_by_name(bufnr, servername)
  for _, client in pairs(vim.lsp.get_active_clients { bufnr = bufnr }) do
    if client.name == servername then
      return client
    end
  end
end

-- https://clangd.llvm.org/extensions.html#switch-between-sourceheader
local function switch_source_header(bufnr)
  -- bufnr = util.validate_bufnr(bufnr)
  local clangd_client = util_get_active_client_by_name(bufnr, 'clangd')
  local params = { uri = vim.uri_from_bufnr(bufnr) }
  if clangd_client then
    clangd_client.request('textDocument/switchSourceHeader', params, function(err, result)
      if err then
        error(tostring(err))
      end
      if not result then
        print 'Corresponding file cannot be determined'
        return
      end
      vim.api.nvim_command('edit ' .. vim.uri_to_fname(result))
    end, bufnr)
  else
    print 'method textDocument/switchSourceHeader is not supported by any servers active on the current buffer'
  end
end

local root_files = {
  '.clangd',
  '.clang-tidy',
  '.clang-format',
  'compile_commands.json',
  'compile_flags.txt',
  'configure.ac', -- AutoTools
}

local default_capabilities = {
  textDocument = {
    completion = {
      editsNearCursor = true,
    },
  },
  offsetEncoding = { 'utf-8', 'utf-16' },
}

-- local sourcekit_config = {
-- {
--     cmd = { 'clangd' },
--     filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
--     root_dir = function(fname)
--       return util.root_pattern(unpack(root_files))(fname) or util.find_git_ancestor(fname)
--     end,
--     single_file_support = true,
--     capabilities = default_capabilities,
--   },
--   commands = {
--     ClangdSwitchSourceHeader = {
--       function()
--         switch_source_header(0)
--       end,
--       description = 'Switch between source/header',
--     },
--   },
--   docs = {
--     description = [[
-- https://clangd.llvm.org/installation.html
-- - **NOTE:** Clang >= 11 is recommended! See [#23](https://github.com/neovim/nvim-lsp/issues/23).
-- - If `compile_commands.json` lives in a build directory, you should
--   symlink it to the root of your source tree.
--   ```
--   ln -s /path/to/myproject/build/compile_commands.json /path/to/myproject/
--   ```
-- - clangd relies on a [JSON compilation database](https://clang.llvm.org/docs/JSONCompilationDatabase.html)
--   specified as compile_commands.json, see https://clangd.llvm.org/installation#compile_commandsjson
-- ]],
--     default_config = {
--       root_dir = [[
--         root_pattern(
--           '.clangd',
--           '.clang-tidy',
--           '.clang-format',
--           'compile_commands.json',
--           'compile_flags.txt',
--           'configure.ac',
--           '.git'
--         )
--       ]],
--       capabilities = [[default capabilities, with offsetEncoding utf-8]],
--     },
--   },
-- }

vim.api.nvim_create_autocmd({"FileType", "BufWinEnter", "BufEnter"}, {
 	pattern = { "*.py", },
 	callback = function()
		local root_dir = vim.fs.dirname(vim.fs.find({
				'pyproject.toml',
				'setup.py',
				'setup.cfg',
				'requirements.txt',
				'Pipfile',
				".git",
			}, {upward=true})[1])
		if root_dir == nil then
			root_dir = vim.fs.dirname('.')
		end
 		local client = vim.lsp.start({
			cmd = { 'pylsp', },
			root_dir = root_dir,
		})
 		vim.lsp.buf_attach_client(0, client)
	end,
})
vim.api.nvim_create_autocmd({"FileType", "BufWinEnter", "BufEnter"}, {
 	pattern = { "*.swift", "*.m", "*.mm", "*.c", "*.h", "*.cc", "*.cxx", "*.hxx", "*.hh", "*.hpp", "*.cpp" },
 	callback = function()
		local sdk = os.getenv("XCODE_SDK") or "iphoneos.internal"
		-- print(string.format('event fired: %s', vim.inspect(ev)))
 		local root_dir = vim.fs.dirname(vim.fs.find({
 			"compile_commands.json",
			'compile_flags.txt',
			'configure.ac',
			'.clangd',
 			".git",
 		}, { upward = true })[1])
 		local client = vim.lsp.start({
 			name = "sourcekit-lsp",
 			cmd = { "xcrun", "-sdk", sdk, "sourcekit-lsp" },
 			root_dir = root_dir,
			capabilities = default_capabilities,
			commands = {
				ClangdSwitchSourceHeader = {
					function()
						switch_source_header(0)
					end,
					description = 'Switch between source/header',
				},
			},

 		})
 		vim.lsp.buf_attach_client(0, client)
 	end,
 })


