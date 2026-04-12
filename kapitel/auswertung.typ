#import "/util.typ": *
#import "/forschungsfragen.typ": forschungsfragen
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
/*- Um die Reihenfolge der anzufahrenden UE zu bestimmen wurden 2 modelle für die route betrachtet: eine punktbasierte (@sec:route-pointbased) und eine auf vordefinierten teilrouten (@sec:route-puzzle-based) basierte
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
  - puzzleteile wären komplexer zu definieren, da schrägen in einem hindernis dazu führen könnten, dass es puzzleteile mit vertikalen und horizontalen streben geben kann*/


// 1. Ziele
Zur Beantwortung der Forschungsfrage (II) "_#forschungsfragen.at(1)_" wurden exakte und heuristische Suchalgorithmen auf einem punktbasierten sowie einem auf Teilabschnitten basierendem Modell betrachtet. Die Beantwortung dieser Frage ist entscheidend für das Ziel der automatisierten Herstellung von Carbonbewehrung, da hierbei die generelle Struktur und statische Integrität des resultierenden Carbongitters bestimmt wird.

// 2. Bewertung
Eine punktbasierte Routenplanung, bei der die Navigation zwischen Umlenkelementen betrachtet wird, scheint für das vorliegende Problem ungeeignet zu sein. Durch die potentiell hohen Anzahl der @UE:pl:long und damit zu besuchenden Knotenpunkten ist der Suchraum sehr groß, wobei es nur sehr wenige ausreichend gute Lösungen gibt. Auch die Bestimmung der ausgehenden Kanten eines Knotens, bei welcher eigentlich nur eine valide Möglichkeit besteht, trägt zur Ineffizienz dieser Modellierung bei. Insbesondere exakte Methoden scheitern an der vergleichsweise hohen Problemgröße. Heuristische Methoden können sich zwar einer potentiellen Lösung stark annähern, allerdings führen die Unsicherheit der Qualität der Route kombiniert mit verletzten strukturellen Anforderungen zu einem unvertretbaren Risiko für die industrielle Produktion von Carbonbeton für Trägerelemente; zumal die Laufzeit zur Generierung dieser minderwertigen Routen dennoch vergleichsweise lang ist.

Ein vielversprechenderer Ansatz ist demnach die Nutzung der in @sec:route-puzzle-based vorgestellten konzeptuellen Teilrouten. Durch die Modellierung durch fest definierte Teilabschnitte, welche zum Schluss der Routenplanung zu einer vollständigen Route verkettet werden, kann der Suchraum signifikant verkleinert werden und eine Suche darin um Größenordnungen effizienter sein.

Der kleinere Suchraum und die resultierende Steigerungen der Effizienz ermöglichen somit wieder den Einsatz exakter Methoden. 


// 3. Literaturvergleich

// 4. Verbesserungspotential


// 5. Fazit

// RQ 3
*Pfadberechnung*

- anpassbar und verständliche vorgehensweise gut für wartung und längeren support

*Gesamtsystem*

Verbindung von Allem


= Zusammenfassung

Und Fazit

= Ausblick
