local M = { plugins = {} }

local languages = {
	"lua",
	"cxx",
	"rust",
	"py",
	"shell",
	"nml",
	"asm",
	"doxygen",
	"markdown",
}

function M.setup()
	require "langs.config.lua".setup()
	for _, lang in ipairs(languages) do
		local mod = require("langs.config." .. lang)
		if mod.setup then
			mod.setup()
		end
	end
end

for _, lang in ipairs(languages) do
	local mod = require("langs.config." .. lang)
	M.plugins = vim.tbl_deep_extend("force", M.plugins, mod.plugins or {})
end

return M
