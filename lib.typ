#import "src/meta-parsing.typ": meta-parse
#import "src/book-matter.typ"

//============================================================================================//
//                                       User Functions                                       //
//============================================================================================//

#let lyceum(
  title: (value: "Default Lyceum Title", short: "Default"),
  authors: ((preffix: "Dr.", given-name: "Lyceum", name: "Default", suffix: "Jr."), ),
  publisher: "Default Lyceum Publisher",
  location: "Default City, Lyceum Country",
  keywords: ("lyceum", "default"),
  date: auto, // auto => datetime.today()
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

  // Metadata writings
  [#metadata(META)<lyceum-meta>]

  // Writes the root metadata into the document
  [#metadata(AUTHORS)<lyceum-auth>]

  // Writes the self-bib-entry
  [#metadata(META.self-bib-entry.join("\n"))<self-bib-entry>]

  // Sets-up FRONT-MATTER
  // matter-meta("FRONT")

  body
}


