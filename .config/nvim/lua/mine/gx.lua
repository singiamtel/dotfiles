-- URL handling

if vim.loop.os_uname().sysname == "Darwin" then
	-- Mac doesn't follow freedesktop convention
	vim.keymap.set("n", "gx", ':call jobstart(["open", expand("<cfile>")], {"detach": v:true})<CR>')
else
	vim.keymap.set("n", "gx", ':call jobstart(["xdg-open", expand("<cfile>")], {"detach": v:true})<CR>')
end
