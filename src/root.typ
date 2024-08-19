#import "./src/util.typ": *


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
/// -> none
#let book(title, author, keywords, date) = {

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
    META.author.insert(
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

  // Sets up document metadata
  document(
    title: META.title.value,
    author: META...,
    keywords: META...,
    date: META.date,
  )

  // Typesets the title page
}

