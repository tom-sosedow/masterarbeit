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

===== Pfadberechnung

// 1. Ziel und Kontext
Zur Beantwortung der Forschungsfrage (III) "_#forschungsfragen.at(2)_" wurde ein Algorithmus zur Planung eines Pfades entwickelt und implementiert. Dieser generiert Wegpunkte auf Basis der zuvor erstellten Route zwischen den Umlenkelementen. Die Beantwortung der Forschungsfrage ist essentiell für das Hauptproblem, da ohne eine gute Pfadplanung kein Carbongitter vollautomatisiert erstellt werden kann, welches die strukturellen Anforderungen erfüllt.

// 2. Bewertung

// Umlaufrichtung
Zur Bestimmung der Umlaufrichtung erweist sich der vektorbasierte Ansatz nach #citep(<merschAutomation3DRobotic2025>) gegenüber dem Verfahren mittels Graphfärbung als geeigneter. Im Allgemeinen produziert er robustere Ergebnisse und ist zuverlässig korrekt. Einschränkungen treten jedoch auf, wenn die Route von den zugrunde gelegten Annahmen abweicht. In diesen Fällen kann die berechnete Umlaufrichtung falsch sein, wobei zumindest die Haftung des Garns am jeweiligen @UE weiterhin gewährleistet bleibt. Da, ausgehend von den Ergebnissen aller 32 Wandkonfigurationen, diese Ausnahmen nicht bei der auf Teilrouten basierenden Routenplanung auftreten, ist dieser Ansatz in Absprache mit dem Team des @CBT ausreichend. Im Zuge weiterer Forschung könnte zur Verbesserung ein Ansatz untersucht werden, welcher die Umlaufrichtung anhand der resultierenden Strebe festlegt und dabei insbesondere starken Bezug auf die Achsenparallelität nimmt, da dies die eigentlich ausschlaggebende Eigenschaft einer korrekten Strebe ist.

// Wegpunkte je Umlenkungsart bestimmen
Aufbauend darauf zeigt sich, dass auch die isolierte Betrachtung einzelner @UE:pl:long zur Bestimmung der zugehörigen Wegpunkte hinreichend ist, um einen gültigen Pfad zu erzeugen. Die möglichen Positionen entsprechen dabei weitestgehend denen, wie sie vom derzeitigen Algorithmus im @CBT generiert werden. Allerdings wird bei dem vorgestellten Verfahren zusätzlich die Position des Umlenkelements in der Route sowie in der Wand berücksichtigt, um die Art der Umlenkung und damit die Positionen der Wegpunkte zu bestimmen. Diese differenziertere Betrachtung ermöglicht eine präzisere Kontrolle der Garnspannung und verstärkt somit die strukturellen Eigenschaften des Carbongitters, da beispielsweise mehr kreuzende Streben in Kontakt kommen und somit bei der Temperierung des Harzes im Ofen verbunden werden.


// Vertikaler Versatz, Kreuzungspunkte
Insbesondere bei der Erzeugung von Kontaktpunkten zwischen sich kreuzenden Streben spielt dieser Vorteil bezüglich der Garnspannung eine wichtige Rolle. In den durchgeführten Tests konnte der nötige vertikale Anstieg in der Nähe der @UE im Mittel gegenüber dem aktuell im @CBT eingesetzten Verfahren reduziert werden, da das Werkzeug erst angehoben wird, sobald eine kreuzende Strebe erreicht wird. Die Spannung aller Streben konnte dabei vollständig aufrechterhalten werden.
Dennoch konnten, wie in @fig:strebe-abrutschen-vert-versatz zu sehen, viele Verbindungen nicht erfolgreich hergestellt werden. Ursache hierfür ist, dass auf das Garn, nachdem es initial nach oben gerutscht ist, keine ausreichend großen vertikal nach unten gerichteten Kräfte wirken, um es wieder in seine ursprüngliche Position zurückzuführen. Möglichkeiten zur Lösung können ein Absenken der Werkzeuges auf eine tiefer gelegene Ebene beinhalten, nachdem die erste Strebe gekreuzt wurde. So könnte das Garn in einem steileren Winkel nach unten gezogen werden, das Garn an dem @UE nach unten rutschen und parallel eine Verbindung mit der darunter liegenden Strebe hergestellt werden.

// Kollisionsvermeidung Garnstreben 
Die Bestimmung der Kreuzungspunkte zwischen dem aktuellen Pfadabschnitt und bereits verlegten Streben basiert jedoch nicht auf einem physikalisch exakten Modell. Entsprechend kann die Genauigkeit dieser Annäherung in bestimmten Situationen begrenzt sein. Insbesondere bei vollständigen Umlenkungen an den Ecken der Wand kommt es deshalb zu Problemen, wie bereits in @sec:path-results beschrieben wurde. Aufgrund der Unterschiede zwischen dem Werkzeugmittelpunkt, welcher den Pfad genau abfährt, und dem gezeigten Werkzeug zur Garnablage wurden bei dem praktischen Test von Wand 5 einige Streben stark gestreift. 

Die beobachteten Ergebnisse zeigen, dass die Kollisionsvermeidung zwischen Werkzeug und Garnstreben noch nicht ausreichend ausgereift ist, um einen zuverlässigen Einsatz in der industriellen Produktion zu gewährleisten. Aufgrund der physikalischen Einschränkungen des Werkzeugs sowie des daraus erforderlichen vertikalen Versatzes zur Kollisionsvermeidung sind die Verbesserungsmöglichkeiten innerhalb des vorgestellten Ansatzes begrenzt. Selbst bei einer Anpassung der Position und Höhe der Wegpunkte für alle Umlenkungsarten und Zwischenpunkte müsste entweder auf die Verbindung zwischen sich kreuzender Streben oder auf die Kollisionsfreiheit verzichtet werden, was in beiden Fällen negative Auswirkungen auf die strukturelle Integrität hätte. In Abstimmung mit dem Team des @CBT erscheint daher künftig sowohl eine softwareseitige Anpassung der Wegpunktberechnung als auch eine ingenieurstechnische Anpassung des Werkzeugs zur Garnablage als erforderlich. So könnte ein erster Schritt die Einführung eines neuen Moduls zur Bewertungsfunktion der Routen hinzugefügt werden, durch das Kanten als negativ bewertet, die unmittelbar neben @UE:pl verlaufen. Je nach dem, wie das Werkzeug angepasst wird, könnte aber auch eine völlig neue Methode zur Kollisionsvermeidung mit Garnstreben nötig sein.

Die Vermeidung von Kollisionen mit den @UE:pl funktioniert hingegen zuverlässig, sodass für realistische Wandgrößen keine Kollisionen zu erwarten sind. Die Kombination der vollständigen Umlenkungen mit dem Ansatz von #citep(<morris-hillBuildingStringArt2023>) erreicht hohe Sicherheit durch klare Terminationsbedingungen und Fehlererkennung. Dadurch ist sichergestellt, dass ausgegebene Pfade nicht zu einem Schaden am Werkzeug oder Roboterarm führen können.

Neben der zuverlässigen Kollisionsvermeidung mit @UE liegt ein weiterer Vorteil des vorgestellten Verfahrens in seiner modularen Struktur. Durch die klare Trennung unterschiedlicher Umlenkungstypen, wie beispielsweise Sonderumlenkungen oder vollständige Umlenkungen, ist der Algorithmus anpassbar, erweiterbar und wartungsfreundlich. Sollten zukünftig neue Arten von Umlenkungen eingefügt werden, kann das Vorgehen dementsprechend um zusätzliche Umlenkungstypen erweitert werden, was die Unterstützung für Wände mit Fensterausschnitt zukünftig erleichtern sollte. 

Abschließend ist auch die Laufzeit des Verfahrens hervorzuheben, die mit wenigen Millisekunden für den praktischen Einsatz im @CBT sehr gut geeignet ist. Dadurch wird nicht nur eine Integration in industrielle, vollautomatisierte Produktion ermöglicht, sondern auch der Einsatz in interaktiven Anwendungen mit Visualisierungen. Die Anzahl der @UE:pl:long hat dabei nur einen geringfügigen Einfluss auf die Laufzeit, da durch die Unabhängigkeit zur genauen Art früherer oder nachfolgender Umlenkungen die Berechnung der Wegpunkte aller @UE parallel erfolgen kann.

// 5. Fazit
Zusammenfassend konnte ein innovativer und robuster Ansatz entwickelt werden, der auf Grundlage der zuvor gezeigten Routenplanung in der Lage ist, zuverlässig gleichmäßige Gitterstrukturen zu erzeugen. Einschränkungen zeigen sich jedoch insbesondere in den Kollisionen zwischen dem Werkzeug zur Garnablage und den bereits verlegten Garnstreben. Ebenfalls treten in Verbindung mit suboptimalen Routen Limitationen auf, welche die korrekte Bestimmung der Umlaufrichtungen erschweren könnten.

Vor diesem Hintergrund kann die Forschungsfrage (III) mit dem vorliegenden Ansatz nur eingeschränkt beantwortet werden. Zwar liefert das Verfahren in weiten Teilen valide Ergebnisse, jedoch ist aufgrund der Kollisionen und ungesicherten Bestimmung der Umlaufrichtung keine gleichmäßige und strukturell konsistente Gitterstruktur garantiert. Zur Ausbesserung dieser Limitationen sind daher zukünftig weitere Untersuchungen notwendig.