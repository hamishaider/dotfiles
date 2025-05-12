local nulls = require("null-ls")


nulls.setup({
    sources = {
        nulls.builtins.formatting.black,
        nulls.builtins.formatting.verible_verilog_format,
        nulls.builtins.formatting.ocamlformat,
        -- nulls.builtins.diagnostics.vint,
        nulls.builtins.formatting.codespell,
        nulls.builtins.formatting.isort,
        -- nulls.builtins.formatting.shellharden,
        nulls.builtins.formatting.prettierd,
    },
})
