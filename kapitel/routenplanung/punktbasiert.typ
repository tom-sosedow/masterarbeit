#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "/data/smallplots.typ": *
#import "/data/largeplots.typ": *
#import "/data/combinedplots.typ": *
#import "@preview/cetz:0.4.2"

== Punktbasierte Planung <sec:route-pointbased>
In klassischen @TSP:pl wird eine Permutation aller zu besuchenden Orte gesucht. Durch die Modellierung als Graphenproblem entsteht also die Frage, in welcher Reihenfolge die Knoten des Graphen entlang seiner Kanten besucht werden sollen. Da im vorliegenden Problem die @UE:pl die Knoten des Graphen repräsentieren, müssen Ansätze für eine punktbasierte Routenplanung von @UE zu @UE untersucht und evaluiert werden. 

// Lösungsraum ath. Modell
Der Lösungsraum ist dabei durch 
$ Omega = {(v_1, v_2, ..., v_n) mid(|) cases(delim: #none, v_i in V and n = |V| and, forall i\,j in {1,..,n}: i!=j => v_i != v_j)} $
definiert. Er beinhaltet $|Omega| = n!$ verschiedene Lösungen.

=== Exakte Methoden
// Brute Force eher unpraktikabel
Durch den schnell wachsenden Lösungsraum mit zunehmendem $n$ wird eine vollständige Aufzählung schnell unpraktikabel. Schon bei einem kleinen $n=15$ gibt es über $15! = 1,3 * 10^(12)$ Permutationen in $Omega$. Somit kommen bei den vorliegenden Problemgrößen Ansätze wie einfaches Brute-Forcing nicht in Frage.

// - branch and bound bewertet unvollständige lösungen um bereits frühzeitig schlechte zweige abzuschneiden
//   - mit vorliegendem problem nicht optimal, da eine lösung bis fast zum schluss sehr gut aussehen kann, aber dann für die letzten streben sehr schlechte wege in kauf genommen werden müssen
//   - dennoch: kann trotzdem schon routen wegschneiden, die bereits zu beginn in die flasche richtung gehen -> lower bound
// - trotz branch and bound konnte für gängige wandgrößen keine lösung in akzeptabler zeit berechnet werden 

// Backtracking
Backtracking kann ein effizienterer Ansatz als Brute-Force sein, da invalide Teillösungen bereits frühzeitig aus der Betrachtung entfernt werden. Durch die Vollständigkeit des Graphen gibt es zwar keine invaliden Teillösungen im konventionellen Sinn, allerdings können durch bestimmte gewählte Kanten die Kosten bereits so hoch sein, dass absehbar ist, dass diese Teilroute keinen akzeptablen Lösungskandidat darstellen kann. Das kann beispielsweise beim Wählen von Kanten durch den Türausschnitt geschehen. Ein Schwellwert der Kosten kann also eingeführt werden, der als Invalidierungskriterium beim Backtracking dient. 

// Parameter Backtracking für Pruning
Für die Testläufe mit Backtracking wird der Schwellwert auf $50$ festgelegt, um so viele schlechte Lösungen wie möglich verwerfen zu können, ohne bei schwierigen Wandkonfigurationen eine optimale Lösung zu verwerfen. Teilrouten werden durch rekursive Traversierung eines impliziten Suchbaums generiert und anschließend bewertet. Übersteigen die Kosten den Schwellwert, werden die Kindelemente unter diesem Knoten und damit dieser Teil des Suchbaumes nicht weiter betrachtet. 

// Mit der Menge aller Routen $R$ sei $R^*$ die Menge aller Teilrouten mit Elementen $r^* = (v_1,...,v_k) in R^*$. Backtracking ist dann eine rekursive Funktion definiert durch
// $ 
// B T(r^*) = cases(
//   r^* ", falls" n = k,
//   B T((...r^*, C(r^*)))
// ) 
// $

// Ergebnisse Backtracking
Die Ergebnisse der Testläufe sind in @fig:res-backtrack-ab dargestellt. Bereits für die kleinen Wände $w_1$ und $w_2$ sind die Laufzeiten vergleichsweise hoch und stark schwankend zwischen Wandkonfigurationen ähnlicher Größe. Für $w_1$ wird dabei nach durchschnittlich 27 Sekunden und bei $w_2$ nach 93 Sekunden das Optimum gefunden. Da es sich um eine exakte Methode handelt, steht das finale Ergebnis allerdings erst nach durchschnittlich 163 Sekunden für $w_1$ bzw. 199 Sekunden für $w_2$ fest, nachdem alle notwendigen Knoten betrachtet wurden und der Algorithmus terminiert. Für die großen Wandkonfigurationen $w_3$ und $w_4$ konnte auch nach einer Stunde Laufzeit kein finales Ergebnis berechnet werden, sodass die aufgezeichneten Daten nicht in die Auswertung einfließen können.

#backtrackABFigure<fig:res-backtrack-ab>

  
=== Heuristische Methoden
Als Vertreter für heuristische Methoden wird hier ein genetischer Algorithmus untersucht, da die Implementierung recht simpel ist und der Ansatz häufig zur Bearbeitung von @TSP:pl genutzt wird. 

Der Algorithmus ist vollständig nach #citep(<weickerEvolutionaereAlgorithmen2015>) implementiert. Die initiale Population wird durch Zufall generiert. Für den Mutationsoperator wird ein einfacher Tausch von zwei zufällig gewählten @UE vorgenommen. Für die Selektion wird eine Turnierselektion nach #todo[QUELLE] eingesetzt. Es wird dabei $n$ Mal eine Lösung mit $k$ zufällig gewählten anderen Lösungen verglichen, also ein Turnier "veranstaltet", und die beste als Elternteil zur Bildung der nächsten Generation gewählt. Als Rekombinationsoperator wird der _Order Crossover Operator_ nach #citep(<larranagaGeneticAlgorithmsTravelling1999>) genutzt, welcher speziell für die Arbeit mit Permutationen bestimmt ist. Dieser basiert auf der Annahme, dass die Reihenfolge der Knoten von größerem Interesse als deren Position in der Permutation ist. Die Nachkommen werden dabei erzeugt, indem zunächst eine Teilsequenz eines Elternteils übernommen wird und die verbleibenden Knoten in der Reihenfolge ergänzt werden, in der sie im anderen Elternteil auftreten.

#todo[Bild zur Erklärung des Operators? Vielleicht einfach nur ein Beispiel?]

Für die Testläufe mit dem genetischen Algorithmus werden die Parameter wie Mutations- und Rekombinationswahrscheinlichkeit, Populationsgröße und Turniergröße fixiert. Um einen zeitlichen Rahmen für die Berechnung und Aufzeichnung der Ergebnisse zu setzen, werden maximal 12000 Generationen durchlaufen.

Die Ergebnisse der Testläufe für Wandkonfiguration $w_2$ sind in @fig:res-genetic links zu sehen. Es werden bei gleichen Parametern zwei Seeds für den Zufallszahlengenerator für die Tests genutzt. Die Abbildung zeigt, dass der Seed Auswirkungen auf die Qualität der gefundenen Lösungen hat. So wurde bei Seed $s_2$ nur eine Lösung mit Kosten von 26 gefunden, während mit Seed $s_1$ für die beste gefundene Lösung Kosten von 21 berechnet wurden. Es konnte also mit keinem von beiden Seeds das Optimum von 1 erreicht werden, da beide nach ca. 15 Sekunden in einem lokalen Optimum hängen bleiben. In beiden Fällen konnten die an das Optimum nah herankommenden Lösungen bereits nach wenigen Sekunden gefunden werden. Es sind hier demnach keine signifikanten Unterschiede in den Laufzeiten zwischen beiden Seeds zu erkennen. 

#combinedBYFigure<fig:res-genetic>

Für eine große Wandkonfiguration sind die Ergebnisse am Beispiel von $w_3$ rechts in @fig:res-genetic zu sehen. Hier sind die Unterschiede zwischen beiden Seeds noch deutlicher zu erkennen. Während mit Seed $s_1$ die beste Lösung mit Kosten von 390 nach ca. 245 Sekunden gefunden wird, dauert es mit Seed $s_2$ 176 Sekunden, um eine Lösung mit Kosten 266 zu finden. Auch hier ist zu beobachten, dass der Algorithmus Schwierigkeiten damit hat, aus lokalen Optima auszubrechen. 

In @fig:res-genetic-y-img ist die Problematik der lokalen Optima am Beispiel der Wandkonfiguration $w_4$ mit Seed $s_2$ gut zu erkennen. Die generelle Struktur sieht vielversprechend aus und große Teile der endgültigen Gitterstruktur bestehen bereits. Allerdings gibt es zahlreiche Lücken, welche teilweise durch falsche Wahl der nachfolgenden Kanten entstehen. So ist z. B. die rechte Seite der Wand bis auf einen Tausch von zwei Teilrouten korrekt gelöst. Es ist also festzuhalten, dass an den übrigen Schlüsselstellen gezielte Tauschoperationen der Knoten oder ganzen Teilrouten nötig wären, um zu einem optimalen Ergebnis zu gelangen. Durch die probabilistische Natur der Operatoren ist dies allerdings sehr unwahrscheinlich.

#figure(
  image("/images/genetic_y_result.png", width: 80%),
  caption: [Resultat GA für Wand $w_4$ unter Seed $s_2$],
)<fig:res-genetic-y-img>
