#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "/data/smallplots.typ": *
#import "/data/largeplots.typ": *
#import "@preview/cetz:0.4.2"

== Planung durch Teilrouten <sec:route-puzzle-based>

Ein Nachteil bei der punktbasierten Routenplanung ist, dass Freiheiten bei der Wahl der nächsten Kante gelassen werden, wo eigentlich keine wirkliche Entscheidungsfreiehit besteht. So gibt es beispielsweise bei horizontal verlaufenden Streben jeweils immer nur den Knoten eine Ebene höher bzw. niedriger zu Auswahl. Eine Abweichung von diesem Muster würde eine irreparable Lücke in der Gitterstruktur erzeugen. Erst ganz oben bzw. unten in den Ecken der Wand oder auf Türhöhe gibt es mehrere Folgekanten, die in Frage kommen könnten.

#maybe[Die Überleitung ist mehr als holprig]

Vor diesem Hintergrund erscheint eine stärkere Strukturierung des Lösungsraumes sinnvoll, sodass unnötige Freiheitsgrade von vornherein reduziert werden. Eine geeignete konzeptionelle Grundlage hierfür bietet die aus dem Coverage Path Planning bekannte Boustrophedon Cellular Decomposition nach #citep(<chosetCoveragePathPlanning1998>). Dieses Verfahren adressiert das Problem, eine Fläche mit einem Pfad endlicher Breite vollständig und in einem zusammenhängenden Durchlauf zu überdecken. Im einfachsten Fall, also ohne Hindernisse, ist die Lösung trivial und entspricht einem gleichmäßigen Hin-und-Her-Bewegungsmuster.

Sobald Hindernisse auftreten, wird die Fläche in mehrere Teilbereiche untergliedert, in denen keine Hindernisse liegen. Dies geschieht, indem das Gebiet in einer Hauptrichtung, beispielsweise von links nach rechts, abgescannt wird. An jeder Ecke des Hindernisses wird ein Gebiet in zwei Teilgebiete aufgespalten oder zwei Teilgebiete wieder vereint. Somit ist die Pfadplanung in diesen Teilbereichen wieder trivial. Das Hauptproblem besteht dann darin eine geeignete Reihenfolge der zu befahrenden Teilgebiete zu finden.

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

Der dadurch entstehende Lösungsraum ist mit einer Kardinalität von $product_(i = 1)^(6) 2i = 46'080$ Permutationen um Größenordnungen kleiner als jener bei einer punktbasierten Planung sowie unabhängig von der Größe der Wand und der daraus resultierenden Anzahl an @UE. Zusätzlich können viele Permutationen aus der Menge entfernt werden, weil sie Reihenfolgen von Teilbereichen enthalten, welche ohnehin keine valide Abfolge darstellen. Das ist beispielsweise der Fall, falls auf ein $R V$ direkt ein $L V$ folgt, da sie sich keine Ecke der Wand teilen und somit ohne Umweg über $T V$ keine valide Route entstehen kann. 

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

Für die Bewertung gefundener Lösungen muss die bestehende Bewertungsfunktion nicht angepasst werden. Aus einer Permutation $pi = (pi^((1)),...,pi^((6))), pi^((i)) in P_V$ lässt sich eine Route durch Verkettung der einzelnen Permutationen berechnen. Somit ist eine Funktion $T: P_V^6 -> R$ definiert, sodass
$ T((pi^((1)),...,pi^((6)))) = pi^((1)) circle.small ... circle.small pi^((6)) $
gilt.

// #figure(
//   raw-render(
//     ```dot
//     digraph {
//       rankdir=TB
//       LV -> {LHR TV}
//       LVR -> {LHR TH}
//       LH -> {LV LVR}
//       LHR -> {THR TV}
//       TV -> {RV RH}
//       TVR -> {LH LVR}
//       RV -> {TH RHR}
//       RVR -> {TVR RHR}
//       RH -> {RVR RV}
//       RHR -> {TVR THR}
//       TH -> {LH RH}
//       THR -> {LV RVR}
//       //EXTRA -- {LH TH RH LV TV RV}
//     }
//     ```
//   ),
//   caption: [Puzzle Graph],
//   placement: auto
// )<fig:puzzle-graph2>

=== Heuristische Methoden <sec:route-puzzle-based-heuristics>
- Genotyp $G = (g_1, g_2,..., g_6) "mit" g_i = (t, r), t in {"TH", "LH", ...}, r in {"wahr", "falsch"}$
- mutation
  - wähle zufällig 2 indizes und vertausche die elemente
  - wähle für jedes getauschte element zufällig, ob es umgekehrt wird
  - #todo[ math. Beschreibung finden]
  - #maybe[ vorteile nachteile?]
- crossover
  - gleicher order crossover aus @sec:route-pointbased mit puzzleteilen als elemente der permutation
  - #maybe[ vorteile nachteile?]

- Ergebnisse siehe @fig:res-puzzlega-xy
  - sehr schnelle annäherung an globales Optimum auch bei großen Wänden $w_3$ und $w_4$
  - mit Seed $s_1$ wird bei Wand $w_3$ dennoch nicht das globale Optimum gefunden, mit Seed $s_2$ (nicht in Graphik) schon
  - beste gefundene Lösung für $w_3$: 15 statt 1, bei $w_3$ gloables Optimum bei kosten von 1 gefunden

#geneticPuzzleFigure<fig:res-puzzlega-xy>


=== Exakte Methoden <sec:route-puzzle-based-exact>
- da lösungsraum überschaubar groß kann brute force eingesetzt werden
- hält die software einfach und anpassbar
- aufzählung aller permutationen durch rekursive funktion 
  - mit filter, welche stücke bei jedem schritt hinzugefügt werden dürfen, um ungültige permutationen herauszufiltern
    - bsp. LV nicht direkt nach RV, TV nur dazwischen, nicht neben TH, RH oder LH
  - ist also hybrider ansatz, nicht rein exakte methode
- es wird immer die beste lösung gefunden @tahamiLiteratureReviewCombining2022
- #maybe[ pseudocode?]

- Ergebnisse siehe @tab:bruteforce-puzzle-res
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

- 129'024 permutationen, die eine valide lösung ergeben können
- daraus in spalte "Anz. Lösungen" die, deren Kosten unter 400 liegen, Kostenlimit
  - 400 um in extremfällen dennoch lösungen zu produzieren aber dennoch den suchprozess zu beschleunigen, indem zu schlechte routen entfernt werden
  - man sieht, dass größere wandkonfigurationen tendenziell weniger lösungen unter diesem schwellwert haben
  - grund: schlechte kanten werden durch größere unterschiede zwischen soll und ist-positionen der knoten noch schlechter bewertet
- geringfügig längere laufzeit bei größeren wänden
  - könnte an bewertungsfkt liegen, die trotz der puzzleteile die lösungen kantenbasiert bewertet


=== Nachbearbeitung
- bei Kombination mancher Teile entstehen ungültige Routen (siehe @sec:ue-place-problem) zb weil zwischen 2 umlenkelementen gefahren werden müsste
  - #todo[ bild aus präsentation verbessern und einfügen als beispiel]
- aber auch wenn routenende knapp unter türoberseite, fehlt strebe über der tür -> einfügen eines letzten/ersten knotens wie in @sec:ue-place-problem beschrieben
- post processing ist abbildung $p: R -> R, "Route" R$
- #maybe[ pseudo code einfügen ?]