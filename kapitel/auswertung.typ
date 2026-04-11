#import "/util.typ": *

= Auswertung <sec:auswertung>
#todo[Einleitender Abschnitt]



// Aufbau
// - Bewerten der Resultate anhand der Kriterien
//   - Was funktioniert gut
//   - Was fehlt oder funktioniert nicht so gut?
//   - Limitationen, zukunftspotential, weitere Forschungsmöglichkeiten
// - Beantworten der RQ, welche Methode sich gut eignet oder ob sie die ziele erfüllt

// Kriterien
// - strukturelle anforderungen: erzeugt es eine gute struktur? gibt es fehler?
// - anwendbarkeit: pass es gut in den prozess? wie verständlich/wartbar/erweiterbar ist es?
// - geschwindigkeit: wie schnell ist es?
// - weitere betrachtungen: gibt es dinge zu beachten, caviats? alternativen? 

// RQ1 
*Platzierung der Umlenkelemente*

Die dynamische Berechnung der Positionen der @UE:pl:long auf Basis der fünf Eingabeparameter wurde in @sec:ue-place untersucht. Das vorgestellte schrittweise Platzierungsverfahren liefert zuverlässig valide Ergebnisse, da es ohne Zufallskomponenten auskommt. Allerdings ist nicht in jedem Fall gewährleistet, dass die resultierenden Anordnungen optimal sind. Insbesondere kann die feste Platzierung des ersten Umlenkelements an der linken unteren Ecke der Tür dazu führen, dass Sonderstellen an ungünstigen Positionen auftreten. Ansätze, welche die für die Sonderumlenkungen nötigen @UE:pl priorisiert platzieren, könnten hier potenziell zu günstigeren Voraussetzungen für die anschließende Routenplanung führen.
#todo[mehr drauf eingehen, wenn abschnitt in Routenplanung fertig ist] 

Die Implementation ist durch die fixierte Vorgehensweise allerdings sehr unkompliziert. Dies führt zu einem geringen Wartungsaufwand sowie zu einer hohen Anpassbarkeit, die auch ohne vertiefte informatische Kenntnisse gewährleistet ist.

Einschränkungen ergeben sich jedoch aus der zugrunde liegenden Modellierung. Durch die Paarung der @UE:pl entlang einer Türseite mit denen einer Wandseite bei der Positionierung vertikaler @UE:pl ist das Verfahren nicht ohne Weiteres auf nicht-rechteckige Formen übertragbar. Bei schrägen Seiten, wie etwa bei Parallelogrammen oder Kreisbögen, müssten die @UE:pl entlang der Schräge sowohl für vertikale als auch für horizontale Streben genutzt werden, wofür in der aktuellen Modellierung keine geeignete Zuordnung vorgesehen ist. Erweiterungen zur Unterstützung rechteckiger Fensterausschnitte oder mehrerer Ausschnitte sollten jedoch problemlos möglich sein.

Auch die Integration zusätzlicher Bauteile, wie beispielsweise Stromdosen oder Kabelkanäle, ist mit der aktuellen Modellierung als Raster nur eingeschränkt möglich. Insbesondere dann, wenn Objekte außerhalb der diskreten Rasterpositionen platziert werden müssen oder größere Abmessungen als ein @UE aufweisen, stößt der Ansatz an seine Grenzen. Eine mögliche Erweiterung könnte darin bestehen, zunächst die @UE:pl zu positionieren und anschließend weitere Elemente in einem stetigen Koordinatensystem zu ergänzen.

Hinsichtlich der Laufzeit erfüllt das Verfahren die Anforderungen der Prozesskette des @CBT in hohem Maße. Selbst für große Wandkonfigurationen erfolgt die Berechnung der Positionen innerhalb weniger Millisekunden, sodass ein Einsatz in industriellen Produktionsketten problemlos möglich ist.

Da die in den folgenden Kapiteln behandelten Verfahren auf den hier bestimmten Positionen der @UE:pl aufbauten und gezeigt werden konnte, dass sich auf dieser Grundlage gleichmäßige Carbongitter erzeugen lassen, stellt das iterative Platzierungsverfahren insgesamt eine geeignete Antwort auf die Forschungsfrage (I) dar.


// RQ 2
*Routenplanung*
- Um die Reihenfolge der anzufahrenden UE zu bestimmen wurden 2 modelle für die route betrachtet: eine punktbasierte (@sec:route-pointbased) und eine auf vordefinierten teilrouten (@sec:route-puzzle-based) basierte
- die in @sec:route-pointbased vorgestellten algorithmen sind für den vorliegenden anwendungsfall des TSP leider unzureichend, da exakte methoden zu lange zur berechnung einer lösung benötigen und heruistische methoden nicht mit sicherheit das optimum liefern können
- die in @sec:route-puzzle-based vorgestellte exakte methode hat eine vollkommen ausreichend gute laufzeit, ist einfach zu verstehen und zu erweitern und liefert garantiert immer eine optimale lösung mit den gegebenen positionen der UE, weshalb sich dieser ansatz gut für das lösen des problems eignet
  - der genetische algorithmus findet hier sehr schnell oftmals das optimum, in einigen fällen, u.A. auch durch den gewählten Seed für die Zufallskomponenten, wird allerdings nur ein lokales Optimum gefunden
    - für wand $w_3$ gibt es nur wenige gute lösungen mit kosten unter 400, wei in @sec:route-puzzle-based-exact zu sehen ist
    - das sind fälle bei denen der lösungsraum sehr klein ist, was dazu führt dass zb @GA dann schwierigkeiten hat genau diese zu finden, wie man auch in den ergebnissen aus @sec:route-puzzle-based-heuristics sehen kann
  - da es sich im vorliegenden problem nur um 6 (bzw. 7) puzzleteile handelt, ist der lösungsraum überschaubar, sodass es sich beim unterschied zw. beiden suchalgorithmen nur um einige wenige sekunden handelt
    - sollten später weitere teile implementiert werden, zb für die unterseite eines fensters, könnten heuristische methoden attraktivere lösungen sein um die laufzeit in einem akzeptablen rahmen zu halten
  - der ansatz sieht die platzierung der UE als fest an
    - es kann sein, dass es in dieser platzierung nur eine minderwertige lösung gibt, aber in einer anderen anordnung eine signifikant bessere route existiert
    - das wird vom ansatz nicht beachtet
- auch hier versagt der ansatz bei nicht-rechteckigen formen für wand und tür
  - die bewertungsfunktion würde zb türbögen falsch bewerten
  - puzzleteile wären komplexer zu definieren, da schrägen in einem hindernis dazu führen könnten, dass es puzzleteile mit vertikalen und horizontalen streben geben kann


// RQ 3
*Pfadberechnung*
- anpassbar und verständliche vorgehensweise gut für wartung und längeren support

*Gesamtsystem*
Verbindung von Allem


= Zusammenfassung
Und Fazit
= Ausblick