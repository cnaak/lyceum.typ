/// Top-level function for book metadata and general formatting settings
///
/// - 
#let book(

  // Book title structure
  title: (
    value: "Title: Complement",
    short: "Title",
  ),

  // Affiliations structure
  affiliations: (
    (
      institution: "",
      research-group: "",
      location: "City, Country",
      roles: (
        author-list: (
          ( // First author
            name: "Baz",
            given-name: "Foo Bar",
            prefix: "Dr.",
            suffix: "III",
            alias: "Codename",
          ), ( // Second author
            name: "Zab",
            given-name: "Oof Rab",
            prefix: "MSc.",
          ), // Other authors..
        ),
        // Other role lists, including and limited to:
        //    translator, afterword, foreword, introduction, annotator, commentator, holder,
        //    compiler, collaborator, organizer, producer, executive-producer, writer, director,
        //    illustrator, editor.
        // as in "translator-list", "afterword-list", etc...
      )
    ),
    // Another institution...
  ),

  // Publisher structure
  publisher: (
    name: (
      value: "",
      short: "",
    ),
    location: "",
    url: "",
  ),

  // Serial number structure
  serial-number: (
    isbn: "",
    doi: "",
    ddc: "",
    udc: "",
  ),

)
