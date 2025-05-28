-- Configure diagnostic appearance
vim.diagnostic.config({
    -- Disable virtual text (no inline messages)
    virtual_text = false,

    -- Enable signs in gutter
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = '',
            [vim.diagnostic.severity.WARN] = '',
            [vim.diagnostic.severity.INFO] = '',
            [vim.diagnostic.severity.HINT] = '',
        },
    },

    -- Underline configuration
    underline = {
        severity = {
            min = vim.diagnostic.severity.WARN, -- Only underline warnings and errors
        },
        severity_limit = 'Warning',             -- Only underline warnings and errors
    },

    -- Floating window on hover
    float = {
        border = 'rounded',
        source = 'always',
        focusable = false,
        header = '',
        prefix = function(diagnostic)
            local icons = {
                [vim.diagnostic.severity.ERROR] = ' ',
                [vim.diagnostic.severity.WARN] = ' ',
                [vim.diagnostic.severity.INFO] = ' ',
                [vim.diagnostic.severity.HINT] = ' ',
            }
            return icons[diagnostic.severity] or ''
        end,
    },

    -- Update in insert mode
    update_in_insert = false,

    -- Sort by severity
    severity_sort = true,
})

-- Custom highlight groups for diagnostics
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = '#ff0000' })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = '#ffa500' })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = '#ffffff' })
vim.api.nvim_set_hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = '#add8e6' })

-- Show diagnostic float when cursor holds on line
vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
        vim.diagnostic.open_float(nil, {
            focusable = false,
            close_events = { 'CursorMoved', 'CursorMovedI', 'BufHidden', 'InsertCharPre' },
            border = 'rounded',
            source = 'always',
            prefix = ' ',
        })
    end
})

-- Optional: Jump to next/previous diagnostic with ]d and [d
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
