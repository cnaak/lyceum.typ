// #import "@preview/lyceum:0.0.1": lyceum
#import "@local/lyceum:0.0.1": FRONT-MATTER, BODY-MATTER, APPENDIX, BACK-MATTER


//----------------------------------------------------------------------------//
//                                FRONT-MATTER                                //
//----------------------------------------------------------------------------//

#show: FRONT-MATTER.with(
  // Document metadata
  title: (
    title: "Igneous Rocks",
    subtitle: "The Hard Science",
    short: "Igneous Rocks",
  ),
  authors: (
    (
      given-name: "Evelyn D.",
      name: "Crump",
      affiliation: "Rocks Hard Research Group",
      email: "crumped@rockshard.org.far",
      location: "Rich Mines, Faraway Country",
    ), (
      preffix: "Sir.",
      given-name: "Effie J.",
      name: "Hitchcock",
      suffix: "Jr.",
      affiliation: "Hard University",
      email: "hitchcockej@hard.edu.far",
      location: "Cambridge, Faraway Country",
    ),
  ),
  editors: ("Cenhelm, Erwin", ),
  publisher: "Lyceum Publisher",
  location: "Lyceum City, Faraway Country",
  affiliated: (
    illustrator: ("Revaz Sopheap", ),
    organizer: "Darko Sergej",
  ),
  keywords: ("igneous", "rocks", "geology", ),
  date: datetime(year: 2024, month: 9, day: 6), // auto => datetime.today()
  // Document general format
  page-size: (width: 155mm, height: 230mm),
  page-margin: (inside: 30mm, rest: 25mm),
  page-binding: left,
  page-fill: color.hsl(45deg, 15%, 85%),  // ivory
  text-font: ("EB Garamond", "Linux Libertine"),
  text-size: 12pt,
  lang-name: "en",
)

// The lyceum auto-generates the title page and enters FRONT-MATTER styling

= Preface

Here goes the book preface.

#lorem(50)

= Contents

#outline(title: none)


//----------------------------------------------------------------------------//
//                                BODY-MATTER                                 //
//----------------------------------------------------------------------------//

#show: doc => BODY-MATTER(doc)


//············································································//
//                                  Chapter                                   //
//············································································//

= Introduction

Now this is a regular chapter.

#lorem(60)

== Section

#lorem(200)

== Section

#lorem(200)

//············································································//
//                                  Chapter                                   //
//············································································//

= Rock Properties

A second chapter.

#lorem(70)

== Section

#lorem(60)

#lorem(200)


//----------------------------------------------------------------------------//
//                                  APPENDIX                                  //
//----------------------------------------------------------------------------//

#show: doc => APPENDIX(doc)


//············································································//
//                              Appendix Chapter                              //
//············································································//

= Tables of Properties of Igneous Rocks

This is an Appendix.

#lorem(30)

== Inorganic Salts

Subsection text.

#lorem(100)

#lorem(200)

//············································································//
//                              Appendix Chapter                              //
//············································································//

= Tables of Properties of Other Rocks

This is an Appendix.

#lorem(30)

== Inorganic Salts

Subsection text.

#lorem(100)

#lorem(200)

== Organic Salts

Subsection text.

#lorem(100)

#lorem(200)


//----------------------------------------------------------------------------//
//                                BACK-MATTER                                 //
//----------------------------------------------------------------------------//

#show: doc => BACK-MATTER(doc)


//············································································//
//                                Back Chapter                                //
//············································································//

= Bibliography

Here goes the bibliography.

//············································································//
//                                Back Chapter                                //
//············································································//

= Subject Index

Here goes the subject index.

//············································································//
//                                Back Chapter                                //
//············································································//

= Citing This Book

The following is the _auto-generated_, self bibliography database entry for the `hayagriva`
manager:

#block(width: 100%)[
  #let self-bib = context query(<self-bib-entry>).first().value
  #set par(leading: 0.5em)
  #text(font: "Inconsolata", size: 9pt, weight: "bold", fill: color.blue.darken(50%))[
    #self-bib
  ]
]

