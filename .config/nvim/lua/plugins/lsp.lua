return {
  -- Mason
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  -- Mason-lspconfig: MasonとLSPの連携
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },

  -- LSP設定
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    config = function()
      -- 診断サインの設定
      local utils = require("utils")
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN] = "⚠",
            [vim.diagnostic.severity.HINT] = "➤",
            [vim.diagnostic.severity.INFO] = "ℹ",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          focusable = false,
          source = "always",
          header = "",
          prefix = "",
        },
        -- 以下を追加
        virtual_text = true, -- コード内に直接診断を表示しない
        echo_preview = true, -- コマンドラインにプレビューを表示
        show_diagnostic_autocmds = { "InsertLeave", "TextChanged" },
      })

      -- ***********************************
      -- ** <診断メッセージを表示する関数たち>
      -- ***********************************
      -- メッセージをクリアする関数
      local function clear_message()
        vim.api.nvim_echo({ { "", "" } }, false, {})
      end

      -- 前回の行番号を保存する変数
      local last_line = nil

      -- 診断メッセージのフォーマット関数
      local function format_diagnostic(diagnostic)
        local severity_icon = {
          [vim.diagnostic.severity.ERROR] = "✘",
          [vim.diagnostic.severity.WARN] = "⚠",
          [vim.diagnostic.severity.INFO] = "ℹ",
          [vim.diagnostic.severity.HINT] = "➤",
        }

        local source = diagnostic.source
        -- sourceが長い場合は短縮する（例：eslintをそのまま表示など）
        if source == "eslint" or source == "prettier" then
        -- do nothing
        elseif string.find(source, "/") then
          -- パスが含まれている場合は最後の部分だけを使用
          source = string.match(source, "([^/]+)$")
        end

        return string.format("%s %s: %s", severity_icon[diagnostic.severity] or "", source, diagnostic.message)
      end

      -- 診断メッセージを表示する関数
      local function show_diagnostic_message()
        local current_line = vim.fn.line(".")
        last_line = current_line

        local diagnostics = vim.diagnostic.get(0, { lnum = current_line - 1 })
        if #diagnostics > 0 then
          local diag = diagnostics[1]
          local message = format_diagnostic(diag)

          if diag.severity == vim.diagnostic.severity.ERROR then
            utils.err(message)
          elseif diag.severity == vim.diagnostic.severity.WARN then
            utils.warn(message)
          elseif diag.severity == vim.diagnostic.severity.INFO then
            utils.info(message)
          elseif diag.severity == vim.diagnostic.severity.HINT then
            utils.info(message)
          end
        end
      end

      -- カーソル移動時の処理
      vim.api.nvim_create_autocmd("CursorMoved", {
        callback = function()
          local current_line = vim.fn.line(".")
          -- 行が変わった場合のみクリア
          if last_line and current_line ~= last_line then
            clear_message()
            last_line = nil
          end
        end,
      })

      -- カーソルが留まった時の処理
      vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
          show_diagnostic_message()
        end,
      })

      -- インサートモードに入った時もクリア
      --vim.api.nvim_create_autocmd("InsertEnter", {
      --  callback = function()
      --    clear_message()
      --    last_line = nil
      --  end
      --})

      -- バッファを離れた時もクリア
      vim.api.nvim_create_autocmd("BufLeave", {
        callback = function()
          clear_message()
          last_line = nil
        end,
      })

      -- ******************************
      -- ** </診断メッセージを表示する関数たち>
      -- ******************************

      -- キーマッピングを追加
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "<space>e", function()
        vim.diagnostic.open_float(nil, { focus = false })
      end, opts)

      vim.keymap.set("n", "<leader>k", vim.diagnostic.goto_prev, opts)
      vim.keymap.set("n", "<leader>j", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

      -- LSPサーバーの設定
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end,
      })

      -- LSP関連のキーマッピング
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    end,
  },
}
