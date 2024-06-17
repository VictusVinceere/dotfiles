require("lualine").setup({
	options = {
		icons_enabled = true,
		component_separators = "|",
		section_separators = "",
	},
	sections = {
		lualine_x = {
			{
				color = { fg = "#ff9e64" },
			},
		},
		lualine_a = {
			{
				"buffers",
			},
		},
	},
})
