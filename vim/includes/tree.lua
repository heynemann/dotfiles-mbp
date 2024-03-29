-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true


local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')
  
  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end
  
  api.config.mappings.default_on_attach(bufnr)
  
  local function print_node_path()
    local api = require('nvim-tree.api')
    local node = api.tree.get_node_under_cursor()

    if vim.fn.isdirectory(node.absolute_path) ~= 1 then
      local command = "call NewTabFzfSink('" .. node.absolute_path .. "')" 

      api.tree.close()
      vim.cmd(command)
    else
      api.node.open.edit() 
    end
  end

  -- override a default
  vim.keymap.set('n', '<cr>', print_node_path,                       opts('Open'))
  vim.keymap.set('n', '-', api.tree.close,                       opts('Close'))
end

require("nvim-tree").setup({
  on_attach = my_on_attach,
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})


