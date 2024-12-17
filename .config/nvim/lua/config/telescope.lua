local actions = require('telescope.actions')
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = ':Telescope find_files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = ':Telescope find_files' })
require("telescope").setup {
    defaults = {
        mappings = {
            i = {
                ["jk"] = actions.close
            },
        },
    },
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
    }
}
