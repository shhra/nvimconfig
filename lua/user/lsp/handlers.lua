local M = {}
local api = vim.api

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

    { name = "DiagnosticSignError", text = "•" },
    { name = "DiagnosticSignWarn", text = "•" },
    { name = "DiagnosticSignHint", text = "•" },
    { name = "DiagnosticSignInfo", text = "•" },
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


-- Setup lsp keymaps using which-key and telescope
local wh = require("which-key")
local tb = require("telescope.builtin")
wh.register({
  ["<leader>c"] = {
    name = "+lsp",
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
    f = { "<cmd>Format<CR>", "Format" },
    h = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
    n = { "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", "Next Diagnostic" },
    p = { "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", "Previous Diagnostic" },
    q = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Quickfix Diagnostics" },
    r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
    s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
    I = { "<cmd>Mason<cr>", "Info" },
    i = { function() tb.lsp_implementations() end, "Implementation" },
    d = { function() tb.lsp_definitions{} end, "Definition" },
    l = { function() tb.diagnostics() end, "List Diagnostics" },
    w = { function() vim.ui.input({ prompt = "Workspace symbols: " }, function(query) tb.lsp_workspace_symbols({ query = query }) end) end, "Workspace Symbols" },
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

  if client.server_capabilities.documentHighlightProvider then
    local group = vim.api.nvim_create_augroup(string.format('lsp-%s-%s', bufnr, client), {})
    vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
      group = group,
      buffer = bufnr,
      callback = function()
        local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
        client.request('textDocument/documentHighlight', params, nil, bufnr)
      end,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = group,
      buffer = bufnr,
      callback = function()
        pcall(vim.lsp.buf.clear_references)
      end,
    })
  end
end

return M
