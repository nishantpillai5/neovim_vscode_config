return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        config = function()
            local wk = require("which-key")
            wk.register({
                ["<leader>"] = {
                    f = {
                        name = "Files",
                        f = "find files",
                        g = "live grep",
                    },
                    x = {
                        name = "Close",
                        x = "close current file",
                    },
                    e = {
                        name = "File Explorer",
                        e = "toggle tree",
                    },
                    ["<space>"] = "hop",
                    h = "harpoon list",
                    a = "harpoon add",
                    t = "terminal",
                    s = "save",
                    u = "undo tree",
                    d = {
                        name = "Debug",
                        s = "start",
                        x = "stop",
                        r = "run with debug",
                        c = "continue",
                        p = "pause",
                        j = "step into",
                        k = "step out",
                        l = "step over",
                    },
                    b = {
                        name = "Build",
                        b = "list targets",
                        d = "list debug targets",
                    },
                    v = {
                        name = "Visual",
                        l = "toggle relative line number",
                        h = "clear search highlight",
                    },
                    fml = "surrender",
                }
            })
        end,
    }
}