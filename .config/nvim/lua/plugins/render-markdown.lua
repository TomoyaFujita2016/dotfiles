return {
	{
		"MeanderingProgrammer/render-markdown.nvim",
		version = "v8.0.0",
		dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
		-- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			heading = {
				width = "block",
				left_pad = 0,
				right_pad = 4,
				icons = {},
				backgrounds = {},
			},
		},
	},

	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
		opts = {
			rocks = { "magick" },
		},
	},

	-- image.nvim本体
	{
		"3rd/image.nvim",
		dependencies = {
			"luarocks.nvim",
		},
		config = function()
			require("image").setup({
				backend = "kitty", -- Kittyを使用
				processor = "magick_cli", -- ImageMagick CLIを使用
				integrations = {
					-- Markdown統合
					markdown = {
						enabled = true,
						clear_in_insert_mode = false,
						download_remote_images = true,
						only_render_image_at_cursor = true, -- すべての画像を表示
						only_render_image_at_cursor_mode = "popup", -- または "inline"
						filetypes = { "markdown", "vimwiki" },
						resolve_image_path = function(document_path, image_path, fallback)
							return fallback(document_path, image_path)
						end,
					},
					-- Neorg統合（使用する場合）
					neorg = {
						enabled = true,
						filetypes = { "norg" },
					},
				},
				max_width = nil,
				max_height = nil,
				max_width_window_percentage = nil,
				max_height_window_percentage = 50,

				-- ウィンドウ設定
				window_overlap_clear_enabled = false,
				window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },

				-- エディタ設定
				editor_only_render_when_focused = false,
				tmux_show_only_in_active_window = true, -- tmux使用時の設定

				-- ハイジャック設定（画像ファイルを直接開く）
				hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
			})
		end,
	},

	-- diagram.nvim（Mermaidレンダリング）
	{
		"3rd/diagram.nvim",
		dependencies = {
			"3rd/image.nvim",
		},
		ft = { "markdown", "norg" },
		config = function()
			require("diagram").setup({
				integrations = {
					require("diagram.integrations.markdown"),
					require("diagram.integrations.neorg"),
				},
				events = {
					-- 自動レンダリングを無効化（エラーを防ぐため）
					render_buffer = {},
					clear_buffer = { "BufLeave" },
				},
				renderer_options = {
					mermaid = {
						background = "transparent", -- または "white", "#hex"
						theme = "dark", -- "default", "forest", "neutral"
						scale = 2, -- 拡大率
						width = 1200, -- 幅（ピクセル）
						height = 800, -- 高さ（ピクセル）
						-- Nixユーザーやサンドボックスエラーが出る場合
						cli_args = {
							"--puppeteerConfigFile",
							"~/.config/puppeteer-config.json",
							"--iconPacks",
							"@iconify-json/logos",
							"@iconify-json/mdi",
						},
					},
					plantuml = {
						charset = "utf-8",
					},
					d2 = {
						theme_id = 1,
						dark_theme_id = 200,
						scale = 1,
					},
					gnuplot = {
						theme = "dark",
						size = "800,600",
					},
				},
			})
		end,
		-- キーマップ設定
		keys = {
			{
				"<leader>dd",
				function()
					require("diagram").show_diagram_hover()
				end,
				mode = "n",
				ft = { "markdown", "norg" },
				desc = "Show diagram in new tab",
			},
		},
	},
}
