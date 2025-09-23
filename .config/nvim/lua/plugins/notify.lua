return {
  {
    "rcarriga/nvim-notify",
    event = "VeryLazy",
    keys = {
      {
        "<leader>un",
        function()
          require("notify").dismiss({ silent = true, pending = true })
        end,
        desc = "Dismiss all notifications",
      },
    },
    opts = {
      timeout = 3000,
      -- 最小限の設定でエラーを回避
      render = "default",
      stages = "fade",
    },
    config = function(_, opts)
      require("notify").setup(opts)

      -- replace=true の問題を修正
      local original_notify = require("notify")
      vim.notify = function(msg, level, opts)
        -- opts が replace=true を含む場合、安全に処理
        if opts and opts.replace == true then
          -- replace を削除して新しい通知として表示
          local safe_opts = vim.deepcopy(opts)
          safe_opts.replace = nil
          return original_notify(msg, level, safe_opts)
        end
        return original_notify(msg, level, opts)
      end
    end,
  },
}
