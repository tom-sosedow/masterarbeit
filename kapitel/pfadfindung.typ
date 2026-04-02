#import "/util.typ": *
#import "@preview/cetz:0.4.2"

= Pfadplanung für Roboterarm <sec:path-finding>
#todo[Einleitender Abschnitt zu dem Kapitel]

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

// Umlaufrichtung
Für die Gleichmäßigkeit des Gittermusters ist entscheidend, in welcher Richtung die @UE:pl umfahren werden. Dabei wird, von oben auf den Ablagetisch gesehen, zwischen dem Uhrzeigersinn $R'$ und entgegen des Uhrzeigersinns $R$ unterschieden. Bei einer falsch gewählten Richtung entstehen keine achsenparallelen Streben, welche für die Lastverteilung und strukturelle Integrität unerlässlich sind. Der Zusammenhang ist in @fig:pfad-zu-muster dargestellt. Dargestellt ist eine Teilroute um die zwei @UE:pl:long $P$ und $Q$, für die je @UE drei Wegpunkte zum Abfahren durch den Roboter definiert wurden. Folgt der Roboterarm dem Pfad $(a,b,c,d,e,f)$, wie im linken Bild blau dargestellt, entstehen achsenparallele, horizontale Streben des Carbongarns (rot dargestellt). 
Wird hingegen bei unveränderter Reihenfolge der anzufahrenden @UE die Umlaufrichtung invertiert, so ergibt sich effektiv eine Umkehr der lokalen Wegpunktreihenfolge. Die resultierende Sequenz lautet in diesem Fall $(c,b,a,f,e,d)$. Wie im rechten Teil der Abbildung zu erkennen ist, verlaufen die erzeugten Streben dadurch nicht mehr parallel, sondern weisen teilweise Kreuzungen auf.
Analog dazu kann eine fehlerhafte Festlegung der zugehörigen Wegpunkte sowie ihrer Reihenfolge dazu führen, dass einzelne @UE:pl ausgelassen werden, Lücken in der Gitterstruktur entstehen oder Kollisionen mit benachbarten @UE auftreten @merschAutomation3DRobotic2025.

#figure(
  stack(
    dir: ltr,
    spacing: 5%,
    image("/images/pfad-zu-muster-richtig.png", width: 50%),
    //line(start: (0%,2%), end: (0%, 13%)),
    image("/images/pfad-zu-muster-falsch.png", width: 50%),
  ),
 caption: [Pfad des Roboters (Blau) und daraus resultierende Garnstruktur (Rot) um zwei Umlenkelemente mit korrekter Umlaufrichtung (links) und vertauschter Umlaufrichtung (rechts)]
)<fig:pfad-zu-muster>


== Stand der Forschung

Auch für das Problem der Pfadplanung lassen sich relevante Erkenntnisse aus dem Bereich der String Art ableiten. In den Arbeiten von #citep(<birsakStringArtComputational2018>) und #citep(<happelQuotemeImg2string2026>), die sich mit klassischer String Art innerhalb eines mit Nägeln bestückten Rahmens befassen, wird jedoch keine explizite Festlegung der Umlaufrichtung um die Nägel vorgenommen. Dies ist vermutlich darauf zurückzuführen, dass aufgrund der geringen Größe der Nägel beziehungsweise Pins der Unterschied zwischen verschiedenen Umlaufrichtungen vernachlässigbar ist. In der Praxis kann daher eine vollständige Umrundung in konstanter Richtung erfolgen, ohne das resultierende Bild wesentlich zu beeinflussen. Zudem sind die Rahmen im Allgemeinen konvex, sodass es keine Hindernisse innerhalb der Zeichenfläche gibt.

Einen stärkeren Bezug zum vorliegenden Problem weist hingegen String Art auf, bei der die Nägel innerhalb der Zeichenfläche platziert werden. In einem Blogbeitrag beschreibt #citep(<morris-hillBuildingStringArt2023>) einen Ansatz, bei dem nach einer initialen Punkt-zu-Punkt-Planung ein konkreter Werkzeugpfad berechnet wird. Hierzu wird um die Nägel ein Sicherheitskreis beschrieben, dessen Radius größer ist als der der Nägel. Schneidet eine geplante Strecke einen solchen Sicherheitsbereich, wird die Laufbahn entsprechend angepasst, sodass das Werkzeug zwischen Ein- und Austrittspunkt entlang der Kreisbahn um den Nagel geführt wird. Dieser Ansatz zur Kollisionsvermeidung kann als konzeptionelle Grundlage für die im Folgenden entwickelte Vorgehensweise dienen.

Für die Bestimmung der Umlaufrichtung um die @UE:pl:long können die Ergebnisse von #citep(<merschAutomation3DRobotic2025>) herangezogen werden. Obwohl hier primär dreidimensionale Skelette betrachtet werden, besteht auch in diesem Kontext die Anforderung, eine zuverlässige Haftung des aus unterschiedlichen Richtungen zugeführten Garns an den Pins sicherzustellen. Der zugrunde liegende Lösungsansatz hierfür lässt sich teilweise auf das vorliegende Problem applizieren und wird in @sec:path-direction näher betrachtet.

Die spezifische Anforderung, gleichmäßig verteilte und zugleich flächenfüllende Streben zu erzeugen, ist in der bestehenden Literatur bislang nur unzureichend untersucht. Zudem lassen sich vorhandene Ansätze aufgrund teilweise in Konflikt stehender Anforderungen nicht auf das vorliegende Problem übertragen. Vor diesem Hintergrund sind weitere Betrachtungen diesbezüglich nötig.

#todo[ ähnliche literatur für fehlendes?]
  
== Bestimmung der Umlaufrichtung <sec:path-direction>
// Umlaufrichtung: Bestimmung durch Vektor 

Für die Bestimmung der Umlaufrichtung muss in Umlenkungen in Hauptrichtung und zur Änderung der Hauptrichtung unterschieden werden. Bei den meisten @UE wird in Hauptrichtung umgelenkt. In den Ecken der Wand wird eine Änderung der Hauptrichtung vollzogen, sodass die Umlenkungen an diesen Stellen gesondert betrachtet werden müssen. Zu Bestimmung der Umlaufrichtung der Umlenkungen in Hauptrichtung werden zwei Ansätze untersucht. 

Einerseits ist zu beobachten, dass die Umlaufrichtung bei jeder Umlenkung invertiert wird, solang die Hauptrichtung beibehalten wird. Für die in @sec:route-puzzle-based beschriebenen Subgraphen wird also eine 2-Färbung des Graphen gesucht, wobei jede Farbe eine Umlaufrichtung darstellt. Da die Teilroute einen linearen Subgraph aufspannt, gibt es lediglich zwei Möglichkeiten einer 2-Färbung des Graphen, welche von der Färbung des initialen Knotens abhängen. Es müssen also für den Start jeder Teilroute Regeln gefunden werden, welche Färbung der erste Knoten besitzen muss. Eine falsche Zuweisung würde zu vertauschten Umlenkungen in der gesamten Teilroute erzeugen. 


#todo[Schaubild zur verdeutlichung. Korrekter subgraph -> inkorrekter subgraph]

Eine weitere Methode zur Bestimmung der Umlaufrichtung basiert auf einem vektoriellen Ansatz nach #citep(<merschAutomation3DRobotic2025>). Zur Bestimmung der Umlaufrichtung an einem @UE:long $B$ mit Position $overarrow(b)$ werden dessen Vorgänger $A$ mit Position $overarrow(a)$ sowie sein Nachfolger $C$ mit Position $overarrow(c)$ in der Route betrachtet.

Aus dem Vorzeichen des Kreuzprodukts
$p = (overarrow(b) - overarrow(a)) times (overarrow(c) - overarrow(a))$
lässt sich die Umlaufrichtung ableiten. Ist das Kreuzprodukt positiv, liegt $C$ links des Vektors von $A$ nach $B$; bei einem negativen Wert entsprechend rechts davon. Befindet sich $C$ rechts des Vektors $overarrow(b) - overarrow(a)$, ist eine Bewegung im Uhrzeigersinn um $B$ erforderlich, während bei einer Lage auf der linken Seite eine Umlaufbewegung entgegen dem Uhrzeigersinn gewählt wird. Der Sachverhalt ist in @fig:vektorbasierte-umlaufrichtung für $R'$ (links) und $R$ (rechts) dargestellt.

#figure(
  cetz.canvas({
    import cetz.draw: *

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

Dieser Ansatz berechnet die Umlaufrichtung um $B$ herum unabhängig von der Lage der einzelnen Knoten und der Umlaufrichtung des vorherigen Knotens zuverlässig.


// Besondere Umlenkungen

Beide gezeigten Ansätze versagen bei der Bestimmung der Umlaufrichtung bei Knoten, in denen sich die Hauptrichtung ändert. Die ist in @fig:vektorbasierte-umlaufrichtung-probleme exemplarisch dargestellt.

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
    circle((4,20))
    circle((6,0))
    circle((10,0), stroke: (dash: "dashed"))

    //right vert
    circle((20,2))
    circle((20,6))
    circle((20,10), stroke: (dash: "dashed"))

    // route
    line((6,0), (4,20), mark:(end:">"))
    line((4,20),(2,0), mark:(end:">"))
    line((2,0),(20,2), mark:(end:">"))

    arc((-0.5,0), start: 160deg, delta:150deg, radius: 2, mark: (end: ">"), stroke: (paint: red))
    content((-2,-2), text(fill:red)[$R'$])

    // falscher pfad
    line((3,20), (0.8,0.3), stroke:(paint: red))
    arc((0.8,0.3), start: 160deg, delta:150deg, radius: 1.3, stroke: (paint: red))
    line((5.5,1),(20,1), stroke: (paint: red))
    line((2.9,-1.1),(5.5,1), stroke: (paint: red))


  }),
  caption: [Fehlerhafte Bestimmung der Umlaufrichtung bei Änderung der Umlaufrichtung]
)<fig:vektorbasierte-umlaufrichtung-probleme>

- beide ansätze versagen beim wechsel zwischen den in @sec:route-puzzle-based definierten bereichen
- müssen gesondert betrachtet werden
  - herzumlenkungen: pausieren des wechsels und volle umkreisungen machen
    - #todo[ bild einfügen]
  - problem: bei manchen fällen nicht trivial entscheidbar, wann es ein sonderfall ist und wann nicht
- #todo[ lösung?]

// Pfad um die UE herum
- zur bestimmung des tatsächlichen pfades mithilfe der route und der umlaufrichtung:
  - modellierung durch liste von anzufahrenden punkten, an denen keine @UE liegen
- jede @UE hat jeweils einen ein- und ausgangspunkt
  - mittelpunkt dazwischen erzeugt dann den bogen
  - bestimmt durch position und den vorherigen und nachfolgenden knoten aus der route
  - bsp.: rolle $i$ an rechter seite der wand mit vorgänger $i-1$ und nachfolger $i+1$, wobei $y_i = y_(i-1) + 1$
    - mittelpunkt bei $(x_i+1, y_i)$, eingang bei $y_(i-1)$, ausgang bei $y_(i+1)$
- dadurch entsteht punkttripel
  - laufrichtung um rolle gibt an, ob reihenfolge des tripels invertiert wird oder nicht
  - zu beachten: position des mittelpunktes kann auch umlaufrichtung flippen
    - bsp: oben nach unten, mittelpkt rechts: im uhrzeigersinn, mittelpkt links: entgegen uhrzeigersinn
- punkttripel wird an bestehenden pfad angehängt



== Kollisionen

#todo[@morris-hillBuildingStringArt2023 Ansatz für Kollisionsvermeidung mit Kreisbahnen als Inspiration für meinen Ansatz nennen]

// Problemdefinition
- bei manchen verbindungen zwischen 2 @UE kann es zu kollisionen mit anderen @UE kommen, da sie zwischen start und zielpunkt eines berechneten teils des pfades liegen
- durch entstehendes zickzack-muster würde der roboter bei den streben nahe der Tür mit deren @UE kollidieren
  - das geschieht daher, dass #todo[ math.beschreibung für streben nahe der tür] MAYBE bild?
  - aber auch an den rändern der wand kann es passieren
- auch mit bereits verlegtem garn kann das ablagewerkzeug kollidieren, im garn festhängen und dann das gitter zerreißen 

// Volle umlenkungen
- für eine einfache und generalisierbare methode kann das knotentripel um zwei punkte erweitert werden
  - diese punkte haben gleiche x- und y-Koordinaten und ersetzen den ein- und ausgangspunkt, sodass eine ganze umkreisung des knotens gefahren wird
  - durch die spannung des garns wird es dennoch ordnungsgemäß verlegt
  - diese neuen punkte werden in hauptlaufrichtung in höhe des äußeren knotens gelegt, beispiel in folgendem bild
  - #todo[ bild einfügen]

// Weitere Kollisionen erkennen und beheben
- #todo[ math. Beschreibung, wann kollision]
- gefundene kollisionen beheben, indem ein neuer punkt in richtung des verbindungsvektors und passender distanz in den pfad eingereiht
- iterativ kollisionen erkennen, dann beheben und erneut überprüfen, ob neue kollisionen dazu gekommen sind


// Kollisionen mit bereits gelegtem Garn
- zur kollisionsvermeidung mit bereits verlegtem garn
  - erster und letzter punkt werden dupliziert und z komponente so angepasst, dass der roboter auf der höheren ebene zum ersten punkt fährt, dann senkrecht nach unten, die umlenkung über den mittelpunkt und dann wieder auf die obere ebene fährt, um zur nächsten @UE zu gelangen
  - mit z-Achse in positiver richtung vom Boden: \
    $(p_1,p_2,p_3)|-> (p'_1,p_1,p_2,p_3,p'_3) "mit" p'_1_((z)) = p'_3_((z)) > p_1_((z)) = p_2_((z)) = p_3_((z))$
- MAYBE pseudo code einfügen?