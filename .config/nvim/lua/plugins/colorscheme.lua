return {
  ---- 100年前からbadwolf
  {
    "sjl/badwolf",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme badwolf]])
    end,
  },
  --{ "catppuccin/nvim", name = "catppuccin", priority = 1000 , lazy = false ,
  --  config = function()
  --    require("catppuccin").setup()
  --    vim.cmd.colorscheme "catppuccin"
  --  end,
  --},
}
