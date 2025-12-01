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
          javascript = { "eslint_d", "prettier" },
          typescript = { "eslint_d", "prettier" },
          javascriptreact = { "eslint_d", "prettier" },
          typescriptreact = { "eslint_d", "prettier" },
          vue = { "eslint_d", "prettier" },
          css = { "prettier" },
          html = { "prettier" },
          json = { "prettier" },
          yaml = { "prettier" },
          markdown = { "prettier" },
          lua = { "stylua" },
          sh = { "shfmt" },
        },
        -- format_on_save = {
        --   timeout_ms = 500,
        --   lsp_fallback = true,
        -- },
        -- formatterの詳細設定
        formatters = {
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
          shfmt = {
            prepend_args = { "-i", "2" }, -- Use 2 spaces for indentation
          },
          --biome = {
          --  command = "biome",
          --  args = { "format", "--stdin-file-path", "$FILENAME" },
          --  stdin = false,
          --},
        },
      })

      -- フォーマットのキーマッピング
      utils.map("", "<C-l>", function()
        require("conform").format({ async = true, lsp_fallback = true })
      end, { desc = "Format buffer" })
    end,
  },
}
