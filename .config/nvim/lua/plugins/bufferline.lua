return {
  {
    "akinsho/bufferline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    lazy = true,
    keys = function()
      local keys = {
        {
          "<leader>bp",
          "<Cmd>BufferLineTogglePin<CR>",
          desc = "Toggle pin",
        },
        {
          "<leader>bl",
          "<Cmd>BufferLineCloseRight<CR><Cmd>BufferLineCloseLeft<CR>",
          desc = "Close all buffers except current and pinned",
        },
        {
          "<leader>bP",
          "<Cmd>BufferLineGroupClose ungrouped<CR>",
          desc = "Delete non-pinned buffers",
        },
        {
          "<leader>bo",
          function()
            -- 現在表示されているバッファのリストを取得
            local visible_buffers = {}
            for _, win in pairs(vim.api.nvim_list_wins()) do
              local buf = vim.api.nvim_win_get_buf(win)
              visible_buffers[buf] = true
            end

            -- 表示されていないバッファを閉じる
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_loaded(buf) and not visible_buffers[buf] then
                vim.api.nvim_buf_delete(buf, { force = false })
              end
            end
          end,
          desc = "Close all buffers except visible ones",
        },
        {
          "gb",
          function()
            if vim.v.count == 0 then
              vim.cmd("BufferLineCycleNext")
            else
              require("bufferline").go_to_buffer(vim.v.count, true)
            end
          end,
          desc = "Next buffer/Goto buffer by ordinal number",
        },
        {
          "gB",
          function()
            if vim.v.count == 0 then
              vim.cmd("BufferLineCyclePrev")
            else
              vim.cmd("buffer" .. tostring(vim.v.count))
            end
          end,
          desc = "Prev buffer/Goto buffer by absolute number",
        },
      }
      for i, n in ipairs({
        "1st",
        "2nd",
        "3rd",
        "4th",
        "5th",
        "6th",
        "7th",
        "8th",
        "9th",
      }) do
        table.insert(keys, {
          "<leader>" .. i,
          "<cmd>lua require('bufferline').go_to_buffer(" .. i .. ", true)<cr>",
          desc = "Goto " .. n .. " buffer",
        })
      end
      table.insert(keys, {
        "<leader>$",
        "<cmd>lua require('bufferline').go_to_buffer(-1)<cr>",
        desc = "Goto last buffer",
      })
      return keys
    end,
    opts = {
      options = {
        numbers = "buffer_id",
        always_show_bufferline = true,
        diagnostics = "nvim_lsp",
        --diagnostics_indicator = function(_, _, diag)
        --  local icons = require("config.icons").diagnostics
        --  local ret = (diag.error and icons.Error .. diag.error .. " " or "")
        --    .. (diag.warning and icons.Warn .. diag.warning or "")
        --  return vim.trim(ret)
        --end,
      },
    },
  },
}
