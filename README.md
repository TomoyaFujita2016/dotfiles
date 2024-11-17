# dotfiles

```
➜ tree .
.
├── coc-settings.json
├── init.lua
├── lua
│   ├── 101-lualine.lua
│   ├── base.lua
│   ├── character_code.lua
│   ├── keyconfig.lua
│   ├── lsp-config.lua
│   ├── mark_displayer.lua
│   ├── plugins.lua
│   └── plugins_config.lua
├── nvim.log
└── plugin
    └── packer_compiled.lua
```

## Generate .config symbolic link

> If the configuration file already exists, it will be renamed to {file_or_dir_name}.org\_{timestamp}.

```bash
sh setup-config.sh
```
