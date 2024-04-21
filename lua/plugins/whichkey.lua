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
                    x = "close current file",
                    ["<space>"] = "hop",
                    s = "save",
                    u = "undo tree",
                    [";"] = {
                        name = "Terminal",
                        [";"] = "command palette",
                        t = "toggle",
                    },
                    f = {
                        name = "Find",
                        f = "git files",
                        a = "all files",
                        g = "live grep",
                        s = "search string",
                        ws = "search word",
                        Ws = "search whole word",
                        o = "symbols",
                        m = "marks",
                        r = "registers",
                        h = "harpoon",
                        d = "debug tasks",
                        [";"] = "terminal",
                    },
                    e = {
                        name = "File Explorer",
                        e = "toggle tree",
                        n = "netrw",
                        f = "oil",
                    },
                    h = "harpoon list",
                    a = "harpoon add",
                    t = {
                        name = "Panel",
                        t = "toggle",
                        w = "workspace",
                        d = "document",
                        q = "quickfix",
                        l = "loclist",
                        n = "next",
                        p = "previous",
                    },
                    d = {
                        name = "Debug",
                        d = "preview",
                        t = "toggle view",
                        s = "start",
                        x = "stop",
                        r = "run with debug",
                        c = "continue",
                        p = "pause",
                        j = "step into",
                        k = "step out",
                        l = "step over",
                        b = "breakpoint",
                        B = "breakpoint w/ message",
                    },
                    b = {
                        name = "Build",
                        t = "toggle",
                        b = "list targets",
                    },
                    z = {
                        name = "Visual",
                        l = "toggle relative line number",
                        h = "clear search highlight",
                        z = "zen mode",
                    },
                    fml = "surrender",
                },
                g = {
                    d = "definition",
                    D = "declaration",
                    i = "implementation",
                    o = "symbol",
                    r = "references",
                    s = "git status",
                    h = "signature help",
                    l = "diagnostics",
                },
                ["[d"] = "previous diagnostic",
                ["d"] = "next diagnostic",
                K = "hover",
                ["<F2>"] = "rename",
                ["<F3>"] = "format",
            })
        end,
    }
}
