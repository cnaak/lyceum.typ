#import "src/meta-parsing.typ": meta-parse

#let SET-FRONT-MATTER() = context {
  let matter-before-here = query(selector(<lyceum-matter>).before(here()))
  assert.eq(matter-before-here.len(), 0,
    message: "[lyceum]: can't SET-FRONT-MATTER() more than once")
  [#metadata("FRONT")<lyceum-matter>]
}

#let SET-BODY-MATTER() = context {
  let matter-before-here = query(selector(<lyceum-matter>).before(here()))
  let values-before-here = ()
  for elem in matter-before-here {
    values-before-here.push(elem.value)
  }
  assert("FRONT" in values-before-here,
    message: "[lyceum]: SET-BODY-MATTER() must follow SET-FRONT-MATTER()")
  assert("BODY" not in values-before-here,
    message: "[lyceum]: can't SET-BODY-MATTER() more than once")
  [#metadata("BODY")<lyceum-matter>]
}

#let SET-BACK-MATTER() = context {
  let matter-before-here = query(selector(<lyceum-matter>).before(here()))
  let values-before-here = ()
  for elem in matter-before-here {
    values-before-here.push(elem.value)
  }
  assert("BODY" in values-before-here,
    message: "[lyceum]: SET-BACK-MATTER() must follow SET-BODY-MATTER()")
  assert("BACK" not in values-before-here,
    message: "[lyceum]: can't SET-BACK-MATTER() more than once")
  [#metadata("BACK")<lyceum-matter>]
}

#let MAKE-TITLE-PAGE(META) = {
  page(
    numbering: none,
    header: none,
    footer: none,
  )[// Book Title on Title Page
    #v(40mm)
    #block(width: 100%,)[
      #set text(size: 32pt)
      #align(center)[*#META.title.value*]
    ]
    #v(3fr)
    // TODO: Loop over authors in a grid
    // TODO: Author affiliations
    // First Author on Title Page
    #block(width: 100%,)[
      #set text(size: 14pt)
      *#META.authors.first().name,*
      *#META.authors.first().given-name*
    ]
    #v(3fr)
    // Publisher block
    #block(width: 100%,)[
      #set text(size: 12pt)
      #META.publisher, \
      #META.location
    ]
    #v(1fr)
    // Date block
    #block(width: 100%,)[
      #set text(size: 12pt)
      #align(center)[#META.date.display()]
    ]
  ]
}

#let lyceum(
  // Document metadata
  title: (value: "Default Lyceum Title", short: "Default"),
  authors: (
    (
      preffix: "Dr.",
      given-name: "Lyceum",
      name: "Default",
      suffix: "Jr.", // TODO: implement author email affiliation and location
      email: "default@organized.org",
      affiliation: "Organized Organization",
      location: "Foo City, Bar Country",
    ),
  ),
  publisher: "Default Lyceum Publisher",
  location: "Default City, Lyceum Country",
  keywords: ("lyceum", "default"),
  date: auto,
  // TODO: include support for editor and affiliated people
  // Document general format
  the-page: (
    size: (width: 155mm, height: 230mm), // TODO: paper name
    margin: (inside: 30mm, rest: 25mm),
    binding: left,
    fill-hue: 45deg, // 45deg for ivory-like, none for white
  ),
  the-text: (
    font: ("Garamond Libre", "Linux Libertine"),
    size: 12pt,
    lang: "en",
  ),
  /* TODO: place remaining font definitions some place else
  text-font-display: (value: "Neuton", fallback: "Linux Libertine Display"),
  text-font-serif:   (value: "Garamond Libre", fallback: "Linux Libertine"),
  text-font-serif-2: (value: "Alegreya", fallback: "Crimson Pro"),
  text-font-sans:    (value: "Fira Sans", fallback: "Liberation Sans"),
  text-font-mono:    (value: "JuliaMono", fallback: "Inconsolata"),
  text-font-greek:   (value: "SBL BibLit", fallback: "Linux Libertine"),
  text-font-math:    (value: "TeX Gyre Termes Math", fallback: "TeX Gyre Termes Math"),
  */
  body
) = {
  // Parse metadata information
  let (META, AUTHORS) = meta-parse((
    title: title,
    authors: authors,
    publisher: publisher,
    location: location,
    keywords: keywords,
    date: date,
  ))

  // Sets up document metadata
  set document(
    title: [#META.title.value],
    author: AUTHORS.join(" and "),
    keywords: META.keywords,
  )

  // Page parameters controlled by input arguments
  set page(
    width: the-page.size.width,
    height: the-page.size.height,
    flipped: false,
    margin: the-page.margin,
    binding: the-page.binding,
    columns: 1,
  )
  if the-page.fill-hue != none {
    set page(
      fill: color.hsl(the-page.fill-hue, 20%, 80%),
    )
  }

  // Text parameters controlled by input arguments
  set text(
    font: the-text.font,
    fallback: true,
    weight: "regular",
    size: the-text.size,
    lang: the-text.lang,
  )

  set heading(
    numbering: _ => context {
      let cur-matter = query(selector(<lyceum-matter>).before(here())).last().value
      if cur-matter == "FRONT" { none }
      if cur-matter ==  "BODY" { "1.1.1." }
      if cur-matter ==  "BACK" { "A.1.1." }
    },
    outlined: true,
  )

  show heading.where(level: 1): it => context {
    let cur-matter = query(selector(<lyceum-matter>).before(here())).last().value
    pagebreak(weak: true, to: "odd")
    if cur-matter == "FRONT" {
      v(40mm)
      set align(center + top)
      set text(20pt, weight: "bold")
      block(width: 100%, height: 40mm)[#it.body]
    } else if cur-matter == "BODY" {
      place(top + right,
        box(width: 35mm, height: 35mm, fill: luma(220))[
          #align(center + horizon)[#counter(heading).display("1")]
        ])
      set align(center + top)
      set text(20pt, weight: "bold")
      place(top + left, dx: 0mm, dy: 40mm,
        block(width: 100%, height: 40mm)[#it.body])
    } else if cur-matter == "BACK" {
      place(top + right,
        box(width: 35mm, height: 35mm, fill: luma(220))[
          #align(center + horizon)[#counter(heading).display("A")]
        ])
      set align(center + top)
      set text(20pt, weight: "bold")
      place(top + left, dx: 0mm, dy: 40mm,
        block(width: 100%, height: 40mm)[#it.body])
    }
  }

  //--------------------------------------------------------------------------------//
  //                                  Front Matter                                  //
  //--------------------------------------------------------------------------------//

  // Metadata writings
  [#metadata(META)<lyceum-meta>]

  // Writes the root metadata into the document
  [#metadata(AUTHORS)<lyceum-auth>]

  // Writes the self-bib-entry
  [#metadata(META.self-bib-entry.join("\n"))<self-bib-entry>]

  // Title page
  MAKE-TITLE-PAGE(META)

  // Set front matter mark
  SET-FRONT-MATTER()

  // Document body
  body
}


