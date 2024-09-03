#import "@local/lyceum:0.1.0": *

#show: lyceum.with(
  title: "My Book Title",
  authors: (
    "Yours, Truly",
    "Jéan-Mark des-Ormeaux",
    "Καίσαρος Αὐγούστου",
    (
      name: "van-'s-Gravendeel",
      given-name: "Jaapjun",
      preffix: "Sir",
      suffix: "III",
    ),
  ),
  keywords: ("polyglossia", "logomania"),
  date: auto,
)

= Metadata

== Title
#META.title

== Authors
#META.authors

== Keywords
#META.keywords

== Date
#META.date

#pagebreak()

Text after the page break.

