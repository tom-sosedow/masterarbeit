#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "@preview/cetz:0.4.2"

== Stand der Forschung
Zur Lösung von Problemen in großen Lösungsräumen kommen spezialisierte Suchalgorithmen zum Einsatz. Insbesondere bei kombinatorischen Optimierungsproblemen, wie beispielsweise der Routenplanung, lassen sich diese Verfahren grob in zwei Kategorien einteilen. Einerseits existieren exakte Methoden, die stets die optimale Lösung eines Problems bestimmen. Andererseits stehen heuristische beziehungsweise approximative Ansätze zur Verfügung, die sich einem Optimum lediglich annähern #cite(<martiExactHeuristicMethods2022>, supplement: [S. 27]). Beide Ansätze wurden aufgrund ihrer vielfältigen Einsatzmöglichkeiten in Wissenschaft, Forschung und Wirtschaft intensiv untersucht.

=== Exakte Methoden

Exakte Methoden bezeichnen im Kontext von Optimierungsproblemen solche Ansätze, die für jede gegebene Problemkonfiguration garantiert eine global optimale Lösung liefern. Zu bekannten Vertretern zählen Integer Programming, dynamische Programmierung, Branch-and-Bound, Backtracking sowie Brute-Force-Verfahren.

Letzteres stellt den einfachsten und zugleich intuitivsten Ansatz dar: Sämtliche möglichen Lösungen werden vollständig enumeriert und anschließend einzeln überprüft. Für kleinere Problemgrößen kann dieses Vorgehen, insbesondere durch geeignete Optimierungen, durchaus effizient sein @oneilExactMethodsSolving. Mit zunehmender Problemgröße sinkt die Leistungsfähigkeit jedoch erheblich, auch wenn das Auffinden akzeptabler Lösungen weiterhin möglich bleibt @oneilExactMethodsSolving. Die Laufzeitkomplexität beträgt $O(n!)$ und gehört damit zu den ungünstigsten Klassen für größere Problemstellungen.

Durch weiterführende Optimierungen lassen sich beispielsweise mittels Backtracking deutlich effizientere Ergebnisse erzielen. Der erstmals 1950 von D. H. Lehmer benannte Algorithmus verfolgt einen gezielteren Ansatz, bei dem nicht alle möglichen Lösungen vollständig betrachtet werden @bitnerBacktrackProgrammingTechniques1975. Stattdessen erfolgt der Aufbau von Lösungen schrittweise entlang eines Entscheidungsbaums. Auf jeder Ebene wird eine partielle Lösung rekursiv erweitert. Sobald dabei ein ungültiges Teilergebnis entsteht, etwa durch die Verletzung von Nebenbedingungen, werden sämtliche nachfolgenden Entscheidungen in diesem Zweig verworfen. Dieser Prozess wird als Pruning bezeichnet @bitnerBacktrackProgrammingTechniques1975. Der Begriff Backtracking beschreibt dabei das systematische Zurückkehren zu vorherigen Entscheidungspunkten: Sobald ein Blatt oder alle Kindknoten eines Knotens untersucht wurden, wird zum übergeordneten Knoten zurückgekehrt, um verbleibende Alternativen zu analysieren.

#question[
  Ist branch and bound eine Heuristik oder eine exakte Methode? Es gibt für beide Seiten Quellen in der Literatur. Meiner Meinung nach ist es eine exakte Methode, weil es immer die optimale Lösung findet und keine Zufallskomponente beinhaltet.
]

#maybe[ Branch And Bound Verfahren erklären?
    - mögliche weitere optimierungen durch branch and bound verfahren, bei dem auch zweige abgeschnitten werden, deren untergrenze der kosten höher ist als ein bereits gefundenes minimum
    - #todo[ weitere erklärungen] und bild einfügen?
    - das kann viel rechenzeit sparen und anderweitig praktisch nicht lösbare probleme doch lösbar machen
      - worst case dennoch $O(n!)$, falls keine zweige für pruning gefunden und dadurch dennoch alle lösungen betrachtet werden
 
  //- aber: für einige probleme gibt es, obwohl sie NP schwer sind, sehr gute exakte methoden die selbst bei großen probleminstanzen schnell eine optimale lösung finden @tahamiLiteratureReviewCombining2022
]

Insgesamt weisen exakte Algorithmen insbesondere Schwierigkeiten im Umgang mit problemspezifischen Einschränkungen sowie einen hohen Rechenaufwand auf @harderExactAlgorithmHeuristic2023. Sie sind daher für zeitkritische Anwendungen, bei denen Ergebnisse kurzfristig oder in (nahezu) Echtzeit benötigt werden, oftmals ungeeignet. Aufgrund ihrer Garantie auf Optimalität finden sie jedoch insbesondere in solchen Szenarien Anwendung, in denen die Qualität der Lösung wichtiger ist als die benötigte Rechenzeit.
 

=== Heuristische Methoden

Heuristiken sind Strategien, die problemspezifische Informationen nutzen, um gezielt vielversprechende Lösungskandidaten zu identifizieren @fulber-garciaHeuristicsVsMetaHeuristics2022. Anstatt den gesamten Lösungsraum vollständig zu durchsuchen, verfolgen sie das Ziel, sich effizient einem, gegebenenfalls lokalen, Optimum anzunähern und somit in kurzer Zeit eine Lösung zu liefern, die unter Umständen bereits ausreichend gut ist #cite(<martiExactHeuristicMethods2022>, supplement: [S. 27]). Dies wird insbesondere dadurch erreicht, dass wenig aussichtsreiche Kandidaten frühzeitig verworfen und nicht weiter betrachtet werden @harderExactAlgorithmHeuristic2023. Zu den bekannten heuristischen Verfahren zählen beispielsweise Greedy-Ansätze sowie Verfahren der lokalen Suche. Sie erweisen sich insbesondere bei großen Problemstellungen mit zahlreichen Nebenbedingungen, Eingabeparametern oder komplexen Bewertungsfunktionen sowie bei nichtlinearen Problemen als geeignet, bei denen exakte Methoden an ihre Grenzen stoßen @ahmedshabanMetaheuristicAlgorithmsEngineering2025.

Metaheuristiken stellen eine übergeordnete Klasse von Heuristiken dar, die darauf abzielen, untergeordnete heuristische Verfahren für Optimierungsprobleme zu entwickeln oder zu steuern @blumMetaheuristicsCombinatorialOptimization2003. Im Gegensatz zu klassischen Heuristiken sind sie in der Regel problemunabhängig, da sie nur geringe spezifische Informationen über das zugrunde liegende Problem benötigen. Dadurch lassen sie sich auf eine Vielzahl unterschiedlicher Problemklassen anwenden. Zu den bekannten Metaheuristiken zählen unter anderem Ameisenkolonie-Algorithmen, Social-Spider-Optimierung sowie evolutionäre Algorithmen @ahmedshabanMetaheuristicAlgorithmsEngineering2025.

Für den vorliegenden Anwendungsfall sind diese approximativen Verfahren aufgrund der fehlenden Optimalitätsgarantie grundsätzlich ungeeignet. Angesichts der Größe des @TSP:pl mit bis zu 81 Knoten können sie jedoch unter Umständen erforderlich sein. Durch eine geeignete Bewertungsfunktion lassen sich potenziell unzureichende Lösungen identifizieren, sodass im Bedarfsfall eine erneute Berechnung initiiert werden kann. Alternativ könnte in solchen Fällen auch eine entsprechende Warnung an den Auftraggeber ausgegeben werden.

Der derzeit leistungsfähigste Lösungsansatz für das @TSP ist die Lin-Kernighan-Heuristik, welche das Problem mit einer Laufzeitkomplexität von $O(n^2)$ lösen kann @goyalSurveyTravellingSalesman @regoTravelingSalesmanProblem2011a. Die praktische Implementierung dieses Verfahrens ist jedoch äußerst komplex, weshalb es sich nicht für den Einsatz im @CBT eignet @goyalSurveyTravellingSalesman.

Eine häufig eingesetzte Metaheuristik zur Lösung des @TSP:pl sind @GA:pl. Diese sind von biologischen Prozessen wie Fortpflanzung und Evolution inspiriert und zeichnen sich durch eine vergleichsweise einfache Verständlichkeit und Implementierbarkeit aus, insbesondere für Nicht-Informatiker. Aufbauend auf Konzepten der lokalen Suche werden Prinzipien der Evolutionsbiologie genutzt, um eine Population von Lösungskandidaten iterativ zu verändern und so eine Annäherung an ein globales Optimum zu erreichen @tahamiLiteratureReviewCombining2022 @duanApplicationsHybridApproach2023a. Die Laufzeitkomplexität ist dabei nicht eindeutig bestimmbar, da sie maßgeblich von der Wahl der Parameter sowie der konkreten Implementierung abhängt @vyasExploringSolutionApproaches.

#todo[Fact Check: Wann kommt die Turnierselektion? Wichtig für Abschnitt "Punktbasiert > heuristische Methoden"]
Nach #citep(<weickerEvolutionaereAlgorithmen2015>, supplement: [S. 39]) verlaufen @GA:pl wie folgt: Zunächst erfolgt eine Kodierung der Lösungskandidaten, um diese in eine für die algorithmische Verarbeitung geeignete Darstellungsform zu überführen, beispielsweise in Form von Binärkodierungen oder Permutationen. Die weiteren Schritte basieren auf dieser Repräsentation. Zu Beginn werden $mu$ potenzielle Lösungen erzeugt, etwa durch zufällige Generierung, die die initiale Population bilden. Anschließend erfolgt die Bewertung jedes Individuums. Daraufhin wird iterativ eine Schleife durchlaufen, bis eine definierte Terminierungsbedingung erfüllt ist. Innerhalb dieser Schleife werden verschiedene biologisch inspirierte Operatoren angewendet: Zunächst werden aus der aktuellen Population, in der Regel durch einen Selektionsoperator, geeignete Individuen als Eltern ausgewählt. Diese werden anschließend durch den Rekombinationsoperator paarweise kombiniert, um Nachkommen zu erzeugen. Die resultierenden Individuen werden daraufhin durch den Mutationsoperator modifiziert und erneut bewertet. Abschließend erfolgt eine Selektion aus der aktuellen Population sowie den neu erzeugten Nachkommen, bei der wiederum $mu$ Individuen für die nächste Generation bestimmt werden.

Die Hoffnung ist, dass die aktuelle Generation im Mittel immer besser wird und somit auch der beste Lösungskandidat nah ans globale Optimum herankommt. Die Operatoren dienen der Diversifizierung, sodass ein Festhängen in lokalen Optima vermieden wird. 

Durch Zufallskomponenten in den Operatoren, wie beispielsweise Wahrscheinlichkeit der Mutation oder Rekombination, sind @GA:pl in der Regel nicht deterministisch. Wird der Seed des Zufallsgenerators jedoch bei jedem Durchlauf festgelegt, werden jedes Mal dieselben Lösungen produziert. Auf die Garantie der Optimalität hat dies keinen Einfluss #cite(<weickerEvolutionaereAlgorithmen2015>, supplement: [S.68]). 

Ein in lokalen Suchen und durch die Rekombinationsoperatoren auch in genetischen Algorithmen häufig auftretendes Problem sind Schwierigkeiten bei der Lösungsfindung bei Problemen mit vielen Randbedingungen, in denen valide Stellen im Lösungsraum weit entfernt oder getrennt voneinander liegen @tahamiLiteratureReviewCombining2022. So kommt es dazu, dass durch die Rekombination von zwei Elternelementen gute Teilrouten nicht in die Nachkommen übertragen werden und dadurch sehr viel schlechtere Lösungen entstehen, die am Ende der nächsten Generation wieder aus dem Suchbereich verschwinden und damit auch ggf. die in den Eltern vorkommenden guten Teilrouten. Daher werden für @TSP:pl mit einer Kodierung als Permutation häufig speziell angepasste Rekombinationsoperatoren eingesetzt, um die Erhaltung guter Teilrouten zu fördern und gleichzeitig die Entstehung invalider Nachkommen zu vermeiden @larranagaGeneticAlgorithmsTravelling1999. Alternativ besteht die Möglichkeit, konventionelle Operatoren zu verwenden und die daraus hervorgehenden Nachkommen im Anschluss zu reparieren, sofern beispielsweise Knoten mehrfach auftreten oder fehlen.

#maybe[
  - Selektionsdruck erklären? 
  - Operatoren und deren Zweck näher erklären?
  - Parameter für jeden Operator?
]

#maybe[
- hybride ansätze
  - kombinieren klassiche exakte algorithmen mit heuristiken, um die optimalität zu gewährleisten und dabei den rechenaufwand zu minimieren
    @duanApplicationsHybridApproach2023a, @tahamiLiteratureReviewCombining2022
  - mit unterstützenden heuristiken kann der suchraum verkleinert werden, sodass (möglichst) nur vielversprechende lösungskandidaten betrachtet werden
    @duanApplicationsHybridApproach2023a, @tahamiLiteratureReviewCombining2022
  - bsp: greedy, depth-first-search, binäre suche, backtracking
  - 2 arten der kombination @agarwalExactAlgorithmsCombinatorial2013:
    - kollaborativ: tauschen informationen aus, aber sind nicht teil von einander. ausführung sequenziell oder parallel
    - integriert: eine methode ist der hauptalgorithmus, die andere ein werkzeug welches während der ausführung für eine teilaufgabe ausgeführt/genutzt wird
]

#todo[Abschließender Absatz für approx. Alg.]