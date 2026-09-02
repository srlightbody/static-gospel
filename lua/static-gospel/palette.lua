-- Static Gospel palette: shared cyberpunk accents over a selectable dark ramp.
-- Variants change ONLY the ramp (base/surface/overlay/_nc + highlight grays);
-- accents and neutrals are shared. Select with:
--   require("static-gospel").setup({ variant = "void-lifted" })  -- void is the default
local config = require("static-gospel.config")

-- accents + neutrals, identical across every variant
local shared = {
	ash = "#6e7487",
	shroud = "#8992a8",
	text = "#f5f5ff",

	ichor = "#ff3860",
	witchfire = "#ffce54",
	siren = "#fa4fbc",
	rift = "#9d6bff",
	aether = "#04d1f9",
	verdigris = "#00c28f",
	ember = "#e87500",
	blight = "#37f499",
	cursor = "#37f499",

	-- bright ANSI, used only by the embedded terminal
	b_white7 = "#dbdcf2",
	b_red = "#ff5c78",
	b_green = "#69f8b3",
	b_yellow = "#ffe08a",
	b_blue = "#b892ff",
	b_magenta = "#ff86d4",
	b_cyan = "#66e4fd",

	none = "NONE",
}

-- per-variant dark ramp
local ramps = {
	-- void: near-black violet (default) — night city, the drowned lit up
	void = {
		base = "#130420", surface = "#17112b", overlay = "#241a38", _nc = "#0a0214",
		highlight_low = "#21202e", highlight_med = "#403d52", highlight_high = "#524f67",
		border = "#26233a", selection = "#4b3f58",
	},
	-- void-lifted: void's violet adapted to a basic laptop LCD, with raised mid-tones
	-- and wider steps. The floor rises only halfway so the base stays deep while the
	-- surface and overlay remain distinct on a lower-contrast panel.
	["void-lifted"] = {
		base = "#190a24", surface = "#261d38", overlay = "#382e4e", _nc = "#12071c",
		highlight_low = "#2b2a38", highlight_med = "#464358", highlight_high = "#58556e",
		border = "#333048", selection = "#4c3f58",
	},
}

local built = {}

-- Returns the merged palette for the configured variant. Memoized per variant
-- so the frequent parse_color() lookups don't rebuild it.
return function()
	local v = config.options.variant
	if v == "auto" then v = config.options.dark_variant end
	if not ramps[v] then v = "void" end
	if not built[v] then
		built[v] = vim.tbl_extend("force", {}, ramps[v], shared)
	end
	return built[v]
end
