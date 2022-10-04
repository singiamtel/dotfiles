-- URL handling
vim.keymap.set("n", "gx", ':call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>')
