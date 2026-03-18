#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "@preview/cetz:0.4.2"

== Stand der Forschung
Um Lösungen in einem großen Lösungsraum zu finden werden spezielle Suchalgorithmen eingesetzt. Für kombinatorische Optimierungsprobleme wie der Routenplanung werden diese grob in zwei Kategorien eingeordnet. Einerseits gibt es exakte Methoden, welche immer die optimale Lösung des Problems finden. Andererseits gibt es heuristische oder auch approximative Ansätze, die sich lediglich nur an ein Optimum annähern #cite(<martiExactHeuristicMethods2022>, supplement: [S. 27]). Beide Arten wurden aufgrund ihrer breiten Anwendungsfelder in Wissenschaft, Forschung und Wirtschaft intensiv erforscht.

=== Exakte Methoden

Exakte Methoden bezeichnen im Kontext von Optimierungsproblemen Ansätze, welche für jede Problemkonfiguration immer das globale Optimum des 

  - liefern immer die optimale lösung eines optimierungsproblems @martiExactHeuristicMethods2022 S.27, @tahamiLiteratureReviewCombining2022
  - z.B. integer programming, dynamische programmierung, branch-and-bound, backtracking oder schlichtes brute forcing
  - letzteres (brute force) bzw lösung durch aufzählung ist der simpelste ansatz
    - es werden alle lösungsmöglichkeiten aufgezählt und einzeln getestet
    - mit einigen optimierungen kann es für kleinere probleme sehr effektiv sein @oneilExactMethodsSolving
    - mit steigender problemgröße nimmt die leistungsfähigkeit stark ab, wobei einfach nur gute lösungen finden trotzdem im rahmen des möglichen bleibt @oneilExactMethodsSolving
    - Laufzeitkomplexität ist $O(n!)$
  - mit etwas mehr optimierungen können z.B. durch backtracking bessere ergebnisse erzielt werden
    - von D.H. lehmer 1950 benannter algorithmus @bitnerBacktrackProgrammingTechniques1975
    - anstatt alle möglichen lösungen aufzuzählen und auszuwerten werden wird ein fokussierterer ansatz verfolgt
    - in einem entscheidungsbaum werden explorativ lösungen schrittweise in jeder ebene aufgebaut @bitnerBacktrackProgrammingTechniques1975
    - sobald ein invalides teilergebnis erzeugt wird, zb durch nichteinhaltung von rahmenbedingungen, werden alle folgenden entscheidungen in diesem zweig nicht weiter betrachtet und dieser vollkommen abgeschnitten, genannt pruning
    - wurde die letzte entscheidung getroffen, man ist also an einem blatt, und die lösung wurde bewertet, wird zum elternknoten eine ebene höher gesprungen und die restlichen entscheidungen betrachtet, meistens von links nach rechts
    - wieder hoch springen, sobald alle möglichen entscheidungen betrachtet
    - mögliche weitere optimierungen durch branch and bound verfahren, bei dem auch zweige abgeschnitten werden, deren untergrenze der kosten höher ist als ein bereits gefundenes minimum
    - #todo[ weitere erklärungen] und #maybe[ bild einfügen?]
    - das kann viel rechenzeit sparen und anderweitig praktisch nicht lösbare probleme doch lösbar machen
      - worst case dennoch $O(n!)$, falls keine zweige für pruning gefunden und dadurch dennoch alle lösungen betrachtet werden
  
  - allgemein haben exakte algorithmen probleme mit problemspezifischen limitierung und hohem rechenaufwand @harderExactAlgorithmHeuristic2023
  - nicht für zeitkritische anwendungen geeignet, bei denen das ergebnis zeitnah oder gar in nahe-echtzeit berechnet werden muss
  //- aber: für einige probleme gibt es, obwohl sie NP schwer sind, sehr gute exakte methoden die selbst bei großen probleminstanzen schnell eine optimale lösung finden @tahamiLiteratureReviewCombining2022

=== Heuristische Methoden
  - heuristiken oder metaheuristiken um lösungen zu finden und sind für eine vielzahl von problemen einsetzbar
    - A heuristic is a strategy that uses information about the problem being solved to find promising solutions @fulber-garciaHeuristicsVsMetaHeuristics2022
  - anstatt den lösungsraum vollständig aufzuzählen wird zufall benutzt um garantie der optimalität durch skalierbarkeit für große suchräume zu tauschen @martiExactHeuristicMethods2022 S.27, @harderExactAlgorithmHeuristic2023
  - schnell eine lösung finden, die gut genug ist, indem schlecht aussehende lösungskandidaten frühzeitig weggeschnitten werden @martiExactHeuristicMethods2022 S.27 oder garnicht erst in betrachtung kommen können
  - gut bei problemen mit vielen einschränkungen, vielen eingabeparametern, komplexer lösungsbewertung oder nicht-linearen problemen @ahmedshabanMetaheuristicAlgorithmsEngineering2025
  - bsp. heuristiken: lokale suche  @tahamiLiteratureReviewCombining2022
    - oder metaheuristiken: ant colony optimization, social spider optimization @ahmedshabanMetaheuristicAlgorithmsEngineering2025
    - metaheruistiken sind nicht problemspezifisch und somit anwendbar für eine vielzahl von problemkategorien
  - ohne garantie für unseren anwendungsfall zwar ungeeignet, allerdings können unzureichende lösungen durch die bewertungsfunktion erkannt und die berechnung ggf neugestartet werden
  - bester lösungsansatz für tsp derzeit: lin-kernighan heuristik, welche das problem in $O(n^2)$ lösen kann @goyalSurveyTravellingSalesman, @regoTravelingSalesmanProblem2011a
    - implementierung ist aber komplex @goyalSurveyTravellingSalesman 
  - bei tsp oft eingesetzt: genetische algorithmen (GA) #todo[ quelle]
    - ist einfacher zu implementieren und zu verstehen
    - benutzt ansätze aus der evolutionsbiologie um Lösungskandidaten schrittweise zu verbessern
    - schnell an globales optimum annähernd
    - basierend auf lokaler suche #todo[ quelle?] @tahamiLiteratureReviewCombining2022 oder @duanApplicationsHybridApproach2023a
    - laufzeit stark abhängig von wahl der parameter und der genauen implementierung @vyasExploringSolutionApproaches
  - ablauf nach @weickerEvolutionaereAlgorithmen2015 S. 39 (Algorithmus 2.6) 
    - initial werden potentielle lösungen zufallsgeneriert
      - bilden population
      - kodierung durch nützliche darstellung, oft binäre repräsentationen oder permutationen
    - population wird bewertet und durch einen selektionsprozess die besten kandidaten anhand der fitness, durch bewertungsfunktion berechnet, ausgewählt
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