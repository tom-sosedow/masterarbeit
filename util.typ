#let citep(..citation) = {
  cite(..citation,form: "prose")
}

#let __infobox(color: color, title, body) = {
  box(
    fill: color.lighten(70%),
    inset: 8pt,
    radius: 6pt,
    baseline: 40%,
    [
      #text(weight: "bold", fill: color, font: "JetBrains Mono")[#title]\
      #body
    ]
  )
}

#let todo(body) = __infobox( color: red, [🚧 TODO:], body)

#let maybe(body) = __infobox( color: rgb("#ff9008"), [💡 Idee:], body)

#let question(body) = __infobox( color: rgb("#0635b5"), [🛈 Frage an Betreuer:], body)

#let definition(title, body) = {
  box(
    inset: 8pt,
    stroke: (paint: black.lighten(30%)),
    baseline: 40%,
    [
      #text(weight: "bold", font: "Liberation Sans")[Definition] _ #title _\
      #body
    ]
  )
}

#let ymax = $y_"max"$
#let xmax = $x_"max"$
#let tx1 = $t_(1,x)$
#let tx2 = $t_(1,y)$
#let ty1 = $t_(2,x)$
#let ty2 = $t_(2,y)$
#let overarrow(content) = {
  return $accent(content, arrow)$
}