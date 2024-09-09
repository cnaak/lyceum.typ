#import "@local/lyceum:0.0.1": *

#show: FRONT-MATTER.with()

= Metadata

With the `lyceum` academic book template, the metadata is only accessible to the user/writer by
querying:

#let META = context query(<lyceum-meta>).at(0).value
#let AUTH = context query(<lyceum-auth>).at(0).value
#let FMAT = context query(<lyceum-fmt>).at(0).value

The `<lyceum-meta>` metadata tag contains document metadata: \
#META.

The `<lyceum-auth>` metadata tag contains compiled author metadata: \
#AUTH.

The `<lyceum-fmt>` metadata tag contains document formatting data: \
#FMAT

