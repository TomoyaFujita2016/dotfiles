# dotfiles

## Generate .config symbolic link

> If the configuration file already exists, it will be renamed to {file_or_dir_name}.org\_{timestamp}.

## File tree

```bash
sh setup-config.sh
```

```
➜ tree -a -I ".git" .
.
├── .config
│   ├── alacritty
│   │   └── alacritty.toml
│   ├── direnv
│   │   └── direnvrc
│   ├── git
│   │   └── ignore
│   ├── lazygit
│   │   └── config.yml
│   ├── nvim
│   │   ├── init.lua
│   │   ├── lazy-lock.json
│   │   ├── lua
│   │   │   ├── auto-commands.lua
│   │   │   ├── lazy-setup.lua
│   │   │   ├── mapping.lua
│   │   │   ├── options.lua
│   │   │   ├── plugins
│   │   │   │   ├── aerial.lua
│   │   │   │   ├── alpha.lua
│   │   │   │   ├── base.lua
│   │   │   │   ├── bufferline.lua
│   │   │   │   ├── colorscheme.lua
│   │   │   │   ├── conform.lua
│   │   │   │   ├── copilot.lua
│   │   │   │   ├── deepl.lua
│   │   │   │   ├── flash.lua
│   │   │   │   ├── hlchunk.lua
│   │   │   │   ├── lazy-git.lua
│   │   │   │   ├── lsp.lua
│   │   │   │   ├── lualine.lua
│   │   │   │   ├── notify.lua
│   │   │   │   ├── nvim-cmp.lua
│   │   │   │   ├── nvim-colorizer.lua
│   │   │   │   ├── nvim-lint.lua
│   │   │   │   ├── nvim-tree.lua
│   │   │   │   ├── persistence.lua
│   │   │   │   ├── signature.lua
│   │   │   │   ├── smart-open.lua
│   │   │   │   ├── telescope.lua
│   │   │   │   ├── todo-comments.lua
│   │   │   │   ├── treesitter.lua
│   │   │   │   ├── ufo.lua
│   │   │   │   └── undotree.lua
│   │   │   └── utils.lua
│   │   └── stylua.toml
│   └── starship.toml
├── .scripts
│   └── ide.sh
├── .zsh_files
│   ├── .zsh_aliases
│   ├── .zsh_functions
│   ├── .zsh_options
│   ├── .zsh_pkg_manager
│   └── .zsh_tmux
├── README.md
└── setup-config.sh

```
