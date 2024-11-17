local utils = require("utils")

vim.info = utils.info
vim.warn = utils.warn
vim.err = utils.err

-- こんぱいるしていい感じにキャッシュしてくれるやつ
vim.loader.enable()


require("options")
require("auto-commands")
require("mapping")
require("lazy-setup")
