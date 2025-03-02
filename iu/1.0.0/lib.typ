#let template(course: str, tutor: str) = (doc) => [
  #set page(
    // Papierformat: DIN A4
    paper: "a4",

    // Seitenränder: 2 cm
    margin: 2cm,

    // Seitenzahlen: Zentriert am Seitenende
    number-align: center + bottom,
  )

  #set text(
    lang: "de",

    // Schrifttyp: Arial (Sans) 11pt
    font: "Liberation Sans",
    size: 11pt,
  )

  // Schrifttyp: Überschriften: 12 Pkt
  #show heading: text.with(size: 12pt)

  // Deckblatt ///////////////////////////////////////////////////////////////////

  #align(center + horizon)[
    // Art der Arbeit
    #text(size: 30pt)[Advanced Workbook]

    // Studiengang - Kursbezeichnung
    #text(size: 26pt)[Cybersecurity - #course]

    #parbreak() \

    #grid(
      columns: (1fr, 1fr),
      text(size: 22pt)[
        // Name Verfasser
        Leon Schumacher \
        // Matrikelnummer
        Mat.\#: IU14104259
      ], //
      text(size: 22pt)[
        // Name Tutor
        #tutor \
        Tutor
      ]
    )

    #parbreak() \

    // Datum
    #text(size: 20pt)[#datetime.today().display()] \

    #align(bottom, image("logo.svg"))

  ]
  #pagebreak()

  // Verzeichnisse ///////////////////////////////////////////////////////////////

  // msoffice line height correction logic
  #let leading = 1.5em
  #let leading = leading - 0.75em

  #set text(top-edge: 1em)
  #set block(spacing: 2em)

  #set par(
    // Zeilenabstand: 1,5
    leading: leading,

    // Satz: Blocksatz
    justify: true,

    // Absätze: 6 Pkt. Abstand
    spacing: leading + 6pt,
  )

  // Seitenzahlen: Seiten vor dem Textteil mit römischen Großbuchstaben
  #set page(numbering: "I")

  // Seitenzahlen: Seitenzahl auf dem Deckblatt erscheint nicht
  // (Beginn also hier ab 2)
  #counter(page).update(2)

  #outline()

  // Seitenzahlen: Seiten des Textteils mit arabischen Zahlen
  #set page(numbering: "1")
  #counter(page).update(1)

  // Gleichungen: nummeriert und referenziert als (1)
  #set math.equation(numbering: "(1)")
  #show ref: it => {
    let eq = math.equation
    let el = it.element

    if el != none and el.func() == eq {
      $#numbering(//
          el.numbering, //
          ..counter(eq).at(el.location()))$
    } else { it }
  }

  #doc
]

#let subtaskS = state("subtask", 0)
#let nextSubtask() = {
  subtaskS.update(x => x + 1)
  pagebreak()
}

#let taskheadings() = (doc) => [
  #set heading(numbering: (..nraw) => {
    let n = nraw.pos()
    let level = n.len()

    if level == 1 {
      [
        Aufgabenstellung
        #numbering("1", ..n):
      ]
      subtaskS.update(1)
    }
    else if level == 2 [
      Teilaufgabe
      #numbering("1.1", ..(n.at(0), subtaskS.get())):
    ]
  })

  #show heading: it => {
    if it.level == 1 {
      pagebreak()
    }
    it
  }

  #doc
]
