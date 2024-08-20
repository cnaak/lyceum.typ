#import "@local/lyceum:0.1.0": book

#show: book.with(
  title: "My Book Title",
  author: (
    "Foo Bar",
    "Yours, Truly",
    "Rebecca St-James",
    "Jéan-Mark des-Ormeaux",
    "Καίσαρος Αὐγούστου",
    (
      name: "van-'s-Gravendeel",
      given-name: "Jaapjun",
      preffix: "Sir",
      suffix: "III",
    ),
    "Johannes D. van-der-Waals",
  ),
  keywords: ("cornucopia", "verborhea"),
)

