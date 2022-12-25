local keymap = vim.keymap.set
local wk = require("which-key")

-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
wk.register({
  b = {
    name = "Buffer Managements",
    i = { "<cmd>Telescope buffers<cr>", "List buffers."},
    k = { "<cmd>bd<cr>", "Delete buffer."},
    n = { "<cmd>bnext<cr>", "Next buffer."},
    p = { "<cmd>bprevious<cr>", "Previous buffer."},
  },
  c = {
    name = "LSP",
    f = {"<cmd>lua vim.lsp.buf.format{ async = true}<cr>", "Format buffer" },
    c = { 
      e = { "<cmd> Copilot enable <cr>", "Enable co-pilot."},
      d = { "<cmd> Copilot disable <cr>", "Disable co-pilot."}, 
      s = { "<cmd> Copilot panel <cr>", "Open co-pilot panel."}
      -- x = { "<cmd>", "Close the panel."}
    }
  },
  w = {
    name = "Window Managements",
    h = { "<C-w>h", "Focus left window."},
    j = { "<C-w>j", "Focus down window."},
    k = { "<C-w>k", "Focus up window."},
    l = { "<C-w>l", "Focus right window."},
    H = { "<C-w>H", "Move left window."},
    J = { "<C-w>J", "Move down window."},
    K = { "<C-w>K", "Move up window."},
    L = { "<C-w>L", "Move right window."},
    s = { "<C-w><C-s>", "Split window horizontally."},
    v = { "<C-w><C-v>", "Split window vertically."},
    c = { "<C-w><C-c>", "Close window."},
    r = { "<C-w><C-r>", "Rotate windows."},
  }
}, { prefix = "<leader>" })


-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Telescope
keymap("n", "<leader><leader>", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>/", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>pp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>bi", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>.", ":Telescope file_browser path=%:p:h<CR>", opts)

-- Git
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Comment
keymap("n", "gcc", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "gcc", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

vim.cmd[[imap <silent><script><expr> <C-k> copilot#Accept("\<CR>")]]
