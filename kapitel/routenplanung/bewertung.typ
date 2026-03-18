#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *

== Bewertung von Lösungen
- zur bewertung einer gefundenen route müssen bewertungskriterien festgelegt werden die zeigen, was eine gute route ausmacht
- modulare bewertungsfunktion
- input: knotentripel mit knoten einer kante und dem vorherigen knoten
- Kriterien 
  - #todo[ für jedes: beschreiben und math. Formulierung angeben]
  - gleichmäßiges Gitternetz
  - Distanz für Kanten in x oder y max. 1
  - Tür als rechteckiges Hindernis, unterseite an unterem Türrand
  - Kanten von Türrolle zu Türrolle
  - Diagonale Rollen (Herzumlenkungen)
- gewichtete summe der module bildet endresultat
- durch die berechneten kosten können lösungen miteinander verglichen werden, weil dadurch eine totale Quasiordnung mit Trägermenge $R$ besteht
  - $O subset.eq R x R, O = {(a,b) | a,b in R, f(a) <= f(b)}$
  - es besteht keine totalordnung, da die anforderung der antisymmetrie nicht 
- keine behandlung von türen oder wänden mit formen die nicht rechteckig sind, zb trapeze oder kreisbögen

- gesamtheitlich strukturelle bewertung erfolgt erst bei pfadfindung, da bei falschem umfahren der richtigen knoten trotzdem kein korrektes gitter entstehen würde
      
== Bewertung der Ansätze
- Bewertungkriterien vorstellen
  - alle tests mit derselben berwertungsfunktion
- Testfälle vorstellen
  - alle tests mit gleichen wandkonfiurationen
    - dimensionen und anzahl der rollen angeben
  - optimale werte für $w_1$ bis $w_4$ angeben
  - seeds angeben
- Hardware vorstellen
- Software vorstellen