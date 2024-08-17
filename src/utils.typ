#let initials-of(a-name) = {
  ret = ()
  for c in a-name {
    if c == upper(c) { // TODO: true for space + punct
      ret.push(c)
    }
  }
  return ret.join("")
}

#let name-to-short(the-name) = {
  if the-name.contains(",") {
    // "Name, Some Author" --> "NameSA"
    let name-split = the-name.split(",")
    let last-name = name-split.at(0)
    let oth-names = name-split.at(1)
  } else {
    // "Some Author Name"  --> "NameSA"
  }
}

