local model = {}
function model.setup()
  require("nvim-treesitter.configs").setup {
    ensure_installed = { "rust", "php", "javascript", },
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
    },
  }
end

return model
