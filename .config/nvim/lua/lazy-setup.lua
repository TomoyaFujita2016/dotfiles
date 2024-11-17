-- lazy.nvimのブートストラップ
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- lazy.nvimの初期化
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
  error("Failed to load lazy.nvim: " .. lazy)
  return
end

-- プラグインの設定
lazy.setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false,
  },
  change_detection = {
    notify = false,
  },
  rocks = {
    enabled = false,
  },
})
