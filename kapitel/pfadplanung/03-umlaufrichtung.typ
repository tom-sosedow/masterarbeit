#import "/util.typ": *
#import "@preview/cetz:0.4.2"

== Bestimmung der Umlaufrichtung <sec:path-direction>
// Umlaufrichtung: Bestimmung durch Vektor 

Für die Bestimmung der Umlaufrichtung, in der die @UE:pl umfahren werden sollen, muss zwischen Umlenkungen entlang der Hauptrichtung und zur Änderung der Hauptrichtung unterschieden werden. Bei den meisten @UE wird in Hauptrichtung umgelenkt. In den Ecken der Wand wird eine Änderung der Hauptrichtung vollzogen, sodass die Umlenkungen an diesen Stellen gesondert betrachtet werden müssen. Zur Bestimmung der Umlaufrichtung der Umlenkungen in Hauptrichtung werden zwei Ansätze untersucht. 

Einerseits ist zu beobachten, dass die Umlaufrichtung bei jeder Umlenkung invertiert wird, solange die Hauptrichtung beibehalten wird. Für die in @sec:route-puzzle-based beschriebenen Subgraphen wird also eine 2-Färbung des Graphen gesucht, wobei jede Farbe eine Umlaufrichtung darstellt. Da die Teilroute einen linearen Subgraph aufspannt, gibt es lediglich zwei Möglichkeiten einer 2-Färbung des Graphen, welche von der Färbung des initialen Knotens abhängen. Es müssen also für den Start jeder Teilroute Regeln gefunden werden, welche Färbung der erste Knoten besitzen muss. Eine falsche Zuweisung würde zu vertauschten Umlenkungen in der gesamten Teilroute führen. 

Eine weitere Methode basiert auf einem vektoriellen Ansatz nach #citep(<merschAutomation3DRobotic2025>). Zur Bestimmung der Umlaufrichtung an einem @UE:long $B$ mit Position $overarrow(b)$ werden dessen Vorgänger $A$ mit Position $overarrow(a)$ sowie sein Nachfolger $C$ mit Position $overarrow(c)$ in der Route betrachtet.

Aus dem Vorzeichen des Kreuzprodukts
$p = (overarrow(b) - overarrow(a)) times (overarrow(c) - overarrow(a))$
lässt sich die Umlaufrichtung ableiten. Ist das Kreuzprodukt positiv, liegt $C$ links des Vektors von $A$ nach $B$; bei einem negativen Wert entsprechend rechts davon. Befindet sich $C$ rechts des Vektors $overarrow(b) - overarrow(a)$, ist eine Bewegung im Uhrzeigersinn um $B$ erforderlich, während bei einer Lage auf der linken Seite eine Umlaufbewegung entgegen dem Uhrzeigersinn gewählt wird. Der Sachverhalt ist in @fig:vektorbasierte-umlaufrichtung für $R'$ (links) und $R$ (rechts) dargestellt.

#figure(
  cetz.canvas({
    import cetz.draw: *

    set-style(radius:0.8)
    scale(0.5)
    circle((0,0))
    content((2,0), [A])
    circle((5,8))
    content((3,8), [B])
    line((0,0),(5,8), mark: (end: ">"))
    arc((4.5,9.5), start: 120deg, delta: -150deg, radius: 1.5, mark: (start: ">"), stroke: (paint: blue))
    content(((7.5,9.5)), text(fill: blue)[$R$])

    circle((-4, 4))
    line((5,8), (-4,4), mark: (end: ">"), stroke:(dash: "dashed", paint: gray))
    content((-4,2), [C])

    scale(x: -1, y: 1)
    translate(x: 14)

    circle((6,0))
    content((4,0), [A])
    circle((3,8))
    content((1,8), [B])
    line((6,0),(3,8), mark: (end: ">"))
    arc((2.5,9.5), start: 120deg, delta: -150deg, radius: 1.5, mark: (start: ">"), stroke: (paint: red))

    circle((-4, 4))
    line((3,8), (-4,4), mark: (end: ">"), stroke:(dash: "dashed", paint: gray))
    content((-4,2), [C])
    content(((5.5,9.5)), text(fill: red)[$R'$])

  }),
  caption: [Vektorbasierte Bestimmung der Umlaufrichtung um einen Knoten $B$ basierend auf seinem Vorgänger und Nachfolger (eigene Darstellung)]
)<fig:vektorbasierte-umlaufrichtung>

Dieser Ansatz ermöglicht grundsätzlich eine robuste Bestimmung der Umlaufrichtung um $B$, unabhängig von der konkreten Lage der Knoten sowie der Umlaufrichtung am vorhergehenden Knoten.


// Besondere Umlenkungen

Allerdings zeigen beide vorgestellten Verfahren Schwächen bei Knoten, an denen sich die Hauptrichtung der Route ändert. Dieser Sachverhalt ist exemplarisch in @fig:vektorbasierte-umlaufrichtung-probleme dargestellt. Die geplante Route ist dort in Schwarz eingezeichnet. Da der Nachfolgeknoten von $B$ links der Verbindung zwischen dem Vorgänger von $B$ und $B$ selbst liegt, wird gemäß dem beschriebenen Kriterium eine Bewegung entgegen dem Uhrzeigersinn bestimmt.

#figure(
  cetz.canvas({
    import cetz.draw: *

    scale(0.3)

    // left vert
    circle((0,4))
    circle((0,8))
    circle((0,12), stroke: (dash: "dashed"))

    // bottom
    circle((2,0))
    content((3,2), [$B$])
    circle((4,18))
    circle((6,0))
    circle((10,0), stroke: (dash: "dashed"))

    //right vert
    circle((18,2))
    circle((18,6))
    circle((18,10), stroke: (dash: "dashed"))

    // route
    line((6,0), (4,18), mark:(end:">"))
    line((4,18),(2,0), mark:(end:">"))
    line((2,0),(18,2), mark:(end:">"))

    arc((-0.5,0), start: 160deg, delta:150deg, radius: 2, mark: (end: ">"), stroke: (paint: red))
    content((-2,-2), text(fill:red)[$R$])

    // falscher pfad
    line((3,18), (0.8,0.3), stroke:(paint: red))
    arc((0.8,0.3), start: 160deg, delta:150deg, radius: 1.3, stroke: (paint: red))
    line((5.5,1),(18,1), stroke: (paint: red))
    line((2.9,-1.1),(5.5,1), stroke: (paint: red))


  }),
  caption: [Fehlerhafte Bestimmung der Umlaufrichtung bei Änderung der Hauptrichtung (eigene Darstellung)]
)<fig:vektorbasierte-umlaufrichtung-probleme>

In diesem konkreten Fall führt diese Entscheidung jedoch zu einem unerwünschten Ergebnis. Es entsteht eine diagonal verlaufende vertikale Strebe, die in der Abbildung rot hervorgehoben ist. Zudem verläuft ein Abschnitt der folgenden horizontalen Strebe nicht achsenparallel zur x-Achse, da diese zunächst unterhalb von $B$ geführt wird.

Eine korrekte Lösung würde hingegen eine Umlaufbewegung im Uhrzeigersinn erfordern. Dadurch ließe sich sicherstellen, dass die abschließende vertikale Strebe achsenparallel zur y-Achse verläuft und zugleich der Beginn der ersten horizontalen Strebe achsenparallel zur x-Achse ausgerichtet ist. Um das zu erreichen kann die berechnete Umlaufrichtung an allen @UE, an denen sich die Hauptrichtung ändert, getauscht werden. Da dort eine vertikale bzw. horizontale Strebe endet und eine horizontale bzw. vertikale Strebe ausgeht ist die durch den vektorbasierten Ansatz berechnete Umlaufrichtung an diesen @UE immer falsch und kann somit unkompliziert getauscht werden, um den Fehler zu korrigieren. 

