return {
  {
    "ryicoh/deepl.vim",
    cmd = "DeepL",
    config = function()
      -- 環境変数からAPIキーを取得
      local deepl_auth_key = os.getenv("DEEPL_API_KEY")

      -- APIキーが存在しない場合の警告
      if not deepl_auth_key then
        vim.notify(
          "DEEPL_AUTH_KEY environment variable is not set",
          vim.log.levels.WARN
        )
        return
      end

      -- DeepLの設定
      vim.g.deepl = {
        endpoint = "https://api-free.deepl.com/v2/translate",
        auth_key = deepl_auth_key,
      }

      -- キーマッピング
      vim.keymap.set("v", "t<C-j>", "<Cmd>call deepl#v('JA')<CR>", {})
      vim.keymap.set("v", "t<C-e>", "<Cmd>call deepl#v('EN')<CR>", {})

    end,
  },
}
