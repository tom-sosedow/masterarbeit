#import "/util.typ": *
#import "@preview/cetz:0.4.2"

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

