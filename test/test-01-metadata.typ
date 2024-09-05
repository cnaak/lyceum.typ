#import "@local/lyceum:0.1.0": *

#show: lyceum.with(
  /*
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
  */
)

= Metadata

With the `lyceum` template, the document's metadata is only accessible by querying:

#let META = context query(<lyceum-meta>).at(0).value
#let AUTH = context query(<lyceum-auth>).at(0).value
#let MATT = context query(<lyceum-matter>)

Metadata is #META.

Authoring is #AUTH.

Matter is #MATT.

#pagebreak()

// #matter-meta("BODY")

This belongs to the `"BODY"` matter.

// #matter-meta("BACK")

And this belongs to the `"BACK"` matter.

