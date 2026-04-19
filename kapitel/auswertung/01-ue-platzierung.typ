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