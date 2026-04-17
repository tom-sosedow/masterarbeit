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
Zur Beantwortung der Forschungsfrage (II) "_#forschungsfragen.at(1)_" wurden exakte und heuristische Suchalgorithmen auf einer punktbasierten Darstellung sowie einer auf Teilrouten basierenden Abstraktion betrachtet. Zur systematischen Bewertung der Ansätze wurden geeignete Kriterien definiert, die sowohl das Laufzeitverhalten als auch die Qualität der erzeugten Lösungen quantifizierbar machen. Die Beantwortung dieser Frage ist entscheidend für das Ziel der automatisierten Herstellung von Carbonbewehrung, da hierdurch die grundlegende Struktur sowie die statische Integrität des resultierenden Carbongitters bestimmt werden.

// 2. Bewertung
// Bewertungsfunktionen
Für die Modellierung als Graph, in dem die @UE:pl:long die Knoten darstellen, eignet sich die kantenbasierte Bewertung von Lösungen gut. Auf diese Weise kann jede Kante als eigenständige Entscheidung im jeweiligen Kontext bewertet werden, wodurch sich die Route schrittweise konstruieren lässt. Somit kann die Route schrittweise aufgebaut werden. Insbesondere exakte Verfahren profitieren von dieser Eigenschaft.

Die modulare Gestaltung der Bewertungsfunktion ermöglicht zudem eine differenzierte Betrachtung einzelner Anforderungen, wobei die Module die jeweiligen Anforderungen an eine korrekt gewählte Kante darstellen. Durch die fehlende Gesamtsicht auf das Gitter fehlt hierbei allerdings der Bezug zur Gitterstruktur, wodurch eine bestimmte Vorstellung einer "guten" Route implizit in den Algorithmus integriert wird. Das führt dazu, dass der Lösungsraum verkleinert wird und somit Routen, welche ebenfalls eine gleichmäßige Gitterstruktur erzeugen würden, systematisch benachteiligt werden. 

Ein weiteres Problem ergibt sich aus der fehlenden oberen Schranke der Kostenfunktion. Aufgrund der Abhängigkeit der Kosten zur Größe der Wand und der Anzahl an Umlenkelementen, ist die Bestimmung einer maximal schlechten Route ebenso schwierig wie die Bestimmung einer optimalen. Dies erschwert die Vergleichbarkeit von Lösungen auf Basis der Gesamtkosten erheblich.

Eine mögliche Verbesserung bestünde in einer ganzheitlichen, strukturbasierten Bewertung, die sich am Aussehen des resultierenden Gittermusters orientiert. Allerdings stellt hier die Bewertung der Gleichmäßigkeit, Lückenfreiheit und der Effizienz hinsichtlich mehrfach verlegter Streben eine größere Herausforderung dar. In weiterführenden Arbeiten könnten hier bildverarbeitende bzw. graphische Ansätze, wie beispielsweise die Hough-Transformation, zur Bewertung der Routen eingesetzt werden. Ebenso erscheint eine Normierung der Kosten auf ein festes Intervall sinnvoll, um die Vergleichbarkeit zu erhöhen.

// Punktbasierte Planung
Eine punktbasierte Routenplanung, bei der die Navigation zwischen einzelnen Umlenkelementen betrachtet wird, erweist sich für das vorliegende Problem als ungeeignet. Aufgrund der großen Anzahl potenziell anzufahrender @UE:pl:long entsteht ein sehr großer Suchraum, dem nur wenige qualitativ hochwertige Lösungen gegenüberstehen. Auch die Bestimmung der ausgehenden Kanten eines Knotens, bei welcher eigentlich nur eine valide Möglichkeit besteht, trägt zur Ineffizienz dieser Modellierung bei. Insbesondere exakte Methoden scheitern an der vergleichsweise hohen Problemgröße. Heuristische Methoden können sich zwar einer potentiellen Lösung schnell annähern, allerdings führen die Unsicherheit der Qualität der Route kombiniert mit verletzten strukturellen Anforderungen zu einem unvertretbaren Risiko für die industrielle Produktion tragender Elemente aus Carbonbeton, insbesondere da die Berechnungszeiten dennoch vergleichsweise hoch bleiben.

// GA kein Vergleich mit Literatur möglich
Da der implementierte genetische Algorithmus zur Routenplanung keine Distanzfunktion im klassischen Sinne zur Bewertung der Individuen nutzt, ist ein Vergleich mit etablierten Benchmark-Problemen des @TSP:pl und deren bekannten Optimal-Lösungen nicht möglich. Ebenso lassen sich bewährte Optimierungsstrategien aus der Literatur nur eingeschränkt übertragen, sodass potenzielle Verbesserungen weitgehend auf Vermutungen beruhen.

// GA Optimierung Operatoren
Dennoch bestehen verschiedene Ansatzpunkte zur Optimierung des genetischen Algorithmus. So könnte eine Feinabstimmung der verwendeten Operatoren die Wahrscheinlichkeit reduzieren, in lokalen Optima zu stagnieren, und gleichzeitig die Lösungsqualität verbessern. Beispielsweise ließe sich der Order Crossover durch einen problemspezifisch optimierten Operator ersetzen, um die Qualität der Ergebnisse eventuell zu verbessern.
Auch könnte statt der Tournierselektion ein rangbasierter Rekombinationsoperator nach #citep(<razaliGeneticAlgorithmPerformance2011>) genutzt werden, welcher im Allgemeinen bessere Ergebnisse erzielen kann. Eine Verbesserung der Laufzeit ist dadurch allerdings nicht zu erwarten, da durch die Sortierung der Population die Rechenzeit für eine Iteration um etwa das Fünffache ansteigt @razaliGeneticAlgorithmPerformance2011. 

// GA Abfall in lokale Optima
Die in @fig:res-genetic-b-generation dargestellten Ergebnisse zeigen, dass die Kosten im Verlauf des genetischen Algorithmus bereits nach wenigen hundert Generationen stark abfallen und beispielsweise im Fall von $w_2$ ein lokales Optimum mit Kosten von 21 erreicht wird. Im Vergleich zu den Ergebnissen von #citep(<rexhepiAnalysis2013>) fallen die Kosten sehr schnell, was nach der Arbeit von #citep(<razaliGeneticAlgorithmPerformance2011>) unter anderem auf die Nutzung der Tournierselektion zurückgeführt werden kann. Rangbasierte Selektionsverfahren erzeugen hingegen einen eher flacheren Verlauf und begünstigen somit gegebenenfalls die Ausweitung der Suche durch die Mutations- und Rekombinationsoperatoren, wodurch schlussendlich bessere Ergebnisse erzielt werden können. 

// GA Populationsgröße
Eine weitere Feinabstimmung ist, neben der Wahl der Operatoren, die Anpassung der Populationsgröße. Ergebnisse aus #citep(<rexhepiAnalysis2013>) legen nahe, dass diese einen größeren Einfluss auf die Lösungsqualität hat als die konkreten Wahrscheinlichkeiten für Mutation und Rekombination. Dabei scheinen kleinere Populationen generell bessere Lösungen zu produzieren, wobei sich die hier verwendete Populationsgröße von 1000 an diesen Werten orientiert und somit vergleichsweise gute Ergebnisse erwarten lässt.

// Heuristiken: Sicherheitsmechanismen 
Zur weiteren Verbesserung der Ergebnisqualität des @GA könnte auch der Einsatz von Sicherheitsmechanismen dazu beitragen, dass suboptimale oder invalide Wandkonfigurationen gar nicht erst ausgegeben werden, sondern die Suche mit einem neuen Zufalls-Seed neugestartet wird. Wie in @sec:route-puzzle-based-heuristics gezeigt, kann eine Variation des Seeds einen signifikanten Einfluss auf die Qualität der gefundenen Lösungen haben.

// Teilrouten Modellierung
Ein wesentlich vielversprechenderer Ansatz ergibt sich aus der Modellierung mittels Teilrouten, wie in @sec:route-puzzle-based vorgestellt. Da die Komplexität des @TSP:pl maßgeblich von der Anzahl der Knoten abhängt, führt die Aggregation der Knoten zu fest definierten Teilabschnitten zu einer erheblichen Reduktion des Suchraums. Die anschließende Verkettung dieser Teilrouten zu einer vollständigen Route ermöglicht eine deutlich effizientere Suche und verbessert die Skalierbarkeit des Ansatzes.

Mithilfe dieser Modellierung können beliebig viele Ausschnitte in der Wand dargestellt werden, indem die Anzahl und Position der Teilabschnitte angepasst wird.
Allerdings ist diese Art der Modellierung für nicht-rechteckige Formen eventuell ungeeignet, da es somit mehr @UE:pl:long gibt, welche mehrfach für vertikale und horizontale Streben genutzt werden und an jedem @UE prinzipiell die Möglichkeit besteht die Hauptrichtung zu ändern. Insbesondere die Definition der Teilrouten sowie die konzeptuelle Abgrenzung zu hauptrichtungsändernden Umlenkungen an den Ecken der Wand muss dann genauer betrachtet werden.

// exakte Methoden
Aufgrund des kleineren Suchraums wird der Einsatz exakter Suchalgorithmen wieder praktikabel, da diese unter den reduzierten Problemgrößen eine ausreichende Performanz aufweisen. Bereits simple Methoden wie Brute-Forcing liefern in diesem Kontext sehr gute Ergebnisse und garantieren zugleich die Optimalität der Lösung. Für den Einsatz im @CBT liegt die Laufzeit von einigen wenigen Sekunden für die größeren Wandkonfigurationen noch völlig im akzeptablen Rahmen. 

// heuristische Methoden
Auch wenn die Vorteile heuristischer Verfahren hinsichtlich der Laufzeit in diesem Szenario aktuell nicht ausschlaggebend sind,könnten sie bei zukünftigen Erweiterungen an Bedeutung gewinnen. Sollte zukünftig die Problemgröße steigen, etwa durch Hinzufügen neuer Teilrouten aufgrund der Präsenz mehrerer Wandausschnitte, könnte das hier verwendete Brute-Forcing auf Limitationen bezüglich der Laufzeit stoßen und sich der Einsatz heuristischer Methoden wieder mehr lohnen. 

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
