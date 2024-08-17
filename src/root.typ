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
      location: "Far City, Far Country",
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

)
