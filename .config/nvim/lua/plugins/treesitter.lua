return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- Avanteファイル用のTreesitterパーサーを追加
        ensure_installed = {
          -- Web Development
          "html",
          "css",
          "scss",
          "javascript",
          "typescript",
          "tsx",
          "vue",

          -- Backend/Script
          "python",
          "lua",
          "bash",

          -- Markup/Data
          "json",
          "yaml",
          "toml",
          "markdown",
          "markdown_inline",

          -- Other useful parsers
          "regex",
          "vim",
          "vimdoc",
          "query", -- Treesitterのクエリ言語
          "git_rebase",
          "gitignore",
          "gitcommit",
          "diff",

          -- Web-related tools
          "prisma",
          "graphql",
          "dockerfile",
        },
        highlight = {
          enable = true, -- 基本的に有効に
          --disable = function(lang, buf)
          --  -- Avanteファイルはカスタムハイライトを使用
          --  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
          --  if ft == "Avante" or ft == "avante" then
          --    return false
          --  end
          --  -- その他のファイルタイプは通常のハイライトを使用
          --  return false
          --end,
          --additional_vim_regex_highlighting = {
          --  "Avante", -- 大文字のAvanteに合わせる
          --},
        },
        indent = {
          enable = true,
        },
        --incremental_selection = {
        --  enable = true,
        --  keymaps = {
        --    init_selection = "<CR>",
        --    node_incremental = "<CR>",
        --    node_decremental = "<BS>",
        --    scope_incremental = "<TAB>",
        --  },
        --},
        -- Auto-completion of HTML/JSX tags
        autotag = {
          enable = true,
        },
        fold = {
          enable = true,
        },
        rainbow = {
          enable = true,
          extended_mode = true,
          max_file_lines = 1000,
        },
      })

      -- Fallback configuration
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
      vim.opt.foldenable = false -- 起動時にフォールドを無効化
    end,
  },

  --{
  --  "nvim-treesitter/nvim-treesitter-textobjects",
  --  dependencies = { "nvim-treesitter/nvim-treesitter" },
  --  config = function()
  --    require("nvim-treesitter.configs").setup({
  --      textobjects = {
  --        select = {
  --          enable = true,
  --          lookahead = true,
  --          keymaps = {
  --            ["af"] = "@function.outer",
  --            ["if"] = "@function.inner",
  --            ["ac"] = "@class.outer",
  --            ["ic"] = "@class.inner",
  --            ["aa"] = "@parameter.outer",
  --            ["ia"] = "@parameter.inner",
  --          },
  --        },
  --        move = {
  --          enable = true,
  --          set_jumps = true,
  --          goto_next_start = {
  --            ["]f"] = "@function.outer",
  --            ["]c"] = "@class.outer",
  --          },
  --          goto_previous_start = {
  --            ["[f"] = "@function.outer",
  --            ["[c"] = "@class.outer",
  --          },
  --        },
  --      },
  --    })
  --  end,
  --},
}
