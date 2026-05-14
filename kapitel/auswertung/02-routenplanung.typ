#import "/util.typ": *
#import "/forschungsfragen.typ": forschungsfragen
#import "@preview/cetz:0.4.2"

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

===== Routenplanung

// 1. Ziele
Zur Beantwortung der Forschungsfrage (II) "_#forschungsfragen.at(1)_" wurden exakte und heuristische Suchalgorithmen auf einer punktbasierten Darstellung sowie einer auf Teilrouten basierenden Abstraktion betrachtet. Zur systematischen Bewertung der Ansätze wurden geeignete Kriterien definiert, die sowohl das Laufzeitverhalten als auch die Qualität der erzeugten Lösungen quantifizierbar machen. Die Beantwortung dieser Frage ist entscheidend für das Ziel der automatisierten Herstellung von Carbonbewehrung, da hierdurch die grundlegende Struktur sowie ein Großteil der statischen Integrität des resultierenden Carbongitters bestimmt werden.

// 2. Bewertung
// Bewertungsfunktionen
Für die Modellierung als Graph, in dem die @UE:pl:long die Knoten darstellen, eignet sich die kantenbasierte Bewertung von Lösungen gut. Auf diese Weise kann jede Kante als eigenständige Entscheidung im jeweiligen Kontext bewertet werden, wodurch sich die Route schrittweise konstruieren lässt. Insbesondere exakte Verfahren profitieren von dieser Eigenschaft.

Die Kostenfunktion ist jedoch in manchen Teilen unausgereift. So wird in @eq:max-distanz-1 eine Kante mit $Delta x = 0$ mit hohen Kosten bewertet. In der Regel ist dies zwar korrekt, allerdings ergeben sich einige Sonderfälle, in denen es die richtige Entscheidung ist, in der gleichen Spalte oder Zeile zu verbleiben. Ein Beispiel ist hierfür in @appendix:wandkonfigurationen Wand 27 zu sehen. Durch die Sonderumlenkung bei @UE 60 und 68 entgegen des Uhrzeigersinns verläuft die nachfolgende vertikale Strebe in Richtung @UE 6 achsenparallel. Die Kante $60 -> 6$, die durch die in @sec:route-postprocessing dargestellte Nachbearbeitung der Route zwischen $L V$ und $T V$ entsteht, wird jedoch aufgrund der gleichen x-Komponente beider Knoten negativ bewertet. Eine detailliertere und komplexere Unterscheidung der Fälle könnte hier sicherlich eine akkuratere Bewertung ermöglichen.

Die modulare Gestaltung der Bewertungsfunktion ermöglicht dafür eine differenziertere Betrachtung einzelner Anforderungen, wobei die Module die jeweiligen Anforderungen an eine korrekt gewählte Kante darstellen. Durch die fehlende Gesamtsicht auf das Gitter fehlt hierbei allerdings der Bezug zur Gitterstruktur, wodurch eine bestimmte Vorstellung einer "guten" Route implizit in den Algorithmus integriert wird. Das führt dazu, dass der Lösungsraum verkleinert wird und somit Routen, welche ebenfalls eine gleichmäßige Gitterstruktur erzeugen würden, systematisch benachteiligt werden. 

Ein weiteres Problem ergibt sich aus der fehlenden oberen Schranke der Kostenfunktion. Aufgrund der Abhängigkeit der Kosten zur Größe der Wand und der Anzahl an Umlenkelementen, ist die Bestimmung einer maximal schlechten Route ebenso schwierig wie die Bestimmung einer optimalen. Dies erschwert die Vergleichbarkeit von Lösungen auf Basis der Gesamtkosten erheblich.

Eine mögliche Verbesserung bestünde in einer ganzheitlichen, strukturbasierten Bewertung, die sich am Aussehen des resultierenden Gittermusters orientiert. Allerdings stellt hier die Bewertung der Gleichmäßigkeit, Lückenfreiheit und der Effizienz hinsichtlich mehrfach verlegter Streben eine größere Herausforderung dar. In weiterführenden Arbeiten könnten hier bildverarbeitende bzw. graphische Ansätze, wie beispielsweise die Hough-Transformation, zur Bewertung der Routen eingesetzt werden. Ebenso erscheint eine Normierung der Kosten auf ein festes Intervall sinnvoll, um die Vergleichbarkeit zu erhöhen.

// Punktbasierte Planung
Unabhängig von möglichen Verbesserungen der Bewertungsfunktion zeigen die Untersuchungsergebnisse jedoch grundlegende Grenzen des punktbasierten Ansatzes auf. Die punktbasierte Routenplanung, bei der die Navigation zwischen einzelnen @UE betrachtet wird, erweist sich insgesamt für das vorliegende Problem als ungeeignet. Aufgrund der großen Anzahl potenziell anzufahrender @UE:pl:long entsteht ein sehr großer Suchraum, dem nur wenige qualitativ hochwertige Lösungen gegenüberstehen. Auch die Bestimmung der ausgehenden Kanten eines Knotens, bei welcher eigentlich nur eine valide Möglichkeit besteht, trägt zur Ineffizienz dieser Modellierung bei. Insbesondere exakte Methoden scheitern an der vergleichsweise hohen Problemgröße. Heuristische Methoden können sich zwar potenziellen Lösungen vergleichsweise schnell annähern, jedoch führen die Unsicherheit hinsichtlich der Qualität der erzeugten Route sowie mögliche Verletzungen struktureller Anforderungen zu einem nicht vertretbaren Risiko für die industrielle Produktion tragender Carbonbetonbauteile. Dies gilt insbesondere vor dem Hintergrund, dass die Berechnungszeiten trotz des heuristischen Ansatzes vergleichsweise hoch bleiben.

// GA kein Vergleich mit Literatur möglich
Die Bewertung der Leistungsfähigkeit des eingesetzten @GA gestaltet sich dabei zusätzlich schwierig. Da der implementierte @GA zur Routenplanung keine Distanzfunktion im klassischen Sinne zur Bewertung der Individuen nutzt und außerdem problemspezifische Operatoren eingesetzt wurden, ist ein Vergleich mit etablierten Benchmark-Problemen des @TSP:pl und deren bekannten Optimal-Lösungen nicht möglich. Ebenso lassen sich bewährte Optimierungsstrategien aus der Literatur nur eingeschränkt übertragen, sodass potenzielle Verbesserungen weitgehend auf Vermutungen beruhen.

Evolutionäre Algorithmen sind zudem ein äußerst umfangreiches und komplexes Forschungsfeld. Sie umfassen eine Vielzahl an anpassbaren Parametern sowie Strategien, mit denen durch problemspezifische Optimierungen sowohl die Effizienz als auch die Qualität der erzielten Ergebnisse verbessert werden können. Im Vergleich zu anderen Arbeiten, die sich mit dem Einsatz von @GA:pl zur Lösung des @TSP:pl befassen, ist der hier implementierte Algorithmus nur geringfügig optimiert.
So zeigen beispielsweise #citep(<tsaiHighPerformanceGeneticAlgorithm2014>), dass durch die direkte Übernahme gemeinsamer Eigenschaften aus der Population in die resultierende Lösung erhebliche Einsparungen bei der Berechnungszeit erzielt werden können. Für Instanzen des @TSP:pl mit über 1000 Städten konnten innerhalb von 133 Generationen Routen berechnet werden, deren Kosten lediglich um 1,5 % über dem Optimum liegen. Eine vertiefte Untersuchung mit ausschließlichem Fokus auf den Einsatz von @GA:pl hat daher das Potenzial, die erzielten Ergebnisse in hohem Maße zu verbessern.

// GA Optimierung Operatoren
Dennoch bestehen auch für den hier implementierten @GA verschiedene Ansatzpunkte zur Optimierung, welche relativ einfach umsetzbar wären. So könnte eine Feinabstimmung der verwendeten Operatoren die Wahrscheinlichkeit reduzieren, in lokalen Optima zu stagnieren, und gleichzeitig die Lösungsqualität verbessern. Beispielsweise ließe sich der Order Crossover durch einen problemspezifisch optimierten Operator ersetzen, um die Qualität der Ergebnisse eventuell zu verbessern.
Auch könnte statt der Tournierselektion ein rangbasierter Rekombinationsoperator nach #citep(<razaliGeneticAlgorithmPerformance2011>) genutzt werden, welcher im Allgemeinen bessere Ergebnisse erzielen kann. Eine Verbesserung der Laufzeit ist dadurch allerdings nicht zu erwarten, da durch die Sortierung der Population die Rechenzeit für eine Iteration um etwa das Fünffache ansteigt @razaliGeneticAlgorithmPerformance2011. 

// GA Abfall in lokale Optima
Die in @fig:res-genetic-b-generation dargestellten Ergebnisse zeigen ferner, dass die Kosten im Verlauf des genetischen Algorithmus bereits nach wenigen hundert Generationen stark abfallen und beispielsweise im Fall von $w_2$ ein lokales Optimum mit Kosten von 21 erreicht wird. Im Vergleich zu den Ergebnissen von #citep(<rexhepiAnalysis2013>) fallen die Kosten sehr schnell, was nach der Arbeit von #citep(<razaliGeneticAlgorithmPerformance2011>) unter anderem auf die Nutzung der Tournierselektion zurückgeführt werden kann. Rangbasierte Selektionsverfahren erzeugen hingegen einen eher flacheren Verlauf und begünstigen somit gegebenenfalls die Ausweitung der Suche durch die Mutations- und Rekombinationsoperatoren, wodurch schlussendlich bessere Ergebnisse erzielt werden können. 

// GA Populationsgröße
Eine weitere Feinabstimmung ist, neben der Wahl der Operatoren, die Anpassung der Populationsgröße. Ergebnisse aus #citep(<rexhepiAnalysis2013>) legen nahe, dass diese einen größeren Einfluss auf die Lösungsqualität hat als die konkreten Wahrscheinlichkeiten für Mutation und Rekombination. Dabei scheinen kleinere Populationen generell bessere Lösungen zu produzieren, wobei sich die hier verwendete Populationsgröße von 1000 an diesen Werten orientiert und somit vergleichsweise gute Ergebnisse erwarten lässt. Dennoch besteht Verbesserungspotential, da #citep(<tsaiHighPerformanceGeneticAlgorithm2014>) mit den oben genannten Optimierungen lediglich 35 bis 80 Individuen in einer Population verwendeten, um signifikant bessere Ergebnisse als die hier erzielten zu erreichen.

// Heuristiken: Sicherheitsmechanismen 
Zur weiteren Verbesserung der Ergebnisqualität des @GA könnte auch der Einsatz von Sicherheitsmechanismen dazu beitragen, dass suboptimale oder invalide Wandkonfigurationen gar nicht erst ausgegeben werden, sondern die Suche mit einem neuen Zufalls-Seed neugestartet wird. Wie in @sec:route-puzzle-based-heuristics gezeigt, kann eine Variation des Seeds einen signifikanten Einfluss auf die Qualität der gefundenen Lösungen haben. Üblicherweise werden deshalb @GA bis zu 30 Mal neugestartet, um aussagekräftige Ergebnisse bezüglich der bestmöglichen Route treffen zu können @tsaiHighPerformanceGeneticAlgorithm2014 @rexhepiAnalysis2013.

Dennoch ist es zweifelhaft, dass diese Änderungen den Einsatz genetischer Algorithmen bei einer punktbasierten Routenplanung im vorliegenden Anwendungsfall praktikabel machen. Da dafür tiefgreifende Änderungen und ein ausgebautes Verständnis der zugrunde liegenden Konzepte nötig wären, wird dieses Vorgehen daher als eher ungeeignet bewertet. 

// Teilrouten Modellierung
Ein wesentlich effizienterer Ansatz ergibt sich aus der Modellierung mittels Teilrouten, wie sie in @sec:route-puzzle-based vorgestellt wurde. Da die Komplexität des @TSP:pl maßgeblich von der Anzahl der Knoten abhängt, führt die Aggregation der Knoten zu fest definierten Teilabschnitten zu einer erheblichen Reduktion des Suchraums. Die anschließende Verkettung dieser Teilrouten zu einer vollständigen Route ermöglicht eine deutlich effizientere Suche und verbessert die Skalierbarkeit des Ansatzes.

Mithilfe dieser Modellierung können beliebig viele Ausschnitte in der Wand dargestellt werden, indem die Anzahl und Position der Teilabschnitte angepasst wird.
Allerdings ist diese Art der Modellierung für nicht-rechteckige Formen eventuell ungeeignet, da es somit mehr @UE:pl:long gibt, welche mehrfach für vertikale und horizontale Streben genutzt werden und an jedem @UE prinzipiell die Möglichkeit besteht die Hauptrichtung zu ändern. Insbesondere die Definition der Teilrouten sowie die konzeptuelle Abgrenzung zu hauptrichtungsändernden Umlenkungen an den Ecken der Wand muss dann genauer betrachtet werden.

// exakte Methoden
Aufgrund des durch diese Modellierung verkleinerten Suchraums wird der Einsatz exakter Suchalgorithmen wieder praktikabel, da diese unter den reduzierten Problemgrößen eine ausreichende Performanz aufweisen können. Bereits simple Methoden wie Brute-Forcing liefern in diesem Kontext schnell sehr gute Ergebnisse, wie in @tab:bruteforce-puzzle-res zu sehen ist. Dabei garantieren sie weiterhin die Optimalität der Lösung. 

Es zeigt sich, dass größere Wandkonfigurationen signifikant weniger potenzielle Lösungen aufweisen. Dies kann zum einen dadurch erklärt werden, dass größere Abweichungen zwischen Ist- und Soll-Positionen der @UE:pl:long durch die distanzbasierte Kostenfunktion stärker bestraft werden und somit vergleichbare Fehler zu höheren Kosten führen. In Verbindung mit der festen Kostengrenze von 400, welche unabhängig von der Wandgröße festgelegt wurde, fallen dadurch mehr Routen aus der Betrachtung. Bei kleineren Wandkonfigurationen verliert diese Kostengrenze dann an Signifikanz, da es zu gröberen Fehlern kommen kann bevor die Grenze überschritten wird. Es wäre hier sicherlich von Vorteil, die Kostengrenze dynamisch und in Abhängigkeit von den Maßen der Wand zu berechnen, um den Algorithmus effizienter zu gestalten.

Außerdem ist zu sehen, dass die Laufzeiten scheinbar proportional mit der Größe der Wandkonfiguration ansteigen, obwohl der Lösungsraum kleiner ist. Ein Faktor ist hierbei die Bewertungsfunktion, die trotz der Kodierung als Permutation fester Länge auf der resultierenden Route arbeitet. Da durch die größeren Wände auch mehr Kanten bewertet werden müssen, steigt die Laufzeit des Gesamtprozesses folglich. Für den Einsatz im @CBT liegt die Laufzeit von einigen wenigen Sekunden für die größeren Wandkonfigurationen allerdings dennoch völlig im akzeptablen Rahmen.

// heuristische Methoden
Auch wenn die Vorteile heuristischer Verfahren hinsichtlich der Laufzeit in diesem Szenario aktuell nicht ausschlaggebend sind, könnten sie bei zukünftigen Erweiterungen an Bedeutung gewinnen. Sollte zukünftig die Problemgröße steigen, etwa durch Hinzufügen neuer Teilrouten aufgrund der Präsenz mehrerer Wandausschnitte, könnte das hier verwendete Brute-Forcing auf Limitationen bezüglich der Laufzeit stoßen und sich der Einsatz heuristischer Methoden wieder mehr lohnen. 

// 4. Verbesserungspotential
Trotz der insgesamt als positiv zu bewertenden Ergebnisse weisen die vorgestellten Ansätze in bestimmten Aspekten Verbesserungspotential auf. Insbesondere erweist sich die Bewertungsfunktion durch den starken und voreingenommenen Eingriff in den Suchalgorithmus als suboptimal. Hier könnte eine ganzheitlich strukturelle Bewertung zu signifikant besseren Ergebnissen führen, da gegebenenfalls mehr potentielle Lösungen existieren können, welche aber durch die Bewertungsfunktion fälschlicherweise als schlecht eingestuft und verworfen werden würden. Ebenso können Optimierungen für den Brute-Force Ansatz die Berechnung effizienter gestalten, indem beispielsweise Routen mit invaliden Abfolgen von Teilrouten nicht betrachtet werden. Auch der Übergang zum Backtracking könnte hier zu weiteren Leistungssteigerungen führen, ohne die Komplexität des Algorithmus unnötig zu erhöhen. Sollten zukünftig Heuristiken bzw. Metaheuristiken relevanter werden, weil eventuell die Problemgröße ansteigt, müsste hier eine Feinabstimmung der Operatoren und Prozessparameter erfolgen.

Die gewählte Modellierung der optionalen Umlenkelemente erweist sich ebenfalls als ungeeignet, da sie die problemspezifischen Gegebenheiten nicht ganz abbilden kann. So kann derzeit nur jeweils ein @UE:long dadurch in der Planung betrachtet werden, obwohl in einer Wandkonfiguration mehrere existieren können und dadurch für die Auswahl zur Verfügung stünden.


// 5. Fazit
Zusammenfassend konnte gezeigt werden, dass die Modellierung durch Teilrouten eine höchst effiziente Berechnung der Reihenfolge der anzufahrenden @UE:pl:long ermöglicht. Durch den Einsatz von Brute Force kann die Optimalität einer gefundenen Lösung bezüglich der definierten Bewertungsfunktion garantiert werden. Die entstehenden Gittermuster erfüllen alle Anforderungen und weisen wenig bis keine Materialverschwendung auf. Dieser Ansatz ist also ohne Weiteres in der automatisierten Produktion von Carbongittern anwendbar und benötigt keine manuellen Schritte außer der Befestigung der Enden des Garns. Er ist somit eine geeignete Antwort auf Forschungsfrage (II).