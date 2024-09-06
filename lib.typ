#import "src/meta-parsing.typ": meta-parse
#import "src/book-element.typ": *

//============================================================================================//
//                                       User Functions                                       //
//============================================================================================//

#let lyceum(
  // Document metadata
  // -----------------
  title: (
    value: "Default Lyceum Title",
    short: "Default",
  ),
  authors: (
    (
      preffix: "Dr.",
      given-name: "Lyceum",
      name: "Default",
      suffix: "Jr.",
    ),
  ),
  publisher: "Default Lyceum Publisher",
  location: "Default City, Lyceum Country",
  keywords: (
    "lyceum",
    "default",
  ),
  date: auto,
  // General page specs
  // ------------------
  page-width: 155mm,
  page-height: 230mm,
  page-margin: (
    inside: 30mm,
    rest: 25mm,
  ),
  page-binding: left,
  page-fill-hue: 45deg, // for ivory-like
  // General font specs
  // ------------------
  text-font-display: (value: "Neuton", fallback: "Linux Libertine Display"),
  text-font-serif:   (value: "Garamond Libre", fallback: "Linux Libertine"),
  text-font-serif-2: (value: "Alegreya", fallback: "Crimson Pro"),
  text-font-sans:    (value: "Fira Sans", fallback: "Liberation Sans"),
  text-font-mono:    (value: "JuliaMono", fallback: "Inconsolata"),
  text-font-greek:   (value: "SBL BibLit", fallback: "Linux Libertine"),
  text-font-math:    (value: "TeX Gyre Termes Math", fallback: "TeX Gyre Termes Math"),
  text-size: 12pt,
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


