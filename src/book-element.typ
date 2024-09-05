//============================================================================================//
//                                      book-element.typ                                      //
//============================================================================================//


//--------------------------------------------------------------------------------------------//
//                                      Matter Functions                                      //
//--------------------------------------------------------------------------------------------//

#let SET-FRONT-MATTER() = context {
  let matter-before-here = query(selector(<lyceum-matter>).before(here()))
  let values-before-here = ()
  for elem in matter-before-here {
    values-before-here.push(elem.value)
  }
  assert(
    "FRONT" not in values-before-here,
    message: "[lyceum]: can't set FRONT matter more than once!",
  )
  [
    `matter-before-here` = #matter-before-here \
    `values-before-here` = #values-before-here \
  ]
  [#metadata("FRONT")<lyceum-matter>]
}


