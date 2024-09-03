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

With the `lyceum` template, the document's metadata is only accessible by querying:

#context {
  let META = query(lyceum-meta)
  let AUTH = query(lyceum-auth)
  let MATT = query(lyecum-matter)
}

Metadata is #META.

Authoring is #AUTH.

Matter is #MATT.

#pagebreak()

Text after the page break.

