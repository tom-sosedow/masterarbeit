#import "/util.typ": *
#import "@preview/cetz:0.4.2"

== Problemdefinition <sec:ue-place-problem>
// Umlenkelemente Einführung
Um die Gitterstruktur des Garns in einem kontinuierlichen Zug ohne Unterbrechung herzustellen, sind Umkehrpunkte erforderlich. Nach #citep(<mechtcherineNeueCarbonfaserbewehrungFur2019>) existieren hierfür zwei grundsätzliche Ansätze: Zum einen kann das Garn spannungsfrei auf einer Oberfläche abgelegt werden, ähnlich dem Verfahren bei 3D-Druckern. Zum anderen kann die Ablage unter Spannung erfolgen, indem das Garn über unbewegliche @UE:pl:long geführt wird.

// Haftung und Aufbau einer Rolle
Beim @CBT wurde der zweite Ansatz gewählt, da das in Harz getränkte Garn nach der Temperierung im Ofen sonst an der Ablageoberfläche haften würde. Aus diesem Grund werden zylinderförmige Körper aus Polytetrafluorethylen (PTFE, umgangssprachlich auch Teflon) als @UE:pl:long eingesetzt, von denen die Garnstruktur später leichter zu lösen ist. Diese verfügen über eine magnetische Basis, wodurch sie von einem Roboterarm auf einer ferromagnetischen Platte frei in zwei Dimensionen positioniert werden können. Ein typisches @UE ist in @fig:umlenkelement abgebildet. Sie haben üblicherweise einen Durchmesser von fünf Zentimetern und eine Höhe von zehn Zentimetern, zzgl. sieben Millimeter für die Basis.

#figure(
  image("/images/umlenkrolle.jpg", width: 30%),
  caption: [Typisches Umlenkelement mit magnetischer Basis und Körper aus PTFE],
)<fig:umlenkelement>

Die Positionen der @UE:pl sollen vollständig automatisiert und unter Berücksichtigung der folgenden Anforderungen durch einen in diesem Kapitel zu erforschenden Algorithmus berechnet werden.

// Eingabewerte
Zu Beginn der Herstellung eines Carbongitters werden fünf Eingabeparameter benötigt: die Breite und Höhe der Wand ($w_b^*$ und $w_h^*$), die Breite und Höhe des Türausschnitts ($t_b^*$ und $t_h^*$) sowie der Abstand der linken Seite des Türausschnitts zur linken Wandkante ($t_x^*$). 

// Schalungselemente
Diese Maße können jedoch nicht unmittelbar als Grenzen für das Carbongitter verwendet werden. Nach der Erstellung des Gitters wird es in eine vorbereitete Schalung platziert. Diese besteht aus stählernen Schalungselementen, die ebenfalls magnetisch auf einer Metallplatte befestigt werden. Die Schalungselemente verhindern beim Betonguss das Austreten des flüssigen Betons und dienen somit als Begrenzung der Wand. Zu diesen Elementen muss ein Abstand $p$, im Folgenden Padding genannt, eingehalten werden, damit das Carbongitter geschützt und von außen nicht sichtbar im Beton liegt.

// Verschiebung der Grenzen durch Abstand zur Schalung, Padding
Dadurch verschieben sich die Grenzen für die Platzierung der @UE. Als Ankerpunkt dienen dafür ihre Mittelpunkte. Der Radius der @UE wird mit $r$ bezeichnet, der Durchmesser ergibt sich zu $d = 2r$. Die tatsächlich verfügbare Wandhöhe und -breite ergibt sich somit zu $w_h = w_h^* - 2p - 2r$ und $w_b = w_b^* - 2p - 2r$, da auf beiden Seiten jeweils einmal das Padding von der Länge abgezogen werden muss und sich das Padding auf den Abstand zur Außenkante des @UE bezieht und somit ebenfalls jeweils der Radius abgezogen werden muss. Der Türausschnitt wird aufgrund des notwendigen Abstands zur Schalung links und rechts um das doppelte Padding verbreitert und wieder der zusätzlich nötige Abstand zum Mittelpunkt der @UE einbezogen, sodass $t_b = t_b^* + 2p + 2r$ gilt. Durch die reduzierte Wandbreite sowie das linke Padding an der Tür muss außerdem der Abstand des Türausschnitts zur linken Wandkante angepasst werden. Daher ergibt sich $t_x = t_x^* - 2p - 2r$. Die Höhe des Türausschnitts muss nicht weiter angepasst werden. Die Zusammenhänge sind in @fig:input-dimensions dargestellt. In Schwarz ist die geforderte Betonfläche und in Rot die dazugehörigen Eingabeparameter verbildlicht. In Blau ist die tatsächlich zur Verfügung stehende Fläche für die @UE:pl:long nach Einbeziehung des Paddings markiert, über die darin platzierte @UE nicht mit ihren Außenkanten hinausragen dürfen.

#figure(
  cetz.canvas({
    import cetz.draw: *

    scale(0.5)

    rect((-0.5,0.5),(15.5,-10.5), stroke: none, fill: orange.transparentize(80%))
    rect((0.5,-0.5),(14.5,-9.5), stroke: none, fill: white)
    rect((3.5,-2.5),(10.5,-9.5), stroke: none, fill: orange.transparentize(80%))
    grid((-0.5,0.5),(15.5,-10.5), stroke: (paint: gray.transparentize(50%)))
    rect((4.5,-3.5),(9.5,-12),fill:white, stroke: none)


    circle((0,-9), radius: 0.5, stroke: (paint: gray.darken(40%)))
    circle((0,-7), radius: 0.5, stroke: (paint: gray.darken(40%)))
    circle((0,-5), radius: 0.5, stroke: (paint: gray.darken(40%), dash: "dashed"))
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

    line((-0.5,-7),(0,-7), mark: mark, stroke: (paint: orange))
    content((1,-7), text(fill:orange)[$r$])

    circle((4,-3), radius: 0.1, stroke: (paint: purple))
    content((4.7,-3), text(fill:purple)[$t_1$])

    circle((10,-10), radius: 0.1, stroke: (paint: purple))
    content((10.7,-10), text(fill:purple)[$t_2$])

  }),
  caption: [Veranschaulichung der Modellierung für die Platzierung von UE an diskreten Positionen.]
)<fig:input-dimensions>

// Math. Modell
Da der Abstand zwischen zwei @UE stets ein Vielfaches von $d$ beträgt, ergeben sich diskrete mögliche Positionen auf einem regelmäßigen Raster, welches in @fig:input-dimensions grau dargestellt ist.

Die Positionen der Mittelpunkte der @UE in diesem Raster können durch eine Menge A von zweidimensionalen Koordinaten mit 
$ A subset {(x,y) in NN_0^2 | 0 <= x <= xmax, 0 <= y <= ymax} $
modelliert werden, wobei durch $xmax = floor(w_b / d)$ und $ymax = floor(w_h / d)$ eine Rasterung der Echtwelt-Koordinaten vollzogen wird. Eine Einheit im Modell beträgt also $d$ Millimeter in der echten Welt. Die Umrechnung von Koordinaten im Modell zu Koordinaten in Millimetern in der Realität erfolgt durch die Abbildung
$ (x,y) in NN^2_0 |-> (x*d + r + p, y*d + r + p) $

Der Türausschnitt wird durch ein Koordinatentupel der oberen linken Ecke 
$ t_1 = (tx1, ty1) = (floor(t_x/d), ymax - ceil(t_h/d)) $ 
sowie der unteren rechten Ecke 
$ t_2 = (tx2, ty2) = (tx1 + ceil(t_b/d), ymax) $ 
beschrieben. Beide Punkte sind in @fig:input-dimensions in Lila dargestellt.

Der Koordinatenursprung befindet sich in dieser Arbeit in der oberen linken Ecke. Die $x$-Achse verläuft nach rechts, die $y$-Achse nach unten in positiver Richtung. Entsprechend liegt die obere Wandkante bei $y=0$, die untere bei $y=ymax$, die linke Seite bei $x=0$ und die rechte bei $x=xmax$.

// Restriktionen und Zickzackmster der Rollen
Die @UE:pl:long sollten nur an den Rändern der Wand nahe der Schalungselemente platziert werden, damit die resultierenden Streben die volle verfügbare Länge nutzen und somit maximale Zugkraft aufnehmen können. Die Positionen der @UE müssen somit folgende Anforderungen erfüllen:
$
  forall (x,y) in A: 
  (x=0 and 0 <= y <= ymax) or (x=xmax and 0 <= y <= ymax) or \
  (0<=x<=xmax and y=0) or (0<=x<=xmax and y=ymax) or \
  (x=tx1 and ty1 <= y <= ymax) or (x=tx2 and ty1 <= y <= ymax) or \
  (tx1 <= x <= tx2 and y = ty1)
$ 
Die dadurch formulierten zulässigen Positionen der @UE:pl sind in @fig:input-dimensions orange hinterlegt.

Auf gegenüberliegenden Seiten der Struktur sind zwei @UE stets genau um $d$ Millimeter entlang der jeweiligen Seite versetzt angeordnet und alternieren zwischen beiden Seiten. Für zwei vertikale Seiten an den x-Koordinaten ${x_1, x_2} in {{0, tx1}, {tx2, xmax}, {0,xmax}}$ ergibt sich im Modell:

$ 
forall (x,y) in A: 
  (x=x_1 arrow {(x_2, y), (x_1, y-1), (x_1, y+1)} inter A = emptyset) or \ 
  (x=x_2 arrow {(x_1, y), (x_2, y-1), (x_2, y+1)} inter A = emptyset)
$<eq:rollen-platzierung-vertikale-seiten>

Analog gilt für zwei horizontale Seiten mit den y-Koordinaten ${y_1, y_2} in {{0, ymax}, {0, ty1}}$:

$
forall (x,y) in A: 
  (y = y_1 arrow {(x, y_2), (x-1, y_1), (x+1, y_1)} inter A = emptyset) or \
  (y = y_2 arrow {(x, y_1), (x-1, y_2), (x+1, y_2)} inter A = emptyset)
$

In @fig:ue-place-model (a) ist der Sachverhalt aus @eq:rollen-platzierung-vertikale-seiten exemplarisch für zwei gegenüberliegende vertikale Seiten dargestellt.

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

        content((-10*r, 0*r), [$y=ymax$])
        line((-6*r, 0*r), (4*r, 0*r), stroke: (dash: "dashed", paint: darkgray))
        content((2*r, 9*r), [$x=xmax$])
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
) <fig:ue-place-model>


// Sonderstellen
Durch die Anforderungen kann es in den Ecken der Wand dazu kommen, dass zwei @UE diagonal direkt nebeneinander platziert werden müssen, wie in @fig:ue-place-model (b) dargestellt. Diese spezielle Anordnung wird als Sonderstelle bezeichnet. Das Werkzeug des Roboters zum Ablegen des Garns passt nicht in die Lücke dazwischen, was besondere Achtung bei der Pfadplanung erfordert. Bei dem Türausschnitt kann in den oberen beiden Ecken selbiges passieren, wobei es hier dazu führen würde, dass ein unregelmäßiger Abstand im Carbongitter entstehen müsste. Aus diesem Grund ist es bei der Platzierung der @UE wichtig, diesen Fall zu vermeiden. Im Speziellen ist eine Sonderstelle nur an bestimmten Stellen zulässig, was durch @eq:sonderstelle-eingrenzung formuliert wird

$
  forall a=(x_1,y_1) in A : 
  \ (exists r=(x_2,y_2) in A: x_1-1<= x_2 <= x_1+1 and y_1-1 <= y_2 <= y_1 + 1) ->  a,r in M
$<eq:sonderstelle-eingrenzung>

wobei M durch 
$ M= {(0,1),(1,0),(0,ymax-1),(1,ymax),(xmax,ymax-1), 
  \ (xmax-1,ymax), (xmax-1, 0),(xmax, 1), (tx1-1, ymax), (tx1, ymax-1)}
$
definiert ist.

Unter diesen Rahmenbedingungen ist es das Ziel, so viele @UE:pl:long wie möglich zu platzieren, um später alle Streben für die strukturelle Integrität achsenparallel verlegen zu können: 
$ |A| -> max! $

// Anzahl der Fälle

#question[Wie definiere ich, dass normalerweise @UE nur zw. $1 <= x <= xmax -1$, aber optionale UE dürfen bei $(xmax,ymax)$ sein?]

Wird einer der Eingabeparameter um mindestens $d$ vergrößert, kann entlang der entsprechenden Hauptachse des Parameters ein weiteres @UE auf der gegenüberliegenden Seite platziert werden.

Erhöht sich beispielsweise die Wandbreite auf $x'_"max" = xmax + 1$ und befindet sich das aktuell am weitesten rechts stehende @UE der horizontal verlaufenden Seiten auf der Oberseite ($a = (xmax-1,0)$), kann anschließend ein weiteres @UE in der unteren Seite ($a' = (x'_"max"-1, ymax)$) platziert werden.

Dadurch können sich die Orte der Sonderstellen ändern, was wiederum erhebliche Auswirkungen auf die anschließende Routenplanung hat. Wird die Breite anschließend erneut erhöht, befinden sich die Sonderstellen jedoch wieder an denselben Positionen wie vor den beiden Vergrößerungen. In diesem Fall kann dieselbe Route verwendet werden, allerdings mit zwei zusätzlichen @UE. 
Dieser Sachverhalt gilt analog für alle fünf Eingabeparameter der Wand. Daraus ergeben sich insgesamt höchstens $N <= 2^5 = 32$ verschiedene mögliche Kombinationen von Wanddimensionen bzw. Positionen von Sonderstellen.

#todo[Link auf Anhang setzen, wo die 32 Konfigurationen zu sehen sind]

#maybe[Induktionsbeweis, dass Fall $w_b approx w_b + 2d$ ? Also, dass beim vergrößern eines Maßes um $2d$ die Sonderstellen dann an den selben Positionen liegen wie vor der Erhöhung und die Berechnungen daher immer gleich ablaufen. Wäre vlt wichtig für die Validierung der Ergebnisse, weil ich somit nicht die Korrektheit für alle Maßangaben nachweisen muss, sondern nur für 32 Fälle, da 5 Eingabeparameter $p$ mit Länge $floor(p/d) mod 2 = 1 $ oder $floor(p/d) mod 2 = 0$ nur 2 Fälle haben jeweils.]

\ 
Der zu entwickelnde Algorithmus soll für alle 32 möglichen Wandkonfigurationen die Positionen der @UE dynamisch bestimmen. Als Eingabe dienen dabei ausschließlich die fünf beschriebenen Parameter sowie der Radius der @UE. Die erzeugte Lösung muss in jedem Fall eine valide Konfiguration darstellen, bei der insbesondere sichergestellt ist, dass keine @UE einander überlappen oder außerhalb der zulässigen Bereiche, wie den Wand- oder Türgrenzen, positioniert werden.

Darüber hinaus wird eine Anordnung gefordert, die eine später folgende Routenplanung und damit schlussendlich die Erzeugung eines gleichmäßigen Carbongitters ermöglicht.
