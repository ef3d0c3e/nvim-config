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
	"fluent",
}

function M.setup()
	for _, lang in ipairs(languages) do
		local mod = require("langs.config." .. lang)
		if mod.setup then
			mod.setup()
		end
	end
end

for _, lang in ipairs(languages) do
	local mod = require("langs.config." .. lang)
	if mod.plugins and #mod.plugins > 0 then
		for _, plugin in pairs(mod.plugins) do
			M.plugins[#M.plugins + 1] = plugin
		end
	end
end

return M
