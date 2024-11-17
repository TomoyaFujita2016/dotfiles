-- キーマップのユーティリティ関数
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- 基本的なキーマッピング
map("i", "<C-j>", "<ESC>")

-- 検索ハイライトを消す
map("n", "<ESC><ESC>", "<cmd>nohl<CR>")
map("n", "<C-j><C-j>", "<cmd>nohl<CR>")

-- 補完表示時の挙動
map("i", "<CR>", function()
  return vim.fn.pumvisible() == 1 and "<C-y>" or "<CR>"
end, { expr = true })
map("i", "<C-n>", function()
  return vim.fn.pumvisible() == 1 and "<Down>" or "<C-n>"
end, { expr = true })
map("i", "<C-p>", function()
  return vim.fn.pumvisible() == 1 and "<Up>" or "<C-p>"
end, { expr = true })

-- カーソル移動
map("i", "<C-e>", "<ESC>$a")
map("i", "<C-a>", "<ESC>^i")
map("n", "<C-e>", "<ESC>$a")
map("n", "<C-a>", "<ESC>^i")

-- 折り返し時の移動
map("n", "j", "gj")
map("n", "k", "gk")
map("v", "j", "gj")
map("v", "k", "gk")

-- ウィンドウ操作
map("n", "<S-Right>", "<C-w><")
map("n", "<S-Left>", "<C-w>>")
map("n", "<S-Up>", "<C-w>-")
map("n", "<S-Down>", "<C-w>+")

-- no yank
vim.api.nvim_set_keymap('n', 'mm', 'dd', { noremap = true })
vim.api.nvim_set_keymap('n', 'd', '"_d', { noremap = true })
vim.api.nvim_set_keymap('n', 'm', 'd', { noremap = true })
vim.api.nvim_set_keymap('n', 'x', '"_x', { noremap = true })
vim.api.nvim_set_keymap('v', 'd', '"_d', { noremap = true })
vim.api.nvim_set_keymap('v', 'm', 'd', { noremap = true })
vim.api.nvim_set_keymap('v', 'x', '"_x', { noremap = true })

-- ファイル操作
vim.api.nvim_create_user_command("W", "w !sudo tee > /dev/null %", {})
map("n", "ZZ", "<cmd>wq!<CR>")

-- 単語ハイライト
map("n", "<Space><Space>", function()
  local word = vim.fn.expand("<cword>")
  vim.fn.setreg("/", "\\<" .. word .. "\\>")
  vim.opt.hlsearch = true
end)
