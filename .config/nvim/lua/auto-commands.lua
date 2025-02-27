local api = vim.api

-- xterm用のペースト設定
--api.nvim_create_autocmd("TermResponse", {
--  pattern = "*",
--  callback = function()
--    if vim.env.TERM:match("xterm") then
--      vim.opt.t_SI = vim.opt.t_SI + "\27[?2004h"
--      vim.opt.t_EI = vim.opt.t_EI + "\27[?2004l"
--      vim.opt.pastetoggle = "\27[201~"
--    end
--  end,
--})

-- カーソル位置の保存
api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    local mark = api.nvim_buf_get_mark(0, '"')
    local lcount = api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(api.nvim_win_set_cursor, 0, mark)
    end
  end,
})
