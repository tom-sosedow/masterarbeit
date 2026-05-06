#import "/util.typ": *
#import "@preview/cetz:0.4.2"

== Pfadgenerierung

// Pfad um die UE herum
Sobald die Umlaufrichtung festgelegt ist, erfolgt im nächsten Schritt die Bestimmung der tatsächlich anzufahrenden Koordinaten. Dabei zeigt sich, dass die Streben im Wesentlichen daraus entstehen, dass der Roboter von einer Umlenkung in Hauptrichtung zur nächsten verfährt. Jede dieser Umlenkungen kann als eigenständiger Subpfad interpretiert werden, der jeweils einen Eintritts- und einen Austrittspunkt sowie eine beliebige Anzahl dazwischenliegender Punkte umfasst, die zur Erzeugung der Kreisbewegung erforderlich sind. In @fig:pfad-zu-muster entsprechen für das @UE $P$ die Punkte $a$ und $c$ dem Ein- beziehungsweise Austrittspunkt, während $b$ einen Zwischenpunkt zur Beschreibung der Halbkreisbewegung darstellt.

Die konkrete Lage dieser Punkte hängt zum einen von der Position des jeweiligen @UE ab, zum anderen von den Positionen der Vorgänger- und Nachfolgeknoten in der Route. So befinden sich die Ein- und Austrittspunkte jeweils zwischen zwei benachbarten @UE, während der Zwischenpunkt immer außerhalb der Wandgrenzen liegt. Dies ist in @fig:wegpunkte-mit-türecke (a) dargestellt.

Für den Bereich der oberen Türecken ergeben sich dabei zusätzliche Besonderheiten, da hier sowohl horizontale als auch vertikale Hauptrichtungen berücksichtigt werden müssen. In @fig:wegpunkte-mit-türecke (b) ist dies mit den Farben Blau und Grün dargestellt. Die doppelte Betrachtung liegt darin begründet, dass diese Knoten zweimalig angefahren werden und somit zwei unterschiedliche Halbkreisbewegungen erforderlich sind.

Die Reihenfolge, in der der Roboter die einzelnen Punkte anfährt, ergibt sich aus der zugrunde liegenden Route sowie der daraus abgeleiteten Hauptrichtung in der jeweiligen Teilroute. Durch die Verkettung aller Subpfade, die aus den einzelnen Umlenkungen hervorgehen, entsteht schließlich der vollständige Bewegungspfad $p$, der zur Erzeugung der Gitterstruktur abgefahren werden muss, wie in @fig:wegpunkte-mit-türecke (a) veranschaulicht.

#figure(
  grid(
    columns:(auto, 15%, auto),
    rows:(auto, auto),
    cetz.canvas({
      import cetz.draw: *

      scale(0.5)
      // links
      circle((0,0))
      circle((0,4))
      
      let points1 = ((0,1.7),(-2, 0),(0,-1.7))
      line(points1.at(0),points1.at(1))
      line(points1.at(1),points1.at(2))
      for p in points1 {
        circle(p, radius: 0.2)
      }

      let points2 = ((0,4+1.7),(-2, 4),(0,4-1.7))
      line(points2.at(0),points2.at(1))
      line(points2.at(1),points2.at(2))
      for p in points2 {
        circle(p, radius: 0.2)
      }

      // rechts
      circle((8,2))
      circle((8,6))

      let points3 = ((8,2+1.7),(8+2, 2),(8,2-1.7))
      line(points3.at(0),points3.at(1))
      line(points3.at(1),points3.at(2))
      for p in points3 {
        circle(p, radius: 0.2)
      }

      let points4 = ((8,6+1.7),(8+2, 6),(8,6-1.7))
      line(points4.at(0),points4.at(1))
      line(points4.at(1),points4.at(2))
      for p in points4 {
        circle(p, radius: 0.2)
      }

      line(points1.first(), points3.last(), stroke: (dash: "dashed", paint: gray))
      line(points3.first(), points2.last(), stroke: (dash: "dashed", paint: gray))
      line(points2.first(), points4.last(), stroke: (dash: "dashed", paint: gray))
    }),
    [],
    cetz.canvas({
      import cetz.draw: *

      scale(0.4)
    
      // Türrollen
      circle((0,0))
      circle((-4,0), stroke: (dash: "dashed"))
      circle((0,-4), stroke: (dash: "dashed"))

      let points1 = ((0,1.7),(-2, 0),(0,-1.7))
      line(points1.at(0),points1.at(1), stroke: (paint: blue))
      line(points1.at(1),points1.at(2), stroke: (paint: blue))
      for p in points1 {
        circle(p, radius: 0.2, stroke: (paint: blue))
      }

      let points2 = ((-2.5, 0),(0,-2.2),(2.2,0))
      line(points2.at(0),points2.at(1), stroke: (paint: green))
      line(points2.at(1),points2.at(2), stroke: (paint: green))
      for p in points2 {
        circle(p, radius: 0.2, stroke: (paint: green))
      }

      // Wandrollen (oben)
      circle((-2,8))
      circle((2,8))
      circle((0,8), radius: 0.2, stroke: (paint: green))
      line(points2.first(), (0,8), stroke: (dash: "dashed", paint: green.transparentize(50%)))
      line(points2.last(), (0,8), stroke: (dash: "dashed", paint: green.transparentize(50%)))

      //Wandrollen (rechst)
      circle((8,2))
      circle((8,-2))
      circle((8,0), radius: 0.2, stroke: (paint: blue))
      line(points1.first(), (8,0), stroke: (dash: "dashed", paint: blue.transparentize(50%)))
      line(points1.last(), (8,0), stroke: (dash: "dashed", paint: blue.transparentize(50%)))

      // Wandrahmen
      line((-2,-2),(-6,-2), stroke: (paint:gray))
      line((-2,-2),(-2,-6), stroke: (paint:gray))

      translate(x: 12, y: 12)
      line((-2,-2),(-18,-2), stroke: (paint:gray))
      line((-2,-2),(-2,-18), stroke: (paint:gray))
    }),
    [(a)],
    [],
    [(b)],
  ),
  caption: [Positionen der Wegpunkte an den Umlenkelementen. Sowohl für Umlenkungen in Hauptrichtung (a) sowie an der oberen rechten Türecke (b).]
)<fig:wegpunkte-mit-türecke>
