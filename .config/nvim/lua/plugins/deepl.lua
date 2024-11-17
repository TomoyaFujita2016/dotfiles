return {
  {
    "ryicoh/deepl.vim",
    priority = 1000,
    cmd = "DeepL",
    keys = {
      {
        "t<C-j>",
        mode = { "v" },
        desc = "Translate to Japanese",
      },
      {
        "t<C-e>",
        mode = { "v" },
        desc = "Translate to English",
      },
    },
    config = function()
      -- 環境変数からAPIキーを取得
      local deepl_auth_key = os.getenv("DEEPL_API_KEY")
      -- APIキーが存在しない場合の警告
      if not deepl_auth_key then
        vim.notify("DEEPL_AUTH_KEY environment variable is not set", vim.log.levels.WARN)
        return
      end

      vim.cmd([[
        let g:deepl#endpoint = "https://api-free.deepl.com/v2/translate"
        let g:deepl#auth_key = "]] .. deepl_auth_key .. [["
        
        vmap t<C-j> <Cmd>call deepl#v('JA')<CR>
        vmap t<C-e> <Cmd>call deepl#v('EN')<CR>
      ]])
    end,
  },
}
