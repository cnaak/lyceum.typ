#import "./src/util.typ": *

/// Top-level function for book metadata and general formatting settings
///
/// - title (string, dictionary)
///   The title of the book item
///
/// -> none
#let book(title, author, keywords, date) = {

  // Complete META
  // =============
  let META = (:)

  // META.title
  // ----------
  if true in (
    type(title) == type(none),
    title == "",
    title == (),
    title == (:),
  ) { META.insert(title: (value: "", short: "",)) } else {
    if type(title) == string {
      META.insert(title: (value: title, short: ""))
    }
    if type(title) == array {
      title = flatten(title)
      for ii in range(title.len()) {
        title.at(ii) = str(title.at(ii))
      }
      META.insert(title: (value: title.join(" "), short: ""))
    }
    if type(title) == dictionary {
      META.insert(title: (:))
      if "value" in title { META.title.value = title.value }
      if "short" in title { META.title.short = title.short }
    }
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

