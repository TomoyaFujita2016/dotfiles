return {
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
    },
    cmd = { "AerialToggle", "Telescope aerial" },
    keys = {
      { "<leader>oo", "<cmd>Telescope aerial<CR>", desc = "Browse Symbols" },
    },
    config = function()
      require("aerial").setup({
        -- Aerialの基本設定
        attach_mode = "global",
        backends = { "lsp", "treesitter", "markdown", "man" },

        -- レイアウト設定
        layout = {
          max_width = { 40, 0.2 },
          width = nil,
          min_width = 20,
          default_direction = "prefer_right",
          placement = "window",
        },

        -- フィルター設定
        filter_kind = {
          "Class",
          "Constructor",
          "Enum",
          "Function",
          "Interface",
          "Module",
          "Method",
          "Struct",
        },
      })
      -- Telescopeとの統合を設定
      require("telescope").load_extension("aerial")
    end,
  },
}
