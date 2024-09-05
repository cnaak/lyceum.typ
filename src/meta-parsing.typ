//============================================================================================//
//                                      meta-parsing.typ                                      //
//============================================================================================//


#let meta-parse(meta) = {
  //--------------------------------------------------------------------------------//
  //                              Auxiliary Functions                               //
  //--------------------------------------------------------------------------------//

  let dict-from(item, keys: ("value", "short"), missing: "") = {
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

  let array-from(item, missing: "") = {
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

  let initials-of(first-names) = {
    let ret = ()
    let M = first-names.matches(regex("\b[-\w]"))
    for m in M { ret.push(m.text) }
    return ret.join("")
  }

  let name-splitting(full-name) = {
    let RET = (unprocessed: full-name)
    if full-name.contains(",") {
      // Possibly "Name, Some Author"
      let name-split = full-name.split(",")
      let last-name = name-split.at(0).replace(regex("\s"), "")
      let first-names = name-split.at(1).trim(regex("\s"), repeat: true)
      RET.insert("name", last-name)
      RET.insert("given-name", first-names)
      RET.insert("short", last-name + initials-of(first-names))
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
      return RET
    }
    // "somethingelse"
    return RET
  }

  //--------------------------------------------------------------------------------//
  //                                   Main Code                                    //
  //--------------------------------------------------------------------------------//

  // META initialization
  let META = (:)

  // META.title
  META.title = dict-from(
    meta.title, keys: (
      "value",
      "short",
    )
  )

  // META.authors - Pass 1
  META.authors = ()
  if type(meta.authors) == array {
    for an-author in meta.authors {
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
        if type(meta.authors) == type("") {
          name-splitting(meta.authors)
        } else {
          meta.authors
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

  // META.keywords
  META.keywords = array-from(meta.keywords, missing: "")

  // META.date
  if meta.date == auto {
    META.date = datetime.today()
  }
  if type(meta.date) == datetime {
    META.date = meta.date
  } else if meta.date == none {
    META.date = datetime.today()
  }

  // AUTHORS - A convenient compilation from META.authors
  let AUTHORS = ()
  for AUTH in META.authors {
    AUTHORS.push(AUTH.short)
  }

  // META.bibkey
  META.bibkey = if AUTHORS.len() == 1 {
      str(META.date.year()) + "-" + AUTHORS.at(0)
    } else if AUTHORS.len() >= 2 {
      str(META.date.year()) + "-" + (AUTHORS.first(), AUTHORS.last()).join("+")
    }
  META.bibkey += "-" + initials-of(META.title.value)

  // META.self-bib-entry
  META.self-bib-entry = (
    META.bibkey + ":",
    "  title:",
    "    value: " + META.title.value,
    "    short: " + META.title.short,
    "  author:",
  )
  for A in META.authors {
    META.self-bib-entry.push("    - name: " + A.name)
    META.self-bib-entry.push("      given-name: " + A.given-name)
    META.self-bib-entry.push("      preffix: " + A.preffix)
    META.self-bib-entry.push("      suffix: " + A.suffix)
  }
  META.self-bib-entry.push("  date: " + META.date.display())

  // Return values
  return (META, AUTHORS)
}


