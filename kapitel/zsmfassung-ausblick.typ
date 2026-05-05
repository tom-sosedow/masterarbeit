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

Die Kombination der drei implementierten Teillösungen erweist sich als äußerst effizient für die vollautomatisierte Herstellung gleichmäßiger Textilbewehrungen. Dabei wird minimale Materialverschwendung erreicht und es sind keine manuellen Eingriffe zwischen Start- und Endknoten erforderlich. Bei der Pfadplanung mangelt es an Robustheit, da Kollisionen zwischen Garnablagewerkzeug und zuvor verlegten Garnstreben nicht zuverlässig vermeiden werden können.


= Ausblick
/**
 * Was steht noch an? Wo sind die größten/wichtigsten Lücken
 */

#question[Nur weiterführende mögliche wiss. Arbeiten oder alle Lücken meines Ansatzes?]

- Anwendung von @GA tiefergehend erforschen nach @tsaiHighPerformanceGeneticAlgorithm2014 
- wände ohne türausschnitt und mit fenster und mit mehreren ausschnitten mit puzzleteilen
- garnapproximation oder physikalisches modell
- für neues garnablagewerkzeug passende umlenkpunkte

#question[Formatierung alles ok? Überschriften, Textgröße, Zeilenabstand, Bilder/Tabellenverzeichnis, usw?]

#question[Wie läuft die Abgabe der Arbeit ab? Wann PDF schicken? Gedrucktes Format? Wie lange ung. bis Kolloquium?]

#question[Typst den Studis empfehlen. Typst >> Latex. Ich kann meine Vorlage öffentlich zur Verfügung stellen und ggf. Anpassungen machen.]