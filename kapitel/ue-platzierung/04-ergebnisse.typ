#import "/util.typ": *
#import "@preview/cetz:0.4.2"

== Ergebnisse <sec:ue-place-result>

Die resultierenden Wandkonfigurationen dieses iterativen Lösungsansatzes werden nun dargestellt. Wie in @sec:ue-place-problem gezeigt, existieren konzeptionell lediglich 32 zu betrachtende Kombinationen von Wanddimensionen. Für jede dieser Kombinationen wurde eine Wand nach dem oben beschriebenen Ansatz generiert und empirisch evaluiert. Die generierten Anordnungen sind in @appendix:wandkonfigurationen zu sehen. In allen Fällen konnten vollständig valide Platzierungen berechnet werden. Die vollständige Beispielkonfiguration einer Wand mit den in @sec:ue-place-implementation berechneten Positionen der @UE ist in @fig:fully-placed-ue-wall dargestellt. Der Versatz $omega$ des obersten linken @UE ist in Blau dargestellt und beträgt in diesem Beispiel $1$. 

#figure(
  cetz.canvas({
    import cetz.draw: *

    scale(0.5)
    
    let rolls = (
      (4,9), 
      (15,9),
      (-1,8), 
      (10,8), 
      (4,7), 
      (15,7), 
      (-1,6), 
      (10,6), 
      (4,5), 
      (15,5), 
      (-1,4), 
      (10,4), 
      (15,3), 
      (-1,2),
      (15,1),
       
      (0,10), 
      (1,0), 
      (2,10), 
      (3,0), 
      (5,0), 
      (6,3),
      (7,0), 
      (8,3), 
      (9,0), 
      (11,0), 
      (12,10), 
      (13,0),
      (14,10),
    )

    for (index, point) in rolls.map((p) => (p.at(0), -1*p.at(1))).enumerate() {
      circle(point, radius: (0.5,0.5))
      content(point, [#index])
    }

    circle((15, -9), radius: (0.5,0.5), fill: red)
    content((15, -9),[$1$])
    circle((14, -10), radius: (0.5,0.5), fill: red)
    content((14, -10),[$27$])
    
    circle((4, -3), radius: (0.5,0.5), fill: blue)
    content((4, -3),[$11$])
    circle((-1,0), radius: (0.5,0.5), fill: green)
    content((-1, 0),[$28$])
    circle((10,-10), radius: (0.5,0.5), fill: green)
    content((10, -10),[$29$])
    line((10,-10),(10,-8), mark: (end: "|", start: "|"), stroke: green.darken(50%))
    line((10,-10),(12,-10), mark: (end: "|", start: "|"), stroke: green.darken(50%))
    content((12,-8.8), text(fill:green.darken(50%), size: 9pt)[$d_M = 2d$])

    line((0,0),(1,0), mark: (end: ">>"), stroke: (paint: blue))
    content((0.2,-0.5), text(fill:blue)[$omega$])

    line((-2,1),(16,1))
    line((16,1),(16,-11))
    line((16,-11),(9,-11))
    line((9,-11),(9, -4))
    line((9, -4), (5,-4))
    line((5,-11),(5, -4))
    line((5, -11),(-2,-11))
    line((-2,-11),(-2,1))

  }),
  caption: [Kleine Wandkonfiguration mit korrekt platzierten Umlenkelementen und Reihenfolge der Berechnung. In Rot dargestellt ist eine Sonderstelle, in Grün optionale UE und in Blau das UE, welches den oberen Versatz $omega$ bestimmt. (eigene Darstellung)]
)<fig:fully-placed-ue-wall>

Die Positionen der @UE sind in allen Fällen zulässig, da die in @sec:ue-place-problem aufgestellten Rahmenbedingungen eingehalten werden. Durch die in @sec:ue-place-implementation beschriebenen optionalen @UE in den Ecken der Wand werden womöglich @UE platziert, welche für die spätere Routenplanung irrelevant sind. Ihre Anzahl begrenzt sich in diesen Fällen auf maximal drei eventuell überflüssige @UE, welche nach der Routenplanung aus dem Ablageprogramm entfernt werden können.

Die durchschnittliche Rechenzeit beträgt 0,08 Millisekunden, während die maximal gemessene Rechenzeit bei 24 Millisekunden über alle 32 Testläufe lag. Die Tests wurden auf einem Intel(R) Core(TM) i5-8350U Prozessor mit 24 GB Arbeitsspeicher durchgeführt.

In @appendix:robotcode ist der für eine beispielhafte Wandkonfiguration erzeugte Code des Roboterarms hinterlegt. Dieser besteht aus einem Header zur Konfiguration, den zwei Anweisungen je @UE für das Greifen vom Magazin und der Platzierung auf dem Ablagetisch, sowie einem Footer, um unter anderem den Greifer für die @UE abzulegen.