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
    columns:(auto, 15%, auto),
    rows:(auto, auto),
    cetz.canvas({
      import cetz.draw: *

      scale(0.6)
      content((4,6), [Pfad: $(...,d,a,b,c,d,e,f,c,...)$])
      // links
      circle((0,0))
      circle((0,4), stroke: (dash: "dashed", paint: gray))
      content((0,0), [Q])
      let points1 = ((0,2),(-2, 0),(0,-2))

      for (p,letter) in points1.zip(("d","e","f")) {
        circle(p, radius: 0.2)
        content((p.at(0) + 0, p.at(1) + 0.6), [#letter])
      }

      arc((-1.5,1.5), delta: 180deg, start: 95deg, radius: 1.5, mark: (end: ">"), stroke: (paint: purple))
      content((-3.5,1), text(fill: purple)[$R$])

      
      // rechts
      circle((8,2))
      content((8,2), [P])
      circle((8,-2), stroke: (dash: "dashed", paint: gray))

      let points3 = ((8,2+2),(8+2, 2),(8,2-2))
      
      for (p, letter) in points3.zip(("a","b","c")) {
        circle(p, radius: 0.2)
        content((p.at(0) + 0, p.at(1) + 0.6), [#letter])
      }

      set-style(mark: (end: ">>"), stroke: (paint: blue))
      line(points3.at(0),points3.at(1))
      line(points3.at(1),points3.at(2))       
      line(points1.at(0),points1.at(1))
      line(points1.at(1),points1.at(2))
      line(points3.last(), points1.first())
      line(points1.first(), points3.first())
      line(points1.last(), points3.last())

      set-style(mark: none, stroke: (paint: red))
      line((0,-1.1), (8,-1))
      line((0,1.1), (8,0.9))
      line((0,3), (8,3.1))
      arc((0,-1.1), radius: 1.1, start: -90deg, delta: -180deg)
      arc((8,1 - 0.1), radius: 1.1, start: -90deg, delta: 180deg)
    }),
    [],
    cetz.canvas({
      import cetz.draw: *

      scale(0.6)
      content((4,7), [Pfad: $(...,c,b,a,f,e,d,...)$])
      // links
      circle((0,0))
      circle((0,4), stroke: (dash: "dashed", paint: gray))
      content((0,0), [Q])
      let points1 = ((0,2),(-2, 0),(0,-2)).rev()
      

      for (p,letter) in points1.zip(("d","e","f").rev()) {
        circle(p, radius: 0.2)
        content((p.at(0) + 0, p.at(1) + 0.6), [#letter])
      }

      // rechts
      circle((8,2))
      circle((8,-2), stroke: (dash: "dashed", paint: gray))
      content((8,2), [P])

      let points3 = ((8,2+2),(8+2, 2),(8,2-2)).rev()
      
      for (p, letter) in points3.zip(("a","b","c").rev()) {
        circle(p, radius: 0.2)
        content((p.at(0) + 0, p.at(1) + 0.6), [#letter])
      }

      arc((-1.5,-1.5), delta: -180deg, start: -95deg, radius: 1.5, mark: (end: ">"), stroke: (paint: purple))
      content((-3.5,1), text(fill: purple)[$R'$])

      set-style(mark: (end: ">>"), stroke: (paint: blue))
      line(points3.at(0),points3.at(1))
      line(points3.at(1),points3.at(2))       
      line(points1.at(0),points1.at(1))
      line(points1.at(1),points1.at(2))
      line((0,6), points3.first())
      line(points3.last(), points1.first())
      line(points1.last(), (8,-4))

      set-style(mark: none, stroke: (paint: red))
      line((0.2,-1.1), (8-0.4,3))
      line((0.2,1.1),(8-0.25,-3))
      line((0.2,5.1),(8-0.2,0.9))
      arc((0.3,-1.05), radius: 1.1, start: -75deg, delta: -210deg)
      arc((8-0.2,1 - 0.09), radius: 1.1, start: -100deg, delta: 210deg)
    }),
    [(a)],
    [],
    [(b)],
  ),
  caption: [Pfad des Roboters (Blau) aus Route $(..., P, Q, ...)$ und daraus resultierende Garnstruktur (Rot) um zwei Umlenkelemente mit korrekter Umlaufrichtung (a) und vertauschter Umlaufrichtung (b)]
)<fig:pfad-zu-muster>


== Stand der Forschung

Zur Bestimmung der Wegpunkte $a,b,c$ beziehungsweise $d,e,f$ aus @fig:pfad-zu-muster wird im aktuellen Ansatz des @CBT derzeit die Sonderumlenkung als Referenz für die Art der Umlenkung herangezogen. Da im bestehenden Verfahren zuerst alle vertikalen Streben verlegt werden, ergibt sich eine vergleichsweise einfache Bestimmung der Wegpunkte. Der erste und letzte Wegpunkt liegen jeweils auf der Höhe des entsprechenden Umlenkelements, sind jedoch um jeweils einen Durchmesser nach links beziehungsweise rechts versetzt. Der mittlere Wegpunkt ($b$ bzw. $e$) befindet sich hingegen auf dem gleichen x-Wert wie das Umlenkelement und ist alternierend um einen Durchmesser nach oben oder unten versetzt.
Für ein @UE $Q=(x,y,i) in V$ an der Ober- bzw. Unterseite der Wand sowie dem Radius $r$ eines Umlenkelements ergeben sich damit die folgenden Wegpunkte
$ 
a = (x-1,y,0) \
c = (x+1, y,0) \
b = (x,y + rho,0) "mit" rho = cases(-1 ", falls" 2 divides x, 1 ", sonst")
$

Nach der Durchführung der Sonderumlenkung wird dieses Verfahren analog angewendet, allerdings um 90° rotiert. Die Bestimmung des mittleren Wegpunktes richtet sich dann nach der Position der Sonderumlenkung. 

Zur Vermeidung von Kollisionen mit bereits verlegtem Garn werden zusätzlich jeweils ein Wegpunkt vor und nach den drei Punkten $a,b,c$ eingefügt. Diese liegen entlang der Nebenrichtung zwischen dem Vorgänger- beziehungsweise Nachfolgeelement, sind jedoch um 20 Millimeter in z-Richtung angehoben. In diesem Fall ergibt sich der neue erste Wegpunkt des Umlenkelements $Q=(x,y,i)$ zu
$ a' = (x-1,y - rho, 20) "mit" rho = cases(-1 ", falls" 2 divides x, 1 ", sonst") $
sowie der neue letzte Wegpunkt zu 
$ c' = (x+1,y - rho, 20) "mit" rho = cases(-1 ", falls" 2 divides x, 1 ", sonst") $
sodass der Teilpfad um $Q$ herum schließlich die Abfolge $(a',a,b,c,c')$ beschreibt.

Aufgrund der erhöhten Komplexität des vorliegenden Problems, insbesondere durch den Türausschnitt, können einige dieser Annahmen jedoch nicht übertragen werden. So ist beispielsweise nicht a priori festgelegt, ob zunächst horizontale oder vertikale Streben verlegt werden oder wohin die Hauptrichtung verläuft, was die Positionierung des mittleren Wegpunktes zusätzlich erschwert. Die isolierte Betrachtung der @UE:pl:long und Erzeugung des Pfades durch stützende Wegpunkte könnte allerdings für die Generierung eines validen Teilpfades genutzt werden. Zur Erweiterung dieses Ansatzes bietet es sich daher an, zusätzliche Perspektiven und Methoden aus verwandten Anwendungsgebieten heranzuziehen.

Dafür können sich wieder relevante Erkenntnisse aus dem Bereich der String Art ableiten lassen. In den Arbeiten von #citep(<birsakStringArtComputational2018>) und #citep(<happelQuotemeImg2string2026>), die sich mit klassischer String Art innerhalb eines mit Nägeln bestückten Rahmens befassen, wird jedoch keine explizite Festlegung der Umlaufrichtung um die Nägel vorgenommen. Dies ist vermutlich darauf zurückzuführen, dass aufgrund der geringen Größe der Nägel beziehungsweise Pins der Unterschied zwischen verschiedenen Umlaufrichtungen vernachlässigbar ist. In der Praxis kann daher eine vollständige Umrundung in konstanter Richtung erfolgen, ohne das resultierende Bild wesentlich zu beeinflussen. Zudem sind die Rahmen im Allgemeinen konvex, sodass es keine Hindernisse innerhalb der Zeichenfläche gibt.

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

Eine korrekte Lösung würde hingegen eine Umlaufbewegung im Uhrzeigersinn erfordern. Dadurch ließe sich sicherstellen, dass die abschließende vertikale Strebe achsenparallel zur y-Achse verläuft und zugleich der Beginn der ersten horizontalen Strebe achsenparallel zur x-Achse ausgerichtet ist. Dafür wird die berechnete Umlaufrichtung an allen @UE getauscht, an denen sich die Hauptrichtung ändert, also zu denen eine vertikale bzw. horizontale Strebe verläuft und dann eine horizontale bzw. vertikale Strebe ausgeht. 

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
Um sichergestellt alle Kollisionen beheben zu können, kann der Ansatz von @morris-hillBuildingStringArt2023 zur Kollisionsauflösung durch Kreisbahnen mit einem Sicherheitsradius herangezogen werden. Das Vorgehen ist in @fig:morris-kollisionsvermeidung exemplarisch skizziert. Dafür wird ein neuer Wegpunkt in Richtung des auf der kreuzenden Strecke orthogonal stehenden und von dem kollidierten @UE ausgehenden Verbindungsvektors eingefügt. Dieser ist in der Abbildung grün markiert. Anschließend kann der entstandene Pfad, in der Abbildung blau markiert, iterativ auf weitere oder neu entstandene Verletzungen der Sicherheitsabstände zu @UE geprüft werden, bis keine mehr übrig sind oder eine maximale Iterationsgrenze erreicht wurde. Sollte die Berechnung stoppen bevor alle Kollisionen behoben werden konnten, gibt das Programm einen Fehler aus und generiert keinen Pfad für die Ausgabe.

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
  ),
  caption: [Iterative Kollisionserkennung nach #citep(<morris-hillBuildingStringArt2023>) mit zwei Iterationen. In Iteration (a) wird die Kollision mit UE x behoben, da der rote Teil des Pfades des Roboters den roten Kreis mit dem Sicherheitsradius von x schneidet. Danach besteht noch die Kollision mit UE y, welche in Iteration (b) auf gleiche Weise behoben wird.]
)<fig:morris-kollisionsvermeidung>

// Kollisionen mit bereits gelegtem Garn
Darüber hinaus ist sicherzustellen, dass Kollisionen der Austrittsdüse mit bereits verlegtem Garn vermieden werden. Eine effektive Strategie zur Kollisionsvermeidung besteht darin, das Werkzeug temporär anzuheben, sobald eine bestehende Strebe gekreuzt wird. Dabei ist jedoch zu beachten, dass die Anhebung weder zu groß noch zu steil erfolgen darf, da andernfalls die Gefahr besteht, dass das Garn vom vorherigen @UE abrutscht. Dies würde auch an den Kreuzungspunkten dazu führen, dass keine Verbindung zwischen sich kreuzenden Streben entsteht und somit die Belastbarkeit des Gitters nach dem Temperieren eingeschränkt ist.

Da zur Erkennung solcher Kreuzungen kein physikalisches Modell des unter Spannung stehenden Garns verwendet wird, muss der geplante Pfad als Annäherung dienen. 
Hierzu wird der Pfad, zunächst ohne Erkennung von Garnkollisionen, erstellt und dabei der Abstand der Wegpunkte zur Mitte der @UE von zwei Radien auf einen Radius geändert. Ebenfalls werden von Sonderumlenkungen und vollständigen Umlenkungen der erste und letzte Wegpunkt entfernt, sodass anliegende Streben eher der Realität entsprechen. Der resultierende Pfad wird als $p'$ bezeichnet. Wenngleich diese Berechnung keinen validen Pfad für den Roboterarm erzeugt, da die Abstände nicht eingehalten werden, führt es dazu, dass die Streben zwischen den Außenkanten der @UE:pl:long verlaufen und somit eine Annäherung der resultierenden Garnstruktur entsteht. Das Ergebnis ist in @fig:pfad-garnannaeherung zu sehen. Es ist zu beachten, dass dennoch einige Streben nicht so verlaufen, wie sie es später tun werden. Ein Beispiel hierfür ist die am weitesten rechts liegende vertikale Strebe, die durch die vollständige Umlenkung um das @UE 62 entsteht. Hier kommt es zu einer Abweichung, da durch das Entfernen des ersten und letzten Wegpunktes für die Umlenkung eine gewöhnliche Umlenkung mit drei Punkten entsteht. Da dort die Hauptrichtung wechselt, verläuft diese Strebe im Gegensatz zur Realität in der Annäherung somit nicht achsenparallel, sondern leicht diagonal.

#figure(
  image("/images/pfadannaeherung.png"),
  caption: [Annäherung $p'$ an resultierende Garnstruktur am Beispiel von Wandkonfiguration $w_4$],
)<fig:pfad-garnannaeherung>

Der Pfad $p$ für den Roboter wird schrittweise analysiert und für jeden Abschnitt überprüft, ob und an welchen Positionen er frühere Segmente in $p'$ schneidet. Die identifizierten Schnittpunkte werden entlang der jeweiligen Strebe von $p$ geordnet.

Am ersten Kreuzungspunkt wird, wie beschrieben, ein zusätzlicher Wegpunkt eingefügt, der sich etwa zwei Zentimeter oberhalb der regulären Arbeitsebene befindet. Die Anhebung erfolgt dabei erst unmittelbar am Schnittpunkt, um die Steigung möglichst gering zu halten und somit die auf das @UE wirkenden vertikalen Kräfte zu minimieren. Ein weiterer zusätzlicher Wegpunkt wird an der letzten Kreuzung eingefügt. Auf diese Weise wird verhindert, dass es beim Übergang zum ersten Wegpunkt der folgenden Umlenkung, der wieder auf der ursprünglichen Ebene liegt, zu einer Kollision mit der zuletzt gekreuzten Strebe kommt.

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
  caption: [Seitenansicht für vertikale Bewegungen des Roboterarms.]
)<fig:seitenansicht-vertikaler-pfad>

== Arten von Umlenkungen

Aus den vorangegangenen Betrachtungen ergeben sich vier verschiedene Arten von Umlenkbewegungen, welche in @fig:umlenkungsarten zusammenfassend dargestellt sind.

#figure(
  cetz.canvas({
    import cetz.draw: *

    scale(0.5)
    set-style(mark: (end: ">"))

    let pointsNormalRotation = ((0,4),(0,1),(1,0),(2,1),(2,4))
    circle((1,1), radius: 0.5)
    for i in range(pointsNormalRotation.len()-1) {
      line(pointsNormalRotation.at(i), pointsNormalRotation.at(i+1))
    }
    content((1,-2.4), [(1) Normal])

    translate(x: 6)

    let pointsFullRotation = ((0.8,4),(1,2),(0,1),(1,0),(2,1),(1,2),(1.2,4))
    circle((1,1), radius: 0.5)
    for i in range(pointsFullRotation.len()-1) {
      line(pointsFullRotation.at(i), pointsFullRotation.at(i+1))
    }
    content((1,-2.5), [(2) Vollständig])

    translate(x: 8)

    let pointsSpecialRotation = ((0.5,4),(0.9,1.9),(0,1),(1,0),(2,1),(3,2),(2,3),(1.1,2.1),(-1,2))
    circle((1,1), radius: 0.5)
    circle((2,2), radius: 0.5)
    for i in range(pointsSpecialRotation.len()-1) {
      line(pointsSpecialRotation.at(i), pointsSpecialRotation.at(i+1))
    }
    content((1,-2.5), [(3) Sonderumlenkung])

    translate(x: 7)

    let pointsCornerRotation = ((4,2),(2,2),(0,2),(0,0),(2,0),(2,2),(2,4))
    circle((1,1), radius: 0.5)
    for i in range(pointsCornerRotation.len()-1) {
      line(pointsCornerRotation.at(i), pointsCornerRotation.at(i+1))
    }
    content((1,-2.5), [(4) Ecke])
  }),
  caption: [Die vier verschiedenen Umlenkungsarten, welche je nach Position des UE ausgewählt werden.]
)<fig:umlenkungsarten>

Normale Umlenkungen (1) werden dabei verwendet, um bei gleichbleibender Hauptrichtung einen Wechsel der Nebenrichtung zu vollziehen und somit eine vertikale oder horizontale Strebe zu verlegen. Diese Art der Umlenkung wird insbesondere dann eingesetzt, wenn sich Vorgänger- und Zielknoten in direkt benachbarten Spalten oder Zeilen befinden, also $Delta x = 1 xor Delta y = 1$ gilt.

Vollständige beziehungsweise volle Umlenkungen (2) kommen an den Enden von Teilrouten zum Einsatz, wenn eine Änderung der Hauptrichtung erfolgt und an der entsprechenden Ecke keine Sonderstelle besteht. So wird beispielsweise in @fig:pfad-garnannaeherung beim Übergang von $R V$ zu $R H^R$ jeweils eine Sonderumlenkung bei @UE 20 als Ende von $R V$ sowie eine am Beginn von $R H ^R$ bei @UE 62 eingesetzt, da zwischen beiden Teilrouten eine Änderung der Hauptrichtung stattfindet. Diese Art der Umlenkung ermöglicht ein kollisionsfreies Anfahren der Kreisbahn mit doppeltem Radius eines Umlenkelements, sodass die Richtungsänderung sicher ausgeführt werden kann. Ebenfalls wird diese Umlenkung bei dem @UE unmittelbar über dem Türausschnitt auf Höhe $y=t_(y,1)-1$ eingesetzt, also in @fig:pfad-garnannaeherung bei dem pink markiertem @UE 27, um eine Kollision mit den @UE des Türausschnittes zu verhindern. Zuletzt wird auf diese Umlenkung als Standardumlenkung zurückgegriffen, falls die Art der Umlenkung nicht anhand der Position des @UE durch andere Regeln bestimmt werden konnte. In @appendix:wandkonfigurationen ist das beim @UE 6 in Wand 27 zu sehen, da dort eine Navigation von @UE 60 auf @UE 6 erfolgt, welche sich in derselben Spalte befinden.

Sonderumlenkungen (3) werden ähnlich wie vollständige Umlenkungen ebenfalls an den Enden von Teilrouten bei Hauptrichtungsänderung eingesetzt. Dies geschieht jedoch ausschließlich dann, wenn die angrenzenden @UE eine Sonderstelle bilden und der Roboter somit nicht mit dem Werkzeug zwischen beiden @UE hindurch fahren kann. In @fig:pfad-garnannaeherung ist eine solche Umlenkung beispielsweise bei den @UE 20 und 0 erforderlich. Grundsätzlich werden hierbei zwei vollständige Umlenkungen durchgeführt, wobei der letzte Wegpunkt des ersten sowie der erste Wegpunkt des zweiten anzufahrenden Umlenkelements entfernt werden, um eine Kollision des Werkzeugs zwischen den @UE zu vermeiden.

Eckumlenkungen (4) werden eingesetzt, wenn es sich bei dem @UE um ein optionales @UE in einer der vier Wandecken oder in einer der beiden unteren Türecken handelt. Diese Art der Umlenkung ähnelt prinzipiell der vollständigen Umlenkung. Der Unterschied besteht jedoch darin, dass sich die Punkte für das kollisionsfreie Anfahren in den diagonal gegenüberliegenden Ecken der angrenzenden acht Felder befinden und nicht direkt oberhalb, unterhalb, links oder rechts des Mittelpunkts des @UE.


== Ergebnisse

Zur Analyse des gezeigten Vorgehens werden, analog zu @sec:ue-place-result, erneut alle 32 möglichen Wandkonfigurationen überprüft, wobei resultierenden Pfade jeweils in @appendix:wandkonfigurationen abgebildet sind. Die Tests werden ebenfalls auf einem Intel(R) Core(TM) i5-8350U Prozessor mit 24 GB Arbeitsspeicher durchgeführt. Die durchschnittliche Rechenzeit beträgt 1,57 Millisekunden, während die maximal gemessene Rechenzeit bei 10,32 Millisekunden über alle 32 Testläufe liegt. In @fig:beispielpfad ist der berechnete Pfad für die Wandkonfiguration $w_4$ aus @sec:routenplanung exemplarisch dargestellt. Die berechnete Route beginnt hier bei @UE 61 und endet bei @UE 27.

#figure(
  image("/images/pfadbeispiel.png", width: 110%),
  caption: [Pfad $p$ des Roboters in einer kleinen Wandkonfiguration $w_4$ aus @sec:routenplanung. Route beginnt bei UE 61 und endet bei UE 27. In Rot dargestellt sind die Punkte, die zur Kollisionsvermeidung auf einer höheren Ebene platziert werden sowie in halbtransparentem Rot die Approximation des Gittermusters zur Bestimmung dieser Punkte.]
)<fig:beispielpfad>

Die Pfade werden insgesamt überwiegend zuverlässig bestimmt. Bei Nutzung der Invertierungsstrategie, wie in @sec:path-direction dargestellt, kommt es bei manchen Routen zu fehlerhaften Teilabschnitten, wodurch sie ähnlich zu dem in @fig:pfad-zu-muster (b) gezeigten Pfad verlaufen. Grund hierfür ist immer eine falsche Berechnung der anfänglichen Umlaufrichtung bei einem Wechsel der Hauptrichtung.

Wird hingegen der vektorbasierte Ansatz genutzt, sind die Teilbereiche immer vollständig korrekt. Insbesondere kann durch die Ausnahmeregelung zur Invertierung der Umlaufrichtung beim Wechsel der Hauptrichtung verhindert werden, dass an einigen Stellen die Umlaufrichtung inkorrekt bestimmt wird. So würde, ohne diese Regel, für das @UE 62 eine Umlenkung im Uhrzeigersinn basierend auf dem reinen vektoriellen Ansatz berechnet werden, was eine diagonal verlaufende horizontale Strebe zum @UE 60 zufolge hätte. Da sich das @UE 62 allerdings in einer Ecke der Wand befindet und zudem die Hauptrichtung ändert, wird hier die Umlaufrichtung korrekterweise getauscht.

Weiterhin lässt sich feststellen, dass die Wegpunkte für die Umlenkungen um mehrfach angefahrene @UE:pl:long korrekt gesetzt werden. So wird das @UE 34 an der oberen rechten Türecke zunächst auf halber Route für eine vertikale Strebe genutzt. Kurz vor Ende der Route wird das @UE dann erneut für eine horizontale Strebe umfahren, bevor der Pfad beim @UE 27 endet.  

Auch die Kollisionsvermeidung funktioniert erwartungsgemäß zuverlässig. In @fig:beispielpfad ist unter anderem an @UE 20 und 62 zu erkennen, dass eine vollständige Umlenkung eine Kollision mit @UE 22 verhindert, die andernfalls bei der Bewegung Richtung @UE 62 auftreten würde. Im @appendix:wandkonfigurationen Wand 28 ist ebenfalls zu sehen, dass die Kollisionsvermeidung durch Sicherheitsabstände nach #citep(<morris-hillBuildingStringArt2023>) erfolgreich eine Kollision verhindern konnte. So wird bei der Navigation von @UE 68 zu @UE 7 der Sicherheitsabstand von @UE 36 verletzt, wodurch ein neuer Wegpunkt ungefähr bei Koordinate $(7.5, 13.5)$ eingefügt werden musste. 

Die zusätzlich eingefügten Zwischenpunkte zur Vermeidung von Kollisionen mit bereits verlegtem Garn sind in @fig:beispielpfad durch rote Kreise und die Annäherung der resultierenden Garnstruktur $p'$ in hellem Rot hervorgehoben. Die Wegpunkte werden korrekt jeweils am ersten und letzten Schnittpunkt eines Pfadsegments aus $p$ mit Streben aus $p'$ platziert, wodurch ein Abriss oder Beschädigung des Garns vermieden wird.

#todo[Letzten abschnitt Ausbauen]

