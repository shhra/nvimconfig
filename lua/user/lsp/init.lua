local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end



require "user.lsp.mason"
require "user.lsp.formatter"
require("user.lsp.handlers").setup()
