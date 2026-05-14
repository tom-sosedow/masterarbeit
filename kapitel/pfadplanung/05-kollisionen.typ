#import "/util.typ": *
#import "@preview/cetz:0.4.2"

== Kollisionen

An bestimmten Stellen kann es bei der Bewegung zwischen zwei Umlenkungen zu Kollisionen mit anderen @UE kommen, häufig insbesondere mit solchen im Bereich der Türöffnung. Ursache hierfür ist, dass der Verbindungsweg zwischen zwei Umlenkungen nicht strikt achsenparallel, sondern leicht diagonal verläuft. Zusätzlich ist die Steigung dabei entgegengesetzt zur jeweiligen Hauptrichtung ausgerichtet, wie in @fig:wegpunkte-mit-türecke (a) dargestellt. Befände sich in diesem Szenario zwischen den beiden untersten @UE ein Türausschnitt, könnte es bei der Ausführung der untersten horizontalen Strebe zu einer Kollision mit den oberen @UE der Tür kommen. Ähnliche Problematiken treten auch an den Rändern der Wand auf, insbesondere wenn für eine Umlenkung lediglich die zuvor beschriebenen drei Wegpunkte verwendet werden, wie bereits in @fig:vektorbasierte-umlaufrichtung-probleme angedeutet wurde.

// Volle Umlenkungen
Ein Großteil dieser Kollisionen lässt sich durch die Verwendung vollständiger Umlenkungen vermeiden. Hierbei werden für kritische @UE, also jene an denen sich beispielsweise die Hauptrichtung ändert oder die nahe an der Tür liegen, insgesamt vier Wegpunkte definiert, wie exemplarisch in @fig:volle-umlenkungen dargestellt. Wird dabei jeweils der dem Start- beziehungsweise Zielpunkt nächstgelegene Wegpunkt als Ein- und Austrittspunkt gewählt, verlaufen die ein- und ausgehenden Pfade achsenparallel. Aufgrund der Spannung des Garns bleibt die resultierende Gitterstruktur dabei unverändert.


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
    circle((0,16))
    circle((4,16))
    circle((6,0))
    circle((8,16))

    circle((10,0), stroke: (dash: "dashed"))

    // richtiger pfad
    arc((-1.3,16), start: 180deg, delta:-180deg, radius: 1.3, stroke: (paint: blue))
    arc((0.9,0), start: 180deg, delta:180deg, radius: 1.1, stroke: (paint: blue))
    line((1.3,16), (0.9,0), stroke:(paint: blue))
    line((3.1,0),(2.8,16), stroke: (paint: blue))
    content((16,16), text(fill:blue)[Garn])

    // Robi pfad
    set-style(mark: (end: "straight"))
    content((16,14), text(fill: green)[Roboterpfad])
    let pointsTop = ((-2,16),(0,18),(1.8,16))
    for point in pointsTop {
      circle(point, radius: 0.2, stroke: (paint: green))
    }
    line(pointsTop.at(0), pointsTop.at(1), stroke: (paint: green))
    line(pointsTop.at(1), pointsTop.at(2), stroke: (paint: green))

    let pointsBot = ((2,2), (0,0), (2,-2), (4,0))
    for point in pointsBot {
      circle(point, radius: 0.2, stroke: (paint: green))
    }
    line(pointsTop.last(), pointsBot.first(), stroke: (paint: green), mark:(end: "straight", start:"straight"))
    line(pointsTop.last(), pointsBot.at(1), stroke: (paint: red.transparentize(50%), dash: "dashed"))
    line(pointsBot.at(0), pointsBot.at(1), stroke: (paint: green))
    line(pointsBot.at(1), pointsBot.at(2), stroke: (paint: green))
    line(pointsBot.at(2), pointsBot.at(3), stroke: (paint: green))
    line(pointsBot.at(3), pointsBot.at(0), stroke: (paint: green))   

    translate(x: 4)
    line(pointsTop.at(0), pointsTop.at(1), stroke: (paint: green))
    line(pointsTop.at(1), pointsTop.at(2), stroke: (paint: green))
    for point in pointsTop {
      circle(point, radius: 0.2, stroke: (paint: green))
    }
  }),
  caption: [Vollständige Umlenkung zur Vermeidung einer Kollision mit einem Umlenkelement. In Grün dargestellt der Roboterpfad und in Blau die resultierende Garnstruktur (eigene Darstellung)]
)<fig:volle-umlenkungen>

// Weitere Kollisionen erkennen und beheben
Um sichergestellt alle Kollisionen beheben zu können, kann zusätzlich der Ansatz von @morris-hillBuildingStringArt2023 zur Kollisionsauflösung durch Kreisbahnen mit einem Sicherheitsradius herangezogen werden. Das Vorgehen ist in @fig:morris-kollisionsvermeidung exemplarisch skizziert. Dafür wird ein neuer Wegpunkt in Richtung des auf der kreuzenden Strecke orthogonal stehenden und von dem kollidierten @UE ausgehenden Verbindungsvektors eingefügt. Dieser ist in der Abbildung grün markiert. Anschließend kann der entstandene Pfad, in der Abbildung blau markiert, iterativ auf weitere oder neu entstandene Verletzungen der Sicherheitsabstände zu @UE geprüft werden, bis keine mehr übrig sind oder eine maximale Iterationsgrenze erreicht wurde. Sollte die Berechnung stoppen bevor alle Kollisionen behoben werden konnten, gibt das Programm einen Fehler aus und generiert keinen Pfad für die Ausgabe.

#figure(
  grid(
    columns: 2,
    column-gutter: 10%,
    row-gutter: 3%,
    cetz.canvas({
      import cetz.draw: *

      scale(0.35)

      circle((0,18))
      circle((4,18))
      circle((-4,18))
      set-style(mark: (end: ">>"))
      line((-2,18),(0,20),(2,18))

      circle((0,4))
      circle((0,8))
      circle((0,8), radius: 1.6, stroke:(paint: red))
      content((-0.2,8),[x])
      content((-0.2,4),[y])

      circle((-2,12))
      circle((-6,12), stroke: (dash: "dashed", paint: gray))

      circle((2,0))
      circle((6,0), stroke: (dash: "dashed", paint: gray))

      line((2,18),(0,0), stroke: (paint: red))
      line((0,0),(2,-2),(4,0))

      line((0,8),(0.8,7.91), stroke: (paint:green))
      line((0,8),(2.2,7.8), stroke: (paint:green))
      line((2,18),(2.2,7.8), stroke: (paint: blue))
      line((2.2,7.8),(0,0), stroke: (paint: blue))
    }),
    cetz.canvas({
      import cetz.draw: *

      scale(0.35)

      circle((0,18))
      circle((4,18))
      circle((-4,18))
      set-style(mark: (end: ">>"))
      line((-2,18),(0,20),(2,18))

      circle((0,4))
      circle((0,4), radius: 1.6, stroke:(paint: red))
      circle((0,8))
      content((-0.2,8),[x])
      content((-0.2,4),[y])

      circle((-2,12))
      circle((-6,12), stroke: (dash: "dashed", paint: gray))

      circle((2,0))
      circle((6,0), stroke: (dash: "dashed", paint: gray))

      line((0,0),(2,-2),(4,0))

      line((0,4),(1,3.7), stroke: (paint:green))
      line((0,4),(2,3.4), stroke: (paint:green))

      line((2,18),(2.2,7.8))
      line((2.2,7.8),(0,0), stroke: (paint: red))
      line((2.2,7.8),(2,3.4), stroke: (paint:blue))
      line((2,3.4),(0,0), stroke: (paint:blue))
    }),
    [(a)],
    [(b)],
    [],[]
  ),
  caption: [Iterative Kollisionserkennung nach #citep(<morris-hillBuildingStringArt2023>) mit zwei Iterationen. In Iteration (a) wird die Kollision mit UE x behoben, da der rote Teil des Pfades des Roboters den roten Kreis mit dem Sicherheitsradius von x schneidet. Danach besteht noch die Kollision mit UE y, welche in Iteration (b) auf gleiche Weise behoben wird.  (eigene Darstellung)]
)<fig:morris-kollisionsvermeidung>

// Kollisionen mit bereits gelegtem Garn
Darüber hinaus ist sicherzustellen, dass Kollisionen der Austrittsdüse mit bereits verlegtem Garn vermieden werden. Eine effektive Strategie zur Kollisionsvermeidung besteht darin, das Werkzeug temporär anzuheben, sobald eine bestehende Strebe gekreuzt wird. Dabei ist jedoch zu beachten, dass die Anhebung weder zu groß noch zu steil erfolgen darf, da andernfalls die Gefahr besteht, dass das Garn vom vorherigen @UE abrutscht. Daraus entsteht eine Reihe von Problemen. Zum einen würde dies an den Kreuzungspunkten dazu führen, dass keine Verbindung zwischen sich kreuzenden Streben entsteht und somit die Belastbarkeit des Gitters nach dem Temperieren eingeschränkt ist. Außerdem erschwert die gestiegene Höhe der Bewehrung in z-Richtung die Handhabung, den Transport und die Stapelung mehrerer Gitter in besonders beanspruchten Bauteilen. Auch können bei ungünstig verlaufenden Pfaden durch den vertikalen Versatz weitere Kollisionen begünstigt werden, da diese Erhöhungen schwer einkalkulierbar sind.
 
Da zur Erkennung solcher Kreuzungen kein physikalisches Modell des unter Spannung stehenden Garns verwendet wird, muss der geplante Pfad als Annäherung dienen. 
Hierzu wird der Pfad, zunächst ohne Erkennung von Garnkollisionen, erstellt und dabei der Abstand der Wegpunkte zur Mitte der @UE von zwei Radien auf einen Radius geändert. Ebenfalls werden von Sonderumlenkungen und vollständigen Umlenkungen der erste und letzte Wegpunkt entfernt, sodass anliegende Streben eher der Realität entsprechen. Der resultierende Pfad wird als $p'$ bezeichnet. Wenngleich diese Berechnung keinen validen Pfad für den Roboterarm erzeugt, da die Abstände nicht eingehalten werden, führt es dazu, dass die Streben zwischen den Außenkanten der @UE:pl:long verlaufen und somit eine Annäherung der resultierenden Garnstruktur entsteht. Das Ergebnis ist in @fig:pfad-garnannaeherung zu sehen. Es ist zu beachten, dass dennoch einige Streben nicht so verlaufen, wie sie es später tun werden. Ein Beispiel hierfür ist die am weitesten rechts liegende vertikale Strebe, die durch die vollständige Umlenkung um das @UE 62 entsteht. Hier kommt es zu einer Abweichung, da durch das Entfernen des ersten und letzten Wegpunktes für die Umlenkung eine gewöhnliche Umlenkung mit drei Punkten entsteht. Da dort die Hauptrichtung wechselt, verläuft diese Strebe im Gegensatz zur Realität in der Annäherung somit nicht achsenparallel, sondern leicht diagonal.

#figure(
  image("/images/pfadannaeherung.png"),
  caption: [Annäherung $p'$ an resultierende Garnstruktur am Beispiel von Wandkonfiguration $w_4$ (eigene Darstellung)],
)<fig:pfad-garnannaeherung>

Der Pfad $p$ für den Roboter wird schrittweise analysiert und für jeden Abschnitt überprüft, ob und an welchen Positionen er frühere Segmente in $p'$ schneidet. Die identifizierten Schnittpunkte werden entlang der jeweiligen Strebe von $p$ geordnet.

Am ersten Kreuzungspunkt wird, wie beschrieben, ein zusätzlicher Wegpunkt eingefügt, der sich etwa zwei Zentimeter oberhalb der regulären Arbeitsebene befindet. Die Anhebung erfolgt dabei erst unmittelbar am Schnittpunkt, um die Steigung möglichst gering zu halten und somit die auf das @UE wirkenden vertikalen Kräfte zu minimieren. Ein weiterer zusätzlicher Wegpunkt wird an der letzten Kreuzung eingefügt. Auf diese Weise soll verhindert werden, dass es beim Übergang zum ersten Wegpunkt der folgenden Umlenkung, der wieder auf der ursprünglichen Ebene liegt, zu einer Kollision mit der zuletzt gekreuzten Strebe kommt.

Der resultierende Pfad, ergänzt um diese zusätzlichen Wegpunkte, ist exemplarisch in @fig:seitenansicht-vertikaler-pfad dargestellt.


#figure(
  cetz.canvas({
    import cetz.draw: *

    scale(0.9)
    rect((0,0), (1,2))
    content((0.5,2.3),[UE])
    rect((15,0), (16,2))
    content((15.5,2.3),[UE])


    for offset in (2,4,6,8) {
      circle((offset+3,0.5), radius: 0.2, stroke:(paint: green))
      circle((offset+3,0.5), radius: 0.02, stroke:(paint: green))
    }
    content((7,-0.5), text(fill:green)[Verlegtes Garn])

    // rechte seite
    line((14.8,0.4),(16.2,0.4), stroke:(paint: blue))
    line((16.2,0.4),(16,0.5), stroke:(paint: blue))
    line((15,0.5),(16,0.5), stroke:(paint: blue, dash:"dashed"))
    // erster zwischenpunkt
    line((15,0.5),(11,1.2), stroke:(paint: blue))
    circle((11,1.2), radius: 0.1, stroke: (paint: blue))
    //zweiter zwischenpunkt
    line((5,1.2),(11,1.2), stroke:(paint: blue))
    circle((5,1.2), radius: 0.1, stroke: (paint: blue))

    content((7.5,3), [Neue Wegpunkte])
    line((7.5,2.6), (10.5,1.6), mark: (end: ">"))
    line((7.5,2.6), (5.5,1.6), mark: (end: ">"))

    // linke seite
    line((1.2,0.4),(-0.2,0.4), stroke:(paint: blue))
    line((1.2,0.4),(5,1.2), stroke:(paint: blue))
    line((0,0.5),(-0.2,0.4), stroke:(paint: blue))
    line((0,0.5),(1,0.5), stroke:(paint: blue, dash:"dashed"))

  }),
  caption: [Seitenansicht für vertikale Bewegungen des Roboterarms (eigene Darstellung)]
)<fig:seitenansicht-vertikaler-pfad>

