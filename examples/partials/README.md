# partials

A Quarto + brand + Typst document customized via `template-partials`. Produces an accessible (PDF/UA-1) PDF with a branded title block, running footer, and booktabs-style tables.

![Page 1 of the rendered PDF showing the branded title block, content, and running footer.](pdf-preview.png)

## Layout

- **First-page title block:** brand logo on the left, title on the right, brand-colored rule spanning both
- **Every-page footer:** centered page number, brand-colored rule, then title (left) and formatted date (right)
- **Tables:** centered as a block, left-aligned cells, booktabs-style brand-colored rules (thick top/bottom, thin under header)

## Files

| File | Role |
|------|------|
| `report.qmd` | Document source. Registers the partials and sets margins/fontsize. |
| `partials/typst-template.typ` | Overrides Quarto's `article()` function: title block, footer, link/heading/table show rules, body. |
| `partials/typst-show.typ` | Overrides the call site of `article()` to pass brand values as parameters. |
| `partials/page.typ` | Strips Quarto's auto-injected brand logo (set as page background by default). |
| `_brand/_brand.yml` | Brand definition (colors, logo, fonts). |

All three `.typ` partials are listed in the qmd's `template-partials:` key.

## Major customizations

### 1. Title block (`partials/typst-template.typ`)
Replaced the centered `place(top, float: true, ...)` title block with a two-column grid: logo (`auto`) on the left, title (`1fr`, centered, hyphenation off) on the right, plus a `line()` underline beneath both. Title is rendered only on the first page.

### 2. Running footer (`partials/typst-template.typ`)
`set page(footer-descent: 0.2in, footer: { ... })`: page-number → rule → title/date grid. The footer renders on every page. `footer-descent` is the gap from content to footer top — a *small* value pulls the footer up close to content (counterintuitive: bigger values push the footer *down*, not up).

### 3. Date formatting (`partials/typst-template.typ`)
A small `format-long-date` helper parses `YYYY-MM-DD` and emits `Month Day, Year` via `datetime.display(...)`. Falls through to the raw value if it can't parse.

### 4. Page setup (`partials/page.typ`)
Quarto's default `page.typ` injects the brand logo as a page background on every page (`set page(background: ...)`). The override here keeps the page-size/margin/numbering setup but drops the background block — otherwise the logo would appear twice (once as background, once in our header).

### 5. Brand color for all rules
The title underline, footer rule, and table strokes all use `brand-color.primary`. Because of typst's lexical scoping, the `article()` function — defined in `partials/typst-template.typ` *before* Quarto's brand-color injection — cannot see `brand-color` directly. Workaround: `article()` takes `brand-primary` and `brand-logo-medium` parameters; `partials/typst-show.typ` (which runs after the brand definitions) passes them in.

### 6. Booktabs tables (`partials/typst-template.typ`)
```typst
set table(stroke: (_, y) => if y == 0 { (bottom: 0.5pt + brand-primary) } else { none })
show table.cell: set align(left + horizon)
show table: it => align(center, block(stroke: (top: ..., bottom: ...), inset: 0pt, it))
```
Centers the table block but explicitly left-aligns cells (a `set table(align: left)` would have been overridden by the inherited center context from `align(center, ...)`).

## Render

```bash
quarto render report.qmd --to typst    # PDF only
quarto render report.qmd               # all formats
```
