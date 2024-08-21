#import "@local/lyceum:0.1.0": *

#let (
  title, authors, keywords, date
) = template.with(
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

This is after `template` call. Are global metadata available? Let's check!

= Metadata

== Title
#title

== Authors
#authors

== Keywords
#keywords

== Date
#date

