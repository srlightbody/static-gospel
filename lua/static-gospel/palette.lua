-- Static Gospel palette: shared cyberpunk accents over a selectable dark ramp.
-- Variants change ONLY the ramp (base/surface/overlay/_nc + highlight grays);
-- accents and neutrals are shared. Select with:
--   require("static-gospel").setup({ variant = "void" })  -- or abyssal / lifted
local config = require("static-gospel.config")

-- accents + neutrals, identical across every variant
local shared = {
	ash = "#6e7487",
	shroud = "#97a0b6",
	text = "#ebfafa",

	ichor = "#ff3860",
	witchfire = "#ffce54",
	siren = "#fa4fbc",
	rift = "#9d6bff",
	aether = "#04d1f9",
	verdigris = "#22e0c0",
	umbra = "#b48eff",
	blight = "#37f499",

	-- bright ANSI, used only by the embedded terminal
	b_white7 = "#e0def4",
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
		border = "#26233a",
	},
	-- drowned: smoky blue-teal — blade runner's rain-dark city, R'lyeh with the neon on
	drowned = {
		base = "#111a1e", surface = "#1a272d", overlay = "#23353d", _nc = "#0c1316",
		highlight_low = "#20262a", highlight_med = "#3e4750", highlight_high = "#505a64",
		border = "#293338",
	},
	-- abyssal: deep cosmic blue
	abyssal = {
		base = "#0a1020", surface = "#141b30", overlay = "#1f2942", _nc = "#070b18",
		highlight_low = "#1f2330", highlight_med = "#3a4358", highlight_high = "#4c576e",
		border = "#222a3a",
	},
	-- lifted: drowned teal with the floor raised ~5 L* and steps widened, so the
	-- depth survives on low-contrast LCD panels (laptops) instead of crushing to mud.
	lifted = {
		base = "#0c2126", surface = "#132d35", overlay = "#1a3a44", _nc = "#08171c",
		highlight_low = "#262d31", highlight_med = "#3e4750", highlight_high = "#505a65",
		border = "#26363d",
	},
	-- void-lifted: void's violet with the mid-tones on lifted's raised L* ladder
	-- (void C/H per role) but the floor only raised halfway- full lifted base felt
	-- washed on the laptop panel, and the deeper base widens the base->surface step.
	["void-lifted"] = {
		base = "#190a24", surface = "#292440", overlay = "#382e4e", _nc = "#12071c",
		highlight_low = "#2b2a38", highlight_med = "#464358", highlight_high = "#58556e",
		border = "#333048",
	},
}

local built = {}

-- Returns the merged palette for the configured variant. Memoized per variant
-- so the frequent parse_color() lookups don't rebuild it.
return function()
	local v = config.options.variant
	if v == "auto" then v = config.options.dark_variant end
	if not ramps[v] then v = "drowned" end
	if not built[v] then
		built[v] = vim.tbl_extend("force", {}, ramps[v], shared)
	end
	return built[v]
end
