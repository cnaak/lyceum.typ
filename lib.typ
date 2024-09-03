//============================================================================================//
//                                    Auxiliary Functions                                     //
//============================================================================================//

/// This function returns a dictionary with the provided keys, based on the provided item.
///
/// - item (none, string, array, dictionary)
///   the data source for the return dictionary
///
/// -> dictionary
#let dict-from(item, keys: ("value", "short"), missing: "") = {
  // Initializations
  let RET = (:)
  for key in keys {
    RET.insert(key, missing)
  }
  // Empty tests
  if true in (
    type(item) == type(none),
    item == "",
    item == (),
    item == (:),
  ) {
    return RET
  }
  // String processing
  if type(item) == type("") {
    RET.at(keys.at(0)) = item
  }
  // Array processing: flatten -> string -> join
  if type(item) == array {
    item = item.flatten()
    for ii in range(item.len()) {
      item.at(ii) = str(item.at(ii))
    }
    RET.at(keys.at(0)) = item.join(" ")
  }
  // Dictionary processing: get fields
  if type(item) == dictionary {
    for key in keys {
      if key in item {
        RET.at(key) = item.at(key)
      }
    }
  }
  return RET
}

/// This function returns an array with the provided strings, based on the provided item.
///
/// - item (none, string, array)
///   the data source for the return array
///
/// -> array
#let array-from(item, missing: "") = {
  // Initializations
  let RET = ()
  // Empty tests
  if true in (
    type(item) == type(none),
    item == "",
    item == (),
  ) {
    return (missing, )
  }
  // String processing
  if type(item) == type("") {
    RET.push(item)
  }
  // Array processing: flatten -> string
  if type(item) == array {
    item = item.flatten()
    for ii in item {
      RET.push(str(ii))
    }
  }
  return RET
}

/// This function returns first name initials of the provided `first-names`.
///
/// #example(`#initials-of("Foo Bar des-Ormeaux")`)
///
/// #example(`#initials-of("Καίσαρος Αὐγούστου")`)
///
/// - first-names (string): The provided first names to abbreviate into initials.
/// -> string
#let initials-of(first-names) = {
  let ret = ()
  let M = first-names.matches(regex("\b[-\w]"))
  for m in M { ret.push(m.text) }
  return ret.join("")
}

/// Name splitting function that attempts at extracting name constituents from a given full-name
///
/// - full-name (string)
///   The name to split into it's constituents
///
/// -> dictionary
#let name-splitting(full-name) = {
  let RET = (unprocessed: full-name)
  if full-name.contains(",") {
    // Possibly "Name, Some Author"
    let name-split = full-name.split(",")
    let last-name = name-split.at(0).replace(regex("\s"), "")
    let first-names = name-split.at(1).trim(regex("\s"), repeat: true)
    RET.insert("name", last-name)
    RET.insert("given-name", first-names)
    RET.insert("short", last-name + initials-of(first-names))
    RET.insert("bibliography", (last-name, first-names).join(", "))
    return RET
  }
  if full-name.contains(regex("\s")) {
    // Possibly "Some Author Name"
    let name-split = full-name.split(regex("\s"))
    let last-name = name-split.pop()
    let first-names = name-split.join(" ")
    RET.insert("name", last-name)
    RET.insert("given-name", first-names)
    RET.insert("short", last-name + initials-of(first-names))
    RET.insert("bibliography", (last-name, first-names).join(", "))
    return RET
  }
  if full-name.contains(regex("\p{Uppercase}")) {
    // Possibly "SomethingLikeThis"
    let name-split = full-name.split(regex("\p{Uppercase}"))
    let last-name = name-split.pop()
    let first-names = name-split.join(" ")
    RET.insert("name", last-name)
    RET.insert("given-name", first-names)
    RET.insert("short", last-name + initials-of(first-names))
    RET.insert("bibliography", (last-name, first-names).join(", "))
    return RET
  }
  // "somethingelse"
  return RET
}


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

  META.title = dict-from(
    title, keys: (
      "value",
      "short",
    )
  )

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
        )
      )
    )
  }
  let AUTHORS = ()
  for AUTH in META.authors {
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

  // Metadata writings
  [#metadata(META)<lyceum-meta>]

  // Writes the root metadata into the document
  [#metadata(AUTHORS)<lyceum-auth>]

  // Sets-up FRONT-MATTER
  matter-meta("FRONT")

  // Sets-up self-bib-entry
  let self-bib-entry = (
    "self-bib-entry:",
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
  self-bib-entry.push("  date: " + META.date.year)
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

