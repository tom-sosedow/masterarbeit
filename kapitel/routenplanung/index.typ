#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "/data/smallplots.typ": *
#import "/data/largeplots.typ": *
#import "@preview/cetz:0.4.2"

// #import "@preview/algorithmic:1.0.7"
// #import algorithmic: style-algorithm, algorithm-figure
// #show: style-algorithm

= Berechnung der Route
Um eine gleichmäßige Gitterstruktur mit dem Carbongarn zu erzeugen werden die in @sec:ue-platzierung platzierten @UE von einem Roboterarm umfahren um das Garn unter Spannung abzulegen.Bevor der Pfad dafür berechnet werden kann, muss zuerst geklärt werden, welche @UE in welcher Reihenfolge angefahren werden sollen. Um dies zu bestimmen werden in diesem Kapitel, nach ein einer einführenden Problembeschreibung und Literaturrecherche, zwei Ansätze für die Routenplanung mit jeweils exakten und heuristischen Suchalgorithmen betrachtet und auf ihre Anwendbarkeit für das vorliegende Problem geprüft.

#include "/kapitel/routenplanung/problemdefinition.typ"
#include "/kapitel/routenplanung/forschungsstand.typ"
#include "/kapitel/routenplanung/bewertung.typ"


     