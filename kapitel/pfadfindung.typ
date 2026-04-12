#import "/util.typ": *
#import "@preview/cetz:0.4.2"

= Pfadplanung für Roboterarm <sec:path-finding>

Nachdem die Reihenfolge der anzufahrenden @UE:pl:long festgelegt wurde, ist im nächsten Schritt der konkrete Bewegungspfad des Roboterarms zu bestimmen. Ziel ist es dabei, das aus dem am Roboter montierten Werkzeug austretende Carbongarn so zu führen, dass es zuverlässig an den @UE:pl haftet und zugleich die gewünschte gleichmäßige Gitterstruktur entsteht.

== Problemdefinition

Im Rahmen der Planung der Bewegungsabläufe des Roboterarms sind mehrere Aspekte zu berücksichtigen. Neben der Festlegung der Umlaufrichtung um die jeweiligen @UE:pl spielt insbesondere die Kollisionserkennung und -vermeidung eine zentrale Rolle, sowohl mit @UE:pl als auch mit bereits verlegten Garnstreben. Darüber hinaus müssen Anforderungen wie die Aufrechterhaltung einer ausreichenden Garnspannung und die Sicherstellung der Haftung gegenüber vertikalem Abrutschen von den @UE einbezogen werden. Ferner ist auch die Überführung der geplanten Trajektorien in mit dem Roboter kompatible Bewegungsmuster erforderlich.

// Werkzeug
Zum Verlegen des Garns wird ein Werkzeug eingesetzt, das aus einer außermittig angebrachten, aufrecht stehenden Rolle besteht, über die das Garn in die Austrittsdüse geführt wird. Der Aufbau ist in @fig:werkzeug-garnablage abgebildet. Aufgrund der Rotierbarkeit des Werkzeugs kann es sich im Ganzen um den Mittelpunkt herum drehen, sobald seitliche Kräfte auf die Austrittsdüse einwirken. Dies ist beispielsweise der Fall, wenn um ein @UE gefahren wird. Durch die kontinuierliche Richtungsänderung der Kreisbewegung wird das Garn zum letzten Auflagepunkt am @UE gezogen, die Düse besitzt dabei allerdings noch dieselbe Orientierung. Die Rotation entsteht also automatisch, ohne Hilfe eines Motors. Für den Roboter ist diese Rotation irrelevant und kann nicht erkannt werden, da der Mittelpunkt des Werkzeugs statisch konfiguriert wird und keine Sensoren die aktuelle Rotation des Werkzeuges aufnehmen.
Durch die Breite und Rotation des Werkzeugs muss beim Umfahren der @UE ein Mindestabstand eingehalten werden, damit sich das Werkzeug frei drehen kann.

#figure(
  image("/images/roboter-werkzeug.jpg", width: 60%),
  caption: [Werkzeug des Roboterarms zum Verlegen des Carbongarns]
)<fig:werkzeug-garnablage>

Da das Garn in etwa mittig aus der Austrittsdüse herauskommt und somit der untere Teil der Düse niedriger als das austretende Garn ist, kann eine bereits verlegte Strebe beim Überqueren durch die Düse beschädigt werden. Hier kann es zum Spleißen oder Verziehen des Garns kommen. Im schlimmsten Fall kann das Garn auch reißen. Es muss also eine Möglichkeit gefunden werden, Kollisionen mit bereits verlegten Garnstreben sichergestellt zu vermeiden. Auch Kollisionen mit @UE müssen vermieden werden, da u.a. durch den Türausschnitt @UE:pl zwischen der direkten Verbindung zweier Umlenkpunkte liegen können.

// Umlaufrichtung
Für die Gleichmäßigkeit des Gittermusters ist entscheidend, in welcher Richtung die @UE:pl umfahren werden. Dabei wird, von oben auf den Ablagetisch gesehen, zwischen dem Uhrzeigersinn $R'$ und entgegen des Uhrzeigersinns $R$ unterschieden. Bei einer falsch gewählten Richtung entstehen keine achsenparallelen Streben, welche für die Lastverteilung und strukturelle Integrität unerlässlich sind. Der Zusammenhang ist in @fig:pfad-zu-muster dargestellt. Dargestellt ist eine Teilroute um die zwei @UE:pl:long $P$ und $Q$, für die je @UE drei Wegpunkte zum Abfahren durch den Roboter definiert wurden. Folgt der Roboterarm dem Pfad $(a,b,c,d,e,f)$, wie im linken Bild blau dargestellt, entstehen achsenparallele, horizontale Streben des Carbongarns (rot dargestellt). 
Wird hingegen bei unveränderter Reihenfolge der anzufahrenden @UE die Umlaufrichtung invertiert, so ergibt sich effektiv eine Umkehr der lokalen Wegpunktreihenfolge. Die resultierende Sequenz lautet in diesem Fall $(c,b,a,f,e,d)$. Wie im rechten Teil der Abbildung zu erkennen ist, verlaufen die erzeugten Streben dadurch nicht mehr parallel, sondern weisen teilweise Kreuzungen in Hauptrichtung auf.
Analog dazu kann eine fehlerhafte Festlegung der zugehörigen Wegpunkte sowie ihrer Reihenfolge dazu führen, dass einzelne @UE:pl ausgelassen werden, Lücken in der Gitterstruktur entstehen oder Kollisionen mit benachbarten @UE auftreten @merschAutomation3DRobotic2025.

#figure(
  grid(
    columns: (auto, auto),
    rows: (auto, auto),
    row-gutter: 4%,
    column-gutter: 4%,
    image("/images/pfad-zu-muster-richtig.png", width: 100%),
    //line(start: (0%,2%), end: (0%, 13%)),
    image("/images/pfad-zu-muster-falsch.png", width: 100%),
    [(a)],
    [(b)],
  ),
 caption: [Pfad des Roboters (Blau) und daraus resultierende Garnstruktur (Rot) um zwei Umlenkelemente mit korrekter Umlaufrichtung (links) und vertauschter Umlaufrichtung (rechts)]
)<fig:pfad-zu-muster>


== Stand der Forschung

#todo[Forschungsstand CBT einfügen.]

Auch für das Problem der Pfadplanung lassen sich relevante Erkenntnisse aus dem Bereich der String Art ableiten. In den Arbeiten von #citep(<birsakStringArtComputational2018>) und #citep(<happelQuotemeImg2string2026>), die sich mit klassischer String Art innerhalb eines mit Nägeln bestückten Rahmens befassen, wird jedoch keine explizite Festlegung der Umlaufrichtung um die Nägel vorgenommen. Dies ist vermutlich darauf zurückzuführen, dass aufgrund der geringen Größe der Nägel beziehungsweise Pins der Unterschied zwischen verschiedenen Umlaufrichtungen vernachlässigbar ist. In der Praxis kann daher eine vollständige Umrundung in konstanter Richtung erfolgen, ohne das resultierende Bild wesentlich zu beeinflussen. Zudem sind die Rahmen im Allgemeinen konvex, sodass es keine Hindernisse innerhalb der Zeichenfläche gibt.

Einen stärkeren Bezug zum vorliegenden Problem weist hingegen String Art auf, bei der die Nägel innerhalb der Zeichenfläche platziert werden. In einem Blogbeitrag beschreibt #citep(<morris-hillBuildingStringArt2023>) einen Ansatz, bei dem nach einer initialen Punkt-zu-Punkt-Planung ein konkreter Werkzeugpfad berechnet wird. Hierzu wird um die Nägel ein Sicherheitskreis beschrieben, dessen Radius größer ist als der der Nägel. Schneidet eine geplante Strecke einen solchen Sicherheitsbereich, wird die Laufbahn entsprechend angepasst, sodass das Werkzeug zwischen Ein- und Austrittspunkt entlang der Kreisbahn um den Nagel geführt wird. Dieser Ansatz zur Kollisionsvermeidung kann als konzeptionelle Grundlage für die im Folgenden entwickelte Vorgehensweise dienen.

Für die Bestimmung der Umlaufrichtung um die @UE:pl:long können die Ergebnisse von #citep(<merschAutomation3DRobotic2025>) herangezogen werden. Obwohl hier primär dreidimensionale Skelette betrachtet werden, besteht auch in diesem Kontext die Anforderung, eine zuverlässige Haftung des aus unterschiedlichen Richtungen zugeführten Garns an den Pins sicherzustellen. Der zugrunde liegende Lösungsansatz hierfür lässt sich teilweise auf das vorliegende Problem applizieren und wird in @sec:path-direction näher betrachtet.

Die spezifische Anforderung, gleichmäßig verteilte und zugleich flächenfüllende Streben zu erzeugen, ist in der bestehenden Literatur bislang nur unzureichend untersucht. Zudem lassen sich vorhandene Ansätze aufgrund von teilweise in Konflikt stehenden Anforderungen nicht auf das vorliegende Problem übertragen. Vor diesem Hintergrund sind weitere Betrachtungen diesbezüglich nötig.

#todo[ ähnliche literatur für fehlendes?]
  
== Bestimmung der Umlaufrichtung <sec:path-direction>
// Umlaufrichtung: Bestimmung durch Vektor 

Für die Bestimmung der Umlaufrichtung muss in Umlenkungen in Hauptrichtung und zur Änderung der Hauptrichtung unterschieden werden. Bei den meisten @UE wird in Hauptrichtung umgelenkt. In den Ecken der Wand wird eine Änderung der Hauptrichtung vollzogen, sodass die Umlenkungen an diesen Stellen gesondert betrachtet werden müssen. Zu Bestimmung der Umlaufrichtung der Umlenkungen in Hauptrichtung werden zwei Ansätze untersucht. 

Einerseits ist zu beobachten, dass die Umlaufrichtung bei jeder Umlenkung invertiert wird, solang die Hauptrichtung beibehalten wird. Für die in @sec:route-puzzle-based beschriebenen Subgraphen wird also eine 2-Färbung des Graphen gesucht, wobei jede Farbe eine Umlaufrichtung darstellt. Da die Teilroute einen linearen Subgraph aufspannt, gibt es lediglich zwei Möglichkeiten einer 2-Färbung des Graphen, welche von der Färbung des initialen Knotens abhängen. Es müssen also für den Start jeder Teilroute Regeln gefunden werden, welche Färbung der erste Knoten besitzen muss. Eine falsche Zuweisung würde zu vertauschten Umlenkungen in der gesamten Teilroute erzeugen. 

Eine weitere Methode zur Bestimmung der Umlaufrichtung basiert auf einem vektoriellen Ansatz nach #citep(<merschAutomation3DRobotic2025>). Zur Bestimmung der Umlaufrichtung an einem @UE:long $B$ mit Position $overarrow(b)$ werden dessen Vorgänger $A$ mit Position $overarrow(a)$ sowie sein Nachfolger $C$ mit Position $overarrow(c)$ in der Route betrachtet.

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
  caption: [Vektorbasierte Bestimmung der Umlaufrichtung um einen Knoten $B$ basierend auf seinem Vorgänger und Nachfolger]
)<fig:vektorbasierte-umlaufrichtung>

Dieser Ansatz ermöglicht grundsätzlich eine robuste Bestimmung der Umlaufrichtung um $B$, unabhängig von der konkreten Lage der Knoten sowie der Umlaufrichtung am vorhergehenden Knoten.


// Besondere Umlenkungen

Allerdings zeigen beide vorgestellten Verfahren Schwächen bei Knoten, an denen sich die Hauptrichtung der Route ändert. Dieser Sachverhalt ist exemplarisch in @fig:vektorbasierte-umlaufrichtung-probleme dargestellt. Die geplante Route ist dort in Weiß eingezeichnet. Da der Nachfolgeknoten von $B$ links der Verbindung zwischen dem Vorgänger von $B$ und $B$ selbst liegt, wird gemäß dem beschriebenen Kriterium eine Bewegung entgegen dem Uhrzeigersinn bestimmt.

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
  caption: [Fehlerhafte Bestimmung der Umlaufrichtung bei Änderung der Hauptrichtung]
)<fig:vektorbasierte-umlaufrichtung-probleme>

In diesem konkreten Fall führt diese Entscheidung jedoch zu einem unerwünschten Ergebnis. Es entsteht eine diagonal verlaufende vertikale Strebe, die in der Abbildung rot hervorgehoben ist. Zudem verläuft ein Abschnitt der folgenden horizontalen Strebe nicht achsenparallel zur x-Achse, da dieser zunächst unterhalb von $B$ geführt wird.

Eine korrekte Lösung würde hingegen eine Umlaufbewegung im Uhrzeigersinn erfordern. Dadurch ließe sich sicherstellen, dass die abschließende vertikale Strebe achsenparallel zur y-Achse verläuft und zugleich der Beginn der ersten horizontalen Strebe achsenparallel zur x-Achse ausgerichtet ist. Da nicht bei allen Umlenkungen zur Änderung der Hauptrichtung ein solch fehlerhaftes Ergebnis entsteht, muss eine Regel zur Erkennung dieser Sonderfälle gefunden werden.

== Pfadgenerierung

// Pfad um die UE herum
Sobald die Umlaufrichtung festgelegt ist, erfolgt im nächsten Schritt die Bestimmung der tatsächlich anzufahrenden Koordinaten. Dabei zeigt sich, dass die Streben im Wesentlichen daraus entstehen, dass der Roboter von einer Umlenkung in Hauptrichtung zur nächsten verfährt. Jede dieser Umlenkungen kann als eigenständiger Subpfad interpretiert werden, der jeweils einen Eintritts- und einen Austrittspunkt sowie eine beliebige Anzahl dazwischenliegender Punkte umfasst, die zur Erzeugung der Kreisbewegung erforderlich sind. In @fig:pfad-zu-muster entsprechen für das @UE $P$ die Punkte $a$ und $c$ dem Ein- beziehungsweise Austrittspunkt, während $b$ einen Zwischenpunkt zur Beschreibung der Halbkreisbewegung darstellt.

Die konkrete Lage dieser Punkte hängt zum einen von der Position des jeweiligen @UE ab, zum anderen von den Positionen der Vorgänger- und Nachfolgeknoten in der Route. So befinden sich die Ein- und Austrittspunkte jeweils zwischen zwei benachbarten @UE, während der Zwischenpunkt immer außerhalb der Wandgrenzen liegt. Dies ist in @fig:wegpunkte-mit-türecke (a) dargestellt.

Für den Bereich der oberen Türecken ergeben sich dabei zusätzliche Besonderheiten, da hier sowohl horizontale als auch vertikale Hauptrichtungen berücksichtigt werden müssen. In @fig:wegpunkte-mit-türecke (b) ist dies mit den Farben Blau und Grün dargestellt. Die doppelte Betrachtung liegt darin begründet, dass diese Knoten zweimalig angefahren werden und somit zwei unterschiedliche Halbkreisbewegungen erforderlich sind.

Die Reihenfolge, in der der Roboter die einzelnen Punkte anfährt, ergibt sich aus der zugrunde liegenden Route sowie der daraus abgeleiteten Hauptrichtung in der jeweiligen Teilroute. Durch die Verkettung aller Subpfade, die aus den einzelnen Umlenkungen hervorgehen, entsteht schließlich der vollständige Bewegungspfad, der zur Erzeugung der Gitterstruktur abgefahren werden muss, wie in @fig:wegpunkte-mit-türecke (a) veranschaulicht.

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

#question[Soll ich erklären, wie ich aus der Punktliste die tatsächlichen Bewegungsschritte des Roboters generiere (LMOVE, C1MOVE, C2MOVE,...)? Oder ist das anwendungsspezifisches implementationsdetail, welches nicht in die Arbeit sollte (weil ja nicht jeder einen kawasaki robi nutzt)?]

== Kollisionen

An bestimmten Stellen kann es bei der Bewegung zwischen zwei Umlenkungen zu Kollisionen mit anderen @UE kommen, häufig insbesondere mit solchen im Bereich der Türöffnung. Ursache hierfür ist, dass der Verbindungsweg zwischen zwei Umlenkungen nicht strikt achsenparallel verläuft, sondern eine leichte diagonale Komponente aufweist. Zusätzlich ist die Steigung dabei entgegengesetzt zur jeweiligen Hauptrichtung ausgerichtet, wie in @fig:wegpunkte-mit-türecke (a) dargestellt. Befände sich in diesem Szenario zwischen den beiden untersten @UE ein Türausschnitt, könnte es bei der Ausführung der untersten horizontalen Strebe zu einer Kollision mit den oberen @UE der Tür kommen. Ähnliche Problematiken treten auch an den Rändern der Wand auf, insbesondere wenn für eine Umlenkung lediglich die zuvor beschriebenen drei Wegpunkte verwendet werden, wie bereits in @fig:vektorbasierte-umlaufrichtung-probleme angedeutet wurde.

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
  caption: [Vollständige Umlenkung zur Vermeidung einer Kollision mit einem Umlenkelement. In Grün dargestellt der Roboterpfad und in Blau die resultierende Garnstruktur]
)<fig:volle-umlenkungen>

// Weitere Kollisionen erkennen und beheben
#maybe[
  
@morris-hillBuildingStringArt2023 Ansatz für Kollisionsvermeidung mit Kreisbahnen als Inspiration:

- gefundene kollisionen beheben, indem ein neuer punkt in richtung des verbindungsvektors und passender distanz in den pfad eingereiht
- iterativ kollisionen erkennen, dann beheben und erneut überprüfen, ob neue kollisionen dazu gekommen sind
]

// Kollisionen mit bereits gelegtem Garn
Darüber hinaus ist sicherzustellen, dass Kollisionen der Austrittsdüse mit bereits verlegtem Garn vermieden werden. Eine effektive Strategie zur Kollisionsvermeidung besteht darin, das Werkzeug temporär anzuheben, sobald eine bestehende Strebe gekreuzt wird. Dabei ist jedoch zu beachten, dass die Anhebung weder zu groß noch zu steil erfolgen darf, da andernfalls die Gefahr besteht, dass das Garn vom vorherigen @UE abrutscht. Dies würde auch an den Kreuzungspunkten dazu führen, dass keine Verbindung zwischen sich kreuzenden Streben entsteht und somit die Belastbarkeit des Gitters nach dem Temperieren eingeschränkt ist.

Da zur Erkennung solcher Kreuzungen kein physikalisches Modell des unter Spannung stehenden Garns verwendet wird, dient der bereits abgefahrene Pfad als Näherung. Hierzu wird der Pfad schrittweise analysiert und für jeden Abschnitt überprüft, ob und an welchen Positionen er frühere Segmente schneidet. Die identifizierten Schnittpunkte werden entlang der jeweiligen Strebe geordnet.

Am ersten Kreuzungspunkt wird, wie beschrieben, ein zusätzlicher Wegpunkt eingefügt, der sich etwa zwei Zentimeter oberhalb der regulären Arbeitsebene befindet. Die Anhebung erfolgt dabei erst unmittelbar am Schnittpunkt, um die Steigung möglichst gering zu halten und somit die auf das @UE wirkenden vertikalen Kräfte zu minimieren. Ein weiterer zusätzlicher Wegpunkt wird an der letzten Kreuzung eingefügt. Auf diese Weise wird verhindert, dass es beim Übergang zum ersten Wegpunkt der folgenden Umlenkung, der wieder auf der ursprünglichen Ebene liegt, zu einer Kollision mit der zuletzt gekreuzten Strebe kommt.

Der resultierende Pfad, ergänzt um diese beiden zusätzlichen Wegpunkte, ist exemplarisch in @fig:seitenansicht-vertikaler-pfad dargestellt.


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
  caption: [Seitenansicht für vertikale Bewegungen des Roboterarms.]
)<fig:seitenansicht-vertikaler-pfad>

== Ergebnisse

Zur Analyse des gezeigten Vorgehens werden, analog zu @sec:ue-place-result, erneut alle 32 möglichen Wandkonfigurationen überprüft. Die Tests werden ebenfalls auf einem Intel(R) Core(TM) i5-8350U Prozessor mit 24 GB Arbeitsspeicher durchgeführt. Die durchschnittliche Rechenzeit beträgt 1,57 Millisekunden, während die maximal gemessene Rechenzeit bei 10,32 Millisekunden über alle 32 Testläufe liegt. In @fig:beispielpfad ist der berechnete Pfad für die Wandkonfiguration $w_4$ aus @sec:routenplanung exemplarisch dargestellt. Die berechnete Route beginnt hier bei @UE 61 und endet bei @UE 27.

#figure(
  image("/images/pfadbeispiel.png"),
  caption: [Pfad des Roboters in Wandkonfiguration $w_4$ aus @sec:routenplanung. Route beginnt bei UE 61 und endet bei UE 27]
)<fig:beispielpfad>

Die Pfade werden insgesamt überwiegend zuverlässig bestimmt. Bei Nutzung der Invertierungsstrategie, wie in @sec:path-direction dargestellt, kommt es bei manchen Routen zu fehlerhaften Teilabschnitten, wodurch sie ähnlich zu dem in @fig:pfad-zu-muster (b) gezeigten Pfad verlaufen. Grund hierfür ist immer eine falsche Berechnung der Umlaufrichtung bei einem Wechsel der Hauptrichtung. 

Wird hingegen der vektorbasierte Ansatz genutzt, sind die Teilbereiche immer vollständig korrekt. Wie bereits beschrieben kommt es allerdings auch bei diesem Ansatz regelmäßig zu Problemen beim Wechsel der Hauptrichtung. Ein Beispiel hierfür ist auch in @fig:beispielpfad zu sehen. Bei dem Teilabschnitt der Route von @UE 20 über @UE 62 zu @UE 60 liegt Letzteres rechts der Kante $20 -> 62$. Gemäß der definierten Regel wird daraus eine Umlaufrichtung im Uhrzeigersinn abgeleitet. In diesem Fall wäre jedoch eine Bewegung entgegen dem Uhrzeigersinn erforderlich, da die resultierende Strebe zwischen @UE 62 und @UE 60 andernfalls nicht achsenparallel zur x-Achse, sondern leicht diagonal verläuft.

Weiterhin lässt sich feststellen, dass die Wegpunkte für die Umlenkungen um mehrfach angefahrene @UE:pl:long korrekt gesetzt werden. So wird das @UE 34 an der oberen rechten Türecke zunächst auf halber Route für eine vertikale Strebe genutzt. Kurz vor Ende der Route wird das @UE dann erneut für eine horizontale Strebe umfahren, bevor der Pfad beim @UE 27 endet.  

Auch die Kollisionsvermeidung durch den Einsatz vollständiger Umlenkungen funktioniert erwartungsgemäß. In @fig:beispielpfad ist dies unter anderem am @UE 20 zu erkennen, wo durch eine entsprechende Umlenkung eine Kollision mit @UE 22 vermieden wird, die andernfalls bei der Bewegung Richtung @UE 62 auftreten würde.

Die zusätzlich eingefügten Zwischenpunkte zur Vermeidung von Kollisionen mit bereits verlegtem Garn sind in der Abbildung durch rote Kreise hervorgehoben. Diese werden korrekt jeweils am ersten und letzten Schnittpunkt eines Pfadsegments platziert, wodurch ein Abriss oder Beschädigung des Garns vermieden wird.

#todo[Letzten abschnitt Ausbauen]

