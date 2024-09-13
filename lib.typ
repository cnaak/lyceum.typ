#import "meta-parsing.typ": meta-parse


//--------------------------------------------------------------------------------------------//
//                            Fundamental, Front-Matter show rule                             //
//--------------------------------------------------------------------------------------------//

#let FRONT-MATTER(
  // Document metadata
  title: (
    title: "Default Lyceum Title",
    subtitle: "A Default Exposition",
    sep: " \u{2014} ",
    short: "Default",
  ),
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
  front-matter-material
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
      // Get current page number
      let cur-page-number = counter(page).at(here()).first()
      if cur-page-number > 1 [
        #align(center + horizon)[
          #numbering("i", cur-page-number)
        ]
      ] else []
    },
    header: [],
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

  // Heading numbering and outlining controls
  set heading(
    numbering: none,
    outlined: true,
  )

  // Main headings in FRONT-MATTER
  show heading.where(level: 1): it => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    // Layout
    pagebreak(weak: true, to: "odd")
    v(MEA.top-gap)
    set align(center + top)
    set text(font: ("EB Garamond", "Linux Libertine"), SIZ.it-siz, weight: "extrabold")
    block(width: 100%, height: MEA.it-hgt)[#it.body]
  }

  // Gather formatting parameters
  let FORMAT = (
    page-size:      page-size,
    page-margin:    page-margin,
    page-binding:   page-binding,
    page-fill:      page-fill,
    text-font:      text-font,
    text-size:      text-size,
    lang-name:      lang-name,
    lang-chapter:   lang-chapter,
    lang-appendix:  lang-appendix,
    par-indent:     par-indent,
    // Composed layouts
    MEA:            ( top-gap: 7.5 * text-size,       // Shared by all level-1 headings
                      sq-side: 5.0 * text-size,       // Shaded square within the top-gap
                      it-hgt:  6.5 * text-size,       // Room for level-1 heading bodies
                    ),
    COL:            ( sq-shade: rgb("#00000070"),     // Shaded square shade color
                      sq-text:  rgb("#000000A0"),     // Shaded text color
                    ),
    SIZ:            ( it-siz:  2.0 * text-size,       // Level-1 heading text size
                      sqn-siz: 3.5 * text-size,       // Square-bound number text-size
                    ),
  )

  // Metadata writings
  [#metadata(META)<lyceum-meta>]

  // Writes the root metadata into the document
  [#metadata(AUTHORS)<lyceum-auth>]

  // Writes the self-bib-entry
  [#metadata(META.self-bib-entry.join("\n"))<self-bib-entry>]

  // Writes formatting parameters into the document
  [#metadata(FORMAT)<lyceum-fmt>]

  // Title page
  page(
    header: [],
    footer: [],
  )[
    #let PARS = (auth-chunk-size: 2, )
    // Book Title on Title Page
    // #v(1fr)
    #if META.title.title.len() > 0 {
      if META.title.subtitle.len() > 0 {
        block(width: 100%,)[
          #align(center, text(size: (8/3) * text-size)[*#META.title.title* \ ])
          #align(center, text(size: (6/3) * text-size)[*#META.title.subtitle*])
        ]
      } else {
        block(width: 100%,)[
          #align(center, text(size: (8/3) * text-size)[*#META.title.title*])
        ]
      }
    } else {
      block(width: 100%,)[
        #align(center, text(size: (8/3) * text-size)[*#META.title.value*])
      ]
    }
    #v(4fr)
    // First Author on Title Page
    #block(width: 100%,)[
      #let CHU = range(META.authors.len()).chunks(PARS.auth-chunk-size)
      #for the-CHU in CHU {
        grid(
          columns: (1fr,) * the-CHU.len(),
          gutter: 1em,
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

  // Front-matter material
  front-matter-material
}


//--------------------------------------------------------------------------------------------//
//                                   Body-Matter show rule                                    //
//--------------------------------------------------------------------------------------------//

#let BODY-MATTER(
  par-indent: 12mm,
  body-matter-material
) = {
  // Counter reset
  counter(heading).update(0)
  counter(page).update(1)

  // Format loading
  let FORMAT = (:)
  context {
    let q-format = query(selector(<lyceum-fmt>)).first().value
    for (KEY, VAL) in q-format {
      FORMAT.insert(KEY, VAL)
    }
  }

  // Page settings adjustments
  set page(
    numbering: "1",
    number-align: center,
    header: context {
      // Get current page number
      let cur-page-number = counter(page).at(here()).first()
      // Only prints header in non-chapter pages
      let main-headings = query(heading.where(level: 1))
      let past-headings = query(heading.where(level: 1).before(here()))
      let cur-main-hdng = past-headings.last()
      if main-headings.all(it => it.location().page() != cur-page-number) {
        if calc.odd(cur-page-number) {
          block(width: 100%, height: (3/2) * 1em)[
            #smallcaps(cur-main-hdng.body) #h(1fr) #cur-page-number
          ]
        } else {
          block(width: 100%, height: (3/2) * 1em)[
            #cur-page-number #h(1fr) #smallcaps(cur-main-hdng.body)
          ]
        }
      }
    },
    footer: context {
      // get current page number
      let cur-page-number = counter(page).at(here()).first()
      align(center + horizon)[
        #numbering("1", cur-page-number)
      ]
    },
  )

  // Paragraph settings
  set par(
    first-line-indent: par-indent,
  )

  // Text parameters controlled by input arguments
  // --- Unnecesssary ---

  // Heading numbering and outlining controls
  set heading(
    numbering: "1.1.1.",
    outlined: true,
  )

  // Main headings in BODY-MATTER
  show heading.where(level: 1): it => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    // Layout
    pagebreak(weak: true, to: "odd")
    place(top + right, // Shaded square
      box(width: FORMAT.MEA.sq-side,
        height: FORMAT.MEA.sq-side,
        fill: FORMAT.COL.sq-shade,
        radius: 4pt,
        inset: 0pt,
        align(center + horizon,
          text(
            font: ("Alegreya", "Linux Libertine"),
            size: FORMAT.SIZ.sqn-siz,
            weight: "extrabold",
            fill: FORMAT.COL.sq-text
          )[#counter(heading).display("1")]
        )
      )
    )
    place(top + right, dx: -1.275 * FORMAT.MEA.sq-side, // Rotated "Chapter"
      rotate(-90deg, origin: top + right,
        box(width: FORMAT.MEA.sq-side,
          align(center + horizon,
            text(
              font: ("EB Garamond", "Linux Libertine"),
              size: 0.275 * FORMAT.SIZ.sqn-siz,
              weight: "bold",
              fill: FORMAT.COL.sq-text
            )[#lang-chapter]
          )
        )
      )
    )
    v(FORMAT.MEA.top-gap)
    set align(center + top)
    set text(font: ("EB Garamond", "Linux Libertine"), FORMAT.SIZ.it-siz, weight: "extrabold")
    block(width: 100%, height: FORMAT.MEA.it-hgt)[#it.body]
  }

  // Book body material
  body-matter-material
}


//--------------------------------------------------------------------------------------------//
//                                Optional, Appendix show rule                                //
//--------------------------------------------------------------------------------------------//

#let APPENDIX(
  par-indent: 12mm,
  appendix-material
) = {
  // Counter reset
  counter(heading).update(0)

  // Page settings adjustments
  set page(
    numbering: "1",
    number-align: center,
    header: context {
      // Get current page number
      let cur-page-number = counter(page).at(here()).first()
      // Only prints header in non-chapter pages
      let main-headings = query(heading.where(level: 1))
      let past-headings = query(heading.where(level: 1).before(here()))
      let cur-main-hdng = past-headings.last()
      if main-headings.all(it => it.location().page() != cur-page-number) {
        if calc.odd(cur-page-number) {
          block(width: 100%, height: (3/2) * 1em)[
            #smallcaps(cur-main-hdng.body) #h(1fr) #cur-page-number
          ]
        } else {
          block(width: 100%, height: (3/2) * 1em)[
            #cur-page-number #h(1fr) #smallcaps(cur-main-hdng.body)
          ]
        }
      }
    },
    footer: context {
      // get current page number
      let cur-page-number = counter(page).at(here()).first()
      align(center + horizon)[
        #numbering("1", cur-page-number)
      ]
    },
  )

  // Paragraph settings
  set par(
    first-line-indent: par-indent,
  )

  // Text parameters controlled by input arguments
  // --- Unnecesssary ---

  // Heading numbering and outlining controls
  set heading(
    numbering: "A.1.1.",
    outlined: true,
  )

  // Main headings in APPENDIX
  show heading.where(level: 1): it => context {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    // Layout
    pagebreak(weak: true, to: "odd")
    place(top + right, // Shaded square
      box(width: FORMAT.MEA.sq-side, height: FORMAT.MEA.sq-side, fill: FORMAT.COL.sq-shade, radius: 4pt, inset: 0pt)[
        #align(center + horizon)[
          #text(
            font: ("Alegreya", "Linux Libertine"),
            size: FORMAT.SIZ.sqn-siz,
            weight: "extrabold",
            fill: FORMAT.COL.sq-text)[#counter(heading).display("A")]
        ]
      ]
    )
    place(top + right, dx: -1.275 * FORMAT.MEA.sq-side, // Rotated "Appendix"
      rotate(-90deg, origin: top + right)[
        #box(width: FORMAT.MEA.sq-side)[
          #align(center + horizon)[
            #text(
              font: ("EB Garamond", "Linux Libertine"),
              size: 0.275 * FORMAT.SIZ.sqn-siz,
              weight: "bold",
              fill: FORMAT.COL.sq-text)[#lang-appendix]
          ]
        ]
      ]
    )
    v(FORMAT.MEA.top-gap)
    set align(center + top)
    set text(font: ("EB Garamond", "Linux Libertine"), FORMAT.SIZ.it-siz, weight: "extrabold")
    block(width: 100%, height: FORMAT.MEA.it-hgt)[#it.body]
  }

  // Appendix Page
  context {
    let lang-appendix = query(selector(<lyceum-fmt>)).last().value.lang-appendix
    pagebreak(weak: true, to: "odd")
    page(
      header: [],
      footer: [],
    )[
      #v(1fr)
      #block(
        width: 100%,
        align(
          center,
          text(size: (8/3) * 1em)[
            *#lang-appendix*
          ]
        )
      )
      #v(1fr)
    ]
  }

  // Appendix material
  appendix-material
}


//--------------------------------------------------------------------------------------------//
//                              Optional, Back-matter show rule                               //
//--------------------------------------------------------------------------------------------//

#let BACK-MATTER(
  par-indent: 12mm,
  back-matter-material
) = {
  // Page settings adjustments
  set page(
    numbering: "1",
    number-align: center,
    header: [],
    footer: context {
      // get current page number
      let cur-page-number = counter(page).at(here()).first()
      align(center + horizon)[
        #numbering("1", cur-page-number)
      ]
    },
  )

  // Paragraph settings
  set par(
    first-line-indent: par-indent,
  )

  // Text parameters controlled by input arguments
  // --- Unnecesssary ---

  // Heading numbering and outlining controls
  set heading(
    numbering: none,
    outlined: true,
  )

  // Main headings in BACK-MATTER
  show heading.where(level: 1): it => {
    counter(figure.where(kind: image)).update(0)
    counter(figure.where(kind: table)).update(0)
    counter(math.equation).update(0)
    // Layout
    pagebreak(weak: true, to: "odd")
    v(FORMAT.MEA.top-gap)
    set align(center + top)
    set text(font: ("EB Garamond", "Linux Libertine"), FORMAT.SIZ.it-siz, weight: "extrabold")
    block(width: 100%, height: FORMAT.MEA.it-hgt)[#it.body]
  }

  // back-matter material
  back-matter-material
}


