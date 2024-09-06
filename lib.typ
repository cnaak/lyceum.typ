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
  counter(heading).update(0)
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
  keywords: ("lyceum", "default"),
  date: auto,
  // TODO: include support for editor and affiliated people
  // Document general format
  the-page: (
    size: (width: 155mm, height: 230mm), // TODO: paper name
    margin: (inside: 30mm, rest: 25mm),
    binding: left,
    fill-hue: 45deg, // 45deg for ivory-like, TODO: allow for white
  ),
  the-text: (
    font: ("EB Garamond", "Linux Libertine"),
    size: 12pt,
  ),
  lang: (
    name: "en",
    chapter: "Chapter",
    appendix: "Appendix",
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
    editors: editors,
    publisher: publisher,
    location: location,
    keywords: keywords,
    date: date,
    lang: lang.name,
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
    fill: color.hsl(the-page.fill-hue, 20%, 80%),
  )

  // Text parameters controlled by input arguments
  set text(
    font: the-text.font,
    fallback: true,
    weight: "regular",
    size: the-text.size,
    lang: lang.name,
  )

  set heading(
    numbering: _ => context {
      let cur-matter = query(selector(<lyceum-matter>).before(here())).last().value
      if cur-matter == "FRONT"    { none }
      if cur-matter == "BODY"     { "1.1.1." }
      if cur-matter == "APPENDIX" { "A.1.1." }
      if cur-matter == "BACK"     { none }
    },
    outlined: true,
  )

  show heading.where(level: 1): it => context {
    let cur-matter = query(selector(<lyceum-matter>).before(here())).last().value
    let MEA = (top-gap: 70pt, sq-side: 60pt, it-hgt: 80pt)
    let COL = (sq-shade: rgb("#00000070"), sq-text: rgb("#000000A0"))
    let SIZ = (it-siz: 2 * the-text.size, sq-num-size: 0.7 * MEA.sq-side)
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
                fill: COL.sq-text)[#lang.chapter]
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
                fill: COL.sq-text)[#lang.appendix]
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
  [ // Title page
    #let PARS = (auth-chunk-size: 2, )
    #let MEA = (top-gap: 70pt, )
    // Book Title on Title Page
    #v(MEA.top-gap)
    #block(width: 100%,)[
      #set text(size: (8/3) * the-text.size)
      #align(center)[*#META.title.value*]
    ]
    #v(4fr)
    // First Author on Title Page
    #block(width: 100%,)[
      #let CHU = range(META.authors.len()).chunks(PARS.auth-chunk-size)
      #for the-CHU in CHU {
        grid(
          columns: (1fr,) * the-CHU.len(),
          gutter: the-text.size,
          ..the-CHU.map(
            auth-indx => [
              #align(center)[
                #set text(size: (4/3) * the-text.size)
                *#META.authors.at(auth-indx).name,*
                *#META.authors.at(auth-indx).given-name* \
                #set text(size: (3/3) * the-text.size)
                #META.authors.at(auth-indx).affiliation \
                #set text(size: (5/6) * the-text.size)
                #raw(META.authors.at(auth-indx).email) \
                #META.authors.at(auth-indx).location
              ]
            ]
          )
        )
        if the-CHU.last() < CHU.flatten().last() [
          #v((4/3) * the-text.size)
        ]
      }
    ]
    #v(4fr)
    // Publisher block
    #block(width: 100%,)[
      #set text(size: the-text.size)
      #META.publisher, \
      #META.location
    ]
    #v(1fr)
    // Date block
    #block(width: 100%,)[
      #set text(size: the-text.size)
      #align(center)[#META.date.display()]
    ]
  ]

  // Set front matter mark
  SET-FRONT-MATTER()

  // Document body
  body
}


