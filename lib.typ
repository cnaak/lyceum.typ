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

  // Metadata
  let META = meta-parse(meta)

  body
}


