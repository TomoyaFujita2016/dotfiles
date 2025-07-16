return {
  "greggh/claude-code.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim", -- Required for git operations
  },
  config = function()
    require("claude-code").setup({
      window = {
        split_ratio = 0.3, -- Percentage of screen for the terminal window (height for horizontal, width for vertical splits)
        position = "vertical", -- Position of the window: "botright", "topleft", "vertical", "rightbelow vsplit", etc.
        enter_insert = true, -- Whether to enter insert mode when opening Claude Code
        hide_numbers = true, -- Hide line numbers in the terminal window
        hide_signcolumn = true, -- Hide the sign column in the terminal window
      },
      keymaps = {
        toggle = {
          normal = "<C-,>", -- Normal mode keymap for toggling Claude Code, false to disable
          terminal = "<C-,>", -- Terminal mode keymap for toggling Claude Code, false to disable
          variants = {
            continue = "<leader>cC", -- Normal mode keymap for Claude Code with continue flag
            verbose = "<leader>cV", -- Normal mode keymap for Claude Code with verbose flag
          },
        },
        window_navigation = false, -- Enable window navigation keymaps (<C-h/j/k/l>)
        scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
      },
    })
    -- Claude Codeターミナル専用のキーマップ設定
    local function setup_claude_terminal_keymaps()
      vim.keymap.set("t", "<C-w>h", "<C-\\><C-n><C-w>h", { buffer = true, silent = true })
      vim.keymap.set("t", "<C-w>j", "<C-\\><C-n><C-w>j", { buffer = true, silent = true })
      vim.keymap.set("t", "<C-w>k", "<C-\\><C-n><C-w>k", { buffer = true, silent = true })
      vim.keymap.set("t", "<C-w>l", "<C-\\><C-n><C-w>l", { buffer = true, silent = true })

      -- ターミナルに戻るためのキーマップ（オプション）
      vim.keymap.set("n", "i", "i", { buffer = true, silent = true })
      vim.keymap.set("n", "a", "a", { buffer = true, silent = true })
    end

    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "*",
      callback = function()
        local cmd = vim.api.nvim_buf_get_option(0, "filetype")
        local bufname = vim.api.nvim_buf_get_name(0)

        -- Claude Codeターミナルの判定（bufnameやコマンドで判定）
        if string.match(bufname, "claude") or string.match(bufname, "term://.*claude") then
          setup_claude_terminal_keymaps()
        end
      end,
    })
  end,
}
