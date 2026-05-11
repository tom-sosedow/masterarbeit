#import "/util.typ": *
#import "@preview/cetz:0.4.2"

== Ergebnisse <sec:path-results>

Zur Analyse der gezeigten Vorgehen werden, analog zu @sec:ue-place-result, erneut alle 32 möglichen Wandkonfigurationen überprüft, wobei die resultierenden Pfade jeweils in @appendix:wandkonfigurationen abgebildet sind. Die Tests werden ebenfalls auf einem Intel(R) Core(TM) i5-8350U Prozessor mit 24 GB Arbeitsspeicher durchgeführt. Die durchschnittliche Rechenzeit beträgt 1,57 Millisekunden, während die maximal gemessene Rechenzeit bei 10,32 Millisekunden über alle 32 Testläufe liegt. In @fig:beispielpfad ist der berechnete Pfad für die Wandkonfiguration $w_4$ aus @sec:routenplanung exemplarisch dargestellt. Die berechnete Route beginnt hier bei @UE 61 und endet bei @UE 27. 
Ebenfalls wurde Wand 5 aus @appendix:wandkonfigurationen im @CBT in kleineren Dimensionen praktisch getestet, allerdings ohne Harztränkung des Garns. Die resultierende Bewehrung und der abgefahrene Pfad ist in @appendix:robotcode zu sehen. 

#figure(
  image("/images/pfadbeispiel.png", width: 110%),
  caption: [Pfad $p$ des Roboters in einer kleinen Wandkonfiguration $w_4$ aus @sec:routenplanung. Route beginnt bei UE 61 und endet bei UE 27. In Rot dargestellt sind die Punkte, die zur Kollisionsvermeidung auf einer höheren Ebene platziert werden sowie in halbtransparentem Rot die Approximation des Gittermusters zur Bestimmung dieser Punkte.]
)<fig:beispielpfad>

Die Pfade werden insgesamt überwiegend zuverlässig bestimmt. Bei Nutzung der Invertierungsstrategie, wie in @sec:path-direction dargestellt, kommt es bei manchen Routen zu fehlerhaften Teilabschnitten, wodurch sie ähnlich zu dem in @fig:pfad-zu-muster (b) gezeigten Pfad verlaufen. Grund hierfür ist immer eine falsche Berechnung der anfänglichen Umlaufrichtung bei einem Wechsel der Hauptrichtung.

Wird hingegen der vektorbasierte Ansatz genutzt, sind die Teilbereiche immer vollständig korrekt. Insbesondere kann durch die Ausnahmeregelung zur Invertierung der Umlaufrichtung beim Wechsel der Hauptrichtung verhindert werden, dass an einigen Stellen die Umlaufrichtung inkorrekt bestimmt wird. So würde, ohne diese Regel, für das @UE 62 eine Umlenkung im Uhrzeigersinn basierend auf dem reinen vektoriellen Ansatz berechnet werden, was eine diagonal verlaufende horizontale Strebe zum @UE 60 zufolge hätte. Da sich das @UE 62 allerdings in einer Ecke der Wand befindet und zudem die Hauptrichtung ändert, wird hier die Umlaufrichtung korrekterweise getauscht.

Weiterhin lässt sich feststellen, dass die Wegpunkte für die Umlenkungen um mehrfach angefahrene @UE:pl:long korrekt gesetzt werden. So wird das @UE 34 an der oberen rechten Türecke zunächst auf halber Route für eine vertikale Strebe genutzt. Kurz vor Ende der Route wird das @UE dann erneut für eine horizontale Strebe umfahren, bevor der Pfad beim @UE 27 endet.  

Die Kollisionsvermeidung mit @UE funktioniert erwartungsgemäß zuverlässig. In @fig:beispielpfad ist unter anderem an @UE 20 und 62 zu erkennen, dass eine vollständige Umlenkung eine Kollision mit @UE 22 verhindert, die andernfalls bei der Bewegung Richtung @UE 62 auftreten würde. Im @appendix:wandkonfigurationen Wand 28 ist ebenfalls zu sehen, dass die Kollisionsvermeidung durch Sicherheitsabstände nach #citep(<morris-hillBuildingStringArt2023>) erfolgreich eine Kollision verhindern konnte. So wird bei der Navigation von @UE 68 zu @UE 7 der Sicherheitsabstand von @UE 36 verletzt, wodurch ein neuer Wegpunkt ungefähr bei Koordinate $(7.5, 13.5)$ eingefügt werden musste. 

Die zusätzlich eingefügten Zwischenpunkte zur Vermeidung von Kollisionen mit bereits verlegtem Garn sind in @fig:beispielpfad durch rote Kreise und die Annäherung der resultierenden Garnstruktur $p'$ in hellem Rot hervorgehoben. Im praktischen Test stellt sich heraus, dass die Schnittpunkte der Pfadsegmente aus $p$ mit der Garnapproximation $p'$ leider nicht als Indikator für die vertikale Bewegung des Werkzeuges dienen können. Da das Carbongarn aus der außermittig angebrachten Düse austritt, liegt der Mittelpunkt des Werkzeugs, welches den berechneten Pfad abfährt, etwas vor und oberhalb der Düse. Dadurch kommt es an manchen Streben dazu, dass das Werkzeug zu früh wieder abgesenkt wird und es somit an der hintersten Garnstrebe schabt. Bei der getesteten Wandkonfiguration 5 (siehe @appendix:wandkonfigurationen) ist dies beispielsweise bei der Navigation von @UE 19 zu @UE 20 der Fall, bei dem eine Kollision mit der Strebe auftritt, die von @UE 0 zu @UE 60 verläuft. Das Resultat dieser Kollision ist in @fig:garnkollision-resultat zu sehen.

#figure(
  image("/images/garnkollision-test.jpg", width: 80%),
  caption: [Resultat der Kollision zwischen Austrittsdüse und Garnstrebe bei dem Test zu Wand 5 aus @appendix:wandkonfigurationen. Die Strebe wurde infolgedessen gespleißt und einige Stränge zerrissen. ],
)<fig:garnkollision-resultat>

Es kommt ebenfalls innerhalb der Umlenkungen zu Kollisionen mit Garnstreben. Da die Kollisionserkennung lediglich für die Anwendung auf die Wege zwischen zwei Umlenkungen konzipiert wurde, werden Streben, welche nah an den @UE anliegen, ebenfalls gestreift. Bei Wand 5 tritt dieser Fall beispielsweise nach der Navigation von @UE 58 zu @UE 60 auf. Hier wird eine horizontal verlaufende Strebe bündig mit der untersten Reihe von @UE verlegt, was in der vollständigen Umlenkung um @UE 60 dazu führt, dass diese Strebe bei der Bewegung zum letzten Wegpunkt oberhalb des @UE gestreift wird. Ein ähnlicher Fall tritt bei @UE 31 auf, bei dem die vorher verlegte vertikale Strebe von @UE 11 innerhalb der Umlenkung für eine horizontale Strebe gestreift wird.

Abschließend ist festzustellen, dass das Vorgehen mit vertikalem Versatz des Werkzeuges trotzdem ein zu starkes Abrutschen des Garns von den @UE:pl verursacht. Im Test zu Wand 5 führte es dazu, dass bei manchen Streben keinerlei Kontakt mit anderen Streben hergestellt wurde. Eine dieser Streben ist in @fig:strebe-abrutschen-vert-versatz zu sehen.

#figure(
  image("/images/strebe-abrutschen-vert-versatz.jpg"),
  caption: [Garnstrebe, die durch den vertikalen Versatz des Werkzeuges zu weit nach oben abgerutscht ist und daher keinen Kontakt mit anderen Streben hat. ]
)<fig:strebe-abrutschen-vert-versatz>