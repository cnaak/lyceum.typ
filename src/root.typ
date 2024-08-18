/// Top-level function for book metadata and general formatting settings
///
/// - title (dictionary)
///   with "value" and "short" keys and string values.
///
/// - affiliations (array)
///   of affiliation dictionaries, with institution and authors/contributors data.
///
/// - publisher (dictionary)
///   with "name", "location", and "url" keys.
///
/// - serial-number (dictionary)
///   with "isbn", "doi", "ddc", and "udc" keys.
///
/// - format (dictionary)
///   with "page", and "text" keyed sub-dictionaries.
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

  // Format structure - other parameters are ignored
  format: (
    page: (
      width: 155mm,
      height: 230mm,
      // or paper: "a5",
      flipped: false,
      margin: (
        inside:   30mm,
        outside:  25mm,
        rest:     25mm,
      ),
      binding: left,
      fill: rgb("#e6deca"), // ivory
    ),
    text: (
      font: "Crimson Pro",
      size: 11pt,
      lang: "en",
      region: "US",
    ),
  ),

) = {
}

