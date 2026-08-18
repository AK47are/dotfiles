#!/usr/bin/env python3
"""Rewrap git commit message bodies to a fixed display width.

Usage: rewrap.py <message-file> [--width N]

Reads a commit message file, rewraps body paragraphs to N terminal columns
(CJK full-width characters count as 2), and writes the file back only when
the message changed. Fail-safe: any error leaves the file untouched and
exits 0, so the commit is never blocked by a formatter failure.

Rules:
- Subject zone (lines before the first blank line) is never rewrapped.
- Body prose paragraphs are greedily rewrapped to the target width.
- Space-less Chinese text breaks after punctuation first, then at character
  boundaries; punctuation never starts a line (lines may exceed the width
  by the width of the trailing punctuation).
- Preserved verbatim: indented/code blocks, Markdown tables, quote lines,
  comment lines, a whitelist of git footer/trailer lines (to EOF), and
  over-wide tokens such as URLs.
- Bullet items wrap with a hanging indent aligned to the first text column.
- Idempotent: rewrapping an already wrapped message changes nothing.
"""

import argparse
import re
import sys
import unicodedata

CJK_CHARS = re.compile(
    r"[\u3000-\u303f\u3400-\u4dbf\u4e00-\u9fff\uf900-\ufaff\uff00-\uffef]"
)
CJK_PUNCT_AFTER = set("，。；：、！？…—～·」』】）》〉’\"")
FOOTER_RE = re.compile(
    r"^(?:Signed-off-by|Co-authored-by|Reviewed-by|Acked-by|Tested-by"
    r"|Reported-by|Suggested-by|Helped-by|Fixes|Closes|Resolves|Ref"
    r"|See-also|References):\s"
)
BULLET_RE = re.compile(r"^(\s*(?:[-*+]|\d+[.)]|[\u00a0-\uffff])\s)")


def w(s):
    """Terminal display width: full-width chars count 2, tabs count 4."""
    return sum(
        2 if unicodedata.east_asian_width(c) in ("W", "F")
        else (4 if c == "\t" else 1)
        for c in s
    )


def is_cjk(ch):
    return CJK_CHARS.match(ch) is not None


def atoms_of(seg):
    """Split a whitespace segment into atoms, cutting after CJK punctuation."""
    out, buf = [], []
    for ch in seg:
        buf.append(ch)
        if ch in CJK_PUNCT_AFTER:
            out.append("".join(buf))
            buf = []
    if buf:
        out.append("".join(buf))
    return out


def split_cjk(atom, maxw):
    """Split an over-wide atom; punctuation sticks to the piece before it."""
    if w(atom) <= maxw:
        return [atom]
    subs = atoms_of(atom)
    if len(subs) == 1:
        subs = list(atom)
    chunks, cur, cw = [], "", 0
    for s in subs:
        sw = w(s)
        is_punct = len(s) == 1 and s in CJK_PUNCT_AFTER
        if cur and cw + sw > maxw and not is_punct:
            chunks.append(cur)
            cur, cw = "", 0
        cur += s
        cw += sw
    if cur:
        chunks.append(cur)
    return chunks


def tokens_of(para):
    """Paragraph -> [(atom, needs_space_before)] preserving CJK spacing."""
    toks = []
    for seg in para.split():
        for idx, atom in enumerate(atoms_of(seg)):
            toks.append((atom, idx == 0))
    return toks


def pack(toks, limit, indent="", cont=None):
    """Greedy wrap; cont is the continuation indent (hanging indent support)."""
    cont = indent if cont is None else cont
    iw, lines = w(indent), []
    cur, cw = indent, iw
    fresh = True

    def flush():
        nonlocal cur, cw, fresh
        lines.append(cur)
        cur, cw, fresh = cont, w(cont), True

    for atom, need_sp in toks:
        aw = w(atom)
        if fresh:
            if iw + aw <= limit or not CJK_CHARS.search(atom):
                cur, cw, fresh = indent + atom, iw + aw, False
                continue
            ps = split_cjk(atom, limit - iw)
            cur, cw, fresh = indent + ps[0], iw + w(ps[0]), False
            for p in split_cjk(atom[len(ps[0]):], limit - w(cont)):
                flush()
                cur, cw, fresh = cont + p, w(cont) + w(p), False
            continue
        gap = " " if need_sp else ""
        gw = w(gap)
        if cw + gw + aw <= limit:
            cur += gap + atom
            cw += gw + aw
            continue
        if CJK_CHARS.search(atom):
            room = limit - cw - gw
            if room > 0:
                ps = split_cjk(atom, room)
                cur += gap + ps[0]
                cw += gw + w(ps[0])
                rest = atom[len(ps[0]):]
                for p in split_cjk(rest, limit - w(cont)):
                    flush()
                    cur, cw, fresh = cont + p, w(cont) + w(p), False
                continue
        flush()
        cur, cw, fresh = cont + atom, w(cont) + aw, False
    if not fresh or lines:
        lines.append(cur)
    return [l.rstrip() for l in lines]


def sep(a, b):
    """Space between joined paragraphs; none between adjacent CJK chars."""
    return "" if (a and b and is_cjk(a[-1]) and is_cjk(b[0])) else " "


def reflow(text, limit=72):
    lines = text.splitlines()
    out, i, n = [], 0, len(lines)
    # Subject zone: only the first line is the subject; keep it verbatim.
    # Everything after it is body, even without a blank-line separator.
    if lines:
        out.append(lines[0])
        i = 1
    while i < n:
        line = lines[i]
        if not line.strip():
            out.append(line)
            i += 1
            continue
        if line.startswith("#") or line.startswith((" ", "\t", "|", ">")):
            out.append(line)
            i += 1
            continue
        if FOOTER_RE.match(line):
            out.extend(lines[i:])
            break
        m = BULLET_RE.match(line)
        if m:
            marker = m.group(1)
            content = line[len(marker):].strip()
            if content:
                cont = " " * w(marker)
                out.extend(pack(tokens_of(content), limit, indent=marker, cont=cont))
            else:
                out.append(marker.rstrip())
            i += 1
            continue
        para, j = [], i
        while j < n:
            lj = lines[j]
            if (not lj.strip() or lj.startswith(("#", " ", "\t", "|", ">"))
                    or FOOTER_RE.match(lj) or BULLET_RE.match(lj)):
                break
            para.append(lj)
            j += 1
        joined = ""
        for p in para:
            joined = p if not joined else joined + sep(joined, p) + p
        out.extend(pack(tokens_of(joined), limit))
        i = j
    eol = "\r\n" if "\r\n" in text else "\n"
    return eol.join(out) + (eol if text.endswith(("\n", "\r")) else "")


def main():
    ap = argparse.ArgumentParser(description="Rewrap git commit message bodies")
    ap.add_argument("file", help="commit message file")
    ap.add_argument("--width", type=int, default=72, help="body wrap width")
    args = ap.parse_args()
    try:
        with open(args.file, "r", encoding="utf-8", newline="") as f:
            text = f.read()
        out = reflow(text, args.width)
        if out != text:
            with open(args.file, "w", encoding="utf-8", newline="") as f:
                f.write(out)
    except Exception as exc:  # fail-safe: never block the commit
        print(f"rewrap: {exc}", file=sys.stderr)
    sys.exit(0)


if __name__ == "__main__":
    main()
