// #import "@preview/lyceum:0.1.0": FRONT-MATTER
#import "@local/lyceum:0.1.0": FRONT-MATTER, BODY-MATTER, APPENDIX, BACK-MATTER

#let TEXT-SIZE = 12pt

//----------------------------------------------------------------------------//
//                                FRONT-MATTER                                //
//----------------------------------------------------------------------------//

#show: FRONT-MATTER.with(
  // Document metadata
  title: (
    title: "Igneous Rocks",
    subtitle: "The Hard Science",
    sep: " - ",
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
      location: "Rockbridge, Faraway Country",
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
  date: datetime(year: 2024, month: 9, day: 13), // auto => datetime.today()
  // Document general format
  page-size: (width: 155mm, height: 230mm),
  page-margin: (inside: 30mm, rest: 25mm),
  page-binding: left,
  page-fill: color.hsl(45deg, 15%, 85%),  // ivory
  text-font: ("EB Garamond", "Linux Libertine"),
  text-size: TEXT-SIZE,
  lang-name: "en",
)

// The lyceum auto-generates the title page and enters FRONT-MATTER styling

#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}

= Preface

Here goes the book preface. #lorem(50)

= Contents

#outline(
  title: none,
  target: heading.where(level: 1),
  indent: auto,
)


//----------------------------------------------------------------------------//
//                                BODY-MATTER                                 //
//----------------------------------------------------------------------------//

#show: BODY-MATTER.with(TEXT-SIZE, "Chapter")

= Introduction

#lorem(120)

== Sub-Section

#lorem(30)

= Methodology

#lorem(50)


//----------------------------------------------------------------------------//
//                                  APPENDIX                                  //
//----------------------------------------------------------------------------//

#show: APPENDIX.with(TEXT-SIZE, "Appendix")

= Tables of Properties

#lorem(50)


//----------------------------------------------------------------------------//
//                                BACK-MATTER                                 //
//----------------------------------------------------------------------------//

#show: BACK-MATTER.with(TEXT-SIZE)

= Citing This Book

The following is the _auto-generated_, self bibliography database entry for the *`hayagriva`*
manager:

#block(width: 100%)[
  #let self-bib = context query(<self-bib-entry>).first().value
  #set par(leading: 0.5em)
  #text(font: "Inconsolata", size: 9pt, weight: "bold")[
    #self-bib
  ]
]


