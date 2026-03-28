#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "/data/smallplots.typ": *
#import "/data/largeplots.typ": *
#import "@preview/cetz:0.4.2"

== Planung durch Teilrouten <sec:route-puzzle-based>

Ein Nachteil bei der punktbasierten Routenplanung ist, dass Freiheiten bei der Wahl der nächsten Kante gelassen werden, wo eigentlich keine wirkliche Entscheidungsfreiehit besteht. So gibt es beispielsweise bei horizontal verlaufenden Streben jeweils immer nur den Knoten eine Ebene höher bzw. niedriger zu Auswahl. Eine Abweichung von diesem Muster würde eine irreparable Lücke in der Gitterstruktur erzeugen. Erst ganz oben bzw. unten in den Ecken der Wand oder auf Türhöhe gibt es mehrere Folgekanten, die in Frage kommen könnten.

Vor diesem Hintergrund erscheint eine stärkere Strukturierung des Lösungsraumes sinnvoll, sodass unnötige Freiheitsgrade von vornherein reduziert werden. Eine geeignete konzeptionelle Grundlage hierfür bietet die aus dem Coverage Path Planning bekannte Boustrophedon Cellular Decomposition nach #citep(<chosetCoveragePathPlanning1998>). Dieses Verfahren adressiert das Problem, eine Fläche mit einem Pfad endlicher Breite vollständig und in einem zusammenhängenden Durchlauf zu überdecken. Im einfachsten Fall, also ohne Hindernisse, ist die Lösung trivial und entspricht einem gleichmäßigen Hin-und-Her-Bewegungsmuster.

Sobald Hindernisse auftreten, wird die Fläche in mehrere Teilbereiche untergliedert, in denen keine Hindernisse liegen. Dies geschieht, indem das Gebiet in einer Hauptrichtung, beispielsweise von links nach rechts, abgescannt wird. An jeder Ecke des Hindernisses wird ein Gebiet in zwei Teilgebiete aufgespalten oder zwei Teilgebiete wieder vereint. Somit ist die Pfadplanung in diesen Teilbereichen wieder trivial. Das Hauptproblem besteht dann darin, eine geeignete Reihenfolge der zu befahrenden Teilgebiete zu finden.

#todo[Bild des Boustrophedon CD inkl. Pfaden]

Überträgt man dieses Prinzip auf den vorliegenden Anwendungsfall, ergeben sich einige Analogien und Vereinfachungen. So ist für vertikale und horizontale Streben ein Scannen in beiden Richtungen erforderlich, um eine geeignete Zellteilung zu finden. Ebenfalls ist die Tür immer immer rechteckig mit den Seiten parallel zu den Seiten der Wand. Somit reicht in horizontaler Scanrichtung, also für vertikale Streben, die Aufspaltung in die drei Teilbereiche links und rechts sowie innerhalb der Tür. In vertikaler Richtung sind ebenfalls drei Teilbereiche nötig, um den Bereich oberhalb der Tür sowie die beiden Bereiche links und rechts neben der Tür abzubilden. In @fig:route-cells sind die resultierenden Teilrouten in den Bereichen an einem Beispiel dargestellt. 

#todo[Bilder ohne Hintergrund neu erstellen]
#figure(
  stack(
    dir: ltr,
    image("/images/puzzle-horizontal.png", width: 57%),
    spacing: 2%,
    image("/images/puzzle-vertikal.png", width: 57%)
  ),
  caption: [Alle Puzzleteile mit Benennung und Position],
)<fig:route-cells>

Die Bereiche $L V, R V, T V in P_V$ sowie $L H, R H "und" T H in P'_V$ sind jeweils als Permutationen von @UE bezüglich der Menge der @UE $V$ dargestellt.
Für die @UE in den drei Bereichen $L V, R V  "und" T V$ für vertikale Streben gilt
$
  forall v in V&: v in L V <=> 1 <= v_((x)) < t_(x,1) \
  forall v in V&: v in T V <=> t_(x,1) <= v_((x)) <= t_(x,2) \
  forall v in V&: v in R V <=> t_(x,1) > v_((x)) >= x_("max")-1 \
$
sowie für die Bereiche $L H, R H "und" T H$ für horizontale Streben

$
  forall v in V&: v in L H <=> (t_(y,1) <= v_((y)) < y_("max")-1) and (0 <= v_((x)) <= t_(x,1)+1) \
  forall v in V&: v in T H <=> t_(x,1) <= v_((y)) <= t_(x,2) \
  forall v in V&: v in R H <=> (t_(y,1) <= v_((y)) < y_("max")-1) and (t_(x,1)-1 <= v_((x)) < y_("max")) \
$

Die Anordnung der @UE bildet sich aus den Bereichen durch Anordnung der @UE entlang der Hauptachse bzw. Scanrichtung. Somit gilt für $p_x in {L V, R V, T V}, p_x = (v_1, ..., v_k)$
$ forall v_i in p_x: v_(i-1, (x)) < v_(i, (x)) $

und für $p_y in {L H, R H, T H}, p_y = (v_1, ..., v_k)$
$ forall v_i in p_y: v_(i-1, (y)) < v_(i, (y)) $

Um ein Durchlaufen der Teilrouten in umgekehrter Richtung, also entgegen der Hauptrichtung, darzustellen, werden für jede Teilroute $p in P'_V$ gegensätzliche Teilrouten $p^R$ definiert. Somit ergibt sich die Menge aller möglichen Teilrouten zu $P_V = P'_V union { L V^R, R V^R, T V^R, L H^R, R H^R, T H^R}$ 

Der dadurch entstehende Lösungsraum $Omega$ ist mit einer Kardinalität von $|Omega| = product_(i = 1)^(6) 2i = 46'080$ Permutationen um Größenordnungen kleiner als jener bei einer punktbasierten Planung sowie unabhängig von der Größe der Wand und der daraus resultierenden Anzahl an @UE. Zusätzlich können viele Permutationen aus der Menge entfernt werden, weil sie Reihenfolgen von Teilbereichen enthalten, welche ohnehin keine valide Abfolge darstellen. Das ist beispielsweise der Fall, falls auf ein $R V$ direkt ein $L V$ folgt, da sie sich keine Ecke der Wand teilen und somit ohne Umweg über $T V$ keine valide Route entstehen kann. 

#todo[Optionale Rolle als eigener teilbereich in der ecke der wand?]
// - verringerung der anzahl der permutationen im Lösungsraum auf $product_(i = 1)^(6) 2i = 46'080$ ohne Optimierungen
//   - durch ausschluss von manchen kanten (zb lv zu rv) auf knapp $18'000$ permutationen reduzierbar
// - bei manchen wänden kann in den ecken noch eine optionale rolle hinzugefügt werden, um mehr möglichkeiten für schwierige umlenkungen zu bieten
//   - modellierung als separates puzzleteil mit nur einer rolle
//   - #todo[ math. Formulierung und bild einfügen]
//   - dadurch erhöht sich die anzahl der möglichen permutationen in diesen fällen auf ca. das sechsfache, da das extra teil nicht benutzt wird, oder es zwischen einer der 6 puzzleteile verwendet wird
//   - also schlussendlich $18'000 * 6 = 108'000$ permutationen #todo[ falsch], es werden 129024 permutationen generiert
// - bewertung der entstandenen route trotzdem kantenbasiert

Der Graph, in dem schlussendlich nach einer Lösung gesucht wird, ist in @fig:puzzle-graph zu sehen. In dieser Darstellung sind aus Gründen der Übersicht die Rückrichtungen $p^R$ der jeweiligen Teilbereiche nicht dargestellt. Eine zulässige Lösung ist, wie bei der punktbasierten Routenplanung, ein Hamiltonpfad in diesem Graphen.

#figure(
  raw-render(
    ```dot
    graph {
      rankdir=LR
      LV -- {LH TH TV}
      LH -- {TH TV}
      TV -- {RV RH}
      TH -- {RV RH}
      RV -- {RH}
      //EXTRA -- {LH TH RH LV TV RV}
    }
    ```
  ),
  caption: [Puzzle Graph],
)<fig:puzzle-graph>

Für die Bewertung gefundener Lösungen muss die bestehende Bewertungsfunktion nicht angepasst werden. Aus einer Permutation $pi: NN -> P_V$ lässt sich eine Route durch Verkettung der einzelnen Permutationen berechnen. Somit ist eine Funktion $T: P_V^6 -> R$ definiert, sodass
$ T((pi(1),...,pi(6))) = pi(1) circle.small ... circle.small pi(6) $
gilt.

// #figure(
//   raw-render(
//     ```dot
//     digraph {
//       rankdir=TB
//       subgraph cluster_LV {
//         rankdir=LR
//         LV -> {LHR TV}
//         LVR -> {LHR TH}      
//       }
//       subgraph cluster_LH {
//         rankdir=LR
//         LH -> {LV LVR}
//         LHR -> {THR TV}   
//       }
//       subgraph cluster_TV {
//         rankdir=LR
//         TV -> {RV RH}
//         TVR -> {LH LVR}
//       }
//       subgraph cluster_RV {
//         rankdir=LR
//         RV -> {TH RHR}
//         RVR -> {TVR RHR}
//       }
//       subgraph cluster_RH {
//         rankdir=LR
//         RH -> {RVR RV}
//         RHR -> {TVR THR}
//       }
//       subgraph cluster_TH {
//         rankdir=LR
//         TH -> {LH RH}
//         THR -> {LV RVR}
//       }
//       //EXTRA -- {LH TH RH LV TV RV}
//     }
//     ```
//   ),
//   caption: [Puzzle Graph],
// )<fig:puzzle-graph2>

=== Heuristische Methoden <sec:route-puzzle-based-heuristics>

Unter den zuvor beschriebenen Rahmenbedingungen kann die Permutation $pi$ als geeignete Kodierung für den genetischen Algorithmus verwendet werden. 
Der Mutationsoperator führt auch hier eine einfache Vertauschung zweier Elemente der Permutation durch. Zusätzlich kann mit einer gewissen Wahrscheinlichkeit auch die Traversierungsrichtung der jeweiligen Teilroute invertiert werden. #maybe[ vorteile nachteile?]
Der eingesetzte Rekombinationsoperator entspricht dem in @sec:route-pointbased beschriebenen _Order Crossover_.
#maybe[ vorteile nachteile?]

Für die Testläufe werden weitgehend identische Parameter für den genetischen Algorithmus verwendet, wie auch schon in @sec:route-pointbased. Der einzige Unterschied liegt in der Anzahl an Segmenten für den Rekombinationsoperator, da mit sechs Elementen pro Permutation fünf Segmente eine übermäßig feine Untergliederung erzeugt werden würde.

Den Verlauf der Kosten der besten Lösung über die Laufzeit ist in @fig:res-puzzlega-xy für Wandkonfigurationen $w_3$ und $w_4$ zu sehen. Es wird der Seed $s_1$ genutzt. Es zeigt sich, dass der Algorithmus bereits nach wenigen Sekunden ein lokales Optimum findet, selbst für größere Wandkonfigurationen. Während für $w_4$ auch das globale Optimum mit Kosten von 1 gefunden wird, verbleibt die Suche für $w_3$ in einem lokalen Optimum mit Kosten von 15. Bei Verwendung des Seeds $s_2$ wird in vergleichbarer Zeit bei beiden Wandkonfigurationen das globale Optimum erreicht.

#geneticPuzzleFigure<fig:res-puzzlega-xy>


=== Exakte Methoden <sec:route-puzzle-based-exact>

Da der Lösungsraum durch die Modellierung als Teilrouten deutlich verkleinert werden konnte, wird die Anwendung von exakten Methoden zur Lösung großer Wandkonfigurationen wieder praktikabel. Insbesondere ermöglicht der Brute-Force-Ansatz eine vergleichsweise einfache und flexible Implementierung, die gleichzeitig hinreichend performant ist und eine Garantie auf Optimalität bietet.

Zur effizienten Erzeugung aller validen Permutationen wird eine rekursive Funktion eingesetzt. In jedem Schritt wird die Permutation um eine noch fehlende Teilroute ergänzt. Anschließend wird die bis dahin bestehende Lösung bewertet und die Funktion nur für diejenigen partiellen Lösungen ausgeführt, die unter der Kostengrenze von 400 liegen. Diese Kombination aus exakten Verfahren und heuristischer Beschränkung des Suchraums trägt dazu bei, die Laufzeit zu reduzieren, ohne die Garantie der Optimalität aufzugeben @tahamiLiteratureReviewCombining2022.
#todo[ist also hybrider Ansatz, nicht rein exakt? Aber irgendwie ja schon?]

#maybe[ pseudocode?]


#question[Soll die auswertung der tabelle (deutung, warum manche zahlen so sind) lieber in die auswertung?]

Die Ergebnisse der Testläufe sind in @tab:bruteforce-puzzle-res zusammengefasst. Insgesamt werden 129'024 verschiedene Permutationen gebildet. In der Spalte "Anz. Lösungen" ist jeweils die Anzahl der Lösungen mit Kosten unter 400 zu sehen. Die Spalte „Anz. Lösungen“ gibt jeweils die Anzahl der Lösungen mit Kosten unterhalb der Schranke von 400 an. Es zeigt sich, dass größere Wandkonfigurationen signifikant weniger potenzielle Lösungen aufweisen. Dies kann dadurch erklärt werden, größere Abweichungen zwischen Ist- und Soll-Positionen der @UE:pl:long durch die distanzbasierte Kostenfunktion stärker bestraft werden und somit vergleichbare Fehler zu höheren Kosten führen.


#figure(
  table(
    columns: 4,
    table.header(
      repeat: true,
      [Wand], [Anz. Lösungen], [$diameter$ Zeit (ms)], [min. Kosten]
    ),
    $w_1$, [$2974$], [$1848$], [1],
    $w_2$, [$3452$], [$2473$], [1],
    $w_3$, [$183$], [$4905$], [1],
    $w_4$, [$201$], [$5798$], [1],
  ),
  caption: [Ergebnisse optimiertes Brute Force]
) <tab:bruteforce-puzzle-res>

Außerdem ist zu sehen, dass die Laufzeiten für die größeren Wandkonfigurationen trotz des kleineren Lösungsraumes größer sind. Ein Faktor spielt hierbei die Bewertungsfunktion, die trotz der Kodierung als Permutation fester Länge auf der resultierenden Route arbeitet. Da durch die größeren Wände auch mehr Kanten bewertet werden müssen, steigt die Laufzeit des Gesamtprozesses folglich.

Dennoch wird selbst für die großen Wandkonfigurationen innerhalb weniger Sekunden das globale Optimum gefunden. Anders als bei der punktbasierten Planung ist das implementationsbedingt auch der Zeitpunkt, an dem die Suche terminiert und das finale Ergebnis somit feststeht.trotz

=== Nachbearbeitung
Wie bereits erwähnt kann aus einer Reihenfolge und Richtung der abzufahrenden Teilrouten die gesamte Route berechnet werden, indem die jeweiligen @UE:pl verkettet werden. Unter bestimmten Bedingungen kann diese bloße Verkettung allerdings dazu führen, dass ungültige bzw. schlecht bewertete Routen entstehen würden, obwohl es eine einfache Lösung für diese Spezialfälle geben könnte. Das passiert unter anderem in dem in @fig:sonderstelle-left-door-corner abgebildeten Fall einer Sonderstelle in der unteren Ecke der Tür. Wird in solch einer Wandkonfiguration eine Route bewertet, bei denen die Teilrouten $L V circle.small T V$ bzw. $T V^R circle.small L V^R$ aufeinander folgen, geht eine negative Bewertung der ignorierten Sonderstelle in die Betrachtung ein. Die Verkettung ergäbe in diesem Fall eine Kante zwischen $a$ und $b$ sowie zwischen $b$ und $c$, ohne einen Zwischenschritt über $x$. 

#maybe[weiterer Fall (letzte/Erste Strebe über der Tür) mit erklären?]

Um eine Permutation korrekt auf eine Route abbilden zu können, benötigt es also eine Nachbearbeitung in Form einer Funktion $p: R -> R$. Sie fügt beispielsweise im Fall von @fig:sonderstelle-left-door-corner das fehlende @UE $x$ zwischen $c$ und $b$ ein, um eine korrekte Umlenkung von $b$ nach $a$ zu ermöglichen. Abhängig von der gewählten Route kann auch eine Addition von $x$ vor $b$ nötig sein, um eine korrekte Umlenkung zu $a$ zu ermöglichen. Dies ist bei einer solchen Wand unter anderem erforderlich, falls auf ein $L H$ ein $L V^R$ folgt. 

#maybe[ pseudo code einfügen ?]

Die Bewertung einer Route wird also bei der Planung basierend auf Teilrouten realisiert durch die Funktion $ c': P_V^6 -> NN$ mit $ c'(pi_P_V) = (c circle.small p circle.small T)(pi_P_V) $