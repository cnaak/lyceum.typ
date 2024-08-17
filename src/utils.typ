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

/// This function returns a short form of the provided `full-name`.
///
/// #example(`#name-to-short("Pétry, Foo Bar des-Ormeaux")`)
///
/// - full-name (string): The provided full name to shorten, either in `Last, First`, or `First
///   Last` forms. In case of malformed `full-name`, no abbreviation is performed nor attempted,
///   and the `full-name` is returned without modifications.
/// -> string
#let name-to-short(full-name) = {
  if full-name.contains(",") {
    // "Name, Some Author" --> "NameSA"
    let name-split = full-name.split(",")
    let last-name = name-split.at(0).replace(regex("\s"), "")
    let first-names = name-split.at(1)
    return last-name + initials-of(first-names)
  }
  if full-name.contains(regex("\s")) {
    // "Some Author Name"  --> "NameSA"
    let name-split = full-name.split(regex("\s"))
    let last-name = name-split.pop()
    let first-names = name-split
    return last-name + initials-of(first-names.join(" "))
  }
  if full-name.contains(regex("\p{Uppercase}")) {
    // "SomethingLikeThis" --> "ThisSL"
    let name-split = full-name.split(regex("\p{Uppercase}"))
    let last-name = name-split.pop()
    let first-names = name-split
    return last-name + initials-of(first-names.join(" "))
  }
  // "somethingelse"
  return full-name
}

