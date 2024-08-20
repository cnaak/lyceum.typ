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
  let RET = (:)
  if full-name.contains(",") {
    // Possibly "Name, Some Author"
    let name-split = full-name.split(",")
    let last-name = name-split.at(0).replace(regex("\s"), "")
    let first-names = name-split.at(1)
    RET.insert("name", last-name)
    RET.insert("given", first-names)
    RET.insert("short", last-name + initials-of(first-names))
    return RET
  }
  if full-name.contains(regex("\s")) {
    // Possibly "Some Author Name"
    let name-split = full-name.split(regex("\s"))
    let last-name = name-split.pop()
    let first-names = name-split
    RET.insert("name", last-name)
    RET.insert("given", first-names)
    RET.insert("short", last-name + initials-of(first-names))
    return RET
  }
  if full-name.contains(regex("\p{Uppercase}")) {
    // Possibly "SomethingLikeThis"
    let name-split = full-name.split(regex("\p{Uppercase}"))
    let last-name = name-split.pop()
    let first-names = name-split
    RET.insert("name", last-name)
    RET.insert("given", first-names)
    RET.insert("short", last-name + initials-of(first-names))
    return RET
  }
  // "somethingelse"
  return (full: full-name)
}


