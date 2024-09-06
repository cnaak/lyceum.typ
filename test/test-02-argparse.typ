#import "@local/lyceum:0.0.1": *

#show: lyceum.with(
  title: "Attonitus Neurons",
  authors: (
    "Domina Cassava",
    (
      name: "van-Nun",
      given-name: "Paulus",
    ),
  ),
  keywords: ("cavillatio", "cassava", "stirpe", "ventum"),
  publisher: "Portae Sinistrae Inferorum",
  location: "Narnia Australis",
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

