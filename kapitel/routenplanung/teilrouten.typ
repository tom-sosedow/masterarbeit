#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "/data/smallplots.typ": *
#import "/data/largeplots.typ": *
#import "@preview/cetz:0.4.2"

== Planung durch Teilrouten <sec:route-puzzle-based>

- Der Nachteil der punktbasierten Planung ist, dass sie freiheiten bei der wahl der nächsten kante lässt, wo eigentlich keine wirkliche entscheidungsfreiheit besteht
- bei horizontalen streben gibt es nur ganz oben und unten sowie auf höhe der oberen türkante mehrere möglichkeiten
- bei vertikalen streben nur links und rechts an der wand sowie an der linken und rechten seite des türausschnitts
- überall dazwischen würde eine abweichung vom zickzackmuster eine lücke im gitter erzeugen
- inspiration: boustrophedon cellular decomposition @chosetCoveragePathPlanning1998
  - für das coverage path planning problem, bei dem ein pfad mit gewisser breite eine fläche komplett in einem zug abdecken muss
  - im einfachen fall ohne hindernisse trivial
  - cellular decomposition, wenn hindernisse im feld sind
  - in einer richtung scannen und bei jeder angetroffenen ecke des polygons eine zelle teilen oder 2 zusammenfügen
  - zellen sind dann wieder triviale fälle in hauptrichtung
  - im vorliegenden fall: tür immer gleichförmig, immer nur eine tür, aber scannen in x und y richtung für vertikale und horizontale streben
  - sich ergebende zellen sind triviale fälle durch zickzack muster
    - 3 vertikale und 3 horizontale zellen
    - #todo[ math. definition, aufzählung aller teile und definition]
    - Zellenteile zu sehen in @fig:route-cells
- verringerung der anzahl der permutationen im Lösungsraum auf $product_(i = 1)^(6) 2i = 46'080$ ohne Optimierungen
  - durch ausschluss von manchen kanten (zb lv zu rv) auf knapp $18'000$ permutationen reduzierbar
- bei manchen wänden kann in den ecken noch eine optionale rolle hinzugefügt werden, um mehr möglichkeiten für schwierige umlenkungen zu bieten
  - modellierung als separates puzzleteil mit nur einer rolle
  - #todo[ math. Formulierung und bild einfügen]
  - dadurch erhöht sich die anzahl der möglichen permutationen in diesen fällen auf ca. das sechsfache, da das extra teil nicht benutzt wird, oder es zwischen einer der 6 puzzleteile verwendet wird
  - also schlussendlich $18'000 * 6 = 108'000$ permutationen #todo[ falsch], es werden 129024 permutationen generiert
- bewertung der entstandenen route trotzdem kantenbasiert
- #maybe[ Bild von Graph mit nur den ein- und ausgangsknoten jedes puzzleteils]
  - oder graph der teile welche permutationen erlaubt sind?

#figure(
  stack(
    dir: ltr,
    image("/images/puzzle-horizontal.png", width: 57%),
    spacing: 2%,
    image("/images/puzzle-vertikal.png", width: 57%)
  ),
  caption: [Alle Puzzleteile mit Benennung und Position],
  placement: auto
)<fig:route-cells>

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
  placement: auto
)<fig:puzzle-graph>

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
  - beste gefundene Lösung für $w_3$: 15 statt 6, bei $w_3$ gloables Optimum bei kosten von 6 gefunden

#geneticPuzzleFigure<fig:res-puzzlega-xy>


=== Exakte Methoden <sec:route-puzzle-based-exact>
- da lösungsraum überschaubar groß kann brute force eingesetzt werden
- hält die software einfach und anpassbar
- aufzählung aller permutationen durch rekursive funktion 
  - mit filter, welche stücke bei jedem schritt hinzugefügt werden dürfen, um ungültige permutationen herauszufiltern
    - bsp. LV nicht direkt nach RV, TV nur dazwischen, nicht neben TH, RH oder LH
  - ist also hybrider ansatz, nicht rein exakte methode
- es wird immer die beste lösung gefunden #todo[ beweis?] @tahamiLiteratureReviewCombining2022
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
    $w_3$, [$183$], [$4905$], [6],
    $w_4$, [$201$], [$5798$], [6],
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