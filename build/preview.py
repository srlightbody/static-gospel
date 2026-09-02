#!/usr/bin/env python3
"""Render assets/preview-<variant>.png from palette.toml (needs Pillow).

  python build/preview.py            # void and void-lifted
  python build/preview.py all        # every variant
"""
import sys, tomllib
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont

ROOT = Path(__file__).resolve().parent.parent
FONT_DIRS = [Path.home() / ".local/share/fonts/NerdFonts", Path("/usr/share/fonts/TTF")]
FONT = "IosevkaNerdFont-{}.ttf"
PREVIEWS = ["void", "void-lifted"]
W, H = 1000, 560


def font(style, size):
    for d in FONT_DIRS:
        f = d / FONT.format(style)
        if f.exists():
            return ImageFont.truetype(str(f), size)
    sys.exit(f"font not found: {FONT.format(style)}")


def palette(variant):
    pal = tomllib.loads((ROOT / "palette.toml").read_text())
    p = dict(pal["accents"])
    p.update(pal["variants"][variant])
    return p


# (text, palette key, bold, italic, underline)
def code(p):
    R = lambda s, k, b=0, i=0, u=0: (s, p[k], b, i, u)
    return [
        [R("-- what the tide brought back, see ", "shroud", i=1), R("https://gate.io/chorus", "ember", i=1, u=1)],
        [R("local ", "rift"), R("Chorus ", "text"), R("= ", "shroud"), R("require", "siren", b=1), R("(", "shroud"), R('"void.chorus"', "witchfire"), R(")", "shroud")],
        [R("function ", "rift"), R("Chorus", "text"), R(".", "shroud"), R("surface", "siren"), R("(", "shroud"), R("depth", "ember", i=1), R(", ", "shroud"), R("voices", "ember", i=1), R(")", "shroud")],
        [R("  ", "text"), R("local ", "rift"), R("song ", "text"), R("= ", "shroud"), R("voices ", "text"), R("or ", "shroud"), R("9", "witchfire")],
        [R("  ", "text"), R("if ", "rift"), R("depth ", "text"), R("> ", "shroud"), R("300 ", "witchfire"), R("then ", "rift"), R("return ", "rift"), R("nil", "witchfire", b=1), R(", ", "shroud"), R('"cold"', "witchfire"), R(" end", "rift")],
        [R("  ", "text"), R("return ", "rift"), R("flame", "text"), R(":", "shroud"), R("temper", "ember"), R("(", "shroud"), R("song", "text"), R(")", "shroud"), R(", flame.", "shroud"), R("temp", "verdigris")],
        [R("end", "rift")],
    ]


def tfvars(p):
    R = lambda s, k, b=0, i=0, u=0: (s, p[k], b, i, u)
    return [
        [R("container    ", "verdigris"), R("= ", "shroud"), R('"regulations-api"', "witchfire")],
        [R("db_host      ", "verdigris"), R("= ", "shroud"), R('"regulations-postgres.int.staging"', "witchfire")],
        [R("replicas     ", "verdigris"), R("= ", "shroud"), R("3", "witchfire"), R("   ", "text"), R("# ", "shroud", i=1), R("Gate", "verdigris"), R(" ok ", "shroud", i=1), R("✓", "blight")],
    ]


def rounded(d, box, fill, r=10):
    d.rounded_rectangle(box, radius=r, fill=fill)


def draw_runs(d, x, y, runs, fonts):
    for s, fill, b, i, u in runs:
        f = fonts[(b, i)]
        d.text((x, y), s, fill=fill, font=f)
        w = f.getlength(s)
        if u:
            d.line([x, y + 20, x + w, y + 20], fill=fill, width=1)
        x += w
    return x


def render(variant):
    p = palette(variant)
    fonts = {(0, 0): font("Regular", 19), (1, 0): font("Bold", 19), (0, 1): font("Italic", 19), (1, 1): font("BoldItalic", 19)}
    title = font("Bold", 26)
    small = font("Regular", 17)
    im = Image.new("RGB", (W, H), p["base"])
    d = ImageDraw.Draw(im)

    name = f"Static Gospel · {variant}"
    d.text(((W - title.getlength(name)) / 2, 22), name, fill=p["text"], font=title)

    accents = ["ichor", "witchfire", "siren", "rift", "ember", "verdigris", "aether", "blight"]
    gap, x0 = 12, 40
    sw = (W - 2 * x0 - gap * (len(accents) - 1)) / len(accents)
    for i, k in enumerate(accents):
        x = x0 + i * (sw + gap)
        rounded(d, [x, 70, x + sw, 116], p[k], r=6)

    # editor panel
    top, lh = 150, 30
    lines = code(p)
    rounded(d, [36, top, W - 36, top + 24 + lh * len(lines) + 12], p["surface"])
    cur = 4
    for n, runs in enumerate(lines):
        y = top + 18 + n * lh
        if n == cur:
            d.rectangle([46, y - 4, W - 46, y + lh - 6], fill=p["overlay"])
        d.text((20, y), str(n + 1), fill=p["siren"] if n == cur else p["ash"], font=small)
        x = draw_runs(d, 56, y, runs, fonts)
        if n == cur:
            d.rectangle([W - 260, y - 2, W - 250, y + 22], fill=p["blight"])
            seg = fonts[(0, 0)].getlength('"cold"')
            # terminal-style selection on the string
            sx = 56 + sum(fonts[(b, i)].getlength(s) for s, _, b, i, _ in runs[:9])
            d.rectangle([sx, y - 4, sx + seg, y + lh - 6], fill=p["selection"])
            d.text((sx, y), '"cold"', fill=p["witchfire"], font=fonts[(0, 0)])

    # tfvars panel
    top2 = top + 24 + lh * len(lines) + 40
    lines2 = tfvars(p)
    rounded(d, [36, top2, W - 36, top2 + 24 + lh * len(lines2) + 12], p["surface"])
    for n, runs in enumerate(lines2):
        draw_runs(d, 56, top2 + 18 + n * lh, runs, fonts)
    return im


if __name__ == "__main__":
    pal = tomllib.loads((ROOT / "palette.toml").read_text())
    which = pal["order"] if len(sys.argv) > 1 and sys.argv[1] == "all" else PREVIEWS
    for v in which:
        render(v).save(ROOT / "assets" / f"preview-{v}.png")
    print(f"wrote {len(which)} previews")
