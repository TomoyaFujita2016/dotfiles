return {
  -- 関数の引数表示のやつ
  {
    "ray-x/lsp_signature.nvim",
    lazy= false,
    opts = {},
    config = function(_, opts) require'lsp_signature'.setup(opts) end
  },
}
