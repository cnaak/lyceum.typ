#import "@preview/lyceum:0.1.0": book

#show: book.with(
  title: "Book title",
  affiliations: (
    (
      institution: "One Institution",
      research-group: "Socrates Research Group",
      location: "Far City, Far Country",
      affiliated: (
        (
          name: "An Author's Name",
          role: "author",
          corresponding: true,
          email: "name@socrates.one.edu.far",
        ),(
          name: "Beltrane Foo",
          role: "author",
          corresponding: false,
        ),
      ),
    ),(
      institution: "Another Institution",
      research-group: "Plato Research Group",
      location: "Near City, Near Country",
      affiliated: (
        (
          name: "Feldchor Bar",
          role: "author",
          corresponding: false,
          email: "barf@plato.another.edu.near",
        ),
      ),
    ),
  ),
  publisher: "Zpecial8 Books, Inc.",
  date: datetime.today().display(),
)

