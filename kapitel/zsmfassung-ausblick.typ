#import "/util.typ": *
#import "/forschungsfragen.typ": forschungsfragen
#import "@preview/cetz:0.4.2"

= Fazit
/** Recap, was gemacht wurde
 * Was war das Ziel
 * Was wurde gemacht, um dahin zu kommen?
 * Was wurde erreicht, was bedeuten die ergebnisse für die zukunft
 * Was können wir dennoch nicht machen?
 */

// Ziel
Ziel dieser Arbeit war es, die automatisierte Produktion von textilen Bewehrungsmatten mit einer Türaussparung für den Einsatz im Betonbau zu ermöglichen. Schwerpunkt war hierbei, dass die nötige Gitterstruktur von einem Roboter in einem Zug mithilfe von platzierten Umlenkelementen (@UE) erzeugt werden soll, indem das Garn um diese @UE:pl gespannt wird. Hinzu kommen Anforderungen an die strukturelle Integrität der Bewehrungsmatte sowie dem ressourcenschonenden Einsatz des Carbongarns mit möglichst geringer Materialverschwendung.

// Einleitung
Zur Lösung dieser Problemstellung wurden drei zentrale Teilprobleme definiert und getrennt voneinander betrachtet. 
+ Berechnung der Positionen der @UE
+ Berechnung der Reihenfolge zum Anfahren der @UE
+ Berechnung der Wegpunkte für den Roboterarm basierend auf der Reihenfolge der @UE

// UE platzierung
Zur Platzierung der @UE:pl wurde ein iterativer Ansatz entwickelt, welcher zuerst von unten nach oben die @UE:pl an den vertikalen Seiten @UE:pl platziert und anschließend von links nach rechts jene an den horizontalen Seiten verlegt. Der Algorithmus zeichnet sich durch eine sehr kurze Laufzeit aus, und die resultierenden Positionen entsprechen durchgehend den strukturellen Anforderungen. Allerdings sind sie gegebenenfalls nicht optimal, da zur Positionsberechnung keine Informationen aus den späteren Teilproblemen herangezogen werden und somit eventuell ungünstige Zusammenhänge die Planung der Route erschweren können.

// Routenplanung
Für die Planung der Route wurde das Problem als @TSP:both modelliert, welches basierend auf einer eigens erstellten Bewertungsfunktion optimiert wurde. Dafür wurden zwei Arten von Suchalgorithmen, exakte und heuristische, unter Modellierung einer Punkt-zu-Punkt Navigation und einer auf vorgefertigten Teilrouten basierenden Modellierung betrachtet. Während mit der Punkt-zu-Punkt-Modellierung keine zufriedenstellenden Ergebnisse erzielt werden konnten, erwiesen sich die Teilrouten als äußerst effiziente Darstellungsform. So konnten sich innerhalb weniger Sekunden mittels einfachem Brute-Forcing zuverlässig optimale Routen erzeugen lassen.     

// pfadplanung
Bei der Planung des Roboterpfades lagen die zentralen Herausforderungen bei der Bestimmung der Position und Abfolge der Wegpunkte sowie in der Vermeidung von Kollisionen zwischen Werkzeug, @UE und bereits verlegten Garnstreben. Für ersteres wurden vier verschiedene Arten von Umlenkungen definiert. Diese werden abhängig von der Position des zu umfahrenden @UE ausgewählt und in Relation zur Position des nachfolgenden @UE entsprechend rotiert und gespiegelt. Zur Kollisionsvermeidung wurden drei Ansätze konzipiert, wobei der gezielte Einsatz einer der Umlenkungsarten bereits den Großteil der Kollisionen mit @UE verhindern kann. Kollisionen mit bereits verlegtem Garn werden durch ein gezieltes Anheben des Werkzeugs an berechneten Schnittpunkten zwischen dem geplanten Pfad und einer Approximation des unter Spannung stehenden Garns versucht zu vermieden. Während der berechnete Pfad zumeist allen Anforderungen entspricht, können nur wenige Garnkollisionen mit diesem Ansatz verhindert werden. Entsprechend sind weiterführende Anpassungen notwendig, um einen reibungslosen Ablauf garantieren zu können. 

Die Kombination der drei implementierten Teillösungen erweist sich als äußerst effizient für die vollautomatisierte Herstellung gleichmäßiger Textilbewehrungen. Dabei wird minimale Materialverschwendung erreicht und es sind keine manuellen Eingriffe zwischen Start- und Endknoten erforderlich. 
Bei der Pfadplanung wurde zudem eine neue Herausforderung aufgedeckt, welche nicht bei Wänden ohne Aussparungen vorkommt. Ideen zur Lösung wurden aufgezeigt und getestet, allerdings besteht weiterhin Verbesserungspotential.

= Ausblick <sec:ausblick>

In dieser Arbeit wurde ein effizienter und zuverlässiger Ansatz zur Berechnung eines Roboterpfades entwickelt, um ein gleichmäßiges Gitter aus Carbonfasern zum Einsatz als Bewehrung für den Betonbau vollautomatisiert herstellen zu können. Dabei haben sich im Verlauf der Untersuchung neben wichtigen Erkenntnissen auch einige offene Fragen und mögliche Themen für weiterführende Forschung aufgetan. 

Ein möglicher Ansatz für zukünftige Arbeiten besteht in der Untersuchung einer kooperative Platzierung der @UE, welche parallel oder nachgelagert zur Routen- oder Pfadplanung abläuft. Im Rahmen dieser Arbeit wurden die einzelnen Teilprobleme unabhängig voneinander betrachtet. Durch eine gemeinsame Optimierung könnte es jedoch möglich sein, die @UE gezielt so zu positionieren, dass sich günstigere Routen und gegebenenfalls kollisionsärmere Pfade ergeben.

Darüber hinaus bietet insbesondere der Einsatz genetischer Algorithmen für die Routenplanung weiteres Forschungspotenzial. Die in dieser Arbeit implementierte Lösung zeigt bereits das Potenzial evolutionärer Verfahren, wurde jedoch nur in begrenztem Umfang optimiert. Durch den Einsatz gezielter Optimierungen und problemspezifischer Operatoren könnten sowohl die Berechnungszeiten als auch die Qualität der erzeugten Lösungen signifikant verbesser werden.

Die betrachtete Problemstellung beschränkt sich zudem auf Wände mit einer einzelnen Türaussparung. Zukünftige Forschungen könnten den entwickelten Ansatz auf weitere Konfigurationen erweitern, beispielsweise auf Wände mit Fenstern oder mit mehreren Aussparungen. Auch hierfür könnte sich der Fokus auf den Einsatz genetischer Algorithmen als vorteilhaft erweisen, da gegebenenfalls die Anzahl an vordefinierten Teilrouten mit hinzukommenden Aussparungen steigen wird.

Abschließend ergeben sich durch die geplante Weiterentwicklung des Garnablagewerkzeugs zusätzliche Anforderungen an die Pfadplanung. Eine präziseres Modell des Garns unter Spannung könnte dabei helfen, kritische Stellen entlang des Werkzeugpfades zu identifizieren und besser vermeiden zu können. Nach der ingenieurstechnischen Anpassung des Werkzeuges wird dann ebenfalls eine Modifikation der Pfadgenerierung nötig, sodass hier weitere Untersuchungen zur Kollisionsvermeidung anzusetzen sind.
