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
    fill: rgb(255, 226, 122),
    inset: 8pt,
    radius: 6pt,
    baseline: 40%,
    [
      #text(weight: "bold", fill: rgb(209, 152, 6), font: "JetBrains Mono")[💡 Idee:] #body
    ]
  )
}