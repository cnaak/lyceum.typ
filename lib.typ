#import "src/meta-parsing.typ"
#import "src/book-matter.typ"

//============================================================================================//
//                                       User Functions                                       //
//============================================================================================//

#let lyceum(
  meta: (
    title: (value: "Book Title", short: "Title"),
    authors: ((preffix: "Dr.", given-name: "John", name: "Smith", suffix: "II"), ),
    publisher: "SOME Publishing Company",
    location: "Faraway City, Far Country",
    keywords: ("key1", "key2"),
    date: auto, // auto => datetime.today()
  ),
  body
) = {

  //--------------------------------------------------------------------------------//
  //                                    Metadata                                    //
  //--------------------------------------------------------------------------------//

  // Parse metadata information
  let (META, AUTHORS) = meta-parse(meta)

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
  [#metadata(self-bib-entry.join("\n"))<self-bib-entry>]

  // Sets-up FRONT-MATTER
  matter-meta("FRONT")

  body
}


