#let abstract = [

Beton ist der wichtigste Baustoff im modernen Wohnungsbau. Anstatt Stahlstreben für die Bewehrung zu nutzen, wurde in den letzten Jahren der Einsatz textiler Bewehrungen, beispielsweise aus Carbonfasern, untersucht. Die vollautomatisierte Herstellung ähnlicher Gitterstrukturen erfolgt, indem das Garn in einem Zug mithilfe eines Roboterarms um gezielt platzierte Umlenkelemente geleitet wird. Das Ziel dieser Arbeit ist es, die für die Herstellung von Carbonbewehrungen mit einem Türausschnitt notwendigen Bewegungsabläufe algorithmisch zu berechnen, wobei zusätzlich minimaler Materialaufwand gefordert ist.

Dafür ist diese Arbeit in drei Teile aufgeteilt, von denen jedes ein zentrales Teilproblem dieser Aufgabenstellung betrachtet. Zunächst werden die Positionen der Umlenkelemente berechnet. Anschließend wird eine Abfolge bestimmt, in der sie umfahren werden sollen. Abschließend wird basierend darauf eine Abfolge von Bewegungsabläufen des Roboterarms generiert, welcher insbesondere die Vermeidung von Kollisionen zur Aufgabe hat. Zu jedem dieser Teilprobleme wurde eine Literaturrecherche und anschließende Konzeption und Implementierung eines Lösungsansatzes durchgeführt. 

Nach einer Auswertung der erzielten Ergebnisse zeigt sich, dass eine iterative und regelbasierte Platzierung der Umlenkelemente zuverlässige Ergebnisse liefert. Eine auf vorgefertigten Teilrouten basierende Brute-Force Suche kann aufbauend darauf effizient optimale Abfolgen zum Abfahren der Umlenkelemente erzeugen. Mithilfe von vordefinierten Umlenkbewegungen und einer vektorbasierten Kollisionsvermeidung werden dann weitestgehend zulässige Bewegungsabläufe für den Roboterarm und dessen Werkzeug generiert.  

]
