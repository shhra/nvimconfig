local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
	return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
-- TODO: Fix this code here.
-- M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

M.setup = function()
	local signs = {

		{ name = "DiagnosticSignError", text = "" },
		{ name = "DiagnosticSignWarn", text = "" },
		{ name = "DiagnosticSignHint", text = "" },
		{ name = "DiagnosticSignInfo", text = "" },
	}

	for _, sign in ipairs(signs) do
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
	end

	local config = {
		virtual_text = false, -- disable virtual text
		signs = {
			active = signs, -- show signs
		},
		update_in_insert = true,
		underline = true,
		severity_sort = true,
		float = {
			focusable = true,
			style = "minimal",
			border = "rounded",
			source = "always",
			header = "",
			prefix = "",
		},
	}

	vim.diagnostic.config(config)

	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
		border = "rounded",
	})

	vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
		border = "rounded",
	})
end

-- local function lsp_keymaps(bufnr)
-- 	local opts = { noremap = true, silent = true }
-- 	local keymap = vim.api.nvim_buf_set_keymap
-- 	keymap(bufnr, "n", "<leader>cD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
-- 	keymap(bufnr, "n", "<leader>cd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
-- 	keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
-- 	keymap(bufnr, "n", "<leader>ci", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
-- 	keymap(bufnr, "n", "<leader>cR", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
-- 	keymap(bufnr, "n", "<leader>cl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
-- 	keymap(bufnr, "n", "<leader>ci", "<cmd>LspInfo<cr>", opts)
-- 	keymap(bufnr, "n", "<leader>cI", "<cmd>Mason<cr>", opts)
-- 	keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
-- 	keymap(bufnr, "n", "<leader>cj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
-- 	keymap(bufnr, "n", "<leader>ck", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
-- 	keymap(bufnr, "n", "<leader>cr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
-- 	keymap(bufnr, "n", "<leader>cs", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
-- 	keymap(bufnr, "n", "<leader>cq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
-- end


-- Setup lsp keymaps using which-key and telescope
local wh = require("which-key")
local tb = require("telescope.builtin")
wh.register({
  ["<leader>c"] = {
    name = "+lsp",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format" },
    n = { "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", "Next Diagnostic" },
    p = { "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Previous Diagnostic" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Quickfix Diagnostics" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
    F = { "<cmd>lua vim.lsp.buf.formatting_sync()<CR>", "Format Sync" },
    I = { "<cmd>Mason<cr>", "Info" },
    i = { function() tb.lsp_implementations() end, "Implementation" },
    d = { function() tb.lsp_definitions{} end, "Definition" },
    l = { function() tb.diagnostics() end, "List Diagnostics" },
    w = { function() tb.lsp_workspace_symbols{} end, "Workspace Symbols" },
    D = { function() tb.lsp_type_definitions() end, "Type Definition" },
    R = { function() tb.lsp_references{} end, "References" },
    S = { function() tb.lsp_document_symbols{} end, "Document Symbols" },
    c = { 
      e = { "<cmd> Copilot enable <cr>", "Enable co-pilot."},
      d = { "<cmd> Copilot disable <cr>", "Disable co-pilot."}, 
      s = { "<cmd> Copilot panel <cr>", "Open co-pilot panel."}
      -- x = { "<cmd>", "Close the panel."}
    }
  },
})


M.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.name == "sumneko_lua" then
		client.server_capabilities.documentFormattingProvider = false
	end

	-- lsp_keymaps(bufnr)
	local status_ok, illuminate = pcall(require, "illuminate")
	if not status_ok then
		return
	end
	illuminate.on_attach(client)
end

return M
