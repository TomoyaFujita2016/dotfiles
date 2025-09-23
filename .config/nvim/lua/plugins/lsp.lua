local utils = require("utils")
return {
  -- Mason
  {
    "williamboman/mason.nvim",
    lazy = false,
    priority = 100,
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- Mason-lspconfig: MasonとLSPの連携
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = false,
    dependencies = {
      "williamboman/mason.nvim",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = false,
      })
    end,
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
        virtual_text = true, -- コード内に直接診断を表示
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
        -- sourceが長い場合は短縮する（例：biomeをそのまま表示など）
        if source then
          if source == "biome" then
          -- do nothing
          elseif string.find(source, "/") then
            -- パスが含まれている場合は最後の部分だけを使用
            source = string.match(source, "([^/]+)$")
          end
          return string.format("%s %s: %s", severity_icon[diagnostic.severity] or "", source, diagnostic.message)
        else
          return string.format("%s %s", severity_icon[diagnostic.severity] or "", diagnostic.message)
        end
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
      vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function()
          clear_message()
          last_line = nil
        end,
      })

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

      -- LSPサーバーの手動設定
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- pyreflyのカスタム設定を追加
      local configs = require("lspconfig.configs")
      if not configs.pyrefly then
        configs.pyrefly = {
          default_config = {
            cmd = function()
              -- Python環境に応じてpyreflyのパスを決定
              local python_path = utils.get_python_env()
              local python_dir = vim.fn.fnamemodify(python_path, ":h")
              local pyrefly_path = python_dir .. "/pyrefly"
              
              -- まず環境のpyreflyを試す
              if vim.fn.executable(pyrefly_path) == 1 then
                return { pyrefly_path, "lsp" }
              end
              
              -- Masonのpyreflyを使用
              return { vim.fn.expand("~/.local/share/nvim/mason/bin/pyrefly"), "lsp" }
            end,
            filetypes = { "python" },
            root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", "Pipfile", ".git"),
            single_file_support = true,
            settings = {
              python = {
                analysis = {
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
                },
              },
            },
          },
        }
      end

      -- インストールされているLSPサーバーを自動的に設定
      local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
      if not mason_lspconfig_ok then
        vim.notify("mason-lspconfig not available", vim.log.levels.WARN)
        return
      end

      local installed_servers = mason_lspconfig.get_installed_servers()

      for _, server_name in ipairs(installed_servers) do
        -- styluaはフォーマッターなのでスキップ
        if server_name == "stylua" then
          goto continue
        end

        local config = {}

        -- Pythonの場合の特別な設定
        if server_name == "pyrefly" then
          -- Python環境に応じてpyreflyのパスを決定
          local python_path = utils.get_python_env()
          local python_dir = vim.fn.fnamemodify(python_path, ":h")
          local pyrefly_path = python_dir .. "/pyrefly"
          
          local cmd_to_use
          if vim.fn.executable(pyrefly_path) == 1 then
            cmd_to_use = { pyrefly_path, "lsp" }
          else
            cmd_to_use = { vim.fn.expand("~/.local/share/nvim/mason/bin/pyrefly"), "lsp" }
          end
          
          config = {
            capabilities = capabilities,
            cmd = cmd_to_use,
            settings = {
              python = {
                analysis = {
                  autoSearchPaths = true,
                  useLibraryCodeForTypes = true,
                  diagnosticMode = "workspace",
                },
                pythonPath = python_path,
              },
            },
          }
        elseif server_name == "ruff" then
          config = {
            capabilities = capabilities,
            init_options = {
              settings = {
                -- ruffの設定
                path = { utils.get_python_env(), "-m", "ruff" },
                interpreter = { utils.get_python_env() },
                importStrategy = "fromEnvironment",
                organizeImports = true,
                fixAll = true,
              },
            },
          }
        else
          -- 他のLSPサーバーの場合はデフォルト設定
          config = {
            capabilities = capabilities,
          }
        end

        lspconfig[server_name].setup(config)

        ::continue::
      end

      -- LSP参照をTelescopeで表示する安定版実装
      local function safe_lsp_references()
        -- 現在のカーソル位置の情報を取得
        local bufnr = vim.api.nvim_get_current_buf()
        local pos = vim.api.nvim_win_get_cursor(0)
        local row, col = pos[1] - 1, pos[2]

        -- LSPリクエストのパラメータを手動で構築
        local params = {
          textDocument = {
            uri = vim.uri_from_bufnr(bufnr),
          },
          position = {
            line = row,
            character = col,
          },
          context = {
            includeDeclaration = true,
          },
        }

        -- 参照を探す
        vim.lsp.buf_request(bufnr, "textDocument/references", params, function(err, result, _, _)
          if err then
            vim.notify("LSPエラー: " .. tostring(err), vim.log.levels.ERROR)
            return
          end

          if not result or vim.tbl_isempty(result) then
            vim.notify("参照が見つかりませんでした", vim.log.levels.INFO)
            return
          end

          -- 結果をQuickfixリストに変換
          local items = vim.lsp.util.locations_to_items(result, "utf-8")
          vim.fn.setqflist({}, "r", {
            title = "LSP References",
            items = items,
          })

          -- Telescope使ってQuickfixリストを表示
          require("telescope.builtin").quickfix({
            prompt_title = "LSP References",
            path_display = { "smart" },
          })
        end)
      end

      -- LSP関連のキーマッピング
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
      vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    end,
  },
}
