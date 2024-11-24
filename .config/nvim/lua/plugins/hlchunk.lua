return {
  {
    "shellRaining/hlchunk.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("hlchunk").setup({
        chunk = {
          enable = true,
          use_treesitter = true,
          chars = {
            horizontal_line = "─",
          },
          style = {
            { fg = "#806d9c", bg = "NONE" },
            { fg = "#c21f30", bg = "NONE" },
          },
        },
        indent = {
          enable = true,
          use_treesitter = true,
          style = {
            {
              fg = "#505050",
              bg = "NONE",
            },
          },
          chars = {
            "│",
          },
        },
        blank = {
          enable = false,
        },
      })
    end,
  },
}
