local null_ls = require("null-ls")
local nvim_venv_path = os.getenv("PYENV_ROOT") .. "/versions/nvim-env"

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black.with({
            command = nvim_venv_path .. "/bin/black",
        }),
        null_ls.builtins.formatting.verible_verilog_format,
        null_ls.builtins.formatting.ocamlformat,
        -- null_ls.builtins.diagnostics.vint,
        null_ls.builtins.formatting.codespell,
        null_ls.builtins.formatting.isort,
        -- null_ls.builtins.formatting.shellharden,
        null_ls.builtins.formatting.prettierd.with({
            disabled_filetypes = { "jsonc" },
        }),
        null_ls.builtins.formatting.prettier.with({
            filetypes = { "jsonc" },
            extra_args = {
                "--trailing-comma", "none",
            },
        }),
        -- slang_diagnostics,
    },
})
