#let citep(..citation) = {
  cite(..citation,form: "prose")
}

#let todo(body) = {
  box(
    fill: rgb(255, 220, 220),
    inset: 8pt,
    radius: 6pt,
    baseline: 40%,
    [
      #text(weight: "bold", fill: red, font: "JetBrains Mono")[🚧 TODO:] #body
    ]
  )
}

#let maybe(body) = {
  box(
    fill: rgb("#fef8b4"),
    inset: 8pt,
    radius: 6pt,
    baseline: 40%,
    [
      #text(weight: "bold", fill: rgb("#ff9008"), font: "JetBrains Mono")[💡 Idee:] #body
    ]
  )
}

#let question(body) = {
  box(
    fill: rgb("#bed5fe"),
    inset: 8pt,
    radius: 6pt,
    baseline: 40%,
    [
      #text(weight: "bold", fill: rgb("#0635b5"), font: "JetBrains Mono")[🛈 Frage an Betreuer:]\
       #body
    ]
  )
}

#let overarrow(content) = {
  return $accent(content, arrow)$
}