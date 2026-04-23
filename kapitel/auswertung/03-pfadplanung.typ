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

*Pfadberechnung*

// 1. Ziel und Kontext
Zur Beantwortung der Forschungsfrage (III) "_#forschungsfragen.at(2)_" wurde ein Algorithmus zur Planung eines Pfades entwickelt und implementiert. Dieser generiert Wegpunkte auf Basis der zuvor erstellten Route zwischen den Umlenkelementen. Die Beantwortung der Forschungsfrage ist essentiell für das Hauptproblem, da ohne eine gute Pfadplanung kein Carbongitter vollautomatisiert erstellt werden kann, welches die strukturellen Anforderungen erfüllt.

\

// 2. Bewertung
Zur Bestimmung der Umlaufrichtung erweist sich der vektorbasierte Ansatz nach #citep(<merschAutomation3DRobotic2025>) gegenüber dem Verfahren mittels Graphfärbung als geeigneter. Im Allgemeinen produziert dieser robustere Ergebnisse und ist bei gewöhnlichen Umlenkungen in Nebenrichtung zuverlässig korrekt. Einschränkungen treten jedoch auf, wenn die Route von den zugrunde gelegten Annahmen abweicht oder ein Wechsel der Hauptrichtung an einem @UE erfolgt. In diesen Fällen kann die berechnete Umlaufrichtung falsch sein, wobei zumindest die Haftung des Garns am jeweiligen @UE weiterhin gewährleistet bleibt. Da diese Ausnahmen allerdings nur in den Ecken der Wand vorkommen, ist dieser Ansatz in Absprache mit dem Team des @CBT ausreichend. Im Zuge weiterer Forschung könnte zur Verbesserung ein Ansatz untersucht werden, welcher die Umlaufrichtung anhand der resultierenden Strebe festlegt und dabei insbesondere starken Bezug auf die Achsenparallelität nimmt, da dies die eigentliche ausschlaggebende Eigenschaft einer korrekten Strebe ist.

Aufbauend darauf zeigt sich, dass auch die isolierte Betrachtung einzelner @UE:pl:long zur Bestimmung der zugehörigen Wegpunkte hinreichend ist, um einen gültigen Pfad zu erzeugen. Die möglichen Positionen entsprechen dabei denen, wie sie vom derzeitigen Algorithmus im @CBT generiert werden. Allerdings werden bei dem gezeigten Verfahren zusätzlich die Position des Umlenkelements in der Route sowie in der Wand berücksichtigt, um die Art der Umlenkung und damit Position der Wegpunkte zu bestimmen. Diese differenziertere Betrachtung ermöglicht eine präzisere Kontrolle der Garnspannung und verstärkt somit die strukturellen Eigenschaften des Carbongitters, da beispielsweise mehr kreuzende Streben in Kontakt kommen und somit bei der Temperierung des Harzes im Ofen verbunden werden.

Besonders bei der Kollisionsvermeidung mit bereits verlegtem Garn spielt dieser Vorteil bezüglich der Garnspannung eine wichtige Rolle. In den durchgeführten Tests konnten nicht nur alle Kollisionen durch die Approximation der Streben aus dem Pfad vermieden werden, sondern auch der nötige vertikale Anstieg nahe der @UE verkleinert werden. Da das Garn in Folge dessen nicht so weit auf dem @UE nach oben rutscht, können mehr Verbindungen an kreuzenden Garnstreben erzeugt werden. Jedoch basiert dieses Vorgehen nicht auf einem physikalisch exakten Modell. Entsprechend kann die Genauigkeit dieser Näherung in bestimmten Situationen begrenzt sein. Insbesondere bei vollständigen Umlenkungen an den Ecken der Wand kann es zu Problemen kommen, da dort die Garnstreben näher am Rand liegen können, als es die Approximation vermuten lässt und dadurch der Anstieg gegebenenfalls zu niedrig oder zu hoch eingeschätzt wird. 

Die Vermeidung von Kollisionen mit den @UE:pl funktioniert hingegen zuverlässig, sodass für realistische Wandgrößen keine Kollisionen zu erwarten sind. Mehr Sicherheit könnte durch die Kombination mit dem Ansatz von #citep(<morris-hillBuildingStringArt2023>) erreicht werden. Eine nähere Betrachtung des Zusammenwirkens der drei Strategien zur Kollisionsvermeidung muss dann näher betrachtet und genaue Implementationen abgestimmt werden. 

Ein weiterer Vorteil des vorgestellten Verfahrens liegt in seiner modularen Struktur. Durch die klare Trennung unterschiedlicher Umlenkungstypen, wie beispielsweise Sonderumlenkungen oder vollständige Umlenkungen, ist der Algorithmus anpassbar, erweiterbar und wartungsfreundlich. Sollten zukünftig neue Arten von Umlenkungen eingefügt werden, kann das Vorgehen dementsprechend um zusätzliche Umlenkungstypen erweitert werden, was die Unterstützung für Wände mit Fensterausschnitt zukünftig erleichtern sollte. 

Abschließend ist auch die Laufzeit des Verfahrens hervorzuheben, die mit wenigen Millisekunden für den praktischen Einsatz im @CBT sehr gut geeignet ist. Dadurch wird nicht nur eine Integration in industrielle, vollautomatisierte Produktion ermöglicht, sondern auch der Einsatz in interaktiven Anwendungen mit Visualisierungen. Die Anzahl der @UE:pl:long hat dabei nur einen geringfügigen Einfluss auf die Laufzeit, da durch die Unabhängigkeit zur genauen Art früherer oder nachfolgender Umlenkungen die Berechnung der Wegpunkte aller @UE parallel erfolgen kann.  

// 5. Fazit
Zusammenfassend konnte ein innovativer und robuster Ansatz entwickelt werden, der auf Grundlage der zuvor gezeigten Routenplanung in der Lage ist, zuverlässig größtenteils gleichmäßige Gitterstrukturen zu erzeugen. Einschränkungen zeigen sich jedoch insbesondere in Ecken der Wand, in denen ein Wechsel der Hauptrichtung auftritt. In diesen Fällen weist die vektorbasierte Bestimmung der Umlaufrichtung Schwächen auf, sodass hier weiterführende Untersuchungen erforderlich sind. Auch die implementierte Kollisionsvermeidung erweist sich insgesamt als zweckmäßig und verhindert Kollisionen mit @UE:pl zuverlässig, zeigt jedoch ebenfalls Einschränkungen in den Eckbereichen.

Vor diesem Hintergrund kann die Forschungsfrage (III) mit dem vorliegenden Ansatz nur eingeschränkt beantwortet werden. Zwar liefert das Verfahren in weiten Teilen valide Ergebnisse, jedoch ist weder eine vollständig kollisionsfreie Pfadgenerierung noch eine gleichmäßige und strukturell konsistente Gitterstruktur garantiert. Zur Ausbesserung dieser Limitationen sind daher weitere Untersuchungen notwendig.