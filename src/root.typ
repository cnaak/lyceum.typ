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
/// - body (contents)
///   The book's body
///
/// -> none
#let book(
  title: "",
  author: "",
  keywords: (""),
  date: datetime.today(),
  body
) = {

  // Complete META
  // =============
  let META = (:)

  META.title  = dict-from(
    title, keys: (
      "value",
      "short",
    )
  )

  META.author = ()
  for an-author in author {
    META.author.push(
      dict-from(
        author, keys: (
          "name",
          "given-name",
          "preffix",
          "suffix",
          "alias",
        )
      )
    )
  }
  let AUTHORS = ()
  for AUTH in META.author {
    AUTHORS.push(
      name-to-short(
        (AUTH.name, AUTH.given-name).join(", ")
      )
    )
  }

  META.keywords = array-from(keywords, missing: "")

  META.date = date

  // Sets up document metadata
  document(
    title: META.title.value,
    author: AUTHORS.join(" and "),
    keywords: META.keywords,
    date: META.date,
  )

  // Typesets the title page
}

