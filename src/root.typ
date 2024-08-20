#import "utils.typ": *

/// Writes thw "root" metadata at the current point in the document
///
/// This is used by `book`, and is _not_ meant to be a user's function.
///
/// - the-meta (dictionary)
///   The `book`'s top-level `META` dictionary.
///
/// - the auth (dictionary)
///   The `book`'s compiled `AUTHORS` dictionary.
///
/// -> none
#let root-meta(the-meta, the-auth) = [
  #metadata((
      SECT: "FRONT", // or BODY, or BACK, for *-MATTER
      META: the-meta,
      AUTH: the-auth,
  )) <root>
]

/// Writes the "matter" metadata at the current point in the document
///
/// - the-matter (string)
///   One of the allowed "matter" indicators, i.e.,
///   whether: "FRONT", "BODY", "BACK" -matter.
///
///   In case of invalid argument, the function silently exits, doing nothing.
///
/// -> none
#let matter-meta(the-matter) = {
  if type(the-matter) == type("") {
    if the-matter in ("FRONT", "BODY", "BACK")
      [#metadata(the-matter) <matter>]
    }
  }
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

  // Writes the matter metadata into the document
  matter-meta("FRONT")

  // Typesets the title page
  [
    #context {
      query(<matter>)
    }
  ]
}

