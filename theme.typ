#let htwk-theme = (
  // Main glossary section
  section: (title, body) => {
    heading(level: 1, numbering: none, title, outlined: false)
    body
  },
  

  // Group of related terms
  group: (name, index, total, body) => {
    // index = group index, total = total groups
    if name != "" and total > 1 {
      heading(level: 2, numbering: none, name)
    }
    body
  },

  // Individual glossary entry
  entry: (entry, index, total) => {
    // index = entry index, total = total entries in group
    let output = [#entry.short#entry.label] // **NOTE:** Label here!
    if entry.long != none {
      output = [#output -- #entry.long]
    }
    if entry.description != none {
      output = [#output: #entry.description]
    }
    block(
      grid(
        columns: (auto, 1fr, auto),
        output,
        //repeat([#h(0.25em) . #h(0.25em)]),
        //entry.pages.join(", "),
      )
    )
  }
)