#import "utils.typ": *
#import "meta.typ": *

/// Book's front-matter setup function
#let front-matter() = {
  // Meta-data marking
  matter-meta("FRONT")
  // Format settings
  set page(
    numbering: "i",
  )
  set heading(
    numbering: none,
    outlined: true,
  )
}

/// Top-level function for book metadata and general formatting settings
///
/// - title (none, string, array, dictionary)
///   The title of the book item
///
/// - author (none, string, array, dictionary)
///   The author data of the book
///
/// - keywords (none, string, array)
///   The book subject keywords
///
/// - date (none, auto, datetime)
///   The book date
///
/// - body (contents)
///   The book's body
///
/// -> none
#let book(
  title: none,
  author: none,
  keywords: none,
  date: none,
  body
) = {

  // Complete META
  // =============
  let META = (:)

  META.title = dict-from(
    title, keys: (
      "value",
      "short",
    )
  )

  META.author = ()
  if type(author) == array {
    for an-author in author {
      META.author.push(
        dict-from(
          if type(an-author) == type("") {
            name-splitting(an-author)
          } else {
            an-author
          }, keys: (
            "name",
            "given-name",
            "preffix",
            "suffix",
            "short",
            "bibliography",
          )
        )
      )
    }
  } else {
    META.author.push(
      dict-from(
        if type(an-author) == type("") {
          name-splitting(author)
        } else {
          an-author
        }, keys: (
          "name",
          "given-name",
          "preffix",
          "suffix",
          "short",
          "bibliography",
        )
      )
    )
  }
  let AUTHORS = ()
  for AUTH in META.author {
    if "name" in AUTH and "given-name" in AUTH {
      AUTHORS.push(
        (AUTH.name, AUTH.given-name).join(", ")
      )
    }
  }

  META.keywords = array-from(keywords, missing: "")

  if date == auto {
    META.date = datetime.today()
  }
  if type(date) == datetime {
    META.date = date
  }

  // Sets up document metadata
  set document(
    title: [#META.title.value],
    author: AUTHORS.join(" and "),
    keywords: META.keywords,
  )

  // Writes the root metadata into the document
  root-meta(META, AUTHORS)

  // Sets-up FRONT-MATTER
  front-matter()

  // Title page
  [
    #context {
      query(<matter>)
    }
  ]

  // Book's body
  body

}

