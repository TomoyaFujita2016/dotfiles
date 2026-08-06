return {
  {
    "hat0uma/csvview.nvim",
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
    keys = {
      { "<Leader>cv", "<Cmd>CsvViewToggle<CR>", desc = "CSV: 整形表示をトグル" },
    },
    -- init はプラグイン読み込み前（起動時）に実行されるので、
    -- 最初に開いた CSV でも FileType を取りこぼさない
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "csv", "tsv", "csv_semicolon", "csv_pipe", "csv_whitespace" },
        callback = function()
          vim.cmd("CsvViewEnable") -- cmd 経由で lazy ロードされる
        end,
      })
    end,
    config = function()
      require("csvview").setup({
        parser = {
          comments = { "#", "//" },
        },
        view = {
          -- "border": 区切り文字を conceal して罫線 │ を表示（カンマが見えない）
          -- "highlight": 区切り文字はそのまま残して色を付けるだけ
          display_mode = "border",
          min_column_width = 5,
          spacing = 2,
          -- スクロールしてもヘッダ行を画面上部に固定
          sticky_header = {
            enabled = true,
            separator = "─",
          },
        },
        keymaps = {
          -- テキストオブジェクト: フィールド単位で操作
          textobject_field_inner = { "if", mode = { "o", "x" } },
          textobject_field_outer = { "af", mode = { "o", "x" } },
          -- フィールド／行間ジャンプ
          jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
          jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
          jump_next_row = { "<Enter>", mode = { "n", "v" } },
          jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
        },
      })

      -- csvview は有効化時に buffer の 'syntax' を空にするため、Neovim 標準の
      -- syntax/csv.vim が定義するはずの csvCol1..8 が未定義のままになる。
      -- （加えて vim-polyglot の syntax/csv.vim が標準版を先に握って潰している）
      -- 結果 CsvViewCol* のリンク先が存在せず列に色が付かないので、ここで直接定義する。
      local col_links = {
        "Statement", -- 1列目
        "Constant",
        "Type",
        "PreProc",
        "Identifier",
        "Special",
        "String",
        "Function",
        "Number", -- 9列目、以降は循環
      }
      local function set_csv_colors()
        for i, link in ipairs(col_links) do
          vim.api.nvim_set_hl(0, "CsvViewCol" .. (i - 1), { link = link })
        end
      end
      set_csv_colors()
      -- colorscheme 切り替えでハイライト定義が飛ぶので貼り直す
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_csv_colors })
    end,
  },
}
