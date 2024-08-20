/// Writes thw "root" metadata at the current point in the document
///
/// This is used by `book`, and is _not_ meant to be a user's function.
///
/// - the-meta (dictionary)
///   The `book`'s top-level `META` dictionary.
///
/// - the auth (dictionary)
///   The `book`'s compiled `AUTHORS` dictionary.
///
/// -> none
#let root-meta(the-meta, the-auth) = [
  #metadata((
      SECT: "FRONT", // or BODY, or BACK, for *-MATTER
      META: the-meta,
      AUTH: the-auth,
  )) <root>
]

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
    if the-matter in ("FRONT", "BODY", "BACK") [#metadata(the-matter) <matter>]
  }
}

