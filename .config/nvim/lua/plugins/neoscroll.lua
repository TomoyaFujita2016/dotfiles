return {
  "karb94/neoscroll.nvim",
  event = "VeryLazy",
  config = function()
    require("neoscroll").setup({
      mappings = {},
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing = "sine",
      performance_mode = true,
    })

    local neoscroll = require("neoscroll")
    local keymap = {
      ["<C-u>"] = function()
        neoscroll.ctrl_u({ duration = 150, easing = "quartic" })
      end,
      ["<C-d>"] = function()
        neoscroll.ctrl_d({ duration = 150, easing = "quartic" })
      end,
      -- ["<C-b>"] = function()
      --   neoscroll.ctrl_b({ duration = 200, easing = "sine" })
      -- end,
      -- ["<C-f>"] = function()
      --   neoscroll.ctrl_f({ duration = 200, easing = "sine" })
      -- end,
      -- ["<C-y>"] = function()
      --   neoscroll.scroll(-0.1, { move_cursor = false, duration = 50 })
      -- end,
      -- ["<C-e>"] = function()
      --   neoscroll.scroll(0.1, { move_cursor = false, duration = 50 })
      -- end,
      -- ["zt"] = function()
      --   neoscroll.zt({ half_win_duration = 150 })
      -- end,
      -- ["zz"] = function()
      --   neoscroll.zz({ half_win_duration = 150 })
      -- end,
      -- ["zb"] = function()
      --   neoscroll.zb({ half_win_duration = 150 })
      -- end,
    }

    local modes = { "n", "v", "x" }
    for key, func in pairs(keymap) do
      vim.keymap.set(modes, key, func)
    end
  end,
}
