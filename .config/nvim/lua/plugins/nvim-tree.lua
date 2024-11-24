return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "antosha417/nvim-lsp-file-operations",
      "echasnovski/mini.base16",
    },
    cmd = "NvimTreeToggle",
    keys = {
      { "<C-n>", "<cmd>NvimTreeToggle<CR>", desc = "NvimTree" },
    },
    config = function()
      -- カスタムアタッチ関数の定義
      local function my_on_attach_nvimtree(bufnr)
        local api = require("nvim-tree.api")

        local function opts(desc)
          return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
        end

        -- デフォルトマッピング
        api.config.mappings.default_on_attach(bufnr)

        -- カスタムマッピング
        vim.keymap.set("n", "<BS>", api.tree.change_root_to_parent, opts("Up"))
        vim.keymap.set("n", "<CR>", api.tree.change_root_to_node, opts("Up"))
        vim.keymap.set("n", "v", api.node.open.vertical, opts("Open node vertically"))
        vim.keymap.set("n", "s", api.node.open.horizontal, opts("Open node horizontal"))
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      end

      -- 変更されたバッファーがあるか確認する関数
      local function is_modified_buffer_open(buffers)
        for _, v in pairs(buffers) do
          if v.name:match("NvimTree_") == nil and v.changed == 1 then
            return true
          end
        end
        return false
      end

      -- メイン設定を直接実行
      require("nvim-tree").setup({
        on_attach = my_on_attach_nvimtree,
        sort_by = "extension",
        view = {
          width = 50,
          side = "left",
          signcolumn = "no",
        },
        filters = {
          git_ignored = true,
          dotfiles = true,
          git_clean = false,
          no_buffer = false,
          custom = {},
          exclude = {},
        },
        renderer = {
          highlight_git = true,
          highlight_opened_files = "name",
          icons = {
            glyphs = {
              git = {
                unstaged = "!",
                renamed = "»",
                untracked = "?",
                deleted = "✘",
                staged = "✓",
                unmerged = "",
                ignored = "◌",
              },
            },
          },
        },
        actions = {
          open_file = {
            --quit_on_open = true
          },
          expand_all = {
            max_folder_discovery = 100,
            exclude = {},
          },
        },
      })

      -- ディレクトリを開いたときに自動的にnvim-treeを開く
      vim.api.nvim_create_autocmd({ "VimEnter" }, {
        callback = function(data)
          if vim.fn.isdirectory(data.file) == 1 then
            require("nvim-tree.api").tree.open()
          end
        end,
      })

      -- Ex コマンドの設定
      vim.api.nvim_create_user_command("Ex", function()
        vim.cmd.NvimTreeToggle()
      end, {})

      -- 自動クローズの設定
      vim.api.nvim_create_autocmd("BufEnter", {
        nested = true,
        callback = function()
          if vim.v.vim_did_enter == 0 then
            return
          end

          if
            #vim.api.nvim_list_wins() == 1
            and vim.bo.filetype == "NvimTree"
            and not is_modified_buffer_open(vim.fn.getbufinfo({ bufmodified = 1 }))
          then
            vim.cmd("quit")
          end
        end,
      })
    end,
  },
}
