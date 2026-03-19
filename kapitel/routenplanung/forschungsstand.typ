#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "@preview/cetz:0.4.2"

== Stand der Forschung
Zur Lösung von Problemen in großen Lösungsräumen kommen spezialisierte Suchalgorithmen zum Einsatz. Insbesondere bei kombinatorischen Optimierungsproblemen, wie beispielsweise der Routenplanung, lassen sich diese Verfahren grob in zwei Kategorien einteilen. Einerseits existieren exakte Methoden, die stets die optimale Lösung eines Problems bestimmen. Andererseits stehen heuristische beziehungsweise approximative Ansätze zur Verfügung, die sich einem Optimum lediglich annähern #cite(<martiExactHeuristicMethods2022>, supplement: [S. 27]). Beide Ansätze wurden aufgrund ihrer vielfältigen Einsatzmöglichkeiten in Wissenschaft, Forschung und Wirtschaft intensiv untersucht.

=== Exakte Methoden

Exakte Methoden bezeichnen im Kontext von Optimierungsproblemen solche Ansätze, die für jede gegebene Problemkonfiguration garantiert eine global optimale Lösung liefern. Zu bekannten Vertretern zählen Integer Programming, dynamische Programmierung, Branch-and-Bound, Backtracking sowie Brute-Force-Verfahren.

Letzteres stellt den einfachsten und zugleich intuitivsten Ansatz dar: Sämtliche möglichen Lösungen werden vollständig enumeriert und anschließend einzeln überprüft. Für kleinere Problemgrößen kann dieses Vorgehen, insbesondere durch geeignete Optimierungen, durchaus effizient sein @oneilExactMethodsSolving. Mit zunehmender Problemgröße sinkt die Leistungsfähigkeit jedoch erheblich, auch wenn das Auffinden akzeptabler Lösungen weiterhin möglich bleibt @oneilExactMethodsSolving. Die Laufzeitkomplexität beträgt $O(n!)$ und gehört damit zu den ungünstigsten Klassen für größere Problemstellungen.

Durch weiterführende Optimierungen lassen sich beispielsweise mittels Backtracking deutlich effizientere Ergebnisse erzielen. Der erstmals 1950 von D. H. Lehmer benannte Algorithmus verfolgt einen gezielteren Ansatz, bei dem nicht alle möglichen Lösungen vollständig betrachtet werden @bitnerBacktrackProgrammingTechniques1975. Stattdessen erfolgt der Aufbau von Lösungen schrittweise entlang eines Entscheidungsbaums. Auf jeder Ebene wird eine partielle Lösung rekursiv erweitert. Sobald dabei ein ungültiges Teilergebnis entsteht, etwa durch die Verletzung von Nebenbedingungen, werden sämtliche nachfolgenden Entscheidungen in diesem Zweig verworfen. Dieser Prozess wird als Pruning bezeichnet @bitnerBacktrackProgrammingTechniques1975. Der Begriff Backtracking beschreibt dabei das systematische Zurückkehren zu vorherigen Entscheidungspunkten: Sobald ein Blatt oder alle Kindknoten eines Knotens untersucht wurden, wird zum übergeordneten Knoten zurückgekehrt, um verbleibende Alternativen zu analysieren.


#maybe[ Branch And Bound Verfahren erklären?
    - mögliche weitere optimierungen durch branch and bound verfahren, bei dem auch zweige abgeschnitten werden, deren untergrenze der kosten höher ist als ein bereits gefundenes minimum
    - #todo[ weitere erklärungen] und bild einfügen?
    - das kann viel rechenzeit sparen und anderweitig praktisch nicht lösbare probleme doch lösbar machen
      - worst case dennoch $O(n!)$, falls keine zweige für pruning gefunden und dadurch dennoch alle lösungen betrachtet werden
 
  //- aber: für einige probleme gibt es, obwohl sie NP schwer sind, sehr gute exakte methoden die selbst bei großen probleminstanzen schnell eine optimale lösung finden @tahamiLiteratureReviewCombining2022
]

Insgesamt weisen exakte Algorithmen insbesondere Schwierigkeiten im Umgang mit problemspezifischen Einschränkungen sowie einem hohen Rechenaufwand auf @harderExactAlgorithmHeuristic2023. Sie sind daher für zeitkritische Anwendungen, bei denen Ergebnisse kurzfristig oder in (nahezu) Echtzeit benötigt werden, oftmals ungeeignet. Aufgrund ihrer Garantie auf Optimalität finden sie jedoch insbesondere in solchen Szenarien Anwendung, in denen die Qualität der Lösung wichtiger ist als die benötigte Rechenzeit.
 

=== Heuristische Methoden

Heuristiken sind Strategien, welche problemspezifische Informationen nutzen um vielversprechende Lösungskandidaten zu finden @fulber-garciaHeuristicsVsMetaHeuristics2022. Statt den Lösungsraum vollständig zu durchsuchen wird versucht sich schnell einem, gegebenenfalls lokalen, Optimum anzunähern und somit schnell eine Lösung zu produzieren, die unter Umständen schon gut genug ist #cite(<martiExactHeuristicMethods2022>, supplement: [S. 27]). Das wird erreicht, indem schlecht aussehende Lösungskandidaten frühzeitig weggeschnitten werden und somit nicht weiter in der Betrachtung vorkommen @harderExactAlgorithmHeuristic2023. Bekannte Heuristiken sind z.B. Greedy Ansätze oder die lokale Suche. Sie eignen sich oftmals bei großen Problemen mit vielen Einschränkungen, Rahmenbedingungen, Eingabeparametern oder komplexer Lösungsbewertung sowie nicht-linearen Problemen, bei denen exakte Methoden versagen @ahmedshabanMetaheuristicAlgorithmsEngineering2025.

Metaheuristiken sind höher geordnete Heuristiken welche eingesetzt werden, um untergeordnete Heuristiken für Optimierungsprobleme zu finden oder designen @blumMetaheuristicsCombinatorialOptimization2003. Sie sind generell poblemunspezifisch, da sie wenig Informationen über das zu lösende Problem besitzen. Somit können sie zur Lösung einer Vielzahl von Problemkategorien eingesetzt werden. Bekannte Metaheuristiken sind z.B. Ameisenkolonie-Algorithmen, Social-Spider Optimierungen oder evolutionäre Algorithmen @ahmedshabanMetaheuristicAlgorithmsEngineering2025.

Für den vorliegenden Anwendungsfall sind diese approximativen Ansätze ohne eine Garantie auf Optimalität zwar ungeeignet, bedingt durch die Größe des @TSP:pl mit bis zu 81 Knoten aber eventuell notwendig. Durch die anzusetzende Bewertungsfunktion können ggf. unzureichende Lösungen erkannt und die Berechnung im Zweifel neugestartet werden. Auch eine Warnung an den Auftraggeber könnte in diesem Fall eingesetzt werden.

Der bisher beste Lösungsansatz für das @TSP ist die Lin-Kernighan Heuristik, welche das Porblem mit einer Laufzeitkomplexität von $O(n^2)$ lösen kann @goyalSurveyTravellingSalesman @regoTravelingSalesmanProblem2011a. Die Implementierung davon ist allerdings sehr komplex, sodass sie sich nicht für den Einsatz im @CBT eignet @goyalSurveyTravellingSalesman. 

Eine oftmals eingesetzte Metaheuristik zum Lösen von @TSP:pl sind @GA:pl. @GA:pl sind inspiriert von biologischer Fortpflanzung und Evolution. Sie sind einfacher für Nicht-Informatiker zu verstehen und zu implementieren. Basierend auf lokaler Suche werden Konzepte aus der Evolutionsbiologie genutzt um iterativ eine Population von Lösungskandidaten zu manipulieren und sich somit schnell einem globalen Optimum anzunähern @tahamiLiteratureReviewCombining2022 @duanApplicationsHybridApproach2023a. Die Laufzeitkomplexität lässt sich nicht einfach bestimmen, da sie stark von der Wahl der Parameter und der Implementation abhängt @vyasExploringSolutionApproaches.

Nach #citep(<weickerEvolutionaereAlgorithmen2015>, supplement: [S. 39]) verlaufen @GA:pl in folgender Weise. Initial werden potenzielle Lösungen zufallsgeneriert. Diese bilden die anfängliche Population. Eine Kodierung der Lösungskandidaten wird vorgenommen, um sie in eine für die Verarbeitung nützliche Darstellungsform zu bringen, z. B. als Binärkodierung oder Permutationen. Anschließend wird jedes Individuum bewertet 

  - ablauf nach @weickerEvolutionaereAlgorithmen2015 S. 39 (Algorithmus 2.6) 
    - initial werden potentielle lösungen zufallsgeneriert
      - bilden population
      - kodierung durch nützliche darstellung, oft binäre repräsentationen oder permutationen
    - population wird bewertet und durch einen selektionsprozess die besten kandidaten anhand der bewertung, durch bewertungsfunktion berechnet, ausgewählt
    - diese pflanzen sich fort, was durch crossover und mutationsoperatoren simuliert wird
      - crossover: zwei elternteile werden durch eine funktion miteinander rekombiniert und ergeben ein oder mehrere kindelemente
      - mutation: nach dem crossover werden die entstandenen kindelemente modifiziert
      - beide operatoren werden nur zu einer gewissen chance angewandt
      - nach den operatoren kann eine reparatur der entstandenen genotypen nötig sein, falls die operatoren illegale kodierungen erzeugt haben
    - aus den kindern entsteht dann die nächste generation.
    - so wird die aktuelle generation stetig im mittel besser, aber es werden auch nicht-optimale lösungen weiter getragen um zu verhindern, dass in lokalen optima fest gehangen wird
      - selektionsdruck
    - operatoren haben zufallskomponenten, die, falls kein seed gegeben ist, den prozess nicht deterministisch machen, sodass nicht immer die optimale lösung gefunden werden kann #cite(<weickerEvolutionaereAlgorithmen2015>, supplement: [S.68])
      - mit seed wird zwar immer dieselbe lösung gefunden, aber trotzdem nicht immer eine optimale
  - hybride ansätze
    - kombinieren klassiche exakte algorithmen mit heuristiken, um die optimalität zu gewährleisten und dabei den rechenaufwand zu minimieren
      @duanApplicationsHybridApproach2023a, @tahamiLiteratureReviewCombining2022
    - mit unterstützenden heuristiken kann der suchraum verkleinert werden, sodass (möglichst) nur vielversprechende lösungskandidaten betrachtet werden
     @duanApplicationsHybridApproach2023a, @tahamiLiteratureReviewCombining2022
    - bsp: greedy, depth-first-search, binäre suche, backtracking
    - 2 arten der kombination @agarwalExactAlgorithmsCombinatorial2013:
      - kollaborativ: tauschen informationen aus, aber sind nicht teil von einander. ausführung sequenziell oder parallel
      - integriert: eine methode ist der hautpalgorithmus, die andere ein werkzeug welches während der ausführung für eine teilaufgabe ausgeführt/genutzt wird