local utils = require("utils")
-- Mason.nvimの修正設定
return {
  -- Mason
  {
    "williamboman/mason.nvim",
    version = "v1.10.0",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        -- 明示的に設定オプションを指定
        ui = {
          check_outdated_packages_on_open = true,
          border = "rounded",
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
        log_level = vim.log.levels.DEBUG,
        max_concurrent_installers = 4,
      })
    end,
  },

  -- Mason-lspconfig: MasonとLSPの連携
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require("mason-lspconfig").setup({
        -- 明示的に設定オプションを指定
        ensure_installed = {
          -- 必要なLSPサーバーをここに追加
          -- 例: "lua_ls", "pyright", "tsserver", など
        },
        automatic_installation = true,
      })
    end,
  },

  -- LSP設定（元のコードと同じ）
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
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
        virtual_text = true,
        echo_preview = true,
        show_diagnostic_autocmds = { "InsertLeave", "TextChanged" },
      })

      -- その他の設定は元のコードと同じ...

      -- LSPサーバーの設定
      local utils = require("utils")

      -- LSPサーバーをセットアップする前にmason-lspconfigが読み込まれていることを確認
      require("mason-lspconfig").setup_handlers({
        function(server_name)
          local config = {}

          -- Pythonの場合の特別な設定
          if server_name == "pyright" then
            config = {
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
              settings = {
                python = {
                  analysis = {
                    autoSearchPaths = true,
                    useLibraryCodeForTypes = true,
                    diagnosticMode = "workspace",
                  },
                  pythonPath = utils.get_python_env(),
                },
              },
            }
          elseif server_name == "ruff" then
            config = {
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
              capabilities = require("cmp_nvim_lsp").default_capabilities(),
            }
          end

          require("lspconfig")[server_name].setup(config)
        end,
      })
    end,
  },
}
