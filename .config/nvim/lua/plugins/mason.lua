return {
  -- Mason for managing LSP servers, formatters, and linters
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Formatters
          "stylua",      -- Lua formatter
          "ruff",        -- Python formatter and linter
          "biome",       -- JavaScript/TypeScript formatter

          -- Add any LSP servers you want to ensure are installed
          -- "lua-language-server",
          -- "typescript-language-server",
          -- etc.
        },
        auto_update = false,
        run_on_start = true,
        start_delay = 3000,
      })
    end,
  },
}