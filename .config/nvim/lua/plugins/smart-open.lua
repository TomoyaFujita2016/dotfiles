return {
  {
    "danielfalk/smart-open.nvim",
    priority = 1000,
    dependencies = {
      { "kkharji/sqlite.lua", lazy = true },
      { "nvim-telescope/telescope-fzy-native.nvim", lazy = true },
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope").extensions.smart_open.smart_open({ cwd_only = true, filename_first = false })
        end,
      },
    },
    config = function()
      require("telescope").load_extension("smart_open")
    end,
  },
}
