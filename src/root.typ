#import "utils.typ": *

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
          name-splitting(an-author), keys: (
            "name",
            "given-name",
            "preffix",
            "suffix",
            "alias",
            "short",
            "bibliography",
          )
        )
      )
    }
  } else {
    META.author.push(
      dict-from(
        name-splitting(author), keys: (
          "name",
          "given-name",
          "preffix",
          "suffix",
          "alias",
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
  if "date" in META {
    set document(
      title: [#META.title.value],
      author: AUTHORS.join(" and "),
      keywords: META.keywords,
      date: META.date,
    )
  } else {
    set document(
      title: [#META.title.value],
      author: AUTHORS.join(" and "),
      keywords: META.keywords,
    )
  }

  // Typesets the title page
  [
    #META

    title = #META.title.value

    authors = #AUTHORS.join(" and ")

  ]
}

