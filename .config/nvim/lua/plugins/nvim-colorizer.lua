return {
  {
    "norcalli/nvim-colorizer.lua",
    lazy = false,
    config = function()
      require("colorizer").setup({
        "css",
        "javascript",
        "typescript",
        "typescriptreact",
        "javascriptreact",
        "python",
        "lua",
        "vim",
        "sh",
        "bash",
        "zsh",
        "dockerfile",
        "toml",
        "yaml",
        "json",
        "markdown",
        "html",
        "xml",
      }, {
        RGB = true, -- #RGB形式のカラーコード
        RRGGBB = true, -- #RRGGBB形式のカラーコード
        names = true, -- カラーネーム (Red, Blueなど)
        RRGGBBAA = true, -- #RRGGBBAA形式のカラーコード
        rgb_fn = true, -- CSS形式のrgb()関数
        hsl_fn = true, -- CSS形式のhsl()関数
        css = true, -- CSS形式のカラー指定
        css_fn = true, -- CSS関連の関数
      })
    end,
  },
}
