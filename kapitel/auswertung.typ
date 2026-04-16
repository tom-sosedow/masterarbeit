#import "/util.typ": *
#import "/forschungsfragen.typ": forschungsfragen
#import "@preview/cetz:0.4.2"

= Auswertung <sec:auswertung>
#todo[Einleitender Abschnitt]

// RQ1 
*Platzierung der Umlenkelemente*

// 1. Ziele
Zur Beantwortung der Forschungsfrage (I) "_#forschungsfragen.at(0)_" wurde eine iterative Platzierung der @UE:pl:long entwickelt, welche die Positionen regelbasiert bestimmt. Die Beantwortung dieser Frage ist grundlegend für das Ziel der automatisierten Herstellung von Carbonbewehrung, da alle nachfolgenden Schritte von dem Ergebnis abhängen.

// 2. Bewertung
Das vorgestellte schrittweise Platzierungsverfahren liefert zuverlässig valide Ergebnisse, da es ohne Zufallskomponenten auskommt. Allerdings ist nicht in jedem Fall gewährleistet, dass die resultierenden Anordnungen optimal sind. Insbesondere kann die feste Platzierung des ersten Umlenkelements an der linken unteren Ecke der Tür dazu führen, dass Sonderstellen an ungünstigen Positionen auftreten. 
#todo[mehr drauf eingehen, wenn abschnitt in Routenplanung fertig ist] 

Die Implementation ist durch die fixierte Vorgehensweise allerdings sehr unkompliziert. Dies führt zu einem geringen Wartungsaufwand sowie zu einer hohen Anpassbarkeit, die auch ohne vertiefte informatische Kenntnisse gewährleistet ist.

Hinsichtlich der Laufzeit erfüllt das Verfahren die Anforderungen der Prozesskette des @CBT in hohem Maße. Selbst für große Wandkonfigurationen erfolgt die Berechnung der Positionen innerhalb weniger Millisekunden, sodass ein Einsatz in industriellen Produktionsketten problemlos möglich ist.

Einschränkungen ergeben sich jedoch aus der zugrunde liegenden Modellierung. Durch die Paarung der @UE:pl entlang einer Türseite mit denen einer Wandseite bei der Positionierung vertikaler @UE:pl ist das Verfahren nicht ohne Weiteres auf nicht-rechteckige Formen übertragbar. Bei schrägen Seiten, wie etwa bei Parallelogrammen oder Kreisbögen, müssten die @UE:pl entlang der Schräge sowohl für vertikale als auch für horizontale Streben genutzt werden, wofür in der aktuellen Modellierung keine geeignete Zuordnung vorgesehen ist. Erweiterungen zur Unterstützung rechteckiger Fensterausschnitte oder mehrerer Ausschnitte sollten jedoch problemlos möglich sein.

Auch die Integration zusätzlicher Bauteile, wie beispielsweise Stromdosen oder Kabelkanäle, ist mit der aktuellen Modellierung als Raster nur eingeschränkt möglich. Insbesondere dann, wenn Objekte außerhalb der diskreten Rasterpositionen platziert werden müssen oder größere Abmessungen als ein @UE aufweisen, stößt der Ansatz an seine Grenzen. 

// 3. Literaturvergleich
#todo[Vergleich mit Forschungsstand CBT]

// 4. Verbesserungspotential
Der Prozess könnte verbessert werden, in dem direkt mit Koordinaten in Millimetern gearbeitet werden würde. Neben der Platzierung anderer Bauteile könnte es die Integration von diagonal verlaufenden Wand- oder Türseiten ermöglichen. Außerdem könnten so gegebenenfalls @UE:pl:long verschiedener Größe genutzt werden, um an Stellen, an denen keine hohen Zugkräfte zu erwarten sind, weniger Carbongarn zu verlegen und somit Einsparungen von Materialkosten zu ermöglichen. 

Ferner könnte der Prozess so angepasst werden, dass die Orte der Sonderumlenkungen statisch festgelegt werden. Dadurch könnte die Routenplanung maßgeblich verändert und deutlich erleichtert werden, da sich die Abfolge der Teilrouten somit in mehr Wandkonfigurationen gleicht und gegebenenfalls kostengünstigere Routen erstellt werden können.

Außerdem wurden in dieser Arbeit keine Ansätze betrachtet, bei denen die Platzierung der Umlenkelemente kooperativ und parallel zur Routen- bzw. Pfadplanung geschieht. Weiterführende Arbeiten könnten Möglichkeiten erforschen, welche zuerst eine optimierte Gitterstruktur in den vorgegebenen Maßen generieren und anschließend die nötigen Stellen identifizieren, an denen @UE:pl:long platziert sein müssen.

// 5. Fazit
Da die in den folgenden Kapiteln behandelten Verfahren auf den hier bestimmten Positionen der @UE:pl aufbauten und gezeigt werden konnte, dass sich auf dieser Grundlage gleichmäßige und den Anforderungen entsprechende Carbongitter erzeugen lassen, stellt das gezeigte iterative Platzierungsverfahren insgesamt eine geeignete Antwort auf die Forschungsfrage (I) dar.


/*
Aufbau
1. Ziel und Kontext einordnen (kurz): Fragestellung. Warum ist das Problem wichtig für das Gesamtproblem
2. Bewertung der Lösung
  - funktioniert es? Nur teilweise? Unter Bedingungen?
  - Qualität, Genauigkeit, Effizienz, Robustheit, Skalierbarkeit, Laufzeit
  - Stärken der Lösung
    - Was ist besonders gut? Wo Mehrwert?
    - innovativ, einfache Impl., Performance, ...
  - Schwächen
    - Wo funktioniert es nicht gut? Welche Annahmen? Limitationen? Problematische Randbedingungen?
    - Warum treten diese Schwächen auf?
3. Literaturvergleich
  - Vergleich mit bestehenden Ansätzen
  - Inwiefern besser/schlechter?
4. Verbesserungspotential
  - Weitere Arbeiten
  - Zukunft
  - vielversprechende Ansätze
5. Fazit
  - Zusammenfassung, ob Frage beantwortet wurde
  - Ziele erreicht?
*/

// Kriterien
// - strukturelle anforderungen: erzeugt es eine gute struktur? gibt es fehler?
// - anwendbarkeit: pass es gut in den prozess? wie verständlich/wartbar/erweiterbar ist es?
// - geschwindigkeit: wie schnell ist es?
// - weitere betrachtungen: gibt es dinge zu beachten, caviats? alternativen? 

// RQ 2
*Routenplanung*

// 1. Ziele
Zur Beantwortung der Forschungsfrage (II) "_#forschungsfragen.at(1)_" wurden exakte und heuristische Suchalgorithmen auf einem punktbasierten sowie einem auf Teilabschnitten basierendem Modell betrachtet. Dazu wurden Kriterien für die Bewertung der Methoden und der gefundenen Lösungen definiert, um somit das Laufzeitverhalten und die Qualität der erzeugten Lösungen jedes Ansatzes quantifizieren zu können. Die Beantwortung dieser Frage ist entscheidend für das Ziel der automatisierten Herstellung von Carbonbewehrung, da hierbei die generelle Struktur und statische Integrität des resultierenden Carbongitters bestimmt wird.

// 2. Bewertung
Für die Modellierung als Graph, in dem die @UE:pl:long die Knoten darstellen, eignet sich die kantenbasierte Bewertung von Lösungen gut, da somit jede Kante als eigenständige Entscheidung in einem Kontext einzeln bewertet werden kann. Somit kann die Route schrittweise aufgebaut werden, was besonders für exakte Methoden von Vorteil ist. 

Die Modularisierung der Bewertungsfunktion ermöglicht eine einfache Betrachtung der einzelnen gewünschten Aspekte einer Route, wobei die Module die jeweiligen Anforderungen an eine korrekt gewählte Kante darstellen. Durch die fehlende Gesamtsicht auf das Gitter fehlt hierbei allerdings der Bezug zur Gitterstruktur, wodurch eine bestimmte Vorstellung einer "guten" Route implizit in den Algorithmus integriert wird. Das führt dazu, dass der Lösungsraum verkleinert wird und somit Routen, welche ebenfalls eine gleichmäßige Gitterstruktur erzeugen würden, systematisch benachteiligt werden. 

Zusätzlich erschwert das Fehlen einer oberen Schranke der Kosten die Bewertung. Aufgrund der Abhängigkeit der Kosten zur Größe der Wand und der Anzahl an Umlenkelementen, ist die Bestimmung einer maximal "schlechten" Route so schwer wie die einer besten Route. So ist, rein an den Gesamtkosten gemessen, schwer abzuschätzen inwieweit eine Route "besser" als eine andere ist.

Besser wäre hier eventuell eine gesamtheitlich strukturelle Bewertung einer Route basierend auf dem Aussehen des resultierenden Gittermusters. Allerdings stellt hier die Bewertung der Gleichmäßigkeit, Lückenfreiheit und der Effizienz hinsichtlich mehrfach verlegter Streben eine größere Herausforderung dar. In weiterführenden Arbeiten könnten hier visuelle bzw. graphische Ansätze, wie beispielsweise die Hough-Transformation, zur Bewertung der Routen eingesetzt werden. Auch eine Normierungen der Kosten auf ein fest definiertes Intervall könnte sich für die Betrachtungen als hilfreich erweisen. 

// Punktbasierte Planung
Eine punktbasierte Routenplanung, bei der die Navigation zwischen Umlenkelementen betrachtet wird, scheint für das vorliegende Problem ungeeignet zu sein. Durch die potentiell hohen Anzahl der @UE:pl:long und damit zu besuchenden Knotenpunkten ist der Suchraum sehr groß, wobei es nur sehr wenige ausreichend gute Lösungen gibt. Auch die Bestimmung der ausgehenden Kanten eines Knotens, bei welcher eigentlich nur eine valide Möglichkeit besteht, trägt zur Ineffizienz dieser Modellierung bei. Insbesondere exakte Methoden scheitern an der vergleichsweise hohen Problemgröße. Heuristische Methoden können sich zwar einer potentiellen Lösung schnell annähern, allerdings führen die Unsicherheit der Qualität der Route kombiniert mit verletzten strukturellen Anforderungen zu einem unvertretbaren Risiko für die industrielle Produktion tragender Elemente aus Carbonbeton; zumal die Laufzeit zur Generierung dieser minderwertigen Routen dennoch vergleichsweise lang ist.

#todo[auswertung, warum meine GA routenplanung schlechter ist, als die in der literatur für TSP]

// Teilrouten Modellierung
Ein vielversprechenderer Ansatz ist demnach die Nutzung der in @sec:route-puzzle-based vorgestellten konzeptuellen Teilrouten. Durch die Modellierung durch fest definierte Teilabschnitte, welche zum Schluss der Routenplanung zu einer vollständigen Route verkettet werden, kann der Suchraum signifikant verkleinert werden und eine Suche darin um Größenordnungen effizienter sein.

Mithilfe dieser Modellierung können beliebig viele Ausschnitte in der Wand dargestellt werden, indem die Anzahl und Position der Teilabschnitte angepasst wird.
Allerdings ist diese Art der Modellierung für nicht-rechteckige Formen eventuell ungeeignet, da es somit mehr @UE:pl:long gibt, welche mehrfach für vertikale und horizontale Streben genutzt werden und an jedem @UE prinzipiell die Möglichkeit besteht die Hauptrichtung zu ändern. Die Definition der Teilrouten sowie die konzeptuelle Abgrenzung zu hauptrichtungsändernden Umlenkungen an den Ecken der Wand muss dann genauer betrachtet werden.

// #figure(
//   cetz.canvas({
//     import cetz.draw: *
//     scale(0.5)
//     set-style(radius:0.5)
//     let offset = 0.9
//     for y in range(0,7, step: 2) {
//       circle((0,y))
//       line((0,y+offset),(0-offset,y))
//       line((0,y - offset),(0-offset,y))
//     }
//     for x in range(9,17, step: 2) {
//       circle((x,10))
//       line((x - offset,10),(x,10+offset))
//       line((x,10 + offset),(x+offset, 10))
//     }
//     circle((8,1))
//     circle((10,3))
//     circle((12,5))
//     circle((14,5))
//     circle((16,5))
//     // Außenlinien
//     line((-1,-1),(-1,11))
//     line((-1,11),(18,11))
//     line((8,-1),(13,4))
//     line((13,4),(18,4))
//   }),
//   caption: [Foo]
// )

Aufgrund des kleineren Suchraums wird der Einsatz exakter Suchalgorithmen wieder praktikabel, da diese unter den reduzierten Problemgrößen eine ausreichende Performanz aufweisen. Bereits simple Methoden wie Brute-Forcing erzielen sehr gute Ergebnisse, während sie dennoch garantieren, eine optimale Lösung zu finden. Für den Anwendungsfall im @CBT liegt die Laufzeit von einigen wenigen Sekunden für die größeren Wandkonfigurationen noch völlig im akzeptablen Rahmen. 

Auch wenn die schnellere Laufzeit des genetischen Algorithmus hier nicht benötigt wird, kann dessen Anwendung in Zukunft eventuell vorteilhaft sein. Sollte zukünftig die Problemgröße steigen, etwa durch Hinzufügen neuer Teilrouten aufgrund der Präsenz mehrerer Wandausschnitte, könnte das hier verwendete Brute-Forcing auf Limitationen bezüglich der Laufzeit stoßen und sich der Einsatz heuristischer Methoden wieder mehr lohnen. 

Eine Feinabstimmung der verwendeten Operatoren kann zudem eventuell die Wahrscheinlichkeit verringern, zu welcher der Algorithmus in einem lokalen Optimum terminiert bzw. die Qualität der Ergebnisse erhöht werden. So könnte der Order Crossover durch einen problemspezifisch optimierten Operator ersetzt werden, um die Qualität der Ergebnisse zu verbessern. Auch könnte statt der Tournierselektion ein rangbasierter Rekombinationsoperator nach #citep(<razaliGeneticAlgorithmPerformance2011>) genutzt werden, welcher im Allgemeinen bessere Ergebnisse erzielen kann. Eine Verbesserung der Laufzeit ist dadurch allerdings nicht zu erwarten, da durch die Sortierung der Population die Rechenzeit für eine Iteration um etwa das Fünffache ansteigt @razaliGeneticAlgorithmPerformance2011. 


Zur Optimierung der Ergebnisse könnte auch der Einsatz von Sicherheitsmechanismen dazu beitragen, dass suboptimale oder invalide Wandkonfigurationen gar nicht erst ausgegeben werden, sondern einen Neustart der Suche mit neuem Seed verursachen. Wie in @sec:route-puzzle-based-heuristics gezeigt, führt eine Neuwahl des Seeds dazu, dass die Qualität der gefundenen Lösungen signifikant ansteigen kann.

// 3. Literaturvergleich: Wie gut ist die MODELLIERUNG + ANSATZ für das PROBLEM

Nach den Ergebnissen von #citep(<rexhepiAnalysis2013>) ist zu vermuten, dass die Populationsgröße einen signifikant größeren Einfluss auf die Qualität der Ergebnisse, hat als die Wahl der Wahrscheinlichkeiten zur Mutation und Rekombination. Dabei scheinen kleinere Populationen generell bessere Lösungen zu produzieren, wobei sich die hier verwendete Populationsgröße von 1000 an diesen Werten orientiert und somit vergleichsweise gute Ergebnisse zu erwarten sind.

Wie in @fig:res-genetic-b-generation dargestellt sinken die Kosten innerhalb weniger Hundert Generationen auf das lokale Optimum von 21 im Fall von $w_2$. Im Vergleich zu den Ergebnissen von #citep(<rexhepiAnalysis2013>) fallen die Kosten sehr schnell. Ein Grund kann sich aus der Arbeit von #citep(<razaliGeneticAlgorithmPerformance2011>) ergeben, bei dem ein ähnlicher Fall unter Nutzung der Tournierselektion auftritt. Die Nutzung der rangbasierten Selektion erzeugt dabei einen flacheren Verlauf und begünstigt somit gegebenenfalls die Ausweitung der Suche durch die Mutations- und Rekombinationsoperatoren, wodurch schlussendlich bessere Ergebnisse erzielt werden können. 


// 4. Verbesserungspotential
- GA parameter feinjustieren
- mehr puzzleteile für fenster
- auch ermöglichen wände ohne türausschnitt

// 5. Fazit

// RQ 3
*Pfadberechnung*

- anpassbar und verständliche vorgehensweise gut für wartung und längeren support

*Gesamtsystem*

Verbindung von Allem


= Zusammenfassung

Und Fazit

= Ausblick
