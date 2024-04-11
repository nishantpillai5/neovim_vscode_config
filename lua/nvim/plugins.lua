require("lazy").setup({
    { 'dasupradyumna/midnight.nvim', lazy = false, priority = 1000 },
    'smoka7/hop.nvim',
    {'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' }},
    { "ThePrimeagen/harpoon", branch = "harpoon2", dependencies = { "nvim-lua/plenary.nvim" }},
version = "*",
opts = {},
})

require('../plugins.midnight')
require('../plugins.hop')
require('../plugins.telescope')
require('../plugins.harpoon')