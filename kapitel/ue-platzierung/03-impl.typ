#import "/util.typ": *
#import "@preview/cetz:0.4.2"
#import "@preview/algorithmic:1.0.7"
#import algorithmic: style-algorithm, algorithm-figure, Call

== Iterative Lösungsmethode <sec:ue-place-implementation>

Die im folgenden Abschnitt vorgestellte Lösungsmethode ist stark an die derzeit verwendete Methode des @CBT zur Berechnung der Positionen der @UE:pl:long angelehnt. Es wird wieder iterativ vorgegangen, allerdings wird der Ablauf für die komplexeren Anforderungen erweitert und angepasst.

// Tür zuerst
Aufgrund der begrenzten Möglichkeiten zur Platzierung der @UE am Türausschnitt werden diese Positionen zuerst bestimmt, um etwaige Einschränkungen für die spätere Routenplanung zu reduzieren. Standardmäßig wird dabei ein @UE in der unteren linken Ecke der Tür bei Position $p_0 = (tx1, ymax-1)$ platziert. Aus diesem lassen sich anschließend alle Positionen der übrigen @UE ableiten.

// vertikale Rollen links und rechts
Dafür werden zunächst die @UE an den vertikal verlaufenden Seiten der Tür und Wand bestimmt, da die @UE auf der linken Seite der Tür auf gleicher Höhe wie die auf der rechten Seite der Wand liegen und analog auch für die rechte Seite der Tür und linke Seite der Wand. Dafür werden, ausgehend von $p_0$, von $y=ymax-1$ bis $y=1$ die beiden auf dem jeweiligen $y$ liegenden @UE:pl alternierend platziert. Folgender Pseudocode veranschaulicht das Vorgehen. In dieser Abbildung liegt das @UE 1 an Position $p_0$. 

#show: style-algorithm
#figure(
  stack(
    spacing: 10pt,
    algorithm-figure(
      "Vertikale UE platzieren",
      supplement: "Algorithmus",
      vstroke: .5pt + luma(200),
      {
        import algorithmic: *
        Function(
          "PlaceVertGE",
          ("A", $xmax$, $ymax$, $t_1$, $t_2$),
          {
            Assign[$y$][$ymax-1$]
            While(
              $y >= 1$,
              {
                Comment[Spaltenindex, in dem das UE an der Tür platziert werden muss]
                Assign($t x$, IfElseInline($(ymax - 1 - y) mod 2= 0$, $tx1$, $tx2$))
                LineBreak
                Comment[Spaltenindex, in dem das UE am Rand der Wand platziert werden muss]
                Assign($w x$, IfElseInline($(ymax - 1 - y) mod 2= 0$, $xmax$, $0$))
                LineBreak
                If($y > ty1$, Assign($A$, $A union {(t x, y)}$))
                Assign[$A$][$A union {(w x, y)}$]
                Assign[$y$][$y - 1$]
              }
            )
            Return[$A$]
          },
        )
      }
    ),
    box(
      inset: (top: -110pt, right: -250pt),
      cetz.canvas(background: white, {
        import cetz.draw: *

        scale(0.4)
        
        let rolls = (
          (4,9), (15,9),(-1,8),(10,8),(4,7), (15,7),(-1,6),(10,6),(4,5), (15,5),(-1,4),(10,4),(15,3),(-1,2),(15,1),
        )
        grid((-1.5,0.5),(15.5,-10.5), stroke: (paint: gray.transparentize(50%)))
        rect((4.52,-3.52),(9.48,-11), fill: white, stroke: none)

        for (index, point) in rolls.map((p) => (p.at(0), -1*p.at(1))).enumerate() {
          circle(point, radius: (0.5,0.5), stroke: (paint: green.darken(40%)))
          content(point, text(fill:green.darken(40%))[#{index+1}])
        }

        line((-2,1),(16,1))
        line((16,1),(16,-11))
        line((16,-11),(9,-11))
        line((9,-11),(9, -4))
        line((9, -4), (5,-4))
        line((5,-11),(5, -4))
        line((5, -11),(-2,-11))
        line((-2,-11),(-2,1))

      }),
    ),

  ),
  caption: [Algorithmus zur Platzierung der UE an den vertikalen Seiten der Wand und resultierende Positionen und Berechnungsreihenfolge.]
)<fig:ue-place-step-1>


Durch die Lage des obersten @UE an der linken und rechten Seite des Türausschnitts, in @fig:ue-place-step-1 in diesem Fall @UE 12, lassen sich die Positionen der @UE:pl an der Oberseite des Türausschnitts bestimmen. So wird, falls das oberste @UE bei $(tx1, ty1+1)$ liegt, kein @UE auf den anliegenden Nachbarfeldern ${(x,ty1) | tx1 <= x <= tx1 +1}$ platziert. In @fig:oberkante-türausschnitt sind diese unzulässigen Positionen rot und das ausschlaggebende Seitenelement blau markiert. Liegt das oberste @UE, wie in @fig:ue-place-step-1, bei $(tx2, ty1+1)$, können keine @UE an den Stellen ${(x,ty1) | tx2-1 <= x <= tx2}$ abgelegt werden. So wird verhindert, dass in den oberen Türecken @UE diagonal nebeneinander liegen und sich somit eine Sonderstelle bildet.

#figure(
  cetz.canvas({
    import cetz.draw: *

    scale(0.3)
    
    for p in (3, 7) {
      circle((p,2), stroke: (paint: green))
    }
    for p in (0, 4, 8) {
      circle((p - 3,8), stroke: (paint: gray))
    }
    circle((9,8), stroke: (paint: gray, dash: "dashed"))
    circle((-1,0), stroke: (paint: blue))
    circle((-1,-4))
    circle((-1,2), stroke: (paint: red))
    circle((1,2), stroke: (paint: red))
    line((0,1), (12,1))
    line((0,1), (0,-4))
    line((-6,9),(12,9))
  }),
  caption: [Valide Positionen (Grün) und unzulässige Positionen (Rot) von UE an der Oberkante der Tür basierend auf dem obersten Seitenelement (Blau)]
)<fig:oberkante-türausschnitt>


// horizontale Rollen oben und unten, top offset
Die grün markierten @UE an der Oberkante des Türausschnitts bestimmen wiederum die Positionen der @UE an der Oberseite der Wand und damit indirekt auch an der Unterseite. Hierzu wird die Position des am weitesten links liegenden @UE an Position $(x,y)$ an der Oberseite des Türausschnitts mit $t_x$ verglichen (in @fig:fully-placed-ue-wall blau dargestellt):
$ omega = cases(
  0 ", falls" 2 divides.not tx1 and tx1 <= x <= tx1+1 and 2 divides.not (tx2-tx1),
  1 ", falls" 2 divides.not tx1,
  1 ", falls" 2 divides (tx2-tx1) and tx1 <= x <= tx1+1,
  0 ", sonst"
) $
Dabei beschreibt $omega$ den horizontalen Versatz der @UE an der Oberkante der Wand. Die Positionen der @UE dort ergeben sich damit zu:
$ { (x + omega, 0) | 0 < x < xmax, 2 | (x+1)} subset A $

Im zweiten Schritt des Algorithmus kann dann $omega$ genutzt werden, um bei der rechtsläufigen Bewegung die y-Komponente der Position des jeweiligen @UE zu bestimmen. Im folgenden Pseudocode ist das Vorgehen für die Platzierung der @UE:pl an den horizontalen Seiten einschließlich der Oberseite der Tür veranschaulicht.


#figure(
  stack(
    spacing: 10pt,
    algorithm-figure(
      "Horizontale UE platzieren",
      supplement: "Algorithmus",
      vstroke: .5pt + luma(200),
      {
        import algorithmic: *
        Function(
          "PlaceHorizGE",
          ("A", $xmax$, $ymax$, $t_1$, $t_2$, $t_h$),
          {
            
            Comment[Ist _wahr_, falls oberstes @UE an der linken Seite der Tür liegt, _falsch_ sonst]
            Assign($t l$, IfElseInline($t_h mod 2 = 0$, $tx1$, $tx2$))
            LineBreak

            Comment[Ist _wahr_, falls der Türausschnitt ein gerades Vielfaches von d breit ist, _falsch_ sonst]
            Assign($t e$, $(tx2 - tx1) mod 2= 1$)
            LineBreak

            Comment[Oberen Versatz $omega$ bestimmen]
            IfElseChain(
              $tx1 mod 2 = 1 and not t l and t e$, Assign($omega$, $0$),
              $tx1 mod 2 = 1 or (t e and not t l)$, Assign($omega$, $1$),
              Assign($omega$, $0$),
            )
            LineBreak
            Assign($x_0$, [$omega + 1$ #CommentInline[x-Komponente der am weitesten links stehenden UE an der Oberseite]])
            Assign($x$, $1$)
            While(
              $x < xmax$,
              {
                IfElseChain(
                  $(x-x_0) mod 2 = 0$, Assign($y$, [$0$ #CommentInline[Platzierung an Oberseite der Wand]]),
                  $tx1 <= x <= tx2$, Assign($y$, [$ty1$ #CommentInline[Platzierung an Oberseite der Tür]]),
                  Assign($y$, [$ymax$ #CommentInline[Platzierung an Unterseite der Wand]])
                )
                LineBreak
                Comment[Nur ein @UE platzieren, falls keins bereits in der Zelle darunter liegt]
                If(
                  $A inter {(x,y+1)} = emptyset$,
                  Assign[$A$][$A union {(x,y)}$]
                )
                Assign($x$, $x+1$)
              }
            )
            Return[$A$]
          },
        )
      }
    ),
    box(
      inset: (top: -90pt, right: -250pt),
      cetz.canvas(background: white, {
        import cetz.draw: *

        scale(0.4)
        
        let rollsVert = (
          (4,9), (15,9),(-1,8),(10,8),(4,7), (15,7),(-1,6),(10,6),(4,5), (15,5),(-1,4),(10,4),(15,3),(-1,2),(15,1),
        )
        grid((-1.5,0.5),(15.5,-10.5), stroke: (paint: gray.transparentize(50%)))
        rect((4.52,-3.52),(9.48,-11), fill: white, stroke: none)

        for (index, point) in rollsVert.map((p) => (p.at(0), -1*p.at(1))).enumerate() {
          circle(point, radius: (0.5,0.5))
        }

        let rollsHor = ((0,10), (1,0), (2,10), (3,0),(4,3), (5,0), (6,3),(7,0), (8,3), (9,0), (11,0), (12,10),(13,0),(14,10))

        for (index, point) in rollsHor.map((p) => (p.at(0), -1*p.at(1))).enumerate() {
          circle(point, radius: (0.5,0.5), stroke: (paint: green.darken(40%)))
          content(point, text(fill:green.darken(40%))[#{index+1}])
        }
        circle((10,-4), stroke: (paint: red), radius: (0.5,0.5))
        line((-2,1),(16,1))
        line((16,1),(16,-11))
        line((16,-11),(9,-11))
        line((9,-11),(9, -4))
        line((9, -4), (5,-4))
        line((5,-11),(5, -4))
        line((5, -11),(-2,-11))
        line((-2,-11),(-2,1))

      }),
    ),

  ),
  caption: [Algorithmus zur Platzierung der UE an den horizontalen Seiten der Wand und resultierende Positionen und Berechnungsreihenfolge.]
)<fig:ue-place-step-2>

In den ersten 15 Zeilen werden dabei Hilfsvariablen angelegt, um unter anderem die Seite des in @fig:ue-place-step-2 rot markierten @UE zu bestimmen oder zu prüfen, ob der Türausschnitt eine gerade Anzahl an @UE breit ist. In Zeile 17 wird der Spaltenindex berechnet, an dem das am weitesten links stehende @UE an der Oberseite der Wand liegen muss. Basierend darauf muss die y-Komponente der übrigen @UE:pl an den horizontalen Seiten angepasst werden. Diese wird innerhalb der Schleife in Zeilen den 20 bis 26 berechnet. Danach steht die Koordinate des zu platzierenden @UE fest. Bevor es zur Menge der Knoten hinzugefügt werden kann, muss allerdings sichergestellt sein, dass in der jeweiligen Spalte kein @UE in der Zeile darunter durch #text(font: "JetBrains Mono", weight: "thin", size: 9pt)[PlaceVertGE] platziert wurde. In @fig:ue-place-step-2 ist dieses Element rot markiert und verhindert somit, dass bei $(tx2,ty1)$ ein @UE platziert wird, da sonst eine Art Sonderstelle entstehen würde.

// Optionale Rollen in den Ecken
In den äußersten Ecken der Wand sowie den unteren Ecken des Türausschnitts kann es außerdem vorkommen, dass die beiden nächstgelegenen @UE jeweils eine Manhattan-Distanz von genau $d_M = 2d$ zur Ecke besitzen. In diesem Fall besteht die Möglichkeit, ein zusätzliches @UE zu platzieren, welches optional in der Routenplanung verwendet werden kann, um größere Freiheitsgrade bei der Gestaltung der Umlenkungen zu erhalten. In @fig:ue-place-step-3 sind diese zusätzlichen @UE grün sowie der Pseudocode des Vorgehens dargestellt.

#figure(
  stack(
    spacing: 10pt,
    algorithm-figure(
      "Optionale UE platzieren",
      supplement: "Algorithmus",
      vstroke: .5pt + luma(200),
      {
        import algorithmic: *
        Comment[Hilfsfkt.: Prüft, ob in den angrenzenden Feldern in den Himmelsrichtungen ein @UE platziert ist]
        Function("hatKeineNachbarn", ($x$, $y$), {
          Assign($M$, $A inter {(x,y-1),(x,y+1),(x-1,y),(x+1,y)}$)
          Return($|M| = 0$)
        })
        LineBreak

        Function(
          "PlaceOptionalGE",
          ("A", $xmax$, $ymax$, $t_1$, $t_2$),
          {
            Comment[Positionen aller Ecken der Wand und Tür]
            Assign($p s$, ${(0,0), (0,ymax),(xmax,0),(xmax,ymax),(tx1,ymax),(tx2,ymax)}$)
            
            For($(x,y) in p s$, {
              let ns = Call.with("hatKeineNachbarn")
              If($"hatKeineNachbarn"(x,y)$, Assign($A$, $A union {(x,y)}$))
            })
            Return[$A$]
          },
        )
      }
    ),
    box(
      inset: (top: -85pt, right: -250pt),
      cetz.canvas(background: white, {
        import cetz.draw: *

        scale(0.4)
        
        let rolls = ((4,9), (15,9),(-1,8), (10,8), (4,7), (15,7), (-1,6), (10,6), (4,5), (15,5), (-1,4), (10,4), (15,3), (-1,2),(15,1),(0,10), (1,0), (2,10), (3,0), (5,0), (6,3),(7,0), (8,3), (9,0), (11,0), (12,10), (13,0),(14,10), (4,3))
        grid((-1.5,0.5),(15.5,-10.5), stroke: (paint: gray.transparentize(50%)))
        rect((4.52,-3.52),(9.48,-11), fill: white, stroke: none)

        for (index, point) in rolls.map((p) => (p.at(0), -1*p.at(1))).enumerate() {
          circle(point, radius: (0.5,0.5))
        }

        circle((-1,0), radius: (0.5,0.5), stroke: (paint: green.darken(40%)))
        circle((10,-10), radius: (0.5,0.5), stroke: (paint: green.darken(40%)))
        line((-2,1),(16,1))
        line((16,1),(16,-11))
        line((16,-11),(9,-11))
        line((9,-11),(9, -4))
        line((9, -4), (5,-4))
        line((5,-11),(5, -4))
        line((5, -11),(-2,-11))
        line((-2,-11),(-2,1))

      }),
    ),

  ),
  caption: [Algorithmus zur Platzierung der optionalen UE an den Ecken der Wand und resultierende Positionen]
)<fig:ue-place-step-3>

Da die Streben, die an diesen @UE enden, aus struktureller Sicht nicht erforderlich sind, müssen diese Elemente nicht zwingend in der Routenplanung berücksichtigt werden. Wird auf ihre Nutzung verzichtet, entfällt auch ihre Platzierung durch den Roboterarm, wodurch Zeit und Energie eingespart werden können.
