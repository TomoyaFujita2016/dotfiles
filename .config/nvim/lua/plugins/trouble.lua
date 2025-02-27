return {
  {
    "folke/trouble.nvim",
    opts = {
      modes = {
        symbols = { -- シンボルモードの設定
          win = {
            type = "split", -- 分割ウィンドウ
            relative = "win", -- 現在のウィンドウに対して相対的
            position = "right", -- 右側に配置
            size = 0.25, -- ウィンドウの25  %
          },
        },
        -- 他のモードも同様に設定可能
        diagnostics = {
          win = {
            size = 0.35,
            type = "split", -- 分割ウィンドウ
            relative = "win", -- 現在のウィンドウに対して相対的
            position = "right", -- 右側に配置
          },
        },
        definitions = {
          win = {
            size = 0.35,
            type = "split", -- 分割ウィンドウ
            relative = "win", -- 現在のウィンドウに対して相対的
            position = "right", -- 右側に配置
          },
        },
        lsp = {
          win = {
            size = 0.35,
            type = "split", -- 分割ウィンドウ
            relative = "win", -- 現在のウィンドウに対して相対的
            position = "right", -- 右側に配置
          },
        },
        references = {
          win = {
            size = 0.35,
            type = "split", -- 分割ウィンドウ
            relative = "win", -- 現在のウィンドウに対して相対的
            position = "right", -- 右側に配置
          },
        },
      },
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle focus=true<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>dd",
        "<cmd>Trouble symbols toggle focus=true<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>gr",
        "<cmd>Trouble lsp toggle focus=true<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
}
