---@alias Variant "drowned" | "void" | "abyssal" | "lifted" | "void-lifted"
---@alias Palette { base: string, surface: string, overlay: string, _nc: string, border: string, highlight_low: string, highlight_med: string, highlight_high: string, ash: string, shroud: string, text: string, ichor: string, witchfire: string, siren: string, rift: string, aether: string, verdigris: string, umbra: string, blight: string }
---@alias PaletteColor "base" | "surface" | "overlay" | "border" | "ash" | "shroud" | "text" | "ichor" | "witchfire" | "siren" | "rift" | "aether" | "verdigris" | "umbra" | "blight" | "highlight_low" | "highlight_med" | "highlight_high"
---@alias Highlight { link: string, inherit: boolean } | { fg: string, bg: string, sp: string, bold: boolean, italic: boolean, undercurl: boolean, underline: boolean, underdouble: boolean, underdotted: boolean, underdashed: boolean, strikethrough: boolean, inherit: boolean }

local config = {}

---@class Options
config.options = {
	---Set the desired variant: "void" (violet, default), "drowned" (teal),
	---"abyssal" (blue), or the raised-floor LCD versions "lifted" (drowned)
	---and "void-lifted" (void). "auto" resolves to `dark_variant`.
	---@type "auto" | Variant
	variant = "auto",

	---Variant used when `options.variant` is "auto".
	---@type Variant
	dark_variant = "void",

	---Differentiate between active and inactive windows and panels.
	dim_inactive_windows = false,

	---Extend background behind borders. Appearance differs based on which
	---border characters you are using.
	extend_background_behind_borders = true,

	enable = {
		legacy_highlights = true,
		migrations = true,
		terminal = true,
	},

	styles = {
		bold = true,
		italic = false,
		transparency = false,
	},

	---@type table<string, table<string, string>>
	palette = {},

	---@type table<string, string | PaletteColor>
	groups = {
		border = "ash",
		link = "umbra",
		panel = "surface",

		error = "ichor",
		hint = "umbra",
		info = "aether",
		ok = "blight",
		warn = "witchfire",
		note = "rift",
		todo = "siren",

		git_add = "aether",
		git_change = "siren",
		git_delete = "ichor",
		git_dirty = "siren",
		git_ignore = "ash",
		git_merge = "umbra",
		git_rename = "rift",
		git_stage = "umbra",
		git_text = "siren",
		git_untracked = "shroud",

		---@type string | PaletteColor
		h1 = "umbra",
		h2 = "aether",
		h3 = "siren",
		h4 = "witchfire",
		h5 = "rift",
		h6 = "blight",

		---@deprecated Replaced by `options.highlight_groups["Normal"]`
		-- background = "base",
		---@deprecated Replaced by `options.highlight_groups["Comment"]`
		-- comment = "shroud",
		---@deprecated Replaced by `options.highlight_groups["@punctuation"]`
		-- punctuation = "ash",
		---@deprecated Expects a table with values h1...h6
		-- headings = "text",
	},

	---@type table<string, Highlight>
	highlight_groups = {},

	---Called before each highlight group, before setting the highlight.
	---@param group string
	---@param highlight Highlight
	---@param palette Palette
	---@diagnostic disable-next-line: unused-local
	before_highlight = function(group, highlight, palette) end,

	---@deprecated Replaced by `options.dim_inactive_windows`
	-- dim_nc_background = false,
	---@deprecated Replaced by `options.enable.transparency`
	-- disable_background = false,
	---@deprecated Replaced by `options.highlight_groups["NormalFloat"]`
	-- disable_float_background = false,
	---@deprecated Replaced by `options.styles.italic`
	-- disable_italics = false,
	---@deprecated Replaced by `options.highlight_groups`
	-- bold_vert_split = false
}

local function migrate(options)
	if options.bold_vert_split then
		local border = options.groups.border or "ash"
		options.highlight_groups["VertSplit"] = { fg = border, bg = border }
		options.highlight_groups["WinSeparator"] = { fg = border, bg = border }
	end

	if options.disable_background then
		options.highlight_groups["Normal"] = { bg = "NONE" }
	end

	if options.disable_float_background then
		options.highlight_groups["NormalFloat"] = { bg = "NONE" }
	end

	options.dim_inactive_windows = options.dim_nc_background or options.dim_inactive_windows

	if options.groups.background ~= nil then
		options.highlight_groups["Normal"] = { bg = options.groups.background }
	end

	if options.groups.comment ~= nil then
		options.highlight_groups["Comment"] = { fg = options.groups.comment }
	end

	if options.groups.punctuation ~= nil then
		options.highlight_groups["@punctuation"] = { fg = options.groups.punctuation }
	end

	options.styles.transparency = (options.disable_background and options.disable_float_background)
		or options.styles.transparency

	-- These never actually existed, but may be set intuitively by the user
	-- because of `disable_italics` existing.
	options.styles.bold = not (options.disable_bold or options.disable_bolds) and options.styles.bold or false

	-- Similar to bold options, `disable_italic` never existed but could be a
	-- common typo of the actual `disable_italics`.
	options.styles.italic = not (options.disable_italic or options.disable_italics) and options.styles.italic or false

	-- Set h1 through h6 to the same color if only one is specified
	if type(options.groups.headings) == "string" then
		options.groups.h1 = options.groups.headings
		options.groups.h2 = options.groups.headings
		options.groups.h3 = options.groups.headings
		options.groups.h4 = options.groups.headings
		options.groups.h5 = options.groups.headings
		options.groups.h6 = options.groups.headings
	elseif type(options.groups.headings) == "table" then
		options.groups.h1 = options.groups.headings.h1 or options.groups.h1
		options.groups.h2 = options.groups.headings.h2 or options.groups.h2
		options.groups.h3 = options.groups.headings.h3 or options.groups.h3
		options.groups.h4 = options.groups.headings.h4 or options.groups.h4
		options.groups.h5 = options.groups.headings.h5 or options.groups.h5
		options.groups.h6 = options.groups.headings.h6 or options.groups.h6
	end
	options.groups.headings = nil

	return options
end

---@param options Options | nil
function config.extend_options(options)
	config.options = vim.tbl_deep_extend("force", config.options, options or {})

	if config.options.enable.migrations then
		config.options = migrate(config.options)
	end
end

return config
