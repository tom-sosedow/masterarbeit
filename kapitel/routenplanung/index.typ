#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "/data/smallplots.typ": *
#import "/data/largeplots.typ": *
#import "@preview/cetz:0.4.2"

// #import "@preview/algorithmic:1.0.7"
// #import algorithmic: style-algorithm, algorithm-figure
// #show: style-algorithm

= Berechnung der Route
Zur Erzeugung einer gleichmäßigen Gitterstruktur mit dem Carbongarn werden die in @sec:ue-platzierung positionierten @UE durch einen Roboterarm sequenziell umfahren, um das Garn unter Spannung abzulegen. Bevor der hierfür erforderliche Bewegungsablauf berechnet werden kann, ist zunächst zu klären, in welcher Reihenfolge die einzelnen @UE angefahren werden sollen.

Zur Bestimmung dieser Reihenfolge und zur Beantwortung der Forschungsfrage II werden in diesem Kapitel, nach einer einführenden Problembeschreibung sowie einer Analyse des aktuellen Stands der Forschung, zwei Ansätze zur Routenplanung untersucht. Dabei werden sowohl exakte als auch heuristische Suchalgorithmen betrachtet und im Hinblick auf ihre Eignung für das vorliegende Problem evaluiert.

#include "/kapitel/routenplanung/problemdefinition.typ"
#include "/kapitel/routenplanung/forschungsstand.typ"
#include "/kapitel/routenplanung/bewertung.typ"
#include "/kapitel/routenplanung/punktbasiert.typ"
#include "/kapitel/routenplanung/teilrouten.typ"
