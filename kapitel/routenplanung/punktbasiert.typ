#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "/data/smallplots.typ": *
#import "/data/largeplots.typ": *
#import "/data/combinedplots.typ": *
#import "@preview/cetz:0.4.2"

== Punktbasierte Planung <sec:route-pointbased>
Unter Berücksichtigung der oben genannten Bewertungskriterien werden nun Ansätze zur Lösung des @TSP:pl untersucht. In klassischen @TSP:pl wird dabei eine Permutation aller zu besuchenden Orte gesucht. Durch die Modellierung als Graphenproblem entsteht also die Frage, in welcher Reihenfolge die Knoten des Graphen entlang seiner Kanten besucht werden sollen. Da im vorliegenden Problem die @UE:pl die Knoten des Graphen repräsentieren, müssen Ansätze für eine punktbasierte Routenplanung von @UE zu @UE untersucht und evaluiert werden. 

// Lösungsraum ath. Modell
Der Lösungsraum ist dabei durch 
$ Omega = {(v_1, v_2, ..., v_n) mid(|) cases(delim: #none, v_i in V and n = |V| and, forall i\,j in {1,..,n}: i!=j => v_i != v_j)} $
definiert. Er beinhaltet $|Omega| = n!$ verschiedene Lösungen.

=== Exakte Methoden
// Brute Force eher unpraktikabel
Durch den schnell wachsenden Lösungsraum mit zunehmendem $n$ wird eine vollständige Aufzählung schnell unpraktikabel. Schon bei einem kleinen $n=15$ gibt es $15! = 1,3 * 10^(12)$ Permutationen in $Omega$. Somit kommen bei den vorliegenden Problemgrößen Ansätze wie einfaches Brute-Forcing nicht in Frage.

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
Als Vertreter für heuristische Methoden wird hier ein genetischer Algorithmus untersucht, da die grundlegende Implementierung recht simpel ist und der Ansatz häufig zur Bearbeitung von @TSP:pl genutzt wird. 

Der Algorithmus ist vollständig nach #citep(<weickerEvolutionaereAlgorithmen2015>, supplement: [S.87]) implementiert. Die initiale Population wird durch Zufall generiert. Für den Mutationsoperator wird ein einfacher Tausch von zwei zufällig gewählten @UE vorgenommen. Für die Selektion wird eine Turnierselektion nach #citep(<razaliGeneticAlgorithmPerformance2011>) eingesetzt. Es wird dabei $n$ Mal eine Lösung mit $k$ zufällig gewählten anderen Lösungen verglichen, also ein Turnier "veranstaltet", und die beste als Elternteil zur Bildung der nächsten Generation gewählt. Als Rekombinationsoperator wird der _Order Crossover Operator_ nach #citep(<davisApplyingAdaptiveAlgorithms1985>) genutzt, welcher speziell für die Arbeit mit Permutationen bestimmt ist. Dieser basiert auf der Annahme, dass die Reihenfolge der Knoten von größerem Interesse als deren Position in der Permutation ist. Die Nachkommen werden dabei erzeugt, indem zunächst eine Teilsequenz eines Elternteils übernommen wird und die verbleibenden Knoten in der Reihenfolge ergänzt werden, in der sie im anderen Elternteil auftreten. Ein Beispiel, wie aus zwei Elternteilen ein Kindelement kombiniert werden kann, ist in @fig:order-crossover zu sehen.

#figure(
  cetz.canvas({
    import cetz.draw: *
    scale(0.7)
    let field(num, pos, color: black) = {
      let name = str(num) + str(pos.at(0)) + str(pos.at(1))
      content(pos, text(fill:color)[#num], name: name)
      rect-around(name, padding:0.2, stroke: (paint: color))
    }

    content((-2,4), [Elternteil 1])
    let p1 = (1,2,3,4,5,6,7,8,9)
    for (i, value) in p1.enumerate() {
      let color = if value >= 4 and value < 7 {
        blue
      } else {
        gray.darken(30%)
      }
      field(value, (i, 4), color: color)
    }

    content((-1.4,2), [Kind])
    let child = (7,2,8,4,5,6,1,3,9)
    for (i, value) in child.enumerate() {
      let color = if value >= 4 and value < 7 {
        blue
      } else if value < 4 or value >= 7 {
        green
      } else {
        black
      }
      field(value, (i, 2), color: color)
    }
    line((3,3.5),(3,2.5), mark: (end: ">"), stroke: (paint: blue))
    line((4,3.5),(4,2.5), mark: (end: ">"), stroke: (paint: blue))
    line((5,3.5),(5,2.5), mark: (end: ">"), stroke: (paint: blue))

    content((-2,0), [Elternteil 2])
    let p2 = (7,2,5,4,8,1,3,6,9)
    for (i, value) in p2.enumerate() {
      let color = if value < 4 or value >= 7 {
        green
      } else {
        gray.darken(30%)
      }
      field(value, (i, 0), color: color)
    }
    line((0,0.5), (0,1.5), mark: (end: ">"), stroke: (paint: green))
    line((1,0.5), (1,1.5), mark: (end: ">"), stroke: (paint: green))
    line((4,0.5), (2,1.5), mark: (end: ">"), stroke: (paint: green))
    line((5,0.5), (6,1.5), mark: (end: ">"), stroke: (paint: green))
    line((6,0.5), (7,1.5), mark: (end: ">"), stroke: (paint: green))
    line((8,0.5), (8,1.5), mark: (end: ">"), stroke: (paint: green))

    line((2.5,5),(2.5,-1))
    line((5.5,5),(5.5,-1))
  }),
  caption: [Order Crossover nach #citep(<davisApplyingAdaptiveAlgorithms1985>) mit Übernahme einer einzelnen Teilsequenz von Elternteil 1. Elternteil 2 füllt die dem Kind fehlenden Knoten anschließend in der Reihenfolge auf, in der sie in ihm vorkommen.]
)<fig:order-crossover>

Für die Testläufe mit dem genetischen Algorithmus werden die Prozessparameter für jeden Testlauf fixiert. Die Mutationswahrscheinlichkeit beträgt dabei $45%$ und die Rekombinationswahrscheinlichkeit $73%$. Die Populationsgröße wird auf 3000 und die Turniergröße auf $3$ bei $36$ Turnieren festgelegt. Um einen zeitlichen Rahmen für die Berechnung und Aufzeichnung der Ergebnisse zu setzen, werden maximal 12'000 Generationen durchlaufen.

Die Ergebnisse der Testläufe für Wandkonfiguration $w_2$ sind in @fig:res-genetic links zu sehen. Durch jeweils gleichbleibende Parameter aber unterschiedliche Seeds ist, anhand der Differenz der Kurvenverläufe und erreichten minimalen Kosten, zu sehen, dass der Seed Auswirkungen auf die Qualität der gefundenen Lösungen hat. So wurde bei Seed $s_2$ nur eine Lösung mit Kosten von 26 gefunden, während mit Seed $s_1$ für die beste gefundene Lösung Kosten von 21 berechnet wurden. Es konnte also mit keinem von beiden Seeds das Optimum von 1 erreicht werden, da beide nach ca. 15 Sekunden in einem lokalen Optimum hängen bleiben. In beiden Fällen konnten die an das Optimum nah herankommenden Lösungen bereits nach wenigen Sekunden gefunden werden. Es sind hier demnach keine signifikanten Unterschiede in den Laufzeiten zwischen beiden Seeds zu erkennen. 

#combinedBYFigure<fig:res-genetic>

Für eine große Wandkonfiguration sind die Ergebnisse am Beispiel von $w_3$ rechts in @fig:res-genetic zu sehen. Hier sind die Unterschiede zwischen beiden Seeds noch deutlicher zu erkennen. Während mit Seed $s_1$ die beste Lösung mit Kosten von 390 nach ca. 245 Sekunden gefunden wird, dauert es mit Seed $s_2$ durchschnittlich 176 Sekunden, um eine Lösung mit Kosten 266 zu finden. Auch hier ist zu beobachten, dass der Algorithmus offenbar Schwierigkeiten damit hat, aus lokalen Optima auszubrechen. 

In @fig:res-genetic-b-generation ist erneut für Wandkonfiguration $w_2$ der Verlauf der Kosten abgebildet, aber im Bezug auf die derzeitige Generation. Die Kosten sinken innerhalb weniger Hundert Generationen auf das lokale Optimum von 21 und verbleiben dort für die restlichen 1600 Generationen.

#geneticBGenFigure<fig:res-genetic-b-generation>


In @fig:res-genetic-y-img ist die Problematik der lokalen Optima am Beispiel der Wandkonfiguration $w_4$ mit Seed $s_2$ gut zu erkennen. Die generelle Struktur sieht vielversprechend aus und große Teile der endgültigen Gitterstruktur bestehen bereits. Allerdings gibt es zahlreiche Lücken, welche teilweise durch falsche Wahl der nachfolgenden Kanten entstehen. So ist z. B. die rechte Seite der Wand bis auf einen Tausch von zwei Teilrouten korrekt gelöst. Es ist also festzuhalten, dass an den übrigen Schlüsselstellen gezielte Tauschoperationen der Knoten oder ganzen Teilrouten nötig wären, um zu einem optimalen Ergebnis zu gelangen. Durch die probabilistische Natur der Operatoren ist dies allerdings sehr unwahrscheinlich.

#figure(
  image("/images/genetic_y_result.png", width: 80%),
  caption: [Von GA berechnete Route für Wand $w_4$ unter Seed $s_2$ (eigene Darstellung)],
)<fig:res-genetic-y-img>
