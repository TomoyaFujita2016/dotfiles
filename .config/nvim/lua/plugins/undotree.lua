return {
  {
    "mbbill/undotree",
    lazy = false,
    --cmd = "UndotreeToggle",
    --keys = {
    --  { "<Leader>u", "<Cmd>UndotreeToggle<CR>", desc = "Toggle undotree" },
    --},
    config = function()
      if vim.fn.has("persistent_undo") == 1 then
        vim.opt.undodir = vim.fn.expand("~/.cache/.undodir/")
        vim.opt.undofile = true
      end
      vim.g.undotree_WindowLayout = 2
      vim.g.undotree_ShortIndicators = 1
      vim.g.undotree_SplitWidth = 30
      vim.g.undotree_SetFocusWhenToggle = 1
      vim.g.undotree_DiffpanelHeight = 8
      vim.keymap.set("n", "<Leader>u", ":UndotreeToggle<CR>", { noremap = true })
    end,
  },
}
