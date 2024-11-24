return {
  {
    "nvim-telescope/telescope.nvim",
    priority = 1200,
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      --{ "<leader>ff", desc = "Find files" },
      { "<leader>fg", desc = "Live grep" },
      { "<leader>fb", desc = "Buffers" },
      { "<leader>fh", desc = "Help tags" },
      { "<leader>fm", desc = "Marks" },
      { "<leader>y", desc = "Registers" },
      { "<leader>q", desc = "Quickfix list" },
    },
    config = function()
      local utils = require("utils")
      local telescope = require("telescope.builtin")

      -- キーマッピングの設定
      -- smart openにします〜
      --utils.map("n", "<leader>ff", function()
      --  telescope.find_files({hidden = true})
      --end)
      utils.map("n", "<leader>fg", function()
        telescope.live_grep()
      end)
      utils.map("n", "<leader>fb", function()
        telescope.buffers()
      end)
      utils.map("n", "<leader>fh", function()
        telescope.help_tags()
      end)
      utils.map("n", "<leader>fm", function()
        telescope.marks()
      end)
      utils.map("n", "<leader>y", function()
        telescope.registers()
      end)

      -- Telescopeのデフォルト設定
      require("telescope").setup({
        defaults = {
          path_display = { "truncate" },
          mappings = {
            i = {
              ["<C-h>"] = "which_key",
              ["<C-u>"] = false,
              ["<C-d>"] = false,
            },
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            no_ignore = false, -- .gitignoreを無視
          },
        },
      })
    end,
  },
}
