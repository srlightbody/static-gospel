#!/usr/bin/env python3
"""Generate every app theme file from palette.toml.

  python build/build.py            # write all app files + palette.lua
  python build/build.py check      # verify working tree matches (CI/pre-commit)
  python build/build.py templatize # regenerate templates from current drowned files

Only the 9 per-variant roles (base/surface/overlay/_nc/hl_low/hl_med/hl_high +
inactive_tab/border) and the display name vary between variants; everything else
is shared. Templates carry @@role@@ placeholders so a round-trip is byte-exact.
"""
import sys, tomllib, difflib
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TPL = Path(__file__).resolve().parent / "templates"
ROLES = ["base", "surface", "overlay", "_nc", "hl_low", "hl_med", "hl_high",
         "inactive_tab", "border", "selection"]

# app -> (theme dir, file extension). The default (drowned) file has no suffix.
APPS = {
    "alacritty": ("alacritty", ".toml"),
    "kitty":     ("kitty", ".conf"),
    "ghostty":   ("ghostty", ""),
    "foot":      ("foot", ".ini"),
    "wezterm":   ("wezterm", ".toml"),
    "tmux":      ("tmux", ".conf"),
    "k9s":       ("k9s", ".yaml"),
    "bat":       ("bat", ".tmTheme"),
    "delta":     ("delta", ".gitconfig"),
    "lazygit":   ("lazygit", ".yml"),
    "lsd":       ("lsd", ".yaml"),
    "noctalia":  ("noctalia", ".json"),  # special path handling below
    "p10k":      ("p10k", ".zsh"),
    "qt6ct":     ("qt6ct", ".conf"),
    "gtk":       ("gtk", ".css"),
}


def load_palette():
    return tomllib.loads((ROOT / "palette.toml").read_text())


def shared_colors(pal):
    """Flat name->hex for colors identical across variants (accents/bright/delta)."""
    out = {}
    for k, v in pal["accents"].items():
        out[k] = v
    for k, v in pal["bright"].items():
        out[f"b_{k}"] = v
    for k, v in pal["delta"].items():
        out[f"d_{k}"] = v
    return out


def slugify(suffix):
    """Filename slug for a variant suffix ('Void Lifted' -> static-gospel-void-lifted)."""
    return "static-gospel" + (f"-{suffix.lower().replace(' ', '-')}" if suffix else "")


def out_path(app, suffix):
    """Where the rendered file for `app`+variant lands."""
    d, ext = APPS[app]
    if app == "noctalia":
        name = "Static Gospel" + (f" {suffix}" if suffix else "")
        return ROOT / d / "colorschemes" / name / f"{name}.json"
    return ROOT / d / f"{slugify(suffix)}{ext}"


def hex_to_rgb(h):
    h = h.lstrip("#")
    return [int(h[i:i + 2], 16) for i in (0, 2, 4)]


def blend_rgb(h1, h2):
    r1, r2 = hex_to_rgb(h1), hex_to_rgb(h2)
    return [round((a + b) / 2) for a, b in zip(r1, r2)]


def brave_out_path(suffix):
    """Chrome loads one manifest per unpacked-extension folder, so each variant
    (besides the default) gets its own directory to load separately."""
    if not suffix:
        return ROOT / "brave" / "manifest.json"
    return ROOT / "brave" / slugify(suffix) / "manifest.json"


def build_brave(variant, pal):
    """Chrome theme manifest: colors are decimal RGB triples, not hex, and a
    few frame tones (inactive/incognito-inactive/toolbar) have no dedicated
    palette role, so they're blended from the adjacent base/surface/overlay
    ramp instead of pulled straight from palette.toml."""
    v = pal["variants"][variant]
    a, br = pal["accents"], pal["bright"]
    frame = hex_to_rgb(v["base"])
    frame_incognito = hex_to_rgb(v["border"])
    colors = {
        "frame": frame,
        "frame_inactive": blend_rgb(v["base"], v["surface"]),
        "frame_incognito": frame_incognito,
        "frame_incognito_inactive": blend_rgb(v["surface"], v["overlay"]),
        "toolbar": hex_to_rgb(v["surface"]),
        "tab_text": hex_to_rgb(a["text"]),
        "tab_background_text": hex_to_rgb(a["ash"]),
        "background_tab_text": hex_to_rgb(a["ash"]),
        "bookmark_text": hex_to_rgb(br["white7"]),
        "ntp_background": frame,
        "ntp_text": hex_to_rgb(a["text"]),
        "ntp_link": hex_to_rgb(a["rift"]),
        "ntp_header": frame_incognito,
        "control_background": frame_incognito,
    }
    name = "Static Gospel" + (f" {v['suffix']}" if v["suffix"] else "")
    rgb = lambda t: "[" + ", ".join(str(n) for n in t) + "]"
    color_lines = ",\n".join(
        f'\t\t\t"{k}": {rgb(val)}' for k, val in colors.items())
    return (
        "{\n"
        "\t\"manifest_version\": 3,\n"
        f"\t\"name\": \"{name}\",\n"
        "\t\"version\": \"1.0\",\n"
        "\t\"description\": \"Eldritch cyberpunk: full-chroma occult neon over deep voids.\",\n"
        "\t\"theme\": {\n"
        "\t\t\"colors\": {\n"
        f"{color_lines}\n"
        "\t\t},\n"
        "\t\t\"tints\": {\n"
        "\t\t\t\"buttons\": [-1, -1, 0.9]\n"
        "\t\t},\n"
        "\t\t\"properties\": {\n"
        "\t\t\t\"ntp_logo_alternate\": 1\n"
        "\t\t}\n"
        "\t}\n"
        "}\n"
    )


def render(template_text, variant, pal):
    """Fill placeholders for one variant."""
    v = pal["variants"][variant]
    out = template_text
    # placeholders carry bare hex digits; any leading '#' stays literal in the
    # template, so apps that write '#rrggbb' and apps that write bare 'rrggbb'
    # (foot) both round-trip.
    for role in ROLES:
        out = out.replace(f"@@{role}@@", v[role].lstrip("#"))
    for name, hx in shared_colors(pal).items():
        out = out.replace(f"@@{name}@@", hx.lstrip("#"))
    suffix = f" {v['suffix']}" if v["suffix"] else ""
    return out.replace("@@name_suffix@@", suffix).replace("@@slug@@", slugify(v["suffix"]))


def build_lua(pal):
    """Regenerate lua/static-gospel/palette.lua from the same source."""
    a = pal["accents"]
    L = []
    add = L.append
    add("-- Static Gospel palette: shared cyberpunk accents over a selectable dark ramp.")
    add("-- Variants change ONLY the ramp (base/surface/overlay/_nc + highlight grays);")
    add("-- accents and neutrals are shared. Select with:")
    add('--   require("static-gospel").setup({ variant = "void" })  -- or abyssal / lifted')
    add('local config = require("static-gospel.config")')
    add("")
    add("-- accents + neutrals, identical across every variant")
    add("local shared = {")
    for k in ("ash", "shroud", "text"):
        add(f'\t{k} = "{a[k]}",')
    add("")
    for k in ("ichor", "witchfire", "siren", "rift", "aether", "verdigris", "umbra", "blight"):
        add(f'\t{k} = "{a[k]}",')
    add("")
    add("\t-- bright ANSI, used only by the embedded terminal")
    for k, hx in pal["bright"].items():
        add(f'\tb_{k} = "{hx}",')
    add("")
    add('\tnone = "NONE",')
    add("}")
    add("")
    add("-- per-variant dark ramp")
    add("local ramps = {")
    for name in pal["order"]:
        v = pal["variants"][name]
        for c in v["comment"]:
            add(f"\t-- {c}")
        key = name if name.isidentifier() else f'["{name}"]'
        add(f"\t{key} = {{")
        add(f'\t\tbase = "{v["base"]}", surface = "{v["surface"]}", '
            f'overlay = "{v["overlay"]}", _nc = "{v["_nc"]}",')
        add(f'\t\thighlight_low = "{v["hl_low"]}", highlight_med = "{v["hl_med"]}", '
            f'highlight_high = "{v["hl_high"]}",')
        add(f'\t\tborder = "{v["border"]}",')
        add("\t},")
    add("}")
    add("")
    add("local built = {}")
    add("")
    add("-- Returns the merged palette for the configured variant. Memoized per variant")
    add("-- so the frequent parse_color() lookups don't rebuild it.")
    add("return function()")
    add("\tlocal v = config.options.variant")
    add('\tif v == "auto" then v = config.options.dark_variant end')
    add('\tif not ramps[v] then v = "drowned" end')
    add("\tif not built[v] then")
    add("\t\tbuilt[v] = vim.tbl_extend(\"force\", {}, ramps[v], shared)")
    add("\tend")
    add("\treturn built[v]")
    add("end")
    return "\n".join(L) + "\n"


def all_outputs(pal):
    """Yield (path, rendered_text) for every app x variant, plus palette.lua."""
    for app in APPS:
        tpl = (TPL / f"{app}.tmpl").read_text()
        for name, v in pal["variants"].items():
            yield out_path(app, v["suffix"]), render(tpl, name, pal)
    for name, v in pal["variants"].items():
        yield brave_out_path(v["suffix"]), build_brave(name, pal)
    yield ROOT / "lua" / "static-gospel" / "palette.lua", build_lua(pal)


def cmd_build(pal):
    n = 0
    for path, text in all_outputs(pal):
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text)
        n += 1
    print(f"wrote {n} files")


def cmd_check(pal):
    drift = 0
    for path, text in all_outputs(pal):
        cur = path.read_text() if path.exists() else ""
        if cur != text:
            drift += 1
            rel = path.relative_to(ROOT)
            print(f"DRIFT: {rel}")
            for line in difflib.unified_diff(
                cur.splitlines(), text.splitlines(),
                fromfile=f"{rel} (working tree)", tofile=f"{rel} (generated)", lineterm=""):
                print("  " + line)
    if drift:
        print(f"\n{drift} file(s) out of sync — run: python build/build.py")
        sys.exit(1)
    print("all files match palette.toml")


def cmd_templatize(pal):
    """Rebuild templates from the current drowned files (dev-only)."""
    d = pal["variants"]["drowned"]
    # roles first, then shared; on a hex collision (cursor==blight) the first
    # wins, keeping a single deterministic placeholder per hex.
    hex_to_ph = {}
    for r in ROLES:
        hex_to_ph.setdefault(d[r].lstrip("#").lower(), f"@@{r}@@")
    for name, hx in shared_colors(pal).items():
        hex_to_ph.setdefault(hx.lstrip("#").lower(), f"@@{name}@@")
    TPL.mkdir(parents=True, exist_ok=True)
    for app in APPS:
        text = out_path(app, "").read_text()
        for hx, ph in hex_to_ph.items():
            text = text.replace("#" + hx, "#" + ph)  # '#rrggbb' -> '#@@role@@'
            text = text.replace(hx, ph)               # bare 'rrggbb' -> '@@role@@'
        # in-file install hints name this variant's own file
        text = text.replace("static-gospel", "@@slug@@")
        text = text.replace("Static Gospel", "Static Gospel@@name_suffix@@")
        (TPL / f"{app}.tmpl").write_text(text)
    print(f"regenerated {len(APPS)} templates")


if __name__ == "__main__":
    pal = load_palette()
    cmd = sys.argv[1] if len(sys.argv) > 1 else "build"
    {"build": cmd_build, "check": cmd_check, "templatize": cmd_templatize}[cmd](pal)
