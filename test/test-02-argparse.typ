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

With the `lyceum` academic book template, the  metadata is only accessible to the user/writer by
querying:

#let META = context query(<lyceum-meta>).at(0).value
#let AUTH = context query(<lyceum-auth>).at(0).value

The `<lyceum-meta>` metadata tag contains: \
#META.

The `<lyceum-auth>` metadata tag contains: \
#AUTH.

