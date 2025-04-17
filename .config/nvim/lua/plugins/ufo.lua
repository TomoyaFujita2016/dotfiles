return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      "neovim/nvim-lspconfig",
    },
    event = "BufReadPost",
    keys = {
      {
        "zR",
        function(...)
          require("ufo").openAllFolds(...)
        end,
      },
      {
        "zM",
        function(...)
          require("ufo").closeAllFolds(...)
        end,
      },
      { "zr", desc = "Increase fold level" },
      { "zm", desc = "Decrease fold level" },
      { "zc", desc = "Close fold" },
      { "zo", desc = "Open fold" },
    },
    config = function()
      local utils = require("utils")

      -- 折りたたみの基本設定
      vim.o.foldcolumn = "0"
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- UFOのプロバイダー設定
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Treesitterとlspをプロバイダーとして使用
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        if endLnum - lnum == 1 then
          suffix = " <<< 1 line"
        else
          suffix = (" <<<  %d lines"):format(endLnum - lnum)
        end
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- 最後のチャンクが切り詰められた場合はそこで終了
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      -- UFOの設定
      require("ufo").setup({
        provider_selector = function(bufnr, filetype, buftype)
          return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
      })

      -- キーマッピング
      local ufo = require("ufo")

      -- プレビュー関連
      utils.map("n", "K", function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold or show hover" })
    end,
  },
}
