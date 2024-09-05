#import "src/meta-parsing.typ": meta-parse
#import "src/book-matter.typ"

//============================================================================================//
//                                       User Functions                                       //
//============================================================================================//

#let lyceum(
  // Bibliography metadata
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
  // Formatting metadata
  page-width: 155mm,
  page-height: 230mm,
  page-margin: (
    inside: 30mm,
    rest: 25mm,
  ),
  page-binding: left,
  page-fill-hue: 45deg, // for ivory-like
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

  // Sets-up FRONT-MATTER
  // matter-meta("FRONT")

  // Metadata writings
  [#metadata(META)<lyceum-meta>]

  // Writes the root metadata into the document
  [#metadata(AUTHORS)<lyceum-auth>]

  // Writes the self-bib-entry
  [#metadata(META.self-bib-entry.join("\n"))<self-bib-entry>]

  body
}


