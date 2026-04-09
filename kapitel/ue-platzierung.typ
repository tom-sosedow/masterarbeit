#import "/util.typ": *
#import "@preview/cetz:0.4.2"

= Platzierung der Umlenkelemente <sec:ue-platzierung>
In diesem Kapitel wird die Forschungsfrage I bezüglich der Platzierung der @UE:pl:long  untersucht. Hierzu wird zunächst das zugrunde liegende Problem definiert, abgegrenzt und mathematisch modelliert. Anschließend wird der aktuelle Stand der Forschung zu diesem Problem dargestellt. Darauf aufbauend wird eine Lösungsmethode entwickelt und erläutert. Abschließend erfolgt eine Darstellung der erzielten Ergebnisse.

== Problemdefinition <sec:ue-place-problem>
// Umlenkelemente Einführung
Um die Gitterstruktur des Garns in einem kontinuierlichen Zug ohne Unterbrechung herzustellen, sind Umkehrpunkte erforderlich. Nach #citep(<mechtcherineNeueCarbonfaserbewehrungFur2019>) existieren hierfür zwei grundsätzliche Ansätze: Zum einen kann das Garn spannungsfrei auf einer Oberfläche abgelegt werden, ähnlich dem Verfahren bei 3D-Druckern. Zum anderen kann die Ablage unter Spannung erfolgen, indem das Garn über unbewegliche Umlenkelemente (@UE) geführt wird.

// Haftung und Aufbau einer Rolle
Beim @CBT wurde der zweite Ansatz gewählt, da das in Harz getränkte Garn nach der Temperierung im Ofen sonst an der Ablageoberfläche haften würde. Aus diesem Grund werden zylinderförmige Körper aus Polytetrafluorethylen (PTFE, umgangssprachlich auch Teflon) eingesetzt, von denen die Garnstruktur später leichter zu lösen ist. Diese verfügen über eine magnetische Basis, wodurch sie von einem Roboterarm auf einer ferromagnetischen Platte frei in zwei Dimensionen positioniert werden können. 

#todo[Bild einer Umlenkrolle einfügen]

Die Positionen der @UE:pl sollen vollständig automatisiert und unter Berücksichtigung der folgenden Anforderungen durch einen in diesem Kapitel zu erforschenden Algorithmus berechnet werden.

// Eingabewerte
Zu Beginn der Herstellung eines Carbongitters werden fünf Eingabeparameter benötigt: die Breite und Höhe der Wand ($w_b^*$ und $w_h^*$), die Breite und Höhe des Türausschnitts ($t_b^*$ und $t_h^*$) sowie der Abstand der linken Seite des Türausschnitts zur linken Wandkante ($t_x^*$). 

// Schalungselemente
Diese Maße können jedoch nicht unmittelbar als Grenzen für das Carbongitter verwendet werden. Nach der Erstellung des Gitters wird es in eine vorbereitete Schalung platziert. Diese besteht aus stählernen Schalungselementen, die ebenfalls magnetisch auf einer Metallplatte befestigt werden. Die Schalungselemente verhindern beim Betonguss das Austreten des flüssigen Betons und dienen somit als Begrenzung der Wand. Zu diesen Elementen muss ein Abstand $p$, im Folgenden Padding genannt, eingehalten werden, damit das Carbongitter geschützt und von Außen nicht sichtbar im Beton liegt.

// Verschiebung der Grenzen durch Abstand zur Schalung, Padding
Dadurch verschieben sich die Grenzen für die Platzierung der @UE. Die tatsächlich verfügbare Wandhöhe und -breite ergibt sich somit zu $w_h = w_h^* - 2p$ und $w_b = w_b^* - 2p$. Der Türausschnitt wird aufgrund des notwendigen Abstands zur Schalung links und rechts um das doppelte Padding verbreitert, sodass $t_b = t_b^* + 2p$ gilt. Durch die reduzierte Wandbreite sowie das linke Padding an der Tür muss außerdem der Abstand zur linken Wandkante angepasst werden. Daher ergibt sich $t_x = t_x^* - 2p$. Die Höhe des Türausschnitts bleibt unverändert. Die Zusammenhänge sind in @fig:input-dimensions dargestellt. In Rot sind die Eingabeparameter und in Blau die tatsächlich zur Verfügung stehende Fläche nach Einbeziehung des Paddings markiert.

#figure(
  cetz.canvas({
    import cetz.draw: *

    scale(0.5)
    
    let mark = (end:"|", start:"|")
    content((7.5,2.5), text(fill: red, size: 14pt)[$w_b^*$])
    line((-1,1.5),(16,1.5), stroke:(paint: red), mark: mark)
    line((-1,1),(16,1))
    
    content((17.5,-5), text(fill: red, size: 14pt)[$w_h^*$])
    line((16.5,1),(16.5,-11), stroke:(paint: red), mark: mark)
    
    line((16,1),(16,-11))
    line((16,-11),(9,-11))

    content((7.5,-9), text(fill: red, size: 14pt)[$t_h^*$])
    line((8.5,-11),(8.5, -4), stroke:(paint: red), mark: mark)
    line((9,-11),(9, -4))

    content((7,-5.5), text(fill: red, size: 14pt)[$t_b^*$])
    line((9, -4.5), (5,-4.5), stroke:(paint: red), mark: mark)
    line((9, -4), (5,-4))
    
    line((5,-11),(5, -4))
    
    content((2,-12.5), text(fill: red, size: 14pt)[$t_x^*$])
    line((5, -11.5),(-1,-11.5), stroke:(paint: red), mark: mark)
    line((5, -11),(-1,-11))
    line((-1,-11),(-1,1)) 

    // Verschmalerung
    let smallercolor = blue
    line((-0.5,0.5),(15.5,0.5), stroke: (paint: smallercolor))
    line((15.5,0.5),(15.5,-10.5), stroke: (paint: smallercolor))
    line((15.5,-10.5),(9.5,-10.5), stroke: (paint: smallercolor))
    line((9.5,-10.5),(9.5, -3.5), stroke: (paint: smallercolor))
    line((4.5, -3.5), (9.5,-3.5), stroke: (paint: smallercolor))
    line((4.5,-10.5),(4.5, -3.5), stroke: (paint: smallercolor))
    line((4.5, -10.5),(-0.5,-10.5), stroke: (paint: smallercolor))
    line((-0.5,-10.5),(-0.5,0.5), stroke: (paint: smallercolor))

    line((-1,-3),(-0.5,-3), mark: mark, stroke: (paint: green))
    content((0,-3), text(fill:green)[$p$])

  }),
  caption: [Veranschaulichung der fünf benötigten Eingabeparameter für eine Wand mit Türausschnitt mit und ohne Padding]
)<fig:input-dimensions>

// Math. Modell
Der Radius der @UE wird mit $r$ bezeichnet, der Durchmesser ergibt sich zu $d = 2r$. Da die @UE stets um genau $d$ voneinander versetzt angeordnet werden, ergeben sich diskrete mögliche Positionen auf einem regelmäßigen Raster.

Die Position der @UE in diesem Raster kann modelliert werden durch eine Menge A von zweidimensionalen Koordinaten mit 
$ A = {(x,y) | 0 <= x < x_("max"), 0 <= y < y_("max"), x,y in NN^+_0} $
wobei durch $x_("max") = floor(w_b / d)$ und $y_("max") = floor(w_h / d)$ eine Rasterung der Echtwelt-Koordinaten vollzogen wird. Eine Einheit im Modell beträgt also $d$ Millimeter in der echten Welt.

Der Türausschnitt wird durch ein Koordinatentupel der oberen linken Ecke $t_1 = (t_(x,1), t_(y,1))$ sowie der unteren rechten Ecke $t_2 = (t_(x,2), t_(y,2))$ beschrieben. Für die am Türausschnitt platzierten @UE gilt damit:

$ t_(x,1) <= x <= t_(x,2) and t_(y,1) <= y < t_(y,2) $

Der Koordinatenursprung befindet sich in dieser Arbeit in der oberen linken Ecke. Die $x$-Achse verläuft nach rechts, die $y$-Achse nach unten in positiver Richtung. Entsprechend liegt die obere Wandkante bei $y=0$, die untere bei $y=y_("max")-1$, die linke Seite bei $x=0$ und die rechte bei $x=x_("max")-1$.

// Restriktionen und Zickzackmster der Rollen
Auf gegenüberliegenden Seiten der Struktur sind zwei @UE stets um $d$ Millimeter entlang der jeweiligen Seite versetzt angeordnet und alternieren zwischen beiden Seiten. Für zwei vertikale Seiten an den x-Koordinaten $(x_1, x_2) in {(0, t_(x,2)), (t_(x,1), x_("max")-1)}$ ergibt sich im Modell:

$ (exists y: (x_1,y) in A and 2<=y<=y_("max")-2) arrow \ (x_2, y+1) in A and (x_2, y-1) in A $<eq:rollen-platzierung-vertikale-seiten>

Analog gilt für zwei horizontale Seiten mit den y-Koordinaten $(y_1, y_2) in {(0, y_("max")-1), (0, t_(y,1))}$:

$ (exists x: (x,y_1) in A and 2<=x<=x_("max")-2) arrow \ (x+1, y_2) in A and (x-1, y_2) in A $
#todo[Bereich, wo zwischen den Seiten gewechselt wird in Hauptrichtung, also wo die Tür in dieser Richtung endet, ist nicht gut dargestellt]
In @fig:ue-placement-model (a) ist der Sachverhalt aus @eq:rollen-platzierung-vertikale-seiten exemplarisch für zwei gegenüberliegende vertikale Seiten dargestellt.

// Sonderstellen
Durch die Anforderungen kann es in den Ecken der Wand dazu kommen, dass zwei @UE diagonal direkt nebeneinander platziert werden müssen (Sonderstellen), wie in @fig:ue-placement-model (b) dargestellt. Das Werkzeug des Roboters zum Ablegen des Garns passt nicht in die Lücke dazwischen, was besondere Achtung bei der Pfadplanung erfordert. Bei dem Türausschnitt kann in den oberen beiden Ecken selbiges passieren, wobei es hier dazu führen würde, dass ein unregelmäßiger Abstand im Carbongitter entstehen müsste. Aus diesem Grund ist es bei der Platzierung der @UE wichtig diesen Fall zu vermeiden.

#let r = 0.4
#figure(
  grid(
    columns: 2,
    gutter: 10%,
    [
      #cetz.canvas({
        import cetz.draw: *
        let d = 4
        let darkgray = luma(120)
        circle((0, 0), radius: (r,r))
        circle((d, 2*r), radius: (r,r))
        circle((0, 4*r), radius: (r,r))
        circle((0, 4*r), radius: (r,r))
        content((0, 7*r), [$x_1$])
        line((0,-2*r), (0,6*r), stroke: (dash: "dashed", paint: darkgray))
    
        content((-2, 4*r), [$y-1$])
        line((-1,4*r), (d+1,4*r), stroke: (dash: "dashed", paint: darkgray))
        
        content((-2, 0), [$y+1$])
        line((-1,0), (d+1,0), stroke: (dash: "dashed", paint: darkgray))
    
        content((-2, 2*r), [$y$])
        line((-1,2*r), (d+1,2*r), stroke: (dash: "dashed", paint: darkgray))
        
        content((d, 7*r), [$x_2$])
        line((d,-2*r), (d,6*r), stroke: (dash: "dashed", paint: darkgray))
    
        content((-0.4, 2.5*r), text(fill: red, size: 14pt)[$d$])
        line((0,1*r), (0,3*r), stroke: (paint: red), mark: (end: "|", start: "|"))
      })
      (a) 
    ],
    [
      #cetz.canvas({
        import cetz.draw: *
        
        let d = 4
        let darkgray = luma(120)
        
        circle((2*r, 2*r), radius: (r,r))
        circle((2*r, 6*r), radius: (r,r))
        
        circle((0*r, 0*r), radius: (r,r))
        circle((-4*r, 0*r), radius: (r,r))

        content((-10*r, 0*r), [$y=y_("max")-1$])
        line((-6*r, 0*r), (4*r, 0*r), stroke: (dash: "dashed", paint: darkgray))
        content((2*r, 9*r), [$x=x_("max")-1$])
        line((2*r, 8*r), (2*r, -2*r), stroke: (dash: "dashed", paint: darkgray))

        line((-6*r, -2*r), (4*r, -2*r))
        line((4*r, 8*r), (4*r, -2*r))

        // padding
        line((3*r, 6*r),(4*r, 6*r), stroke: (paint: red), mark: (end: "|", start: "|"))
        content((5*r, 6*r), text(fill: red, size: 14pt)[$p$])
      })
      (b) 
    ]
  ),
  caption: [Veranschaulichung des Modells. Bezeichnungen in Rot stellen Werte in Millimetern dar. (a) Abstand zwischen den UE, (b) Sonderstelle in unterer rechter Ecke der Wand mit Padding $p=r$ ],
) <fig:ue-placement-model>

// Anzahl der Fälle
Wird einer der Eingabeparameter um mindestens $d$ vergrößert, kann entlang der entsprechenden Hauptachse ein weiteres @UE auf der gegenüberliegenden Seite platziert werden.

Erhöht sich beispielsweise die Wandbreite auf $x'_"max" = x_("max") + 1$ und befindet sich das aktuell letzte @UE in der oberen rechten Ecke ($a = (x_("max")-2,0)$), kann anschließend ein weiteres @UE in der unteren linken Ecke ($a' = (x'_"max"-2, y_"max"-1)$) platziert werden.

Dadurch können sich die Stellen, an denen @UE diagonal aneinander liegen, ändern, was wiederum erhebliche Auswirkungen auf die anschließende Routenplanung hat. Wird die Breite anschließend erneut erhöht, befinden sich die Sonderstellen jedoch wieder an denselben Positionen wie vor den beiden Vergrößerungen. In diesem Fall kann dieselbe Route verwendet werden, allerdings mit zwei zusätzlichen @UE. 
Dieser Sachverhalt gilt analog für alle fünf Eingabeparameter der Wand. Daraus ergeben sich insgesamt höchstens $N <= 2^5 = 32$ verschiedene mögliche Kombinationen von Wanddimensionen bzw. Positionen von Sonderstellen.

#maybe[Induktionsbeweis, dass Fall $w_b approx w_b + d$ ?]

\ 
Der zu entwickelnde Algorithmus soll für sämtliche 32 möglichen Wandkonfigurationen die Positionen der @UE dynamisch bestimmen. Als Eingabe dienen dabei ausschließlich die fünf beschriebenen Parameter sowie der Radius der @UE. Die erzeugte Lösung muss in jedem Fall eine valide Konfiguration darstellen, bei der insbesondere sichergestellt ist, dass keine @UE einander überlappen oder außerhalb der zulässigen Bereiche, wie den Wand- oder Türgrenzen, positioniert werden.

Darüber hinaus wird eine Anordnung gefordert, die eine später folgende Routenplanung und damit schlussendlich die Erzeugung eines gleichmäßigen Carbongitters ermöglicht. Obwohl die Rechenzeit des Algorithmus eine untergeordnete Rolle spielt, soll dennoch die Gesamtanzahl der zu platzierenden @UE minimiert werden. Auf diese Weise kann der spätere physische Ablageprozess durch den Roboterarm verkürzt werden, wodurch sowohl Zeit- und Energieaufwand reduziert als auch die mechanische Belastung der Motoren und Gelenke verringert wird.

== Stand der Forschung <sec:ue-place-forschungsstand>
Sowohl in der Forschung als auch in industriellen Anwendungen existiert nur wenig veröffentlichte Literatur zur Platzierung von Umlenkelementen.

// TU Dresden
#citep(<merschAutomation3DRobotic2025>) untersuchten die automatisierte Garnablage für dreidimensionale Skelette, einschließlich der Planung der Bewegungsbahnen eines Roboterarms. Die räumlichen Positionen der Pins werden dabei jedoch als gegeben und strukturell konsistent vorausgesetzt und nicht eigenständig berechnet. Darüber hinaus werden keine Anforderungen an die Gleichmäßigkeit der resultierenden Struktur, beispielsweise in Form eines Gitters, gestellt.

// String Art
Im kreativen Bereich existieren hingegen Arbeiten, bei denen Künstler mithilfe von Algorithmen Bilder durch das Verlegen von Garn erzeugen (engl. String Art). Häufig dient dabei eine einfache geometrische Form, etwa ein Kreis oder Rechteck, als Rahmen @birsakStringArtComputational2018. Auf diesem Rahmen sind in regelmäßigen Abständen Pins angebracht, um welche das Garn entsprechend der gewünschten Detailtreue geführt wird.

Ein anderer Ansatz wird von #citep(<morris-hillBuildingStringArt2023>) oder Firmen wie Laarco Studio #footnote[Website: https://laarco.com/, Letzter Zugriff: 15.03.2026] verfolgt. Sie platzieren die Pins oder Nägel mithilfe eines Roboterarms auf einer freien Fläche und berechnen anschließend den Pfad des Garns so, dass vorgegebene Bilder möglichst präzise durch den resultierenden Faden dargestellt werden. Dabei wird in dunklen Bildbereichen mehr Garn verlegt, während helle Bereiche mit weniger Fäden dargestellt werden.

Während #citep(<morris-hillBuildingStringArt2023>) die Pins in einem gleichmäßigen Raster oder in zufällig gewählten Positionen aufstellt, werden bei Laarco Studios die Pins bereits im Vorfeld so positioniert, dass sie für die Struktur des Bildes günstig liegen, beispielsweise entlang der Konturen eines Gesichts oder mit geringerer Dichte in großen einfarbigen Flächen. Auch hier steht jedoch nicht die Erzeugung einer gleichmäßigen Struktur im Fokus. Erkenntnisse aus der entsprechenden Forschung wurden zudem nicht veröffentlicht.


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
)

\

// Schlussfolgerung eigene Lösung
Da keine relevanten Arbeiten zum hier betrachteten Problem identifiziert werden konnten und darüber hinaus spezifische Anforderungen und Restriktionen bestehen, ist die Entwicklung eines eigenen Lösungsansatzes erforderlich.

== Lösungsmethode <sec:ue-placement-implementation>

// Tür zuerst
Aufgrund der begrenzten Möglichkeiten zur Platzierung der @UE am Türausschnitt, ohne die spätere Routenplanung stark einzuschränken, werden diese Positionen zuerst bestimmt. Standardmäßig wird dabei ein @UE in der unteren linken Ecke der Tür platziert, woraus sich die Positionen der übrigen @UE ableiten lassen.

// vertikale Rollen links und rechts
Aus den Positionen der @UE entlang der Seiten des Türausschnitts ergeben sich anschließend die Positionen der @UE an der linken und rechten Wandseite. Dabei wird jeweils an denjenigen Stellen ein @UE an der Wand platziert, an denen entlang des Türausschnitts eine Lücke besteht.

#maybe[Erklärungen ausbauen, wie sich die Position von UE aus den Positionen andere UE ergibt]

Durch die Lage des obersten @UE an der linken und rechten Seite des Türausschnitts lassen sich die Positionen der @UE:pl an der Oberseite des Türausschnitts bestimmen. So wird, falls das oberste @UE bei $(t_(x,1), t_(y,1)+1)$ liegt, kein @UE auf den anliegenden Nachbarfeldern ${(x,t_(y,1)) | t_(x,1) <= x <= t_(x,1) +1}$ platziert. In @fig:oberkante-türausschnitt sind diese unzulässigen Positionen rot und das ausschlaggebende Seitenelement blau markiert. Liegt das oberste @UE bei $(t_(x,2), t_(y,1)+1)$ so können keine @UE an den Stellen ${(x,t_(y,1)) | t_(x,2)-1 <= x <= t_(x,2)}$ abgelegt werden. So wird verhindert, dass in den oberen Türecken @UE diagonal nebeneinander liegen.

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
Die grün markierten @UE an der Oberkante des Türausschnitts bestimmen wiederum die Positionen der @UE an der Oberseite der Wand und damit indirekt auch an der Unterseite. Hierzu wird die Position des am weitesten links liegenden @UE an der Oberseite des Türausschnitts $(x,y)$ mit $t_x$ verglichen (in @fig:fully-placed-ue-wall blau dargestellt):
$ omega = cases(
  0 ", falls" 2 divides.not t_(x,1) and t_(x,1) <= x <= t_(x,1)+1 and 2 divides.not (t_(x,2)-t_(x,1)),
  1 ", falls" 2 divides.not t_(x,1),
  1 ", falls" 2 divides (t_(x,2)-t_(x,1)) and t_(x,1) <= x <= t_(x,1)+1,
  0 ", sonst"
) $
Dabei beschreibt $omega$ den horizontalen Versatz der @UE an der Oberkante der Wand. Die Positionen der @UE dort ergeben sich damit zu:
$ { (x + omega, 0) | 1 <= x < x_("max")-1, 2 | (x+1)} $

#maybe[Vielleicht simplen Pseudocode einfügen, der den Ansatz ohne Müll zeigt?]

// Optionale Rollen in den Ecken
In den äußersten Ecken der Wand sowie den unteren Ecken des Türausschnitts kann es außerdem vorkommen, dass die beiden nächstgelegenen @UE jeweils einen Abstand von mindestens $2d$ zur Ecke besitzen. In diesem Fall besteht die Möglichkeit, ein zusätzliches @UE zu platzieren, welches optional in der Routenplanung verwendet werden kann, um größere Freiheitsgrade bei der Gestaltung der Umlenkungen zu erhalten. In @fig:fully-placed-ue-wall sind diese zusätzlichen @UE grün dargestellt.

Da Streben, die an diesen @UE enden, aus struktureller Sicht nicht erforderlich sind, müssen diese Elemente nicht zwingend in der Routenplanung berücksichtigt werden. Wird auf ihre Nutzung verzichtet, entfällt auch ihre Platzierung durch den Roboterarm, wodurch Zeit und Energie eingespart werden können.


== Ergebnisse

Wie in @sec:ue-place-problem dargestellt, existieren konzeptionell lediglich 32 zu betrachtende Kombinationen von Wanddimensionen. Der vorgestellte Ansatz wurde für sämtliche dieser Kombinationen empirisch getestet und anschließend evaluiert. In allen Fällen konnten vollständig valide Platzierungen berechnet werden. Eine Beispielkonfiguration einer Wand mit den berechneten Positionen der @UE ist in @fig:fully-placed-ue-wall dargestellt. In dem gezeigten Beispiel ist kein Versatz der oberen @UE erforderlich.

#figure(
  cetz.canvas({
    import cetz.draw: *

    scale(0.5)
    
    let rolls = ((1,0), (3,0), (5,0), (7,0), (9,0), (11,0), (13,0), (15,1), (0,2), (4,3), (6,3), (8,3), (15,3), (0,4), (10,4), (4,5), (15,5), (0,6), (10,6), (4,7), (15,7), (0,8), (10,8), (4,9), (15,9), (0,10), (2,10), (12,10), (14,10))

    for point in rolls.map((p) => (p.at(0), -1*p.at(1))) {
      circle(point, radius: (0.5,0.5))
    }

    circle((15, -9), radius: (0.5,0.5), fill: red)
    circle((14, -10), radius: (0.5,0.5), fill: red)
    
    circle((4, -3), radius: (0.5,0.5), fill: blue)
    circle((0,-10), radius: (0.5,0.5), fill: green)
    circle((10,-10), radius: (0.5,0.5), fill: green)

    line((-1,1),(16,1))
    line((16,1),(16,-11))
    line((16,-11),(9,-11))
    line((9,-11),(9, -4))
    line((9, -4), (5,-4))
    line((5,-11),(5, -4))
    line((5, -11),(-1,-11))
    line((-1,-11),(-1,1))

  }),
  caption: [Kleine Wandkonfiguration mit korrekt platzierten Umlenkelementen. In Rot dargestellt eine Sonderstelle, in Grün optionale UE und in Blau das UE, welches den oberen Versatz bestimmt.]
)<fig:fully-placed-ue-wall>

Die Anzahl der @UE ist in den meisten Fällen minimal. Durch die in @sec:ue-placement-implementation beschriebenen optionalen @UE in den Ecken der Wand werden womöglich @UE platziert, welche für die spätere Routenplanung irrelevant sind. Ihre Anzahl begrenzt sich in diesen Fällen auf maximal zwei eventuell überflüssige @UE, welche nach der Routenplanung aus dem Ablageprogramm entfernt werden können.

Die durchschnittliche Rechenzeit beträgt 0,08 Millisekunden, während die maximal gemessene Rechenzeit bei 24 Millisekunden über alle 32 Testläufe lag. Die Tests wurden auf einem Intel(R) Core(TM) i5-8350U Prozessor mit 24 GB Arbeitsspeicher durchgeführt.