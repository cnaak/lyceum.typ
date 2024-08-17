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

  // Publisher structure
  publisher: (
    name: (
      value: "ABZ-XYC-ÖÖÖ Publishing Tents",
      short: "ABZ-XYC-ÖÖÖ",
    ),
    location: "Far City, Far Country",
    url: "www9.abz-xyc-ööö-pubtent.com.far",
  ),

  // Serial number structure
  serial-number: (
    isbn: "",
    doi: "",
    ddc: "",
    udc: "",
  ),

)
