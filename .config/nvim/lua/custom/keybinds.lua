local telekasten = require 'telekasten'

vim.keymap.set('n', '<leader>e', '<Cmd>Neotree toggle<CR>')

-- Launch panel if nothing is typed after <leader>z
vim.keymap.set('n', '<leader>z', '<cmd>Telekasten panel<CR>')

-- Most used functions
vim.keymap.set('n', '<leader>zf', '<cmd>Telekasten find_notes<CR>')
vim.keymap.set('n', '<leader>zg', '<cmd>Telekasten search_notes<CR>')
vim.keymap.set('n', '<leader>zd', '<cmd>Telekasten goto_today<CR>')
vim.keymap.set('n', '<leader>zz', '<cmd>Telekasten follow_link<CR>')
vim.keymap.set('n', '<leader>zn', '<cmd>Telekasten new_note<CR>')
vim.keymap.set('n', '<leader>zc', '<cmd>Telekasten show_calendar<CR>')
vim.keymap.set('n', '<leader>zb', '<cmd>Telekasten show_backlinks<CR>')
vim.keymap.set('n', '<leader>zI', '<cmd>Telekasten insert_img_link<CR>')
vim.keymap.set('n', '<leader>zw', '<cmd>Telekasten goto_thisweek<CR>')
vim.keymap.set('n', '<leader>zt', '<cmd>Telekasten show_tags<CR>')
-- Call insert link automatically when we start typing a link
vim.keymap.set('i', '[[', '<cmd>Telekasten insert_link<CR>')
-- Call make new note for my templates
vim.keymap.set('n', '<leader>nt', function()
  require('telekasten').new_templated_note()
end, { desc = 'New templated note (pick template)' })

-- Clearing current highlights
vim.keymap.set('n', '<leader>n,', '<cmd>nohlsearch<CR>', { noremap = true, silent = true })
