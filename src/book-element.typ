//============================================================================================//
//                                      book-matter.typ                                       //
//============================================================================================//

#let matter-meta(the-matter) = {
  if type(the-matter) == type("") {
    if the-matter in ("FRONT", "BODY", "BACK") [#metadata(the-matter)<lyceum-matter>]
  }
}


