local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.verible_verilog_format,
        null_ls.builtins.formatting.ocamlformat,
        -- null_ls.builtins.diagnostics.vint,
        null_ls.builtins.formatting.codespell,
        null_ls.builtins.formatting.isort,
        -- null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.prettierd,
        -- slang_diagnostics,
    },
})
