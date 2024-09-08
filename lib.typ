#import "meta-parsing.typ": meta-parse

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
  counter(heading).update(0)
  [#pagebreak(weak: true)] // As to insert the metadata AFTER the last FRONT-MATTER page
  [#metadata("BODY")<lyceum-matter>]
}

#let SET-APPENDIX() = context {
  let matter-before-here = query(selector(<lyceum-matter>).before(here()))
  let values-before-here = ()
  for elem in matter-before-here {
    values-before-here.push(elem.value)
  }
  assert("BODY" in values-before-here,
    message: "[lyceum]: SET-APPENDIX() must follow SET-BODY-MATTER()")
  assert("APPENDIX" not in values-before-here,
    message: "[lyceum]: can't SET-APPENDIX() more than once")
  counter(heading).update(0)
  [#metadata("APPENDIX")<lyceum-matter>]
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


#let lyceum(
  // Document metadata
  title: (value: "Default Lyceum Title", short: "Default"),
  authors: (
    (
      preffix: "Dr.",
      given-name: "Lyceum",
      name: "Default",
      suffix: "Jr.",
      email: "default@organized.org",
      affiliation: "Organized Organization",
      location: "Foo City, Bar Country",
    ),
  ),
  editors: (
    (
      preffix: "Dr.",
      given-name: "Erudit",
      name: "Wise",
      suffix: "FRS",
    ),
  ),
  publisher: "Default Lyceum Publisher",
  location: "Default City, Lyceum Country",
  affiliated: (
    illustrator: (
      "Alfreda D. Ballew",
      "Jim M. McKinnis",
    ),
    organizer: "Nicholas D. Gladstone",
  ),
  keywords: ("lyceum", "default"),
  date: auto,
  // Document general format
  page-size: (width: 155mm, height: 230mm),
  page-margin: (inside: 30mm, rest: 25mm),
  page-binding: left,
  page-fill: color.hsl(45deg, 15%, 85%),  // ivory
  text-font: ("EB Garamond", "Linux Libertine"),
  text-size: 12pt,
  lang-name: "en",
  lang-chapter: "Chapter",
  lang-appendix: "Appendix",
  par-indent: 12mm,
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
    editors: editors,
    publisher: publisher,
    location: location,
    affiliated: affiliated,
    keywords: keywords,
    date: date,
    lang: lang-name,
  ))

  // Sets up document metadata
  set document(
    title: [#META.title.value],
    author: AUTHORS.join(" and "),
    keywords: META.keywords,
  )

  // Page parameters controlled by input arguments
  set page(
    width: page-size.width,
    height: page-size.height,
    flipped: false,
    margin: page-margin,
    binding: page-binding,
    columns: 1,
    fill: page-fill,
    footer: context {
      // Get current page number and matter
      let cur-page-number = counter(page).at(here()).first()
      let past-matters = query(selector(<lyceum-matter>).before(here()))
      let cur-matter = if past-matters.len() > 0 {
        past-matters.last().value
      } else { "FRONT" }
      // Format page footer accordingly
      if cur-matter == "FRONT" {
        // Only prints page number after the titlepage
        if cur-page-number > 1 [
          #align(center + horizon)[
            #numbering("\u{2013} i \u{2013}", cur-page-number)
          ]
        ] else []
      } else [
        #align(center + horizon)[
          #numbering("\u{2013} 1 \u{2013}", cur-page-number)
        ]
      ]
    },
    header: context {
      // Get current page number and matter
      let cur-page-number = counter(page).at(here()).first()
      let past-matters = query(selector(<lyceum-matter>).before(here()))
      let cur-matter = if past-matters.len() > 0 {
        past-matters.last().value
      } else { "FRONT" }
      // Format page header accordingly
      if cur-matter in ("FRONT", "BACK") [] else {
        // Only prints header in non-chapter pages
        let main-headings = query(heading.where(level: 1))
        let past-headings = query(heading.where(level: 1).before(here()))
        let cur-main-hdng = past-headings.last()
        if main-headings.all(it => it.location().page() != cur-page-number) {
          if calc.odd(cur-page-number) {
            block(width: 100%, height: (3/2)*text-size)[
              #smallcaps(cur-main-hdng.body) #h(1fr) #cur-page-number
            ]
          } else {
            block(width: 100%, height: (3/2)*text-size)[
              #cur-page-number #h(1fr) #smallcaps(cur-main-hdng.body)
            ]
          }
        }
      }
    }
  )

  // Paragraph settings
  set par(
    leading: 0.65em,
    justify: true,
    linebreaks: "optimized",
    first-line-indent: par-indent,
    hanging-indent: 0pt,
  )

  // Text parameters controlled by input arguments
  set text(
    font: text-font,
    fallback: true,
    weight: "regular",
    size: text-size,
    lang: lang-name,
  )

  set heading(
    /* THIS works in BODY fails in APPENDIX and in the OUTLINE
    numbering: "1.1.1.", */
    /* THIS works in BODY fails in APPENDIX and in the OUTLINE */
    numbering: context {
      let past-matters = query(selector(<lyceum-matter>).before(here()))
      let cur-matter = if past-matters.len() > 0 {
        past-matters.last().value
      } else { "FRONT" }
      if cur-matter in ("FRONT", "BACK") {
        ""
      } else if cur-matter in ("BODY",) {
        "1.1.1"
      } else if cur-matter in ("APPENDIX",) {
        "A.1.1"
      }
    },
    /*
    numbering: (..nums) => context {
      let cur-matter = query(selector(<lyceum-matter>).before(here())).last().value
      if cur-matter == "FRONT" {
        ""
      } else if cur-matter == "BODY" {
        numbering("1.1.1", ..nums)  // TODO TODO: find out why isn't this working
      } else if cur-matter == "APPENDIX" {
        numbering("A.1.1", ..nums)
      } else if cur-matter == "BACK" {
        ""
      }
    },
    */
    outlined: true,
  )

  show heading.where(level: 1): it => context {
    let cur-matter = query(selector(<lyceum-matter>).before(here())).last().value
    let MEA = (top-gap: 70pt, sq-side: 60pt, it-hgt: 80pt)
    let COL = (sq-shade: rgb("#00000070"), sq-text: rgb("#000000A0"))
    let SIZ = (it-siz: 2 * text-size, sq-num-size: 0.7 * MEA.sq-side)
    pagebreak(weak: true, to: "odd")
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    if cur-matter == "FRONT" {
      v(MEA.top-gap)
      set align(center + top)
      set text(font: ("EB Garamond", "Linux Libertine"), SIZ.it-siz, weight: "extrabold")
      block(width: 100%, height: MEA.it-hgt)[#it.body]
    } else if cur-matter == "BODY" {
      place(top + right,
        box(width: MEA.sq-side, height: MEA.sq-side, fill: COL.sq-shade, radius: 4pt, inset: 0pt)[
          #align(center + horizon)[
            #text(
              font: ("Alegreya", "Linux Libertine"),
              size: SIZ.sq-num-size,
              weight: "extrabold",
              fill: COL.sq-text)[#counter(heading).display("1")]
          ]
        ]
      )
      place(top + right, dx: -1.275 * MEA.sq-side,
        rotate(-90deg, origin: top + right)[
          #box(width: MEA.sq-side)[
            #align(center + horizon)[
              #text(
                font: ("EB Garamond", "Linux Libertine"),
                size: 0.275 * SIZ.sq-num-size,
                weight: "bold",
                fill: COL.sq-text)[#lang-chapter]
            ]
          ]
        ]
      )
      v(MEA.top-gap)
      set align(center + top)
      set text(font: ("EB Garamond", "Linux Libertine"), SIZ.it-siz, weight: "extrabold")
      block(width: 100%, height: MEA.it-hgt)[#it.body]
    } else if cur-matter == "APPENDIX" {
      place(top + right,
        box(width: MEA.sq-side, height: MEA.sq-side, fill: COL.sq-shade, radius: 4pt, inset: 0pt)[
          #align(center + horizon)[
            #text(
              font: ("Alegreya", "Linux Libertine"),
              size: SIZ.sq-num-size,
              weight: "extrabold",
              fill: COL.sq-text)[#counter(heading).display("A")]
          ]
        ]
      )
      place(top + right, dx: -1.275 * MEA.sq-side,
        rotate(-90deg, origin: top + right)[
          #box(width: MEA.sq-side)[
            #align(center + horizon)[
              #text(
                font: ("EB Garamond", "Linux Libertine"),
                size: 0.275 * SIZ.sq-num-size,
                weight: "bold",
                fill: COL.sq-text)[#lang-appendix]
            ]
          ]
        ]
      )
      v(MEA.top-gap)
      set align(center + top)
      set text(font: ("EB Garamond", "Linux Libertine"), SIZ.it-siz, weight: "extrabold")
      block(width: 100%, height: MEA.it-hgt)[#it.body]
    } else if cur-matter == "BACK" {
      v(MEA.top-gap)
      set align(center + top)
      set text(font: ("EB Garamond", "Linux Libertine"), SIZ.it-siz, weight: "extrabold")
      block(width: 100%, height: MEA.it-hgt)[#it.body]
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
  page(
    header: [],
    footer: [],
  )[
    #let PARS = (auth-chunk-size: 2, )
    #let MEA = (top-gap: 70pt, )
    // Book Title on Title Page
    #v(MEA.top-gap)
    #block(width: 100%,)[
      #set text(size: (8/3) * text-size)
      #align(center)[*#META.title.value*]
    ]
    #v(4fr)
    // First Author on Title Page
    #block(width: 100%,)[
      #let CHU = range(META.authors.len()).chunks(PARS.auth-chunk-size)
      #for the-CHU in CHU {
        grid(
          columns: (1fr,) * the-CHU.len(),
          gutter: text-size,
          ..the-CHU.map(
            auth-indx => [
              #align(center)[
                #set text(size: (4/3) * text-size)
                *#META.authors.at(auth-indx).name,*
                *#META.authors.at(auth-indx).given-name* \
                #set text(size: (3/3) * text-size)
                #META.authors.at(auth-indx).affiliation \
                #set text(size: (5/6) * text-size)
                #raw(META.authors.at(auth-indx).email) \
                #META.authors.at(auth-indx).location
              ]
            ]
          )
        )
        if the-CHU.last() < CHU.flatten().last() [
          #v((4/3) * text-size)
        ]
      }
    ]
    #v(4fr)
    // Publisher block
    #block(width: 100%,)[
      #set text(size: text-size)
      #META.publisher, \
      #META.location
    ]
    #v(1fr)
    // Date block
    #block(width: 100%,)[
      #set text(size: text-size)
      #align(center)[#META.date.display()]
    ]
  ]

  // Set front matter mark
  SET-FRONT-MATTER()

  // Document body
  body
}


