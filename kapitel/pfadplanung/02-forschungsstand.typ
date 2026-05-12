#import "/util.typ": *
#import "@preview/cetz:0.4.2"

== Stand der Forschung

Zur Bestimmung der Wegpunkte $a,b,c$ beziehungsweise $d,e,f$ aus @fig:pfad-zu-muster wird im aktuellen Ansatz des @CBT derzeit die Sonderstelle als Referenz für die Art der Umlenkung herangezogen. Da im bestehenden Verfahren zuerst alle vertikalen Streben verlegt werden, ergibt sich eine vergleichsweise einfache Bestimmung der Wegpunkte. Der erste und letzte Wegpunkt liegen jeweils auf der Höhe des entsprechenden Umlenkelements, sind jedoch um jeweils einen Durchmesser nach links beziehungsweise rechts versetzt. Der mittlere Wegpunkt ($b$ bzw. $e$) befindet sich hingegen auf dem gleichen x-Wert wie das Umlenkelement und ist alternierend um einen Durchmesser nach oben oder unten versetzt.
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
