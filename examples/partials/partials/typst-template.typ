// Adapted from Quarto's default typst-template.typ.
// Sections marked CUSTOM are this template's additions/replacements;
// everything else is identical to upstream.

#let article(
  title: none,
  subtitle: none,
  authors: none,
  keywords: (),
  date: none,
  abstract-title: none,
  abstract: none,
  thanks: none,
  cols: 1,
  lang: "en",
  region: "US",
  font: none,
  fontsize: 11pt,
  title-size: 1.3em,  // CUSTOM: was 1.5em — fits "State of Arcadonia, 2015–2024" on one line
  subtitle-size: 1.25em,
  heading-family: none,
  heading-weight: "bold",
  heading-style: "normal",
  heading-color: black,
  heading-line-height: 0.65em,
  mathfont: none,
  codefont: none,
  linestretch: 1,
  sectionnumbering: none,
  linkcolor: none,
  citecolor: none,
  filecolor: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  // CUSTOM: extra params populated by typst-show.typ at call time —
  // brand-color and brand-logo aren't in scope where article is defined.
  brand-primary: black,
  brand-logo-medium: none,
  doc,
) = {
  // Set document metadata for PDF accessibility
  set document(title: title, keywords: keywords)
  set document(
    author: authors.map(author => content-to-string(author.name)).join(", ", last: " & "),
  ) if authors != none and authors != ()
  set par(
    justify: true,
    leading: linestretch * 0.65em
  )
  set text(lang: lang,
           region: region,
           size: fontsize)
  set text(font: font) if font != none
  show math.equation: set text(font: mathfont) if mathfont != none
  show raw: set text(font: codefont) if codefont != none

  set heading(numbering: sectionnumbering)

  show link: set text(fill: rgb(content-to-string(linkcolor))) if linkcolor != none
  show ref: set text(fill: rgb(content-to-string(citecolor))) if citecolor != none
  show link: this => {
    if filecolor != none and type(this.dest) == label {
      text(this, fill: rgb(content-to-string(filecolor)))
    } else {
      text(this)
    }
   }

  // ── CUSTOM start: show rules & helpers added on top of upstream ───────
  // Brand-colored links and underlined refs; spacing around headings.
  show link: set text(fill: brand-primary)
  show ref: set text(fill: brand-primary)
  show ref: it => underline(it)
  show heading: set block(above: 1.5em, below: 1em)

  // Booktabs-style tables: centered block, left-aligned cells, brand-colored rules.
  set table(
    inset: 7pt,
    stroke: (_, y) => if y == 0 { (bottom: 0.5pt + brand-primary) } else { none },
  )
  show table.cell: set align(left + horizon)
  show table: it => align(
    center,
    block(stroke: (top: 1pt + brand-primary, bottom: 1pt + brand-primary), inset: 0pt, it),
  )

  // Helper: format an ISO date string ("2026-05-01") as "May 1, 2026".
  let format-long-date(d) = {
    if d == none { return [] }
    let s = content-to-string(d)
    let parts = s.split("-")
    if parts.len() == 3 {
      datetime(
        year: int(parts.at(0)),
        month: int(parts.at(1)),
        day: int(parts.at(2)),
      ).display("[month repr:long] [day padding:none], [year]")
    } else {
      d
    }
  }

  // Running footer on every page: page number, border, then title and date.
  set page(
    footer-descent: 0.7in,
    footer: {
      set text(size: 0.8em)
      align(center, context counter(page).display("1"))
      v(0.9em, weak: true)
      line(length: 100%, stroke: 0.5pt + brand-primary)
      grid(
        columns: (1fr, auto),
        align: (left, right),
        title,
        format-long-date(date),
      )
    },
  )
  // ── CUSTOM end ────────────────────────────────────────────────────────

  // ── CUSTOM start: title block REPLACES upstream's centered place(top, ...) block ──
  // First-page header: logo on the left, title on the right, underline spanning both.
  if title != none {
    block(below: 1.5em, width: 100%)[
      #grid(
        columns: (auto, 1fr),
        column-gutter: 1em,
        align: (left + bottom, center + bottom),
        image(brand-logo-medium.path, height: 0.6in, alt: brand-logo-medium.alt),
        {
          set text(size: title-size, weight: heading-weight, hyphenate: false)
          set text(font: heading-family) if heading-family != none
          set text(style: heading-style) if heading-style != "normal"
          set text(fill: heading-color) if heading-color != black
          set par(justify: false, leading: heading-line-height) if heading-line-height != none
          [#title #if thanks != none {
            footnote(thanks, numbering: "*")
            counter(footnote).update(n => n - 1)
          }]
        },
      )
      #v(0.3em)
      #line(length: 100%, stroke: 0.6pt + brand-primary)
    ]

    if subtitle != none {
      align(right, block(below: 1em, text(size: subtitle-size)[#subtitle]))
    }
  }
  // ── CUSTOM end ────────────────────────────────────────────────────────

  if authors != none and authors != () {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    block(below: 1em, grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    ))
  }

  if abstract != none {
    block(inset: 2em)[
      #text(weight: "semibold")[#abstract-title] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth,
      indent: toc_indent
    );
    ]
  }

  doc
}