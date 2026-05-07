#import "/util.typ": *
#import "@preview/cetz:0.4.2"

== Stand der Forschung <sec:ue-place-forschungsstand>
Sowohl in der Forschung als auch in industriellen Anwendungen existiert nur wenig veröffentlichte Literatur zur Platzierung von Umlenkelementen.

Im @CBT erfolgt die Bestimmung der Positionen der @UE derzeit iterativ und ist auf einfache Wandkonfigurationen ohne Ausschnitte oder Hindernisse beschränkt. Ausgehend von den eingegebenen Abmessungen der Wand werden zunächst die Randabstände (Paddings) berücksichtigt, bevor in einer festen Abfolge eine Liste von Koordinaten der @UE:pl in Millimetern erzeugt wird. Zunächst werden die @UE:pl entlang der Ober- und Unterkante der Wand von links nach rechts alternierend platziert. Anschließend werden die @UE:pl nach der Sonderstelle an der linken sowie rechten Seite der Wand entweder von oben nach unten oder umgekehrt platziert, je nach dem wo das letzte @UE im vorherigen Schritt platziert wurde. Die Reihenfolge der Berechnung ist in @fig:rollenplatzierung-cbt dargestellt. Auf diese Weise ergibt sich genau eine relevante Sonderstelle, die sich entweder in der unteren rechten (a) oder oberen rechten (b) Ecke der Wand befindet. Eine automatisierte Erweiterung dieses Verfahrens für Wandkonfigurationen mit Hindernissen oder Aussparungen ist bislang nicht umgesetzt. Daher müssen weitere Arbeiten mit ähnlichen Problemstellungen untersucht werden.

#figure(
  grid(
    columns: (auto, auto),
    rows: (auto, auto),
    column-gutter: 10%,
    row-gutter: 2%,
    cetz.canvas({
      import cetz.draw: *
      
      scale(0.3)

      let width = 8
      let height = 6
      let names = ()
      for (x,i) in range(width - 1).enumerate() {
        let pos = (2+ x*2, if calc.even(x) {0} else {height*2})
        circle(pos, name: "v" + str(i))
        names.push("v" + str(i))
        content(pos, [#(i+1)])
      }
      for (y,i) in range(height - 1).enumerate() {
        let pos = (if calc.odd(y) {0} else {width*2}, 2 + y*2)
        circle(pos, name: "h" + str(i))
        names.push("h" + str(i))
        content(pos, [#(i+width)])
      }
      circle((width*2-2, 0), stroke:(paint: red))
      circle((width*2, 2), stroke:(paint: red))
      rect-around(
        ..names,
        padding: 1
      )
    }),
    cetz.canvas({
      import cetz.draw: *
      
      scale(0.3)

      let width = 9
      let height = 6
      let names = ()
      for (x,i) in range(width - 1).enumerate() {
        let pos = (2+ x*2, if calc.even(x) {0} else {height*2})
        circle(pos, name: "v" + str(i))
        names.push("v" + str(i))
        content(pos, [#(i+1)])
      }
      for (y,i) in range(height - 1, 0, step: -1).enumerate() {
        let pos = (if calc.odd(y) {0} else {width*2}, 2 + y*2)
        circle(pos, name: "h" + str(i))
        names.push("h" + str(i))
        content(pos, [#(i+width - 1)])
      }
      circle((width*2-2, height*2), stroke:(paint: red))
      circle((width*2, height*2 - 2), stroke:(paint: red))
      rect-around(
        ..names,
        padding: 1
      )
    }),
    [(a)],
    [(b)]
  ),
  
  caption: [Reihenfolge der Positionierung der UE im aktuellen Ansatz des CBT für einfache Wände ohne Tür- oder Fensterausschnitt. In Rot sind die UE der Sonderstelle markiert.]
)<fig:rollenplatzierung-cbt>

// TU Dresden
Im Unterschied zum @CBT untersuchten #citep(<frieseRobotAssistedManufacturingTechnology2023>) die automatisierte Garnablage für dreidimensionale Skelette, einschließlich der Planung der Bewegungsbahnen eines Roboterarms. Die räumlichen Positionen der Pins werden dabei jedoch als gegeben und strukturell konsistent vorausgesetzt und nicht eigenständig berechnet. Darüber hinaus werden keine Anforderungen an die Gleichmäßigkeit der resultierenden Struktur, beispielsweise in Form eines Gitters, gestellt.

// String Art
Im kreativen Bereich existieren hingegen Arbeiten, bei denen Künstler mithilfe von Algorithmen Bilder durch das Verlegen von Garn erzeugen (engl. String Art). Häufig dient dabei eine einfache geometrische Form, etwa ein Kreis oder Rechteck, als Rahmen @birsakStringArtComputational2018. Auf diesem Rahmen sind in regelmäßigen Abständen Pins angebracht, um welche das Garn entsprechend der gewünschten Detailtreue geführt wird. Ein solcher Rahmen ist in @fig:string-art-beispiele (a) sowie ein resultierendes Bild mit der entsprechenden Vorlage in (b) zu sehen.

Ein anderer Ansatz wird von #citep(<morris-hillBuildingStringArt2023>) oder Firmen wie Laarco Studio #footnote[Website: https://laarco.com/, Letzter Zugriff: 15.03.2026] verfolgt. Sie platzieren die Pins oder Nägel mithilfe eines Roboterarms auf einer freien Fläche und berechnen anschließend den Pfad des Garns so, dass vorgegebene Bilder möglichst präzise durch den resultierenden Faden dargestellt werden. Dabei wird in dunklen Bildbereichen mehr Garn verlegt, während helle Bereiche mit weniger Fäden dargestellt werden.

Während #citep(<morris-hillBuildingStringArt2023>) die Pins in einem gleichmäßigen Raster oder in zufällig gewählten Positionen aufstellt, werden bei Laarco Studios die Pins bereits im Vorfeld so positioniert, dass sie für die Struktur des Bildes günstig liegen, beispielsweise entlang der Konturen eines Gesichts oder mit geringerer Dichte in großen hellen Flächen. Auch hier steht jedoch nicht die Erzeugung einer gleichmäßigen Struktur im Fokus. Erkenntnisse aus der entsprechenden Forschung wurden zudem nicht veröffentlicht.


#figure(
  grid(
    columns: (35%, 35%),
    rows: (auto, auto),
    row-gutter: 3%,
    column-gutter: 8%,
    image("/images/string-art-naegel.png", height: 35%),
    image("/images/string-art-hund.png", height: 35%),
    [(a)],
    [(b)]
  ),
  caption: [Rahmen mit regelmäßig aufgestellten Pins (a) sowie Eingabebild und resultierende Garnstruktur (b) bei String Art von #citep(<birsakStringArtComputational2018>)]
)<fig:string-art-beispiele>

\

// Schlussfolgerung eigene Lösung
Da keine relevanten Arbeiten zum hier betrachteten Problem identifiziert werden konnten und darüber hinaus spezifische Anforderungen und Restriktionen bestehen, ist die Entwicklung eines eigenen Lösungsansatzes erforderlich.
