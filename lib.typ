#import "src/meta-parsing"

//============================================================================================//
//                                     Metadata Functions                                     //
//============================================================================================//

/// Writes the "matter" metadata at the current point in the document
///
/// This is used by the "-matter" functions, and is not meant to be a direct
/// user's function.
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
    if the-matter in ("FRONT", "BODY", "BACK") [#metadata(the-matter)<lyceum-matter>]
  }
}


//============================================================================================//
//                                       User Functions                                       //
//============================================================================================//

/// Top-level function for the lyceum template global show rule
///
/// - title (none, string, array, dictionary)
///   The title of the template item
///
/// - authors (none, string, array, dictionary)
///   The authors data of the template
///
/// - keywords (none, string, array)
///   The template subject keywords
///
/// - date (none, auto, datetime)
///   The template date
///
/// - body (contents)
///   The entire document contents passed by the main `show` rule.
///
/// -> none
#let lyceum(
  title: none,
  authors: none,
  keywords: none,
  date: none,
  body
) = {

  // Complete META
  // =============
  let META = (:)

  // META.title
  META.title = dict-from(
    title, keys: (
      "value",
      "short",
    )
  )

  // META.authors - Pass 1
  META.authors = ()
  if type(authors) == array {
    for an-author in authors {
      META.authors.push(
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
          )
        )
      )
    }
  } else {
    META.authors.push(
      dict-from(
        if type(an-author) == type("") {
          name-splitting(authors)
        } else {
          an-author
        }, keys: (
          "name",
          "given-name",
          "preffix",
          "suffix",
          "short",
        )
      )
    )
  }

  // META.authors - Pass 2
  for i in range(META.authors.len()) {
    if META.authors.at(i).short == "" {
      META.authors.at(i).short =  META.authors.at(i).name
      META.authors.at(i).short += initials-of(META.authors.at(i).given-name)
    }
  }

  // AUTHORS - A convenient compilation from META.authors
  let AUTHORS = ()
  for AUTH in META.authors {
    AUTHORS.push(AUTH.short)
  }

  // META.keywords
  META.keywords = array-from(keywords, missing: "")

  // META.date
  if date == auto {
    META.date = datetime.today()
  }
  if type(date) == datetime {
    META.date = date
  }

  // META.bibkey
  META.bibkey = if AUTHORS.len() == 1 {
      str(META.date.year()) + "-" + AUTHORS.at(0)
    } else if AUTHORS.len() >= 2 {
      str(META.date.year()) + "-" + (AUTHORS.first(), AUTHORS.last()).join("+")
    }
  META.bibkey += "-" + initials-of(META.title.value)

  // Sets up document metadata
  set document(
    title: [#META.title.value],
    author: AUTHORS.join(" and "),
    keywords: META.keywords,
  )

  // Metadata writings
  [#metadata(META)<lyceum-meta>]

  // Writes the root metadata into the document
  [#metadata(AUTHORS)<lyceum-auth>]

  // Sets-up FRONT-MATTER
  matter-meta("FRONT")

  // Sets-up self-bib-entry
  let self-bib-entry = (
    META.bibkey + ":",
    "  title:",
    "    value: " + META.title.value,
    "    short: " + META.title.short,
    "  author:",
  )
  for A in META.authors {
    self-bib-entry.push("    - name: " + A.name)
    self-bib-entry.push("      given-name: " + A.given-name)
    self-bib-entry.push("      preffix: " + A.preffix)
    self-bib-entry.push("      suffix: " + A.suffix)
  }
  self-bib-entry.push("  date: " + str(META.date.year()) + "-" + str(META.date.month()))
  [#metadata(self-bib-entry.join("\n"))<self-bib-entry>]

  // Format settings
  set page(
    margin: (top: 16pt, bottom: 24pt),
    numbering: "i",
    number-align: center + bottom,
  )
  set heading(
    numbering: "1",
    outlined: true,
  )

  body
}

