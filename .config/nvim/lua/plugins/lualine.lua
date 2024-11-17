return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- LSP診断情報を取得する関数
      local function lsp_diagnostics()
        local diagnostics = vim.diagnostic.get(0)
        local count = { errors = 0, warnings = 0, info = 0, hints = 0 }
        for _, diagnostic in ipairs(diagnostics) do
          if diagnostic.severity == vim.diagnostic.severity.ERROR then
            count.errors = count.errors + 1
          elseif diagnostic.severity == vim.diagnostic.severity.WARN then
            count.warnings = count.warnings + 1
          elseif diagnostic.severity == vim.diagnostic.severity.INFO then
            count.info = count.info + 1
          elseif diagnostic.severity == vim.diagnostic.severity.HINT then
            count.hints = count.hints + 1
          end
        end
        local result = {}
        if count.errors > 0 then
          table.insert(result, " " .. count.errors)
        end
        if count.warnings > 0 then
          table.insert(result, " " .. count.warnings)
        end
        if count.info > 0 then
          table.insert(result, " " .. count.info)
        end
        if count.hints > 0 then
          table.insert(result, " " .. count.hints)
        end
        return table.concat(result, " ")
      end

      -- lualineの設定を直接実行
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "everforest",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = {},
          always_divide_middle = true,
          globalstatus = false,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = {
            { "filename", path = 2 }, -- 絶対パスを表示
          },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {
            { "filename", path = 2 }, -- 絶対パスを表示
          },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        extensions = {},
      })
    end,
  },
}
