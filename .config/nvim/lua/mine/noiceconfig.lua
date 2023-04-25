require("noice").setup({
	routes = {
		{
			filter = {
				event = "msg_show",
				["not"] = {
					kind = { "confirm", "confirm_sub" },
				},
			},
			opts = { skip = true },
		},
	},
})
