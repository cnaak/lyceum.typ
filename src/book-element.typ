//============================================================================================//
//                                      book-element.typ                                      //
//============================================================================================//


//--------------------------------------------------------------------------------------------//
//                                      Matter Functions                                      //
//--------------------------------------------------------------------------------------------//

#let is-no-matter() = context { // Tests whether no matter has been set
  let m-arr = query(<lyceum-matter>, before(here()))
  [#m-arr]
}

#let SET-BOOK-MATTER(the-matter) = {
  if the-matter in ("FRONT", "BODY", "BACK") {
    [#metadata(the-matter)<lyceum-matter>]
  }
}


