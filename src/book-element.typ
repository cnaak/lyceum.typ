//============================================================================================//
//                                      book-element.typ                                      //
//============================================================================================//


//--------------------------------------------------------------------------------------------//
//                                      Matter Functions                                      //
//--------------------------------------------------------------------------------------------//

#let SET-FRONT-MATTER() = context {
  let matter-before-here = query(selector(<lyceum-matter>).before(here()))
  let front-in-document = "FRONT" in matter-before-here
  assert(
    not front-in-document,
    message: "[lyceum]: can't set FRONT matter more than once!",
  )
  [
    `matter-before-here` = #matter-before-here \
    `front-in-document` = #front-in-document \
    `not front-in-document` = #not front-in-document \
  ]
  [#metadata("FRONT")<lyceum-matter>]
}


