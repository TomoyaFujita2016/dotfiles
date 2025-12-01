return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    opts = function()
      local dashboard = require("alpha.themes.dashboard")
      local hostname = vim.fn.hostname()

      -- ホスト名から色を生成（同じホスト名なら同じ色）
      local function hostname_to_color(name)
        local hash = 0
        for i = 1, #name do
          hash = (hash * 31 + string.byte(name, i)) % 16777216
        end
        return string.format("#%06x", hash)
      end

      local hostname_color = hostname_to_color(hostname)

      dashboard.section.header.val = {
        "                                                                                       ▒█▀▀▄                ",
        "                                                                                     ░▒█    ██▄▄▄▄▒█▀ ▀▄    ",
        "                                                                                     ▄▒          ░▒█    ▀▄  ",
        " ███▄ ▄███▓ ▒█████   ███▄ ▄███▓ ▒█████   ███▄    █   ▄████  ▄▄▄                    ░▒▒                  ▀▒  ",
        "▓██▒▀█▀ ██▒▒██▒  ██▒▓██▒▀█▀ ██▒▒██▒  ██▒ ██ ▀█   █  ██▒ ▀█▒▒████▄                 ▄▄                    ░█  ",
        "▓██    ▓██░▒██░  ██▒▓██    ▓██░▒██░  ██▒▓██  ▀█ ██▒▒██░▄▄▄░▒██  ▀█▄              ▀       ▄▄     ▄▄       █  ",
        "▒██    ▒██ ▒██   ██░▒██    ▒██ ▒██   ██░▓██▒  ▐▌██▒░▓█  ██▓░██▄▄▄▄██           ▒▄          ▄▄█▄          ▀░ ",
        "▒██▒   ░██▒░ ████▓▒░▒██▒   ░██▒░ ████▓▒░▒██░   ▓██░░▒▓███▀▒ ▓█   ▓██▒         ▒░            ▀▀        ▄▄▒█  ",
        "░ ▒░   ░  ░░ ▒░▒░▒░ ░ ▒░   ░  ░░ ▒░▒░▒░ ░ ▒░   ▒ ▒  ░▒   ▒  ▒▒   ▓▒█░       ▀█▄                    █▀    ░█ ",
        "░  ░      ░  ░ ▒ ▒░ ░  ░      ░  ░ ▒ ▒░ ░ ░░   ░ ▒░  ░   ░   ▒   ▒▒ ░     ▒█ ▒░                  ▄▄      █  ",
        "░      ░   ░ ░ ░ ▒  ░      ░   ░ ░ ░ ▒     ░   ░ ░ ░ ░   ░   ░   ▒       ▒░   █▒ ▀              █      ▄▒   ",
        "       ░       ░ ░         ░       ░ ░           ░       ░       ░  ░   ▒      ░▄█              ▒      ▀▄   ",
        "                                                                        ▀                        ▄     ▄█   ",
        "                                                                       ░█  ░▀▒                   ▀▒  ▒▀▀    ",
        "                                                                         ▄▀▄▀▄▒░░░▄▄▄▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▄▀▄",
        "",
      }

      dashboard.section.buttons.val = {
        dashboard.button("f", "  Find file", ":Telescope smart_open <CR>"),
        dashboard.button("i", "  New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("r", "  Restore Session", [[:lua require("persistence").load() <CR>]]),
        dashboard.button("l", "  Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", "  GrugFar", ":GrugFar <CR>"),
        dashboard.button("G", "  Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", "  Config", ":e $MYVIMRC <CR>"),
        dashboard.button("z", "󰒲  Lazy", ":Lazy<CR>"),
        dashboard.button("q", "  Quit", ":qa<CR>"),
      }

      -- ホスト名ベースの色でハイライトを設定
      vim.api.nvim_set_hl(0, "AlphaHeader", { fg = hostname_color })

      for _, button in ipairs(dashboard.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dashboard.section.header.opts.hl = "AlphaHeader"
      dashboard.section.buttons.opts.hl = "AlphaButtons"
      dashboard.section.footer.opts.hl = "AlphaFooter"

      dashboard.opts.layout[1].val = 8
      return dashboard
    end,
    config = function(_, dashboard)
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dashboard.opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dashboard.section.footer.val = {
            "🖧 Now on \"" .. vim.fn.hostname() .. "\"",
            "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms",
          }
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
}
