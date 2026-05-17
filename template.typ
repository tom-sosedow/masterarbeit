#import "@preview/glossy:0.9.0": *
#import "theme.typ": htwk-theme
#import "glossary.typ": my-glossary

#let font = "Liberation Serif"

#let titlepage(
  name: [Ihr Familienname],
  vorname: [Ihr Vorname],
  gebdatum: [Ihr Geburtsdatum],
  ort: [Ihr Geburtsort],
  betreuer: [Titel Vorname Familienname Ihres Betreuers],
  betreuer2: [name ihres Betreuers],
  thema: [Titel ihrer Arbeit],
  datum: [tt. mm. jjjj],
  studiengang: [Studiengang],
  fakultaet: [Ihre Fakultät],
  thesis: "bsc",
  // body,
) = {
  let arbeit = if thesis == "bsc" [Bachelorabeit] else [Masterarbeit]
  let kuerzel = if thesis == "bsc" [B.Sc.] else [M.Sc.]

  set page(
    margin: 2.5cm,
  )
  set text(
    size: 12pt,
    font: font,
  )
  set align(center)
  let space = 0pt
  // https://tex.stackexchange.com/questions/24599/what-point-pt-font-size-are-large-etc ... dont ask!
  let large(body) = text(size: 14pt)[#body]
  let Large(body) = text(size: 16pt)[#body]
  let LARGE(body) = text(size: 20pt)[#body]
  let Huge(body) = text(size: 22pt)[#body]

  // Font-Source: https://www.1001fonts.com/latin-modern-roman-font.html
  text(
    weight: "thin",
  )[ \
    #Large[Hochschule für Technik, Wirtschaft und Kultur Leipzig \ ]

    #large(fakultaet) \ \
    #studiengang (#kuerzel)
  ]
  v(1fr)
  Large[#thema]
  v(1fr)
  large[
    #arbeit #v(space)
  ]
  v(1fr)
  large[
    #set text(weight: "thin", size: 12pt)
    vorgelegt von #v(space)
    #upper[#vorname #name] #v(space)
    geboren am #gebdatum in #smallcaps[#ort] #v(space)\ ]
  v(1fr)
  align(left + bottom)[
    Tag der Einreichung: #datum #v(space)
    Verantwortlicher Hochschullehrer: #betreuer \ Betrieblicher Betreuer: #betreuer2
  ]
}

#let selbständigkeit(
  thema: [Titel ihrer Arbeit],
  datum: [tt. mm. jjjj],
  thesis: "bsc",
  signature: [],
) = {
  set page(margin: 3cm)
  set heading(numbering: none)
  v(1cm)
  heading(outlined: false)[Erklärung]
  let arbeit = if thesis == "bsc" [Bachelorabeit] else [Masterarbeit]
  [
    Hiermit erkläre ich, dass ich die eingereichte #arbeit zum Thema _#thema _ selbstständig erarbeitet, verfasst und Zitate kenntlich gemacht habe. Andere als die angegebenen Hilfsmittel wurden von mir nicht benutzt.
    #grid(
      columns: (auto,1fr,auto),
      row-gutter: 10pt,
      [],[],
      signature,
      [Leipzig, #datum],
      [],
      [Unterschrift]
    )
  ]
}

#let abstract(
  title: "Zusammenfassung",
  body,
) = {
  heading(outlined: false, numbering: none)[#title]
  body
}

#let htwk-thesis(
  name: [Ihr Familienname],
  vorname: [Ihr Vorname],
  gebdatum: [Ihr Geburtsdatum],
  ort: [Ihr Geburtsort],
  betreuer: [Vollständiger akad. Titel (z.B. Prof. Dr. rer. nat. habil.) Vorname Familienname Ihres Betreuers / Ihrer Betreuerin],
  betreuer-kurz: [Kurzer akad. Titel (z.B. Prof. Dr.) Vorname Familienname Ihres Betreuers / Ihrer Betreuerin],
  betreuer2: [Name ihres Betreuers],
  thema: [Titel ihrer Arbeit],
  datum: [tt. mm. jjjj],
  fakultaet: [Ihre Fakultät],
  abschluss: "bsc",
  studiengang: [Mathematik oder Technomathematik oder Wirtschaftsmathematik],
  use-default-math-env: true,
  zusammenfassung: [Zusammenfassung Ihrer Arbeit],
  signature: [],
  body,
) = {
  set page(
    margin: 2.5cm,
    paper: "a4",
  )
  set par(justify: true, leading: 1.2em, spacing: 1.4em)
  set math.equation(numbering: "(1)")
  show math.equation.where(block: true): set text(size: 13pt)
  show math.equation.where(block: false): box

  show outline.entry: set block(above: 1.3em)
  show table.cell: set text(size: 10pt)
  set text(
    size: 11pt,
    lang: "de",
    font: font,
  )
  show figure: it => {
    v(1.5em)
    it
    v(1.5em)
  }

  set table(
    fill: (x, y) => if y == 0 {
      gray.lighten(80%)
    },
  )


  // Links
  show link: set text(fill: rgb(0, 0, 238))
  // Überschriften
  set heading(numbering: "1.1.1")

  show heading.where(level: 1): it => {
    set block(
      below: 1cm,
    )
    v(0.5cm)
    block([#it])
  }

  show heading.where(level: 5): set heading(outlined: false, numbering: none, bookmarked: false)

  show heading: it => {
    set block(below: 1.8em, above: 3em)

    set text(font: font)
    let level = it.level
    let heading_index = counter(heading).get().first()

    if level == 1 {
      if it.supplement != [Anhang] and heading_index > 1 {
        pagebreak()
      }
      set text(size: 18pt)
      block([#it])
    } else if level == 2 {
      set text(size: 16pt)
      block([#it])
    } else if level == 3 {
      set text(size: 14pt)
      block([#it])
    } else if level == 4 {
      set text(size: 12pt)
      block([#it])
    } else {
      block(underline([#it]))
    }
  }
  // Variablen
  let header = context { 
    let currentHeading = query(heading.where(level: 1)).find(h => h.location().page() == here().page())
    
    if currentHeading == none {
      let headingBody = query(heading.where(level: 1).before(here()))
      rect(
        align(right, emph[
          #if headingBody.last().numbering != none {
            counter(heading.where(level: 1, numbering: headingBody.last().numbering)).display(headingBody.last().numbering)
            [. ]
            headingBody.last().body
          }
        ]),
        stroke: (bottom: 1pt + black),
        width: 100%,
      )
    }
  }

  titlepage(
    name: name,
    vorname: vorname,
    gebdatum: gebdatum,
    ort: ort,
    betreuer: betreuer,
    betreuer2: betreuer2,
    thema: thema,
    datum: datum,
    studiengang: studiengang,
    thesis: abschluss,
    fakultaet: fakultaet,
  )
  pagebreak()
  abstract(zusammenfassung)

  set page(
    header: header,
    numbering: "I",
  )
  counter(page).update(1)

  selbständigkeit(
    thema: thema,
    datum: datum,
    thesis: abschluss,
    signature: signature
  )

  outline(indent: 1.2em)

  pagebreak(weak: true)
  outline(
    title: [Abbildungsverzeichnis],
    target: figure.where(kind: image),
  )

  pagebreak(weak: true)
  outline(
    target: figure.where(kind: table),
    title: "Tabellenverzeichnis",
  )


  show: init-glossary.with(my-glossary)

  pagebreak(weak: true)
  glossary(
    title: "Abkürzungsverzeichnis", // Optional: defaults to Glossary
    theme: htwk-theme, // Optional: defaults to theme-academic
    sort: true, // Optional: whether or not to sort the glossary
    ignore-case: true, // Optional: ignore case when sorting terms
    show-all: false, // Optional; Show all terms even if unreferenced
  )


  set page(
    numbering: "- 1 -",
  )
  counter(page).update(1)
  body

  set page(
    numbering: none,
  )
}

