//============================================================================================//
//                                      book-element.typ                                      //
//============================================================================================//


//--------------------------------------------------------------------------------------------//
//                                      Matter Functions                                      //
//--------------------------------------------------------------------------------------------//


#let SET-FRONT-MATTER() = context {
  assert(
    "FRONT" not in query(selector(<lyceum-matter>).before(here())),
    message: "[lyceum]: can't set FRONT matter more than once!",
  )
  [#metadata("FRONT")<lyceum-matter>]
}


