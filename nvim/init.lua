-- Both leaders have to be set before lazy is loaded
vim.g.mapleader = "<space>"
vim.g.maplocalleader = ","
require("config.options")
require("config.autocommands")
require("config.lazy")
require("config.keymap")
require("config.godot")
