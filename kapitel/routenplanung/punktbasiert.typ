#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "/data/smallplots.typ": *
#import "/data/largeplots.typ": *
#import "@preview/cetz:0.4.2"

== Punktbasierte Planung <sec:route-pointbased>
- im klassischen TSP wird eine permutation aller zu besuchenden knoten des graphen gesucht
  - navigation also von rolle zu rolle

=== Exakte Methoden
- lösungsraum is $Omega = {(v_1, v_2, ..., v_n) | v_i in V and n = |V| and forall i,j in {1,..,n}: i!=j => v_i != v_j}$
- es gibt $n!$ lösungen, $|Omega| = n!$
- bei gerade 10 rollen und einer evaluierungsdauer von 1ms würde eine vollständige Durchsuchung des Lösungsraumes über 60 sekunden dauern $10! div 1000 div 60 = 60.48$
  - brute force nicht praktikabel für vorliegende problemgrößen
// - branch and bound bewertet unvollständige lösungen um bereits frühzeitig schlechte zweige abzuschneiden
//   - mit vorliegendem problem nicht optimal, da eine lösung bis fast zum schluss sehr gut aussehen kann, aber dann für die letzten streben sehr schlechte wege in kauf genommen werden müssen
//   - dennoch: kann trotzdem schon routen wegschneiden, die bereits zu beginn in die flasche richtung gehen -> lower bound
// - trotz branch and bound konnte für gängige wandgrößen keine lösung in akzeptabler zeit berechnet werden 
- backtracking
  - greedy methode aus code erklären
- Ergebnis siehe @fig:res-backtrack-ab
  - laufzeit für kleine wände schon sehr hoch und stark schwankend: Lösung von $w_1$ dauert ca. ein Fünftel der Zeit wie $w_2$
    - findet einigermaßen schnell eine nah am optimum liegende lösung
    - durchschnitt bis optimum gefunden wurde: w1 27,048s, w2 93,259s
    - durchschnitt bis algorithmus alle permutationen betrachtet hat und die beste lösung zurückgibt im schnitt: w2 199,087s; w1 163,331s
  - für größere Wände $w_3$ und $w_4$ konnte kein Ergebnis berechnet werden

#backtrackABFigure<fig:res-backtrack-ab>

  
=== Heuristische Methoden
- hier betrachtet: genetischer algorithmus, da implementierung recht simpel und gängiger ansatz für tsp
- initiale generation zufallsgeneriert
- #todo[ mutation und crossover für permutations-genotypen nach #cite(<weickerEvolutionaereAlgorithmen2015>, form: "prose")]
  - nPoint und order crossover
  - reparatur erklären
  - problem: macht gute konstrukte kaputt zwischen generationen
    - sonst unproblematisch, weil dafür an anderer stelle dafür gespart werden kann, was hier aber nicht der fall ist
  - Grund: local search methods often have problems with highly constrained problems where feasible areas of the solution space are disconnected
   @tahamiLiteratureReviewCombining2022

- Ergebnis
  - kleine wand @fig:res-genetic-b
    - wand $w_2$ mit 2 verschiedenen seeds für den rng
    - es wird sich innerhalb weniger sekunden einem lokalen optimum angenähert
    - es wird nicht aus dem lokalen optimum ausgebrochen und dahe rnicht das globale optimum gefunden
    - keine großen unterschiede zwischen den laufzeiten bei beiden seeds
    - minimal erreichte kosten bei $s_1$: 21, bei $s_2$ 26, seed hat also einfluss auf die qualität der gefundenen ergebnisse
#geneticBFigure<fig:res-genetic-b>

  - große wand @fig:res-genetic-x
    - wand $w_3$ mit gleichen seeds
    - deutlich längere laufzeiten und deutlich unterschiedliche resultate
      - minimal erreichte kosten bei $s_1$: 390, bei $s_2$ 266
    - wieder zu beobachten: lokales optimum ist zeitnah gefunden, aber globales optimum wird nicht gefunden
      - siehe @fig:res-genetic-y-img
      - generelle struktur stimmt schon, aber manche streben sind deplatziert
      - an schlüsselstellen werden mehrstufige tauschoperationen in der route benötigt, um zum globalen optimum zu kommen

#figure(
  image("/images/genetic_y_result.png"),
  caption: [Resultat GA für Wand $w_4$ unter Seed $s_2$],
)<fig:res-genetic-y-img>
    
#geneticXFigure<fig:res-genetic-x>
  
