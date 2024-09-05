//============================================================================================//
//                                      book-element.typ                                      //
//============================================================================================//


//--------------------------------------------------------------------------------------------//
//                                      Matter Functions                                      //
//--------------------------------------------------------------------------------------------//

#let matters-so-far() = context {
  return query(selector(<lyceum-matter>).before(here()))
}

#let SET-FRONT-MATTER() = {
  assert(
    ("FRONT" not in matters-so-far()),
    message: "[lyceum]: can't set FRONT matter more than once!",
  )
  [#metadata("FRONT")<lyceum-matter>]
}


