//============================================================================================//
//                                      book-element.typ                                      //
//============================================================================================//


//--------------------------------------------------------------------------------------------//
//                                      Matter Functions                                      //
//--------------------------------------------------------------------------------------------//

#let SET-FRONT-MATTER() = context {
  let matter-before-here = query(selector(<lyceum-matter>).before(here()))
  assert.eq(
    matter-before-here.len(), 0,
    message: "[lyceum]: can't SET-FRONT-MATTER() more than once",
  )
  [#metadata("FRONT")<lyceum-matter>]
}

#let SET-BODY-MATTER() = context {
  let matter-before-here = query(selector(<lyceum-matter>).before(here()))
  let values-before-here = ()
  for elem in matter-before-here {
    values-before-here.push(elem.value)
  }
  assert(
    "FRONT" in values-before-here,
    message: "[lyceum]: SET-BODY-MATTER() must follow SET-FRONT-MATTER()",
  )
  assert(
    "BODY" not in values-before-here,
    message: "[lyceum]: can't SET-BODY-MATTER() more than once",
  )
  [#metadata("BODY")<lyceum-matter>]
}

#let SET-BACK-MATTER() = context {
  let matter-before-here = query(selector(<lyceum-matter>).before(here()))
  let values-before-here = ()
  for elem in matter-before-here {
    values-before-here.push(elem.value)
  }
  assert(
    "BODY" in values-before-here,
    message: "[lyceum]: SET-BACK-MATTER() must follow SET-BODY-MATTER()",
  )
  assert(
    "BACK" not in values-before-here,
    message: "[lyceum]: can't SET-BACK-MATTER() more than once",
  )
  [#metadata("BACK")<lyceum-matter>]
}


//--------------------------------------------------------------------------------------------//
//                                   Typesetting Functions                                    //
//--------------------------------------------------------------------------------------------//

#let MAKE-TITLE-PAGE(META) = {
  page(
    numbering: none,
    header: none,
    footer: none,
  )[
    #v(40mm)
    #block(width: 100%,)[
      #set text(size: 32pt)
      #align(center)[*#META.title.value*]
    ]
    #v(2fr)
    #block(width: 100%,)[
      #set text(size: 14pt)
      *#META.authors.first().name,*
      *#META.authors.first().given-name*
    ]
    #v(1fr)
    #block(width: 100%,)[
      #set text(size: 12pt)
      #META.publisher, \
      #META.location
    ]
    #v(1fr)
    #block(width: 100%,)[
      #set text(size: 12pt)
      #align(center)[#META.date.display()]
    ]
  ]
}

