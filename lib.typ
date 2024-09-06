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
  page: (
    size: (width: 155mm, height: 230mm), // TODO: paper name
    margin: (inside: 30mm, rest: 25mm),
    binding: left,
    fill-hue: 45deg, // for ivory-like
  ),
  text: (
    font: ("Garamond Libre", "Linux Libertine"),
    size: 12pt,
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

  //--------------------------------------------------------------------------------//
  //                                    Metadata                                    //
  //--------------------------------------------------------------------------------//

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

  //--------------------------------------------------------------------------------//
  //                               Formatting - Fonts                               //
  //--------------------------------------------------------------------------------//

  //--------------------------------------------------------------------------------//
  //                               Formatting - Page                                //
  //--------------------------------------------------------------------------------//

  // Page parameters controlled by input arguments
  set page(
    width: page-width,
    height: page-height,
    flipped: false,
    margin: page-margin,
    binding: page-binding,
    columns: 1,
    fill: color.hsl(page-fill-hue, 20%, 80%),
  )

  // Metadata writings
  [#metadata(META)<lyceum-meta>]

  // Writes the root metadata into the document
  [#metadata(AUTHORS)<lyceum-auth>]

  // Writes the self-bib-entry
  [#metadata(META.self-bib-entry.join("\n"))<self-bib-entry>]

  //--------------------------------------------------------------------------------//
  //                                   Show Rules                                   //
  //--------------------------------------------------------------------------------//

  show heading.where(level: 1): it => context {
    let matter-before-here = query(selector(<lyceum-matter>).before(here()))
    let cur-matter = matter-before-here.last().value
    pagebreak(weak: true, to: "even")
    if cur-matter == "FRONT" {
      set heading(
        numbering: none,
        outlined: true,
      )
      block(width: 100%)[
        #set align(center)
        #set text(20pt, weight: "bold")
        #it.body
      ]
    } else if cur-matter == "BODY" {
      set heading(
        numbering: "1.1.",
        outlined: true,
      )
      block(width: 100%)[
        #set align(center)
        #set text(20pt, weight: "bold")
        #it.body
      ]
    } else if cur-matter == "BACK" {
      set heading(
        numbering: "A.",
        outlined: true,
      )
      block(width: 100%)[
        #set align(center)
        #set text(20pt, weight: "bold")
        #it.body
      ]
    }
  }

  //--------------------------------------------------------------------------------//
  //                                  Front Matter                                  //
  //--------------------------------------------------------------------------------//

  // Title page
  MAKE-TITLE-PAGE(META)

  // Set front matter mark
  SET-FRONT-MATTER()

  // Set front matter formattings

  set page(
    numbering: "i",
    number-align: center + bottom,
    header: none,
  )

  body
}


