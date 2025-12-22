return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = function()
      vim.cmd("silent !make tiktoken")
    end,
    event = "VeryLazy",
    config = function()
      -- クリップボード設定
      vim.opt.clipboard = "unnamedplus"
      -- selectモジュールを安全にロード
      local select = nil
      local success, result = pcall(require, "CopilotChat.select")
      if success then
        select = result
      else
        print(
          "CopilotChat.select モジュールをロードできませんでした。一部の機能が使用できません。"
        )
        return
      end
      require("CopilotChat").setup({
        model = "claude-3.7-sonnet-thought",
        clear_chat_on_new_prompt = true,
        show_help = "yes",
        prompts = {
          --Optimize = {
          --  prompt = "/COPILOT_REFACTOR 選択したコードを最適化し、パフォーマンスと可読性を向上させてください。説明は日本語でお願いします。",
          --  mapping = "<leader>co",
          --  description = "バディにコードの最適化をお願いする",
          --},
          --Tests = {
          --  prompt = "/COPILOT_TESTS 選択したコードの詳細なユニットテストを書いてください。説明は日本語でお願いします。",
          --  mapping = "<leader>ct",
          --  description = "バディにコードのテストコード作成をお願いする",
          --},
          --FixDiagnostic = {
          --  prompt = "コードの診断結果に従って問題を修正してください。修正内容の説明は日本語でお願いします。",
          --  mapping = "<leader>cx",
          --  description = "バディにコードの静的解析結果に基づいた修正をお願いする",
          --  selection = select.diagnostics,
          --},
          Commit = {
            model = "claude-sonnet-4.5",
            prompt = "commitize の規則に従って、変更に対するコミットメッセージを記述してください。 タイトルは最大50文字で、メッセージは72文字で折り返されるようにしてください。 メッセージ全体を gitcommit 言語のコード ブロックでラップしてください。gitdiffに存在しない内容は、混乱するためコミットメッセージに含めないでください。差分がなければ何も出力しなくて構いません。メッセージは日本語でお願いします。体言止めを使ってください。それでは、commitize の規則に従ってコミットメッセージを記述してください。",
            mapping = "<leader>cc",
            description = "バディにコミットメッセージの作成をお願いする",
            selection = nil,
            --selection = select.gitdiff,
            --context = { include_context = false },
            context = "git:staged",
            callback = function(response, _)
              if not response then
                vim.notify("No response received from Copilot", "warn")
                return
              end

              -- responseがテーブルの場合、contentフィールドを取得
              local response_text
              if type(response) == "string" then
                response_text = response
              elseif type(response) == "table" and response.content then
                response_text = response.content
              else
                vim.notify("Unexpected response format from Copilot", "warn")
                return
              end

              local commit_message = response_text:match("```gitcommit\n(.-)\n```")
              if commit_message then
                -- OSC 52でクリップボードにコピー（リモートtmux対応）
                local b64 = vim.base64.encode(commit_message)
                local osc52 = string.format("\027]52;c;%s\027\\", b64)
                io.stdout:write(osc52)
                io.stdout:flush()
                -- 通常のレジスタにも保存
                vim.fn.setreg("+", commit_message)
                vim.fn.setreg('"', commit_message)
                vim.notify("Commit message copied to clipboard!")
              else
                vim.notify("Commit message was NOT found...", "warn")
              end
            end,
          },
        },
        -- ウィンドウの設定
        window = {
          layout = "float", -- 'vertical', 'horizontal', 'float'
          relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
          border = "rounded", -- 'none', 'single', 'double', 'rounded'
          width = 0.8, -- 幅（0.0-1.0）
          height = 0.8, -- 高さ（0.0-1.0）
          title = "Copilot Chat", -- ウィンドウのタイトル
          zindex = 1, -- 重なり順
        },
        -- その他の設定
        auto_follow_cursor = true, -- カーソルに自動的に追従
        show_help = true, -- ヘルプメッセージを表示
      })

      vim.keymap.set("n", "<leader>ch", ":CopilotChatToggle<CR>", { desc = "CopilotChatのトグル" })
    end,
  },
}
