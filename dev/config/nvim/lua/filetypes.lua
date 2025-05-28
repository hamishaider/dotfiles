vim.filetype.add({
    extension = {
        expect = "tcl",
    },
    pattern = {
        [".*%.expect"] = "tcl",
    },
})
