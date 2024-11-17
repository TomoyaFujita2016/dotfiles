return {
  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      { "<C-l>", mode = "", desc = "Format buffer" },
    },
    config = function()
      local utils = require("utils")

      -- conformの設定
      require("conform").setup({
        formatters_by_ft = {
          python = { "ruff_format", "ruff_fix", "ruff_organize_imports" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          javascriptreact = { "prettier" },
          typescriptreact = { "prettier" },
          vue = { "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          lua = { "stylua" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
        -- formatterの詳細設定
        formatters = {
          prettier = {
            -- prettierのデフォルト設定
            options = {
              -- arrow_parens = "avoid",
              -- bracket_spacing = true,
              -- bracket_same_line = false,
              -- embedded_language_formatting = "auto",
              -- end_of_line = "lf",
              -- html_whitespace_sensitivity = "css",
              -- jsx_single_quote = false,
              -- print_width = 80,
              -- prose_wrap = "preserve",
              -- quote_props = "as-needed",
              -- semi = true,
              -- single_quote = false,
              -- tab_width = 2,
              -- trailing_comma = "es5",
              -- use_tabs = false,
              -- vue_indent_script_and_style = false,
            },
          },
          ruff_format = {
            command = utils.get_python_env(),
            args = { "-m", "ruff", "format", "-" },
          },
          ruff_fix = {
            command = utils.get_python_env(),
            args = { "-m", "ruff", "check", "--fix-only", "-" },
          },
          ruff_organize_imports = {
            command = utils.get_python_env(),
            args = { "-m", "ruff", "check", "--select", "I", "--fix-only", "-" },
          },
        },
      })

      -- フォーマットのキーマッピング
      utils.map("", "<C-l>", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },
}
