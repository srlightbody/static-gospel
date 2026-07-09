local M = {}
local config = require("static-gospel.config")

local function set_highlights()
	local utilities = require("static-gospel.utilities")
	local palette = require("static-gospel.palette")()
	local styles = config.options.styles

	local groups = {}
	for group, color in pairs(config.options.groups) do
		groups[group] = utilities.parse_color(color)
	end

	local function make_border(fg)
		fg = fg or groups.border
		return {
			fg = fg,
			bg = (config.options.extend_background_behind_borders and not styles.transparency) and palette.surface
				or "NONE",
		}
	end

	local highlights = {}
	local legacy_highlights = {
		["@attribute.diff"] = { fg = palette.witchfire },
		["@boolean"] = { link = "Boolean" },
		["@class"] = { fg = palette.verdigris },
		["@conditional"] = { link = "Conditional" },
		["@field"] = { fg = palette.verdigris },
		["@include"] = { link = "Include" },
		["@interface"] = { fg = palette.verdigris },
		["@macro"] = { link = "Macro" },
		["@method"] = { fg = palette.siren },
		["@namespace"] = { link = "Include" },
		["@number"] = { link = "Number" },
		["@parameter"] = { fg = palette.umbra, italic = styles.italic },
		["@preproc"] = { link = "PreProc" },
		["@punctuation"] = { fg = palette.shroud },
		["@punctuation.bracket"] = { link = "@punctuation" },
		["@punctuation.delimiter"] = { link = "@punctuation" },
		["@punctuation.special"] = { link = "@punctuation" },
		["@regexp"] = { link = "String" },
		["@repeat"] = { link = "Repeat" },
		["@storageclass"] = { link = "StorageClass" },
		["@symbol"] = { link = "Identifier" },
		["@text"] = { fg = palette.text },
		["@text.danger"] = { fg = groups.error },
		["@text.diff.add"] = { fg = groups.git_add, bg = groups.git_add, blend = 20 },
		["@text.diff.delete"] = { fg = groups.git_delete, bg = groups.git_delete, blend = 20 },
		["@text.emphasis"] = { italic = true },
		["@text.environment"] = { link = "Macro" },
		["@text.environment.name"] = { link = "Type" },
		["@text.math"] = { link = "Special" },
		["@text.note"] = { link = "SpecialComment" },
		["@text.strike"] = { strikethrough = true },
		["@text.strong"] = { bold = styles.bold },
		["@text.title"] = { link = "Title" },
		["@text.title.1.markdown"] = { link = "markdownH1" },
		["@text.title.1.marker.markdown"] = { link = "markdownH1Delimiter" },
		["@text.title.2.markdown"] = { link = "markdownH2" },
		["@text.title.2.marker.markdown"] = { link = "markdownH2Delimiter" },
		["@text.title.3.markdown"] = { link = "markdownH3" },
		["@text.title.3.marker.markdown"] = { link = "markdownH3Delimiter" },
		["@text.title.4.markdown"] = { link = "markdownH4" },
		["@text.title.4.marker.markdown"] = { link = "markdownH4Delimiter" },
		["@text.title.5.markdown"] = { link = "markdownH5" },
		["@text.title.5.marker.markdown"] = { link = "markdownH5Delimiter" },
		["@text.title.6.markdown"] = { link = "markdownH6" },
		["@text.title.6.marker.markdown"] = { link = "markdownH6Delimiter" },
		["@text.underline"] = { underline = true },
		["@text.uri"] = { fg = groups.link },
		["@text.warning"] = { fg = groups.warn },
		["@todo"] = { link = "Todo" },

		-- lukas-reineke/indent-blankline.nvim
		IndentBlanklineChar = { fg = palette.ash, nocombine = true },
		IndentBlanklineSpaceChar = { fg = palette.ash, nocombine = true },
		IndentBlanklineSpaceCharBlankline = { fg = palette.ash, nocombine = true },
	}
	local default_highlights = {
		ColorColumn = { bg = palette.surface },
		Conceal = { bg = "NONE" },
		CurSearch = { fg = palette.base, bg = palette.witchfire },
		Cursor = { fg = palette.base, bg = palette.blight },
		CursorColumn = { bg = palette.overlay },
		-- CursorIM = {},
		CursorLine = { bg = palette.overlay },
		CursorLineNr = { fg = palette.siren, bold = styles.bold },
		-- DarkenedPanel = { },
		-- DarkenedStatusline = {},
		DiffAdd = { bg = groups.git_add, blend = 20 },
		DiffChange = { bg = groups.git_change, blend = 20 },
		DiffDelete = { bg = groups.git_delete, blend = 20 },
		DiffText = { bg = groups.git_text, blend = 40 },
		diffAdded = { link = "DiffAdd" },
		diffChanged = { link = "DiffChange" },
		diffRemoved = { link = "DiffDelete" },
		Directory = { fg = palette.aether, bold = styles.bold },
		-- EndOfBuffer = {},
		ErrorMsg = { fg = groups.error, bold = styles.bold },
		FloatBorder = make_border(),
		FloatTitle = { fg = palette.aether, bg = groups.panel, bold = styles.bold },
		FoldColumn = { fg = palette.ash },
		Folded = { fg = palette.text, bg = groups.panel },
		IncSearch = { link = "CurSearch" },
		LineNr = { fg = palette.ash },
		MatchParen = { fg = palette.aether, bg = palette.aether, blend = 30 },
		ModeMsg = { fg = palette.shroud },
		MoreMsg = { fg = palette.umbra },
		NonText = { fg = palette.ash },
		Normal = { fg = palette.text, bg = palette.base },
		NormalFloat = { bg = groups.panel },
		NormalNC = { fg = palette.text, bg = config.options.dim_inactive_windows and palette._nc or palette.base },
		NvimInternalError = { link = "ErrorMsg" },
		Pmenu = { fg = palette.shroud, bg = groups.panel },
		PmenuExtra = { fg = palette.ash, bg = groups.panel },
		PmenuExtraSel = { fg = palette.shroud, bg = palette.overlay },
		PmenuKind = { fg = palette.aether, bg = groups.panel },
		PmenuKindSel = { fg = palette.shroud, bg = palette.overlay },
		PmenuSbar = { bg = groups.panel },
		PmenuSel = { fg = palette.text, bg = palette.overlay },
		PmenuThumb = { bg = palette.ash },
		Question = { fg = palette.witchfire },
		QuickFixLine = { fg = palette.aether },
		-- RedrawDebugNormal = {},
		RedrawDebugClear = { fg = palette.base, bg = palette.witchfire },
		RedrawDebugComposed = { fg = palette.base, bg = palette.rift },
		RedrawDebugRecompose = { fg = palette.base, bg = palette.ichor },
		Search = { fg = palette.text, bg = palette.witchfire, blend = 35 },
		SignColumn = { fg = palette.text, bg = "NONE" },
		SpecialKey = { fg = palette.verdigris },
		SpellBad = { sp = palette.shroud, undercurl = true },
		SpellCap = { sp = palette.shroud, undercurl = true },
		SpellLocal = { sp = palette.shroud, undercurl = true },
		SpellRare = { sp = palette.shroud, undercurl = true },
		StatusLine = { fg = palette.shroud, bg = groups.panel },
		StatusLineNC = { fg = palette.ash, bg = groups.panel, blend = 60 },
		StatusLineTerm = { fg = palette.base, bg = palette.rift },
		StatusLineTermNC = { fg = palette.base, bg = palette.rift, blend = 60 },
		Substitute = { link = "IncSearch" },
		TabLine = { fg = palette.shroud, bg = groups.panel },
		TabLineFill = { bg = groups.panel },
		TabLineSel = { fg = palette.text, bg = palette.overlay, bold = styles.bold },
		Title = { fg = palette.aether, bold = styles.bold },
		VertSplit = { fg = groups.border },
		Visual = { bg = palette.umbra, blend = 55 },
		-- VisualNOS = {},
		WarningMsg = { fg = groups.warn, bold = styles.bold },
		-- Whitespace = {},
		WildMenu = { link = "IncSearch" },
		WinBar = { fg = palette.shroud, bg = groups.panel },
		WinBarNC = { fg = palette.ash, bg = groups.panel, blend = 60 },
		WinSeparator = { fg = groups.border },

		DiagnosticError = { fg = groups.error },
		DiagnosticHint = { fg = groups.hint },
		DiagnosticInfo = { fg = groups.info },
		DiagnosticOk = { fg = groups.ok },
		DiagnosticWarn = { fg = groups.warn },
		DiagnosticDefaultError = { link = "DiagnosticError" },
		DiagnosticDefaultHint = { link = "DiagnosticHint" },
		DiagnosticDefaultInfo = { link = "DiagnosticInfo" },
		DiagnosticDefaultOk = { link = "DiagnosticOk" },
		DiagnosticDefaultWarn = { link = "DiagnosticWarn" },
		DiagnosticFloatingError = { link = "DiagnosticError" },
		DiagnosticFloatingHint = { link = "DiagnosticHint" },
		DiagnosticFloatingInfo = { link = "DiagnosticInfo" },
		DiagnosticFloatingOk = { link = "DiagnosticOk" },
		DiagnosticFloatingWarn = { link = "DiagnosticWarn" },
		DiagnosticSignError = { link = "DiagnosticError" },
		DiagnosticSignHint = { link = "DiagnosticHint" },
		DiagnosticSignInfo = { link = "DiagnosticInfo" },
		DiagnosticSignOk = { link = "DiagnosticOk" },
		DiagnosticSignWarn = { link = "DiagnosticWarn" },
		DiagnosticUnderlineError = { sp = groups.error, undercurl = true },
		DiagnosticUnderlineHint = { sp = groups.hint, undercurl = true },
		DiagnosticUnderlineInfo = { sp = groups.info, undercurl = true },
		DiagnosticUnderlineOk = { sp = groups.ok, undercurl = true },
		DiagnosticUnderlineWarn = { sp = groups.warn, undercurl = true },
		DiagnosticVirtualTextError = { fg = groups.error, bg = groups.error, blend = 10 },
		DiagnosticVirtualTextHint = { fg = groups.hint, bg = groups.hint, blend = 10 },
		DiagnosticVirtualTextInfo = { fg = groups.info, bg = groups.info, blend = 10 },
		DiagnosticVirtualTextOk = { fg = groups.ok, bg = groups.ok, blend = 10 },
		DiagnosticVirtualTextWarn = { fg = groups.warn, bg = groups.warn, blend = 10 },

		Boolean = { fg = palette.siren },
		Character = { fg = palette.witchfire },
		Comment = { fg = palette.shroud, italic = styles.italic },
		Conditional = { fg = palette.rift },
		Constant = { fg = palette.witchfire },
		Debug = { fg = palette.siren },
		Define = { fg = palette.umbra },
		Delimiter = { fg = palette.shroud },
		Error = { fg = palette.ichor },
		Exception = { fg = palette.rift },
		Float = { fg = palette.witchfire },
		Function = { fg = palette.siren },
		Identifier = { fg = palette.text },
		Include = { fg = palette.rift },
		Keyword = { fg = palette.rift },
		Label = { fg = palette.verdigris },
		LspCodeLens = { fg = palette.shroud },
		LspCodeLensSeparator = { fg = palette.ash },
		LspInlayHint = { fg = palette.ash, bg = palette.ash, blend = 10 },
		LspReferenceRead = { bg = palette.highlight_med },
		LspReferenceText = { bg = palette.highlight_med },
		LspReferenceWrite = { bg = palette.highlight_med },
		Macro = { fg = palette.umbra },
		Number = { fg = palette.witchfire },
		Operator = { fg = palette.shroud },
		PreCondit = { fg = palette.umbra },
		PreProc = { link = "PreCondit" },
		Repeat = { fg = palette.rift },
		Special = { fg = palette.verdigris },
		SpecialChar = { link = "Special" },
		SpecialComment = { fg = palette.umbra },
		Statement = { fg = palette.rift, bold = styles.bold },
		StorageClass = { fg = palette.verdigris },
		String = { fg = palette.witchfire },
		Structure = { fg = palette.verdigris },
		Tag = { fg = palette.verdigris },
		Todo = { fg = palette.siren, bg = palette.siren, blend = 20 },
		Type = { fg = palette.verdigris },
		TypeDef = { link = "Type" },
		Underlined = { fg = palette.umbra, underline = true },
		Added = { fg = groups.git_add },
		Changed = { fg = groups.git_change },
		Removed = { fg = groups.git_delete },

		healthError = { fg = groups.error },
		healthSuccess = { fg = groups.info },
		healthWarning = { fg = groups.warn },

		htmlArg = { fg = palette.umbra },
		htmlBold = { bold = styles.bold },
		htmlEndTag = { fg = palette.shroud },
		htmlH1 = { link = "markdownH1" },
		htmlH2 = { link = "markdownH2" },
		htmlH3 = { link = "markdownH3" },
		htmlH4 = { link = "markdownH4" },
		htmlH5 = { link = "markdownH5" },
		htmlItalic = { italic = true },
		htmlLink = { link = "markdownUrl" },
		htmlTag = { fg = palette.shroud },
		htmlTagN = { fg = palette.text },
		htmlTagName = { fg = palette.verdigris },

		markdownDelimiter = { fg = palette.shroud },
		markdownH1 = { fg = groups.h1, bold = styles.bold },
		markdownH1Delimiter = { link = "markdownH1" },
		markdownH2 = { fg = groups.h2, bold = styles.bold },
		markdownH2Delimiter = { link = "markdownH2" },
		markdownH3 = { fg = groups.h3, bold = styles.bold },
		markdownH3Delimiter = { link = "markdownH3" },
		markdownH4 = { fg = groups.h4, bold = styles.bold },
		markdownH4Delimiter = { link = "markdownH4" },
		markdownH5 = { fg = groups.h5, bold = styles.bold },
		markdownH5Delimiter = { link = "markdownH5" },
		markdownH6 = { fg = groups.h6, bold = styles.bold },
		markdownH6Delimiter = { link = "markdownH6" },
		markdownLinkText = { link = "markdownUrl" },
		markdownUrl = { fg = groups.link, sp = groups.link, underline = true },

		mkdCode = { fg = palette.aether, italic = styles.italic },
		mkdCodeDelimiter = { fg = palette.siren },
		mkdCodeEnd = { fg = palette.aether },
		mkdCodeStart = { fg = palette.aether },
		mkdFootnotes = { fg = palette.aether },
		mkdID = { fg = palette.aether, underline = true },
		mkdInlineURL = { link = "markdownUrl" },
		mkdLink = { link = "markdownUrl" },
		mkdLinkDef = { link = "markdownUrl" },
		mkdListItemLine = { fg = palette.text },
		mkdRule = { fg = palette.shroud },
		mkdURL = { link = "markdownUrl" },

		--- Treesitter
		--- |:help treesitter-highlight-groups|
		["@variable"] = { fg = palette.text, italic = styles.italic },
		["@variable.builtin"] = { fg = palette.ichor, italic = styles.italic, bold = styles.bold },
		["@variable.parameter"] = { fg = palette.umbra, italic = styles.italic },
		["@variable.parameter.builtin"] = { fg = palette.umbra, italic = styles.italic, bold = styles.bold },
		["@variable.member"] = { fg = palette.verdigris },

		["@constant"] = { fg = palette.witchfire },
		["@constant.builtin"] = { fg = palette.witchfire, bold = styles.bold },
		["@constant.macro"] = { fg = palette.witchfire },

		["@module"] = { fg = palette.text },
		["@module.builtin"] = { fg = palette.text, bold = styles.bold },
		["@label"] = { link = "Label" },

		["@string"] = { link = "String" },
		-- ["@string.documentation"] = {},
		["@string.regexp"] = { fg = palette.umbra },
		["@string.escape"] = { fg = palette.rift },
		["@string.special"] = { link = "String" },
		["@string.special.symbol"] = { link = "Identifier" },
		["@string.special.url"] = { fg = groups.link },
		-- ["@string.special.path"] = {},

		["@character"] = { link = "Character" },
		["@character.special"] = { link = "Character" },

		["@boolean"] = { link = "Boolean" },
		["@number"] = { link = "Number" },
		["@number.float"] = { link = "Number" },
		["@float"] = { link = "Number" },

		["@type"] = { fg = palette.verdigris },
		["@type.builtin"] = { fg = palette.verdigris, bold = styles.bold },
		-- ["@type.definition"] = {},

		["@attribute"] = { fg = palette.umbra },
		["@attribute.builtin"] = { fg = palette.umbra, bold = styles.bold },
		["@property"] = { fg = palette.verdigris, italic = styles.italic },

		["@function"] = { fg = palette.siren },
		["@function.builtin"] = { fg = palette.siren, bold = styles.bold },
		-- ["@function.call"] = {},
		["@function.macro"] = { link = "Function" },

		["@function.method"] = { fg = palette.siren },
		["@function.method.call"] = { fg = palette.umbra },

		["@constructor"] = { fg = palette.verdigris },
		["@operator"] = { link = "Operator" },

		["@keyword"] = { link = "Keyword" },
		-- ["@keyword.coroutine"] = {},
		-- ["@keyword.function"] = {},
		["@keyword.operator"] = { fg = palette.shroud },
		["@keyword.import"] = { fg = palette.rift },
		["@keyword.storage"] = { fg = palette.verdigris },
		["@keyword.repeat"] = { fg = palette.rift },
		["@keyword.return"] = { fg = palette.rift },
		["@keyword.debug"] = { fg = palette.siren },
		["@keyword.exception"] = { fg = palette.rift },

		["@keyword.conditional"] = { fg = palette.rift },
		["@keyword.conditional.ternary"] = { fg = palette.rift },

		["@keyword.directive"] = { fg = palette.umbra },
		["@keyword.directive.define"] = { fg = palette.umbra },

		--- Punctuation
		["@punctuation.delimiter"] = { fg = palette.shroud },
		["@punctuation.bracket"] = { fg = palette.shroud },
		["@punctuation.special"] = { fg = palette.shroud },

		--- Comments
		["@comment"] = { link = "Comment" },
		-- ["@comment.documentation"] = {},

		["@comment.error"] = { fg = groups.error },
		["@comment.warning"] = { fg = groups.warn },
		["@comment.todo"] = { fg = groups.todo, bg = groups.todo, blend = 15 },
		["@comment.hint"] = { fg = groups.hint, bg = groups.hint, blend = 15 },
		["@comment.info"] = { fg = groups.info, bg = groups.info, blend = 15 },
		["@comment.note"] = { fg = groups.note, bg = groups.note, blend = 15 },

		--- Markup
		["@markup.strong"] = { bold = styles.bold },
		["@markup.italic"] = { italic = true },
		["@markup.strikethrough"] = { strikethrough = true },
		["@markup.underline"] = { underline = true },

		["@markup.heading"] = { fg = palette.aether, bold = styles.bold },

		["@markup.quote"] = { fg = palette.text },
		["@markup.math"] = { link = "Special" },
		["@markup.environment"] = { link = "Macro" },
		["@markup.environment.name"] = { link = "@type" },

		-- ["@markup.link"] = {},
		["@markup.link.markdown_inline"] = { fg = palette.shroud },
		["@markup.link.label.markdown_inline"] = { fg = palette.aether },
		["@markup.link.url"] = { fg = groups.link },

		-- ["@markup.raw"] = { bg = palette.surface },
		-- ["@markup.raw.block"] = { bg = palette.surface },
		["@markup.raw.delimiter.markdown"] = { fg = palette.shroud },

		["@markup.list"] = { fg = palette.rift },
		["@markup.list.checked"] = { fg = palette.aether, bg = palette.aether, blend = 10 },
		["@markup.list.unchecked"] = { fg = palette.text },

		-- Markdown headings
		["@markup.heading.1.markdown"] = { link = "markdownH1" },
		["@markup.heading.2.markdown"] = { link = "markdownH2" },
		["@markup.heading.3.markdown"] = { link = "markdownH3" },
		["@markup.heading.4.markdown"] = { link = "markdownH4" },
		["@markup.heading.5.markdown"] = { link = "markdownH5" },
		["@markup.heading.6.markdown"] = { link = "markdownH6" },
		["@markup.heading.1.marker.markdown"] = { link = "markdownH1Delimiter" },
		["@markup.heading.2.marker.markdown"] = { link = "markdownH2Delimiter" },
		["@markup.heading.3.marker.markdown"] = { link = "markdownH3Delimiter" },
		["@markup.heading.4.marker.markdown"] = { link = "markdownH4Delimiter" },
		["@markup.heading.5.marker.markdown"] = { link = "markdownH5Delimiter" },
		["@markup.heading.6.marker.markdown"] = { link = "markdownH6Delimiter" },

		["@diff.plus"] = { fg = groups.git_add, bg = groups.git_add, blend = 20 },
		["@diff.minus"] = { fg = groups.git_delete, bg = groups.git_delete, blend = 20 },
		["@diff.delta"] = { bg = groups.git_change, blend = 20 },

		["@tag"] = { link = "Tag" },
		["@tag.attribute"] = { fg = palette.umbra },
		["@tag.delimiter"] = { fg = palette.shroud },

		--- Non-highlighting captures
		-- ["@none"] = {},
		["@conceal"] = { link = "Conceal" },
		["@conceal.markdown"] = { fg = palette.shroud },

		-- ["@spell"] = {},
		-- ["@nospell"] = {},

		--- Semantic
		["@lsp.type.comment"] = {},
		["@lsp.type.comment.c"] = { link = "@comment" },
		["@lsp.type.comment.cpp"] = { link = "@comment" },
		["@lsp.type.enum"] = { link = "@type" },
		["@lsp.type.interface"] = { link = "@interface" },
		["@lsp.type.keyword"] = { link = "@keyword" },
		["@lsp.type.namespace"] = { link = "@namespace" },
		["@lsp.type.namespace.python"] = { link = "@variable" },
		["@lsp.type.parameter"] = { link = "@parameter" },
		["@lsp.type.property"] = { link = "@property" },
		["@lsp.type.variable"] = {}, -- defer to treesitter for regular variables
		["@lsp.type.variable.svelte"] = { link = "@variable" },
		["@lsp.typemod.function.defaultLibrary"] = { link = "@function.builtin" },
		["@lsp.typemod.operator.injected"] = { link = "@operator" },
		["@lsp.typemod.string.injected"] = { link = "@string" },
		["@lsp.typemod.variable.constant"] = { link = "@constant" },
		["@lsp.typemod.variable.defaultLibrary"] = { link = "@variable.builtin" },
		["@lsp.typemod.variable.injected"] = { link = "@variable" },

		--- Plugins
		-- romgrk/barbar.nvim
		BufferCurrent = { fg = palette.text, bg = palette.overlay },
		BufferCurrentIndex = { fg = palette.text, bg = palette.overlay },
		BufferCurrentMod = { fg = palette.aether, bg = palette.overlay },
		BufferCurrentSign = { fg = palette.shroud, bg = palette.overlay },
		BufferCurrentTarget = { fg = palette.witchfire, bg = palette.overlay },
		BufferInactive = { fg = palette.shroud },
		BufferInactiveIndex = { fg = palette.shroud },
		BufferInactiveMod = { fg = palette.aether },
		BufferInactiveSign = { fg = palette.ash },
		BufferInactiveTarget = { fg = palette.witchfire },
		BufferTabpageFill = { fg = "NONE", bg = "NONE" },
		BufferVisible = { fg = palette.shroud },
		BufferVisibleIndex = { fg = palette.shroud },
		BufferVisibleMod = { fg = palette.aether },
		BufferVisibleSign = { fg = palette.ash },
		BufferVisibleTarget = { fg = palette.witchfire },

		-- lewis6991/gitsigns.nvim
		GitSignsAdd = { fg = groups.git_add, bg = "NONE" },
		GitSignsChange = { fg = groups.git_change, bg = "NONE" },
		GitSignsDelete = { fg = groups.git_delete, bg = "NONE" },
		SignAdd = { fg = groups.git_add, bg = "NONE" },
		SignChange = { fg = groups.git_change, bg = "NONE" },
		SignDelete = { fg = groups.git_delete, bg = "NONE" },

		-- mvllow/modes.nvim
		ModesCopy = { bg = palette.witchfire },
		ModesDelete = { bg = palette.ichor },
		ModesFormat = { bg = palette.siren },
		ModesInsert = { bg = palette.aether },
		ModesReplace = { bg = palette.rift },
		ModesVisual = { bg = palette.umbra },

		-- kyazdani42/nvim-tree.lua
		NvimTreeEmptyFolderName = { fg = palette.ash },
		NvimTreeFileDeleted = { fg = groups.git_delete },
		NvimTreeFileDirty = { fg = groups.git_dirty },
		NvimTreeFileMerge = { fg = groups.git_merge },
		NvimTreeFileNew = { fg = palette.aether },
		NvimTreeFileRenamed = { fg = groups.git_rename },
		NvimTreeFileStaged = { fg = groups.git_stage },
		NvimTreeFolderIcon = { fg = palette.shroud },
		NvimTreeFolderName = { fg = palette.aether },
		NvimTreeGitDeleted = { fg = groups.git_delete },
		NvimTreeGitDirty = { fg = groups.git_dirty },
		NvimTreeGitIgnored = { fg = groups.git_ignore },
		NvimTreeGitMerge = { fg = groups.git_merge },
		NvimTreeGitNew = { fg = groups.git_add },
		NvimTreeGitRenamed = { fg = groups.git_rename },
		NvimTreeGitStaged = { fg = groups.git_stage },
		NvimTreeImageFile = { fg = palette.text },
		NvimTreeNormal = { link = "Normal" },
		NvimTreeOpenedFile = { fg = palette.text, bg = palette.overlay },
		NvimTreeOpenedFolderName = { link = "NvimTreeFolderName" },
		NvimTreeRootFolder = { fg = palette.aether, bold = styles.bold },
		NvimTreeSpecialFile = { link = "NvimTreeNormal" },
		NvimTreeWindowPicker = { link = "StatusLineTerm" },

		-- nvim-neotest/neotest
		NeotestAdapterName = { fg = palette.umbra },
		NeotestBorder = { fg = palette.highlight_med },
		NeotestDir = { fg = palette.aether },
		NeotestExpandMarker = { fg = palette.highlight_med },
		NeotestFailed = { fg = palette.ichor },
		NeotestFile = { fg = palette.text },
		NeotestFocused = { fg = palette.witchfire, bg = palette.highlight_med },
		NeotestIndent = { fg = palette.highlight_med },
		NeotestMarked = { fg = palette.siren, bold = styles.bold },
		NeotestNamespace = { fg = palette.witchfire },
		NeotestPassed = { fg = palette.rift },
		NeotestRunning = { fg = palette.witchfire },
		NeotestWinSelect = { fg = palette.ash },
		NeotestSkipped = { fg = palette.shroud },
		NeotestTarget = { fg = palette.ichor },
		NeotestTest = { fg = palette.witchfire },
		NeotestUnknown = { fg = palette.shroud },
		NeotestWatching = { fg = palette.umbra },

		-- nvim-neo-tree/neo-tree.nvim
		NeoTreeGitAdded = { fg = groups.git_add },
		NeoTreeGitConflict = { fg = groups.git_merge },
		NeoTreeGitDeleted = { fg = groups.git_delete },
		NeoTreeGitIgnored = { fg = groups.git_ignore },
		NeoTreeGitModified = { fg = groups.git_dirty },
		NeoTreeGitRenamed = { fg = groups.git_rename },
		NeoTreeGitUntracked = { fg = groups.git_untracked },
		NeoTreeTabActive = { fg = palette.text, bg = palette.overlay },
		NeoTreeTabInactive = { fg = palette.shroud },
		NeoTreeTabSeparatorActive = { link = "WinSeparator" },
		NeoTreeTabSeparatorInactive = { link = "WinSeparator" },
		NeoTreeTitleBar = { link = "StatusLineTerm" },

		-- folke/flash.nvim
		FlashLabel = { fg = palette.base, bg = palette.ichor },

		-- folke/which-key.nvim
		WhichKey = { fg = palette.umbra },
		WhichKeyBorder = make_border(),
		WhichKeyDesc = { fg = palette.witchfire },
		WhichKeyFloat = { bg = groups.panel },
		WhichKeyGroup = { fg = palette.aether },
		WhichKeyIcon = { fg = palette.rift },
		WhichKeyIconAzure = { fg = palette.rift },
		WhichKeyIconBlue = { fg = palette.rift },
		WhichKeyIconCyan = { fg = palette.aether },
		WhichKeyIconGreen = { fg = palette.blight },
		WhichKeyIconGrey = { fg = palette.shroud },
		WhichKeyIconOrange = { fg = palette.siren },
		WhichKeyIconPurple = { fg = palette.umbra },
		WhichKeyIconRed = { fg = palette.ichor },
		WhichKeyIconYellow = { fg = palette.witchfire },
		WhichKeyNormal = { link = "NormalFloat" },
		WhichKeySeparator = { fg = palette.shroud },
		WhichKeyTitle = { link = "FloatTitle" },
		WhichKeyValue = { fg = palette.siren },

		-- lukas-reineke/indent-blankline.nvim
		IblIndent = { fg = palette.overlay },
		IblScope = { fg = palette.aether },
		IblWhitespace = { fg = palette.overlay },

		-- hrsh7th/nvim-cmp
		CmpItemAbbr = { fg = palette.shroud },
		CmpItemAbbrDeprecated = { fg = palette.shroud, strikethrough = true },
		CmpItemAbbrMatch = { fg = palette.text, bold = styles.bold },
		CmpItemAbbrMatchFuzzy = { fg = palette.text, bold = styles.bold },
		CmpItemKind = { fg = palette.shroud },
		CmpItemKindClass = { link = "StorageClass" },
		CmpItemKindFunction = { link = "Function" },
		CmpItemKindInterface = { link = "Type" },
		CmpItemKindMethod = { link = "PreProc" },
		CmpItemKindSnippet = { link = "String" },
		CmpItemKindVariable = { link = "Identifier" },

		-- NeogitOrg/neogit
		-- https://github.com/NeogitOrg/neogit/blob/master/lua/neogit/lib/hl.lua#L109-L198
		NeogitChangeAdded = { fg = groups.git_add, bold = styles.bold, italic = styles.italic },
		NeogitChangeBothModified = { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
		NeogitChangeCopied = { fg = groups.git_untracked, bold = styles.bold, italic = styles.italic },
		NeogitChangeDeleted = { fg = groups.git_delete, bold = styles.bold, italic = styles.italic },
		NeogitChangeModified = { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
		NeogitChangeNewFile = { fg = groups.git_stage, bold = styles.bold, italic = styles.italic },
		NeogitChangeRenamed = { fg = groups.git_rename, bold = styles.bold, italic = styles.italic },
		NeogitChangeUpdated = { fg = groups.git_change, bold = styles.bold, italic = styles.italic },
		NeogitDiffAddHighlight = { link = "DiffAdd" },
		NeogitDiffContextHighlight = { bg = palette.surface },
		NeogitDiffDeleteHighlight = { link = "DiffDelete" },
		NeogitFilePath = { fg = palette.aether, italic = styles.italic },
		NeogitHunkHeader = { bg = groups.panel },
		NeogitHunkHeaderHighlight = { bg = groups.panel },

		-- vimwiki/vimwiki
		VimwikiHR = { fg = palette.shroud },
		VimwikiHeader1 = { link = "markdownH1" },
		VimwikiHeader2 = { link = "markdownH2" },
		VimwikiHeader3 = { link = "markdownH3" },
		VimwikiHeader4 = { link = "markdownH4" },
		VimwikiHeader5 = { link = "markdownH5" },
		VimwikiHeader6 = { link = "markdownH6" },
		VimwikiHeaderChar = { fg = palette.shroud },
		VimwikiLink = { link = "markdownUrl" },
		VimwikiList = { fg = palette.umbra },
		VimwikiNoExistsLink = { fg = palette.ichor },

		-- nvim-neorg/neorg
		NeorgHeading1Prefix = { link = "markdownH1Delimiter" },
		NeorgHeading1Title = { link = "markdownH1" },
		NeorgHeading2Prefix = { link = "markdownH2Delimiter" },
		NeorgHeading2Title = { link = "markdownH2" },
		NeorgHeading3Prefix = { link = "markdownH3Delimiter" },
		NeorgHeading3Title = { link = "markdownH3" },
		NeorgHeading4Prefix = { link = "markdownH4Delimiter" },
		NeorgHeading4Title = { link = "markdownH4" },
		NeorgHeading5Prefix = { link = "markdownH5Delimiter" },
		NeorgHeading5Title = { link = "markdownH5" },
		NeorgHeading6Prefix = { link = "markdownH6Delimiter" },
		NeorgHeading6Title = { link = "markdownH6" },
		NeorgMarkerTitle = { fg = palette.aether, bold = styles.bold },

		-- tami5/lspsaga.nvim (fork of glepnir/lspsaga.nvim)
		DefinitionCount = { fg = palette.siren },
		DefinitionIcon = { fg = palette.siren },
		DefinitionPreviewTitle = { fg = palette.siren, bold = styles.bold },
		LspFloatWinBorder = make_border(),
		LspFloatWinNormal = { bg = groups.panel },
		LspSagaAutoPreview = { fg = palette.shroud },
		LspSagaCodeActionBorder = make_border(palette.siren),
		LspSagaCodeActionContent = { fg = palette.aether },
		LspSagaCodeActionTitle = { fg = palette.witchfire, bold = styles.bold },
		LspSagaCodeActionTruncateLine = { link = "LspSagaCodeActionBorder" },
		LspSagaDefPreviewBorder = make_border(),
		LspSagaDiagnosticBorder = make_border(palette.witchfire),
		LspSagaDiagnosticHeader = { fg = palette.aether, bold = styles.bold },
		LspSagaDiagnosticTruncateLine = { link = "LspSagaDiagnosticBorder" },
		LspSagaDocTruncateLine = { link = "LspSagaHoverBorder" },
		LspSagaFinderSelection = { fg = palette.witchfire },
		LspSagaHoverBorder = { link = "LspFloatWinBorder" },
		LspSagaLspFinderBorder = { link = "LspFloatWinBorder" },
		LspSagaRenameBorder = make_border(palette.rift),
		LspSagaRenamePromptPrefix = { fg = palette.ichor },
		LspSagaShTruncateLine = { link = "LspSagaSignatureHelpBorder" },
		LspSagaSignatureHelpBorder = make_border(palette.aether),
		ReferencesCount = { fg = palette.siren },
		ReferencesIcon = { fg = palette.siren },
		SagaShadow = { bg = palette.overlay },
		TargetWord = { fg = palette.umbra },

		-- ray-x/lsp_signature.nvim
		LspSignatureActiveParameter = { bg = palette.overlay },

		-- rlane/pounce.nvim
		PounceAccept = { fg = palette.ichor, bg = palette.ichor, blend = 20 },
		PounceAcceptBest = { fg = palette.witchfire, bg = palette.witchfire, blend = 20 },
		PounceGap = { link = "Search" },
		PounceMatch = { link = "Search" },

		-- ggandor/leap.nvim
		LeapLabelPrimary = { link = "IncSearch" },
		LeapLabelSecondary = { link = "StatusLineTerm" },
		LeapMatch = { link = "MatchParen" },

		-- phaazon/hop.nvim
		-- smoka7/hop.nvim
		HopNextKey = { fg = palette.ichor, bg = palette.ichor, blend = 20 },
		HopNextKey1 = { fg = palette.aether, bg = palette.aether, blend = 20 },
		HopNextKey2 = { fg = palette.rift, bg = palette.rift, blend = 20 },
		HopUnmatched = { fg = palette.ash },

		-- nvim-telescope/telescope.nvim
		TelescopeBorder = make_border(),
		TelescopeMatching = { fg = palette.siren },
		TelescopeNormal = { link = "NormalFloat" },
		TelescopePromptNormal = { link = "TelescopeNormal" },
		TelescopePromptPrefix = { fg = palette.shroud },
		TelescopeSelection = { fg = palette.text, bg = palette.overlay },
		TelescopeSelectionCaret = { fg = palette.siren, bg = palette.overlay },
		TelescopeTitle = { fg = palette.aether, bold = styles.bold },

		-- ibhagwan/fzf-lua
		FzfLuaBorder = make_border(),
		FzfLuaBufFlagAlt = { fg = palette.shroud },
		FzfLuaBufFlagCur = { fg = palette.shroud },
		FzfLuaCursorLine = { fg = palette.text, bg = palette.overlay },
		FzfLuaFilePart = { fg = palette.text },
		FzfLuaHeaderBind = { fg = palette.siren },
		FzfLuaHeaderText = { fg = palette.ichor },
		FzfLuaNormal = { link = "NormalFloat" },
		FzfLuaTitle = { link = "FloatTitle" },

		-- rcarriga/nvim-notify
		NotifyBackground = { link = "NormalFloat" },
		NotifyDEBUGBody = { link = "NormalFloat" },
		NotifyDEBUGBorder = make_border(),
		NotifyDEBUGIcon = { link = "NotifyDEBUGTitle" },
		NotifyDEBUGTitle = { fg = palette.ash },
		NotifyERRORBody = { link = "NormalFloat" },
		NotifyERRORBorder = make_border(groups.error),
		NotifyERRORIcon = { link = "NotifyERRORTitle" },
		NotifyERRORTitle = { fg = groups.error },
		NotifyINFOBody = { link = "NormalFloat" },
		NotifyINFOBorder = make_border(groups.info),
		NotifyINFOIcon = { link = "NotifyINFOTitle" },
		NotifyINFOTitle = { fg = groups.info },
		NotifyTRACEBody = { link = "NormalFloat" },
		NotifyTRACEBorder = make_border(palette.umbra),
		NotifyTRACEIcon = { link = "NotifyTRACETitle" },
		NotifyTRACETitle = { fg = palette.umbra },
		NotifyWARNBody = { link = "NormalFloat" },
		NotifyWARNBorder = make_border(groups.warn),
		NotifyWARNIcon = { link = "NotifyWARNTitle" },
		NotifyWARNTitle = { fg = groups.warn },

		-- rcarriga/nvim-dap-ui
		DapUIBreakpointsCurrentLine = { fg = palette.witchfire, bold = styles.bold },
		DapUIBreakpointsDisabledLine = { fg = palette.ash },
		DapUIBreakpointsInfo = { link = "DapUIThread" },
		DapUIBreakpointsLine = { link = "DapUIBreakpointsPath" },
		DapUIBreakpointsPath = { fg = palette.aether },
		DapUIDecoration = { link = "DapUIBreakpointsPath" },
		DapUIFloatBorder = make_border(),
		DapUIFrameName = { fg = palette.text },
		DapUILineNumber = { link = "DapUIBreakpointsPath" },
		DapUIModifiedValue = { fg = palette.aether, bold = styles.bold },
		DapUIScope = { link = "DapUIBreakpointsPath" },
		DapUISource = { fg = palette.umbra },
		DapUIStoppedThread = { link = "DapUIBreakpointsPath" },
		DapUIThread = { fg = palette.witchfire },
		DapUIValue = { fg = palette.text },
		DapUIVariable = { fg = palette.text },
		DapUIType = { fg = palette.umbra },
		DapUIWatchesEmpty = { fg = palette.ichor },
		DapUIWatchesError = { link = "DapUIWatchesEmpty" },
		DapUIWatchesValue = { link = "DapUIThread" },

		-- glepnir/dashboard-nvim
		DashboardCenter = { fg = palette.witchfire },
		DashboardFooter = { fg = palette.umbra },
		DashboardHeader = { fg = palette.rift },
		DashboardShortcut = { fg = palette.ichor },

		-- SmiteshP/nvim-navic
		NavicIconsArray = { fg = palette.witchfire },
		NavicIconsBoolean = { fg = palette.siren },
		NavicIconsClass = { fg = palette.aether },
		NavicIconsConstant = { fg = palette.witchfire },
		NavicIconsConstructor = { fg = palette.witchfire },
		NavicIconsEnum = { fg = palette.witchfire },
		NavicIconsEnumMember = { fg = palette.aether },
		NavicIconsEvent = { fg = palette.witchfire },
		NavicIconsField = { fg = palette.aether },
		NavicIconsFile = { fg = palette.ash },
		NavicIconsFunction = { fg = palette.rift },
		NavicIconsInterface = { fg = palette.aether },
		NavicIconsKey = { fg = palette.umbra },
		NavicIconsKeyword = { fg = palette.rift },
		NavicIconsMethod = { fg = palette.umbra },
		NavicIconsModule = { fg = palette.siren },
		NavicIconsNamespace = { fg = palette.ash },
		NavicIconsNull = { fg = palette.ichor },
		NavicIconsNumber = { fg = palette.witchfire },
		NavicIconsObject = { fg = palette.witchfire },
		NavicIconsOperator = { fg = palette.shroud },
		NavicIconsPackage = { fg = palette.ash },
		NavicIconsProperty = { fg = palette.aether },
		NavicIconsString = { fg = palette.witchfire },
		NavicIconsStruct = { fg = palette.aether },
		NavicIconsTypeParameter = { fg = palette.aether },
		NavicIconsVariable = { fg = palette.text },
		NavicSeparator = { fg = palette.shroud },
		NavicText = { fg = palette.shroud },

		-- folke/noice.nvim
		NoiceCursor = { fg = palette.highlight_high, bg = palette.text },

		-- folke/trouble.nvim
		TroubleText = { fg = palette.shroud },
		TroubleCount = { fg = palette.umbra, bg = palette.surface },
		TroubleNormal = { fg = palette.text, bg = groups.panel },

		-- echasnovski/mini.nvim
		MiniAnimateCursor = { reverse = true, nocombine = true },
		MiniAnimateNormalFloat = { link = "NormalFloat" },

		MiniClueBorder = { link = "FloatBorder" },
		MiniClueDescGroup = { link = "DiagnosticFloatingWarn" },
		MiniClueDescSingle = { link = "NormalFloat" },
		MiniClueNextKey = { link = "DiagnosticFloatingHint" },
		MiniClueNextKeyWithPostkeys = { link = "DiagnosticFloatingError" },
		MiniClueSeparator = { link = "DiagnosticFloatingInfo" },
		MiniClueTitle = { bg = groups.panel, bold = styles.bold },

		MiniCompletionActiveParameter = { underline = true },

		MiniCursorword = { underline = true },
		MiniCursorwordCurrent = { underline = true },

		MiniDepsChangeAdded = { fg = groups.git_add },
		MiniDepsChangeRemoved = { fg = groups.git_delete },
		MiniDepsHint = { link = "DiagnosticHint" },
		MiniDepsInfo = { link = "DiagnosticInfo" },
		MiniDepsMsgBreaking = { link = "DiagnosticWarn" },
		MiniDepsPlaceholder = { link = "Comment" },
		MiniDepsTitle = { link = "Title" },
		MiniDepsTitleError = { link = "DiffDelete" },
		MiniDepsTitleSame = { link = "DiffText" },
		MiniDepsTitleUpdate = { link = "DiffAdd" },

		MiniDiffOverAdd = { fg = groups.git_add, bg = groups.git_add, blend = 20 },
		MiniDiffOverChange = { fg = groups.git_change, bg = groups.git_change, blend = 20 },
		MiniDiffOverContext = { bg = palette.surface },
		MiniDiffOverDelete = { fg = groups.git_delete, bg = groups.git_delete, blend = 20 },
		MiniDiffSignAdd = { fg = groups.git_add },
		MiniDiffSignChange = { fg = groups.git_change },
		MiniDiffSignDelete = { fg = groups.git_delete },

		MiniFilesBorder = { link = "FloatBorder" },
		MiniFilesBorderModified = { link = "DiagnosticFloatingWarn" },
		MiniFilesCursorLine = { link = "CursorLine" },
		MiniFilesDirectory = { link = "Directory" },
		MiniFilesFile = { fg = palette.text },
		MiniFilesNormal = { link = "NormalFloat" },
		MiniFilesTitle = { link = "FloatTitle" },
		MiniFilesTitleFocused = { fg = palette.siren, bg = groups.panel, bold = styles.bold },

		MiniHipatternsFixme = { fg = palette.base, bg = groups.error, bold = styles.bold },
		MiniHipatternsHack = { fg = palette.base, bg = groups.warn, bold = styles.bold },
		MiniHipatternsNote = { fg = palette.base, bg = groups.info, bold = styles.bold },
		MiniHipatternsTodo = { fg = palette.base, bg = groups.hint, bold = styles.bold },

		MiniIconsAzure = { fg = palette.aether },
		MiniIconsBlue = { fg = palette.rift },
		MiniIconsCyan = { fg = palette.aether },
		MiniIconsGreen = { fg = palette.blight },
		MiniIconsGrey = { fg = palette.shroud },
		MiniIconsOrange = { fg = palette.siren },
		MiniIconsPurple = { fg = palette.umbra },
		MiniIconsRed = { fg = palette.ichor },
		MiniIconsYellow = { fg = palette.witchfire },

		MiniIndentscopeSymbol = { fg = palette.ash },
		MiniIndentscopeSymbolOff = { fg = palette.witchfire },

		MiniJump = { sp = palette.witchfire, undercurl = true },

		MiniJump2dDim = { fg = palette.shroud },
		MiniJump2dSpot = { fg = palette.witchfire, bold = styles.bold, nocombine = true },
		MiniJump2dSpotAhead = { fg = palette.aether, bg = palette.surface, nocombine = true },
		MiniJump2dSpotUnique = { fg = palette.siren, bold = styles.bold, nocombine = true },

		MiniMapNormal = { link = "NormalFloat" },
		MiniMapSymbolCount = { link = "Special" },
		MiniMapSymbolLine = { link = "Title" },
		MiniMapSymbolView = { link = "Delimiter" },

		MiniNotifyBorder = { link = "FloatBorder" },
		MiniNotifyNormal = { link = "NormalFloat" },
		MiniNotifyTitle = { link = "FloatTitle" },

		MiniOperatorsExchangeFrom = { link = "IncSearch" },

		MiniPickBorder = { link = "FloatBorder" },
		MiniPickBorderBusy = { link = "DiagnosticFloatingWarn" },
		MiniPickBorderText = { bg = groups.panel },
		MiniPickIconDirectory = { link = "Directory" },
		MiniPickIconFile = { link = "MiniPickNormal" },
		MiniPickHeader = { link = "DiagnosticFloatingHint" },
		MiniPickMatchCurrent = { link = "CursorLine" },
		MiniPickMatchMarked = { link = "Visual" },
		MiniPickMatchRanges = { fg = palette.aether },
		MiniPickNormal = { link = "NormalFloat" },
		MiniPickPreviewLine = { link = "CursorLine" },
		MiniPickPreviewRegion = { link = "IncSearch" },
		MiniPickPrompt = { bg = groups.panel, bold = styles.bold },

		MiniStarterCurrent = { nocombine = true },
		MiniStarterFooter = { fg = palette.shroud },
		MiniStarterHeader = { link = "Title" },
		MiniStarterInactive = { link = "Comment" },
		MiniStarterItem = { link = "Normal" },
		MiniStarterItemBullet = { link = "Delimiter" },
		MiniStarterItemPrefix = { link = "WarningMsg" },
		MiniStarterSection = { fg = palette.siren },
		MiniStarterQuery = { link = "MoreMsg" },

		MiniStatuslineDevinfo = { fg = palette.shroud, bg = palette.overlay },
		MiniStatuslineFileinfo = { link = "MiniStatuslineDevinfo" },
		MiniStatuslineFilename = { fg = palette.ash, bg = palette.surface },
		MiniStatuslineInactive = { link = "MiniStatuslineFilename" },
		MiniStatuslineModeCommand = { fg = palette.base, bg = palette.ichor, bold = styles.bold },
		MiniStatuslineModeInsert = { fg = palette.base, bg = palette.aether, bold = styles.bold },
		MiniStatuslineModeNormal = { fg = palette.base, bg = palette.siren, bold = styles.bold },
		MiniStatuslineModeOther = { fg = palette.base, bg = palette.siren, bold = styles.bold },
		MiniStatuslineModeReplace = { fg = palette.base, bg = palette.rift, bold = styles.bold },
		MiniStatuslineModeVisual = { fg = palette.base, bg = palette.umbra, bold = styles.bold },

		MiniSurround = { link = "IncSearch" },

		MiniTablineCurrent = { fg = palette.text, bg = palette.overlay, bold = styles.bold },
		MiniTablineFill = { link = "TabLineFill" },
		MiniTablineHidden = { fg = palette.shroud, bg = groups.panel },
		MiniTablineModifiedCurrent = { fg = palette.overlay, bg = palette.text, bold = styles.bold },
		MiniTablineModifiedHidden = { fg = groups.panel, bg = palette.shroud },
		MiniTablineModifiedVisible = { fg = groups.panel, bg = palette.text },
		MiniTablineTabpagesection = { link = "Search" },
		MiniTablineVisible = { fg = palette.text, bg = groups.panel },

		MiniTestEmphasis = { bold = styles.bold },
		MiniTestFail = { fg = palette.ichor, bold = styles.bold },
		MiniTestPass = { fg = palette.aether, bold = styles.bold },

		MiniTrailspace = { bg = palette.ichor },

		-- goolord/alpha-nvim
		AlphaButtons = { fg = palette.aether },
		AlphaFooter = { fg = palette.witchfire },
		AlphaHeader = { fg = palette.rift },
		AlphaShortcut = { fg = palette.siren },

		-- github/copilot.vim
		CopilotSuggestion = { fg = palette.ash, italic = styles.italic },

		-- nvim-treesitter/nvim-treesitter-context
		TreesitterContext = { bg = palette.overlay },
		TreesitterContextLineNumber = { fg = palette.siren, bg = palette.overlay },

		-- RRethy/vim-illuminate
		IlluminatedWordRead = { link = "LspReferenceRead" },
		IlluminatedWordText = { link = "LspReferenceText" },
		IlluminatedWordWrite = { link = "LspReferenceWrite" },

		-- HiPhish/rainbow-delimiters.nvim
		RainbowDelimiterBlue = { fg = palette.rift },
		RainbowDelimiterCyan = { fg = palette.aether },
		RainbowDelimiterGreen = { fg = palette.blight },
		RainbowDelimiterOrange = { fg = palette.siren },
		RainbowDelimiterRed = { fg = palette.ichor },
		RainbowDelimiterViolet = { fg = palette.umbra },
		RainbowDelimiterYellow = { fg = palette.witchfire },

		-- MeanderingProgrammer/render-markdown.nvim
		RenderMarkdownBullet = { fg = palette.siren },
		RenderMarkdownChecked = { fg = palette.aether },
		RenderMarkdownCode = { bg = palette.overlay },
		RenderMarkdownCodeInline = { fg = palette.text, bg = palette.overlay },
		RenderMarkdownDash = { fg = palette.ash },
		RenderMarkdownH1Bg = { bg = groups.h1, blend = 20 },
		RenderMarkdownH2Bg = { bg = groups.h2, blend = 20 },
		RenderMarkdownH3Bg = { bg = groups.h3, blend = 20 },
		RenderMarkdownH4Bg = { bg = groups.h4, blend = 20 },
		RenderMarkdownH5Bg = { bg = groups.h5, blend = 20 },
		RenderMarkdownH6Bg = { bg = groups.h6, blend = 20 },
		RenderMarkdownQuote = { fg = palette.shroud },
		RenderMarkdownTableFill = { link = "Conceal" },
		RenderMarkdownTableHead = { fg = palette.shroud },
		RenderMarkdownTableRow = { fg = palette.shroud },
		RenderMarkdownUnchecked = { fg = palette.shroud },

		-- MagicDuck/grug-far.nvim
		GrugFarHelpHeader = { fg = palette.rift },
		GrugFarHelpHeaderKey = { fg = palette.witchfire },
		GrugFarHelpWinActionKey = { fg = palette.witchfire },
		GrugFarHelpWinActionPrefix = { fg = palette.aether },
		GrugFarHelpWinActionText = { fg = palette.rift },
		GrugFarHelpWinHeader = { link = "FloatTitle" },
		GrugFarInputLabel = { fg = palette.aether },
		GrugFarInputPlaceholder = { link = "Comment" },
		GrugFarResultsActionMessage = { fg = palette.aether },
		GrugFarResultsChangeIndicator = { fg = groups.git_change },
		GrugFarResultsRemoveIndicator = { fg = groups.git_delete },
		GrugFarResultsAddIndicator = { fg = groups.git_add },
		GrugFarResultsHeader = { fg = palette.rift },
		GrugFarResultsLineNo = { fg = palette.umbra },
		GrugFarResultsLineColumn = { link = "GrugFarResultsLineNo" },
		GrugFarResultsMatch = { link = "CurSearch" },
		GrugFarResultsPath = { fg = palette.aether },
		GrugFarResultsStats = { fg = palette.umbra },

		-- yetone/avante.nvim
		AvanteTitle = { fg = palette.highlight_high, bg = palette.siren },
		AvanteReversedTitle = { fg = palette.siren },
		AvanteSubtitle = { fg = palette.highlight_med, bg = palette.aether },
		AvanteReversedSubtitle = { fg = palette.aether },
		AvanteThirdTitle = { fg = palette.highlight_med, bg = palette.umbra },
		AvanteReversedThirdTitle = { fg = palette.umbra },
		AvantePromptInput = { fg = palette.text, bg = groups.panel },
		AvantePromptInputBorder = { fg = groups.border },

		-- Saghen/blink.cmp
		BlinkCmpDoc = { bg = palette.highlight_low },
		BlinkCmpDocSeparator = { bg = palette.highlight_low },
		BlinkCmpDocBorder = { fg = palette.highlight_high },
		BlinkCmpGhostText = { fg = palette.ash },

		BlinkCmpLabel = { fg = palette.ash },
		BlinkCmpLabelDeprecated = { fg = palette.ash, strikethrough = true },
		BlinkCmpLabelMatch = { fg = palette.text, bold = styles.bold },

		BlinkCmpDefault = { fg = palette.highlight_med },
		BlinkCmpKindText = { fg = palette.rift },
		BlinkCmpKindMethod = { fg = palette.aether },
		BlinkCmpKindFunction = { fg = palette.aether },
		BlinkCmpKindConstructor = { fg = palette.aether },
		BlinkCmpKindField = { fg = palette.rift },
		BlinkCmpKindVariable = { fg = palette.siren },
		BlinkCmpKindClass = { fg = palette.witchfire },
		BlinkCmpKindInterface = { fg = palette.witchfire },
		BlinkCmpKindModule = { fg = palette.aether },
		BlinkCmpKindProperty = { fg = palette.aether },
		BlinkCmpKindUnit = { fg = palette.rift },
		BlinkCmpKindValue = { fg = palette.ichor },
		BlinkCmpKindKeyword = { fg = palette.umbra },
		BlinkCmpKindSnippet = { fg = palette.siren },
		BlinkCmpKindColor = { fg = palette.ichor },
		BlinkCmpKindFile = { fg = palette.aether },
		BlinkCmpKindReference = { fg = palette.ichor },
		BlinkCmpKindFolder = { fg = palette.aether },
		BlinkCmpKindEnum = { fg = palette.aether },
		BlinkCmpKindEnumMember = { fg = palette.aether },
		BlinkCmpKindConstant = { fg = palette.witchfire },
		BlinkCmpKindStruct = { fg = palette.aether },
		BlinkCmpKindEvent = { fg = palette.aether },
		BlinkCmpKindOperator = { fg = palette.aether },
		BlinkCmpKindTypeParameter = { fg = palette.umbra },
		BlinkCmpKindCodeium = { fg = palette.aether },
		BlinkCmpKindCopilot = { fg = palette.aether },
		BlinkCmpKindSupermaven = { fg = palette.aether },
		BlinkCmpKindTabNine = { fg = palette.aether },

		-- folke/snacks.nvim
		SnacksIndent = { fg = palette.overlay },
		SnacksIndentChunk = { fg = palette.overlay },
		SnacksIndentBlank = { fg = palette.overlay },
		SnacksIndentScope = { fg = palette.aether },

		SnacksPickerMatch = { fg = palette.siren, bold = styles.bold },

		-- justinmk/vim-sneak
		Sneak = { fg = palette.base, bg = palette.ichor },
		SneakCurrent = { link = "StatusLineTerm" },
		SneakScope = { link = "IncSearch" },

		-- sindrets/diffview.nvim
		DiffviewPrimary = { fg = palette.rift },
		DiffviewSecondary = { fg = palette.aether },
		DiffviewNormal = { fg = palette.text, bg = palette.surface },
		DiffviewWinSeparator = { fg = palette.text, bg = palette.surface },

		DiffviewFilePanelTitle = { fg = palette.aether, bold = styles.bold },
		DiffviewFilePanelCounter = { fg = palette.siren },
		DiffviewFilePanelRootPath = { fg = palette.aether, bold = styles.bold },
		DiffviewFilePanelFileName = { fg = palette.text },
		DiffviewFilePanelSelected = { fg = palette.witchfire },
		DiffviewFilePanelPath = { link = "Comment" },

		DiffviewFilePanelInsertions = { fg = groups.git_add },
		DiffviewFilePanelDeletions = { fg = groups.git_delete },
		DiffviewFilePanelConflicts = { fg = groups.git_merge },
		DiffviewFolderName = { fg = palette.aether, bold = styles.bold },
		DiffviewFolderSign = { fg = palette.shroud },
		DiffviewHash = { fg = palette.siren },
		DiffviewReference = { fg = palette.aether, bold = styles.bold },
		DiffviewReflogSelector = { fg = palette.siren },
		DiffviewStatusAdded = { fg = groups.git_add },
		DiffviewStatusUntracked = { fg = groups.git_untracked },
		DiffviewStatusModified = { fg = groups.git_change },
		DiffviewStatusRenamed = { fg = groups.git_rename },
		DiffviewStatusCopied = { fg = groups.git_untracked },
		DiffviewStatusTypeChange = { fg = groups.git_change },
		DiffviewStatusUnmerged = { fg = groups.git_change },
		DiffviewStatusUnknown = { fg = groups.git_delete },
		DiffviewStatusDeleted = { fg = groups.git_delete },
		DiffviewStatusBroken = { fg = groups.git_delete },
		DiffviewStatusIgnored = { fg = groups.git_ignore },
	}
	local transparency_highlights = {
		DiagnosticVirtualTextError = { fg = groups.error },
		DiagnosticVirtualTextHint = { fg = groups.hint },
		DiagnosticVirtualTextInfo = { fg = groups.info },
		DiagnosticVirtualTextOk = { fg = groups.ok },
		DiagnosticVirtualTextWarn = { fg = groups.warn },

		FloatBorder = { fg = palette.ash, bg = "NONE" },
		FloatTitle = { fg = palette.aether, bg = "NONE", bold = styles.bold },
		Folded = { fg = palette.text, bg = "NONE" },
		NormalFloat = { bg = "NONE" },
		Normal = { fg = palette.text, bg = "NONE" },
		NormalNC = { fg = palette.text, bg = config.options.dim_inactive_windows and palette._nc or "NONE" },
		Pmenu = { fg = palette.shroud, bg = "NONE" },
		PmenuExtra = { fg = palette.text, bg = "NONE" },
		PmenuKind = { fg = palette.aether, bg = "NONE" },
		SignColumn = { fg = palette.text, bg = "NONE" },
		StatusLine = { fg = palette.shroud, bg = "NONE" },
		StatusLineNC = { fg = palette.ash, bg = "NONE" },
		TabLine = { bg = "NONE", fg = palette.shroud },
		TabLineFill = { bg = "NONE" },
		TabLineSel = { fg = palette.text, bg = "NONE", bold = styles.bold },

		-- ["@markup.raw"] = { bg = "none" },
		["@markup.raw.markdown_inline"] = { fg = palette.witchfire },
		-- ["@markup.raw.block"] = { bg = "none" },

		TelescopeNormal = { fg = palette.shroud, bg = "NONE" },
		TelescopePromptNormal = { fg = palette.text, bg = "NONE" },
		TelescopeSelection = { fg = palette.text, bg = "NONE", bold = styles.bold },
		TelescopeSelectionCaret = { fg = palette.siren },

		TroubleNormal = { bg = "NONE" },

		WhichKeyFloat = { bg = "NONE" },
		WhichKeyNormal = { bg = "NONE" },

		IblIndent = { fg = palette.overlay, bg = "NONE" },
		IblScope = { fg = palette.aether, bg = "NONE" },
		IblWhitespace = { fg = palette.overlay, bg = "NONE" },

		TreesitterContext = { bg = "NONE" },
		TreesitterContextLineNumber = { fg = palette.siren, bg = "NONE" },

		MiniFilesTitleFocused = { fg = palette.siren, bg = "NONE", bold = styles.bold },

		MiniPickPrompt = { bg = "NONE", bold = styles.bold },
		MiniPickBorderText = { bg = "NONE" },
	}

	if config.options.enable.legacy_highlights then
		for group, highlight in pairs(legacy_highlights) do
			highlights[group] = highlight
		end
	end
	for group, highlight in pairs(default_highlights) do
		highlights[group] = highlight
	end
	if styles.transparency then
		for group, highlight in pairs(transparency_highlights) do
			highlights[group] = highlight
		end
	end

	-- Reconcile highlights with config
	if config.options.highlight_groups ~= nil and next(config.options.highlight_groups) ~= nil then
		for group, highlight in pairs(config.options.highlight_groups) do
			local existing = highlights[group] or {}
			-- Traverse link due to
			-- "If link is used in combination with other attributes; only the link will take effect"
			-- see: https://neovim.io/doc/user/api.html#nvim_set_hl()
			while existing.link ~= nil do
				existing = highlights[existing.link] or {}
			end
			local parsed = vim.tbl_extend("force", {}, highlight)

			if highlight.fg ~= nil then
				parsed.fg = utilities.parse_color(highlight.fg) or highlight.fg
			end
			if highlight.bg ~= nil then
				parsed.bg = utilities.parse_color(highlight.bg) or highlight.bg
			end
			if highlight.sp ~= nil then
				parsed.sp = utilities.parse_color(highlight.sp) or highlight.sp
			end

			if (highlight.inherit == nil or highlight.inherit) and existing ~= nil then
				parsed.inherit = nil
				highlights[group] = vim.tbl_extend("force", existing, parsed)
			else
				parsed.inherit = nil
				highlights[group] = parsed
			end
		end
	end

	for group, highlight in pairs(highlights) do
		if config.options.before_highlight ~= nil then
			config.options.before_highlight(group, highlight, palette)
		end

		if highlight.blend ~= nil and (highlight.blend >= 0 and highlight.blend <= 100) and highlight.bg ~= nil then
			highlight.bg = utilities.blend(highlight.bg, highlight.blend_on or palette.base, highlight.blend / 100)
		end

		highlight.blend = nil
		highlight.blend_on = nil

		if highlight._nvim_blend ~= nil then
			highlight.blend = highlight._nvim_blend
		end

		vim.api.nvim_set_hl(0, group, highlight)
	end

	--- Terminal
	-- Mirrors the 16-color ANSI table the terminal themes ship.
	if config.options.enable.terminal then
		vim.g.terminal_color_0 = palette.border -- black
		vim.g.terminal_color_8 = palette.ash -- bright black
		vim.g.terminal_color_1 = palette.ichor -- red
		vim.g.terminal_color_9 = palette.b_red -- bright red
		vim.g.terminal_color_2 = palette.blight -- green
		vim.g.terminal_color_10 = palette.b_green -- bright green
		vim.g.terminal_color_3 = palette.witchfire -- yellow
		vim.g.terminal_color_11 = palette.b_yellow -- bright yellow
		vim.g.terminal_color_4 = palette.rift -- blue
		vim.g.terminal_color_12 = palette.b_blue -- bright blue
		vim.g.terminal_color_5 = palette.umbra -- magenta
		vim.g.terminal_color_13 = palette.b_magenta -- bright magenta
		vim.g.terminal_color_6 = palette.aether -- cyan
		vim.g.terminal_color_14 = palette.b_cyan -- bright cyan
		vim.g.terminal_color_7 = palette.b_white7 -- white
		vim.g.terminal_color_15 = palette.text -- bright white

		-- Support StatusLineTerm & StatusLineTermNC from vim
		vim.cmd([[
		augroup static-gospel
			autocmd!
			autocmd TermOpen * if &buftype=='terminal'
				\|setlocal winhighlight=StatusLine:StatusLineTerm,StatusLineNC:StatusLineTermNC
				\|else|setlocal winhighlight=|endif
			autocmd ColorSchemePre * autocmd! static-gospel
		augroup END
		]])
	end
end

function M.load()
	vim.opt.termguicolors = true
	if vim.g.colors_name then
		vim.cmd("hi clear")
		vim.cmd("syntax reset")
	end
	vim.o.background = "dark"
	vim.g.colors_name = "static-gospel"

	set_highlights()
end

---@param options Options
function M.setup(options)
	config.extend_options(options or {})
end

return M
