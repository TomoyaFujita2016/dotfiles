return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "github/copilot.vim" }, -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim", branch = "master" }, -- for curl, log and async functions
    },
    build = "make tiktoken", -- Only on MacOS or Linux
    opts = {
      window = {
        layout = "float", -- 'float' | 'bottom' | 'top' | 'right' | 'left'
        width = 0.4, -- width of the chat window when layout is 'float', 'right' or 'left'
        height = 1.0, -- height of the chat window when layout is 'float', 'top' or 'bottom'
      },
    },
    keys = {
      { "<leader>cp", "<cmd>CopilotChatToggle<CR>", desc = "CopilotChat - 通常チャット" },
    },
  },
}
