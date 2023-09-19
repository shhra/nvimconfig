local vim = vim
local formatter = require("formatter")
local prettierConfig = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)), "--single-quote"},
    stdin = true
  }
end

local formatterConfig = {
  lua = {
    -- function()
    --    return {
    --      exe = "stylua",
    --      args = {  "-" },
    --      stdin = true,
    --    }
    --  end,
    -- function()
    --   return {
    --     exe = "luafmt",
    --     args = {"--indent-count", 2, "--stdin"},
    --     stdin = true
    --   }
    -- end
  },
  vue = {
    function()
      return {
        exe = "prettier",
        args = {
          "--stdin-filepath",
          vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
          "--single-quote",
          "--parser",
          "vue"
        },
        stdin = true
      }
    end
  },
  rust = {
    -- Rustfmt
    function()
      return {
        exe = "rustfmt",
        args = {"--emit=stdout"},
        stdin = true
      }
    end
  },
  ['*'] = {
    require("formatter.filetypes.any").lsp_format,
    -- require('formatter.filetypes.any').remove_trailing_whitespace
  }
}
local commonFT = {
  "css",
  "scss",
  "html",
  "java",
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "markdown",
  "markdown.mdx",
  "json",
  "yaml",
  "xml",
  "svg"
}

for _, ft in ipairs(commonFT) do
  formatterConfig[ft] = {prettierConfig}
end
-- Setup functions
formatter.setup(
  {
    logging = true,
    filetype = formatterConfig,
    log_level = 2,
  }
)
