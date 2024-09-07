// #import "@preview/lyceum:0.0.1": lyceum
#import "@local/lyceum:0.0.1": lyceum, SET-BODY-MATTER, SET-APPENDIX, SET-BACK-MATTER

#show: lyceum.with(
  // Document metadata
  title: (
    value: "Igneous Rocks \u{2013} The Hard Science",
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
  page-size: "a5",
  page-margin: (inside: 30mm, rest: 25mm),
  page-binding: left,
  page-fill: color.yellow.lighten(80%),
  text-font: ("EB Garamond", "Linux Libertine"),
  text-size: 12pt,
  lang-name: "en",
)

// The lyceum auto-generates the title page
// and enters FRONT-MATTER styling

= Preface

Here goes the book preface.

= Contents
#outline(title: none)

// Book contents should be placed in BODY-MATTER
#SET-BODY-MATTER()

= Introduction

Now this is a regular chapter.

= Rock Properties

A second chapter.

// Appendices should be placed in APPENDIX
#SET-APPENDIX()

= Tables of Properties of Igneous Rocks

This is an Appendix.

// Bibliography and Indices should be placed in BACK-MATTER
#SET-BACK-MATTER()

= Bibliography

Here goes the bibliography.

= Subject Index

Here goes the subject index.

= Citing This Book

/* The `lyceum` package auto-generates self-citation information. It is available as document
`metadata` accessible by Typst's introspection system: */

#{
  let self-bib = context query(<self-bib-entry>).first().value
  set par(leading: 0.5em)
  set text(font: "Inconsolata", size: 9pt, weight: "bold", fill: color.blue.darken(50%))
  self-bib
}

