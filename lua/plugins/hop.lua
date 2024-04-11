local hop = require('hop')

hop.setup({
	multi_windows = true,
	uppercase_labels = true,
	jump_on_sole_occurrence = false,
})

vim.keymap.set("n", "<leader><space>", vim.cmd.HopChar2)