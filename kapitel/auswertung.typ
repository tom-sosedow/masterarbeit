#import "/util.typ": *

= Auswertung


// RQ1 
*Platzierung der Umlenkelemente*
- die in @sec:ue-platzierung vorgestellte iterative platzierung der UE ist 
  - ausreichend schnell, 
  - bringt sicher optimale lösungen und 
  - ist einfach zu implementieren und verstehen, was geringen wartungsaufwand un einfache erweiterungen und anpassungen verspricht
  - unabhängig vom genauen radius der @UE, kleine und große modelle möglich
- es mangelt an anpassbarkeit im bezug auf die form des türausschnittes und der wand selbst
  - sollte es formen wie parallelogramme, trapeze oder rundungen geben versagt der algorithmus mit der angegebenen modellierung
  - weitere betrachtungen für das wiederholte nutzen von @UE für vertikale und horizontale streben wären nötig
- modellierung als raster eventuell nicht zukunftssicher, falls @UE oder andere hindernisse in bereichen zwischen den diskreten positionen abgelegt werden müssen, beispielsweise wenn eine @UE oder ein anderes einzuarbeitendes objekt nicht 2r breit und hoch ist
  - kann aber im nachgang außerhalb der betrachtung durch das raster eingepflegt/platziert werden
  
// RQ 2
*Routenplanung*
- Um die Reihenfolge der anzufahrenden UE zu bestimmen wurden 2 modelle für die route betrachtet: eine punktbasierte (@sec:route-pointbased) und eine auf vordefinierten teilrouten (@sec:route-puzzle-based) basierte
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
  - puzzleteile wären komplexer zu definieren, da schrägen in einem hindernis dazu führen könnten, dass es puzzleteile mit vertikalen und horizontalen streben geben kann


// RQ 3
*Pfadberechnung*
- anpassbar und verständliche vorgehensweise gut für wartung und längeren support
