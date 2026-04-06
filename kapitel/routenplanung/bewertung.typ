#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *

== Bewertung von Lösungen
// Kantenbasierte Bewertung, kontextabhängig
Um Lösungskandidaten bewerten zu können, müssen geeignete Bewertungskriterien definiert und in Form einer Funktion formalisiert werden. Die Bewertung einer Route erfolgt dabei kantenbasiert. Eine isolierte Betrachtung einzelner Kanten ist jedoch nicht ausreichend, da aufgrund der geforderten gleichmäßigen Gitterstruktur jede Kante im Kontext ihrer vorhergehenden beziehungsweise nachfolgenden Kante analysiert werden muss. Aus diesem Grund wird zur Bewertung einer Kante ein Knotentripel bestehend aus dem vorherigen Knoten sowie dem Start- und Endknoten der betrachteten Kante herangezogen. Als Ausgabe liefert die Bewertungsfunktion einen Kostenwert, analog zur Distanzbewertung zwischen zwei Knoten im klassischen @TSP:pl. Die Gesamtkosten einer Kante werden modular berechnet und setzen sich aus mehreren Teilfunktionen zusammen.

// Kanten nur mit 1er Distanz in eine Richtung
Zunächst wird die geometrische Struktur der Kanten berücksichtigt. In dem zugrunde liegenden Gitter müssen die beiden Knoten einer Kante stets um genau eine Einheit in mindestens einer Richtung, entweder vertikal oder horizontal, versetzt sein. Diese Eigenschaft wird durch die Funktion
$ d(a,b,c) = cases((Delta x+Delta y)^6 ", falls" Delta x=0 or Delta y=0, 0 ", falls" Delta x = 1 or Delta y=1, 5+(Delta x)^4+(Delta y)^4 ", sonst") \ "mit" Delta x = |b_((x))-c_((x))|, Delta y = |b_((y))-c_((y))| $
abgebildet. Insbesondere Kanten, die strikt entlang einer Zeile oder Spalte verlaufen, werden dabei negativ bewertet.

// gleichmäßiges Muster, Zickzack
Um zusätzlich plötzliche Umlenkungen in der Mitte einer Wandseite zu einer orthogonalen Seite zu verhindern, müssen die Kanten ein gleichmäßiges Muster bilden. Diese Anforderung lässt sich so formulieren, dass der vorherige Knoten sowie der Endknoten einer Kante entweder in ihrer x- oder y-Koordinate übereinstimmen müssen. Die Funktion $g$ bildet diese Bedingung ab:
$ g(a,b,c) = cases(15 ", falls" not(a_((x))=c_((x)) or a_((y)) = c_((y))) and not"ausnahme(b,c)", 0 ", sonst") $
Die Hilfsfunktion $"ausnahme"(b,c)$ nimmt den Wert „falsch“ an, sofern kein Sonderfall vorliegt. Solche Sonderfälle treten unter anderem dann auf, wenn Kanten von einer Wandseite zu Knoten des Türausschnitts verlaufen, während ihre Vorgänger nur von Wandseite zu Wandseite verliefen.

// Tür als Hindernis
Der Türausschnitt wird im Modell als Hindernis interpretiert. Entsprechend müssen alle Kanten, die durch diesen Bereich verlaufen würden, mit zusätzlichen Kosten belegt werden. Dies erfolgt durch die Funktion $t$:
// $ t(a,b,c) = cases(
//   50 ", falls" cases(delim: #none,
//     "("b_((y)) >= t_(y,1) and c_((y)) > t_(y,1) or, // below door down
//     b_((y)) > t_(y,1) and c_((y)) >= t_(y,1)")" and, // below door up
//     "("b_((x)) <= t_(x,1) and c_((x)) > t_(x,1)+1 or, // ltr
//     b_((x)) >= t_(x,2) and c_((x)) < t_(x,2)-1")", // rtl
//   ),
//   0 ", sonst"
// ) $
$ t(a,b,c) = cases(
  50 ", falls" s c h n e i d e t(overline(b c), T),
  0 ", sonst"
) $
Dabei ist $T = (t_(x,1)+1, t_(y,1)+1, t_(x,2)-1, t_(y,2)-1)$ als Rechteck definiert, das den Türausschnitt beschreibt. Die Funktion $s c h n e i d e t: (NN_0^2 times NN_0^2) times N_0^4$ liefert den Wahrheitswert „wahr“, falls die Strecke $overline(b c)$ das durch $T$ definierte Rechteck schneidet.

// Sonderstellen Herzumlenkungen
Zur Berücksichtigung spezieller Strukturanforderungen wird zusätzlich die Funktion $h$ eingeführt. Diese bestraft Routen, bei denen an Sonderstellen keine Verbindung zwischen den beiden angrenzenden @UE hergestellt wird. Konkret wird ein Kostenwert vergeben, falls von den beteiligten @UE nicht mindestens eine Kante zum jeweils anderen @UE existiert:
$ h(a,b,c) = cases(100 ", falls" exists v in V: (v != c or v != a) and cases(delim: #none, b_((x))-1 <= v_((x)) <= b_((x))+1 and, b_((y))-1 <= v_((y)) <= b_((y))+1), 0 ", sonst") $

#todo[Modul: $e: R -> NN$ Lange Kanten (horiz. Streben oberhalb der Tür) erst, wenn bereits kurze vertikale Streben irgendwo gelegt wurden]

// Gesamtbewertung
Die Gesamtbewertung einer Kante ergibt sich schließlich als gewichtete Summe der zuvor beschriebenen Teilfunktionen. Diese wird durch die gewichtete Bewertungsfunktion $f$ beschrieben:
$ f(a,b,c) = vec(x_1,x_2,x_3,x_4) dot vec(h(a,b,c), d(a,b,c), t(a,b,c), g(a,b,c)) $
Die Bewertung einer gesamten Route wird durch Funktion $c$ berechnet und ergibt sich unter anderem aus der Summe der Kosten aller enthaltenen Kanten
$ c: R -> NN, c(r) = e(r) + sum_((a,b,c) in R) f(a,b,c) $ 
Eine Route mit Gesamtkosten von 0 stellt dabei eine optimale Lösung dar.

// gesamtheitlich strukturelle Bewertung hier noch nicht sinnvoll
Eine rein strukturelle Gesamtbetrachtung ohne Berücksichtigung einzelner Kanten und deren Reihenfolge liefert im Kontext der Routenplanung keinen zusätzlichen Mehrwert. Dies liegt darin begründet, dass die resultierende Struktur maßgeblich vom tatsächlich durchlaufenen Pfad um die @UE abhängt. Aus der Route allein lassen sich nicht alle für eine umfassende Bewertung notwendigen Informationen ableiten, weshalb die Bewertung konsequent kantenbasiert erfolgt.

// Vergleichbarkeit durch Kosten
Auf Grundlage der berechneten Kosten können verschiedene Routen miteinander verglichen werden. Die Bewertungsfunktion induziert dabei eine totale Quasiordnung $O$ auf der Trägermenge $R$ aller möglichen Routen. Diese ist definiert als
$ O subset.eq R x R, O = {(a,b) | a,b in R, c(a) <= c(b)} $
Eine vollständige Totalordnung liegt jedoch nicht vor, da die Eigenschaft der Antisymmetrie verletzt ist, wenn zwei unterschiedliche Routen identische Kosten aufweisen.

//- keine behandlung von türen oder wänden mit formen die nicht rechteckig sind, zb trapeze oder kreisbögen

== Bewertung der Ansätze
#todo[Bewertungkriterien vorstellen, alle tests mit derselben berwertungsfunktion ]

Um einen passenden Ansatz bestimmen zu können, müssen Bewertungskriterien festgelegt werden. Anhand derer werden die betrachteten exakten und heuristischen Methoden bewertet und untereinander bezüglich ihrer Anwendbarkeit und Eignung zur Lösung der zuvor definierten Problemstellung systematisch verglichen. 

// Wandkonfigurationen
Um die Ergebnisse vergleichbar zu machen, werden vier verschiedene Wandkonfigurationen $w_1, ..., w_4$ festgelegt. Dabei sind $w_1$ und $w_2$ kleine Wandkonfigurationen mit einer Breite von 80 cm und einer Höhe von 55 cm, wobei sie sich nur in dem horizontalen Versatz des Türausschnittes unterscheiden. Durch manuelle Analyse konnten als optimal angenommene Routen für diese Wandkonfigurationen mit minimalen Kosten von jeweils 1 bestimmt werden. Wandkonfigurationen $w_3$ und $w_4$ sind größere Wände mit einer Breite von 2,1 m und einer Höhe von 1,05 m, also Größen wie sie auch derzeit im @CBT herstellbar sind. Die händisch bestimmten optimalen Lösungen haben ebenfalls minimal erreichte Kosten von jeweils 1. Die genauen Maße sowie die benötigte Anzahl an @UE:pl:long je Wandkonfiguration sind in @fig:wandkonfigurationen-tabelle aufgeschlüsselt. Es werden pro Konfiguration jeweils vier Durchläufe aufgezeichnet, um die Ergebnisse gegenüber zufälligen Schwankungen robuster zu machen und deren Aussagekraft zu erhöhen.

#figure(
  table(
    columns: 7,
    table.header(
      repeat: true,
      [Wand], [Breite (cm)], [Höhe (cm)], [Türhöhe (cm)], [Türbreite (cm)], [Türversatz (cm)], [Anzahl UE]
    ),
    $w_1$, [80], [55], [25], [35], [30], [30],
    $w_2$, [80], [55], [35], [25], [25], [32],
    $w_3$, [210], [105], [70], [50], [75], [75],
    $w_4$, [215], [110], [75], [50], [80], [77]
  ),
  caption: [Maße der Wandkonfigurationen für die Testläufe]
)<fig:wandkonfigurationen-tabelle>

// Seeds
Für nicht-deterministische Methoden, welche einen Zufallsgenerator benötigen, werden zwei selbstgewählte Initialisierungswerte $s_1 = 1234$ und $s_2 = 84273915$ festgelegt, um die Ergebnisse in diesen Testläufen vergleichbar zu halten. Auch hier werden wieder je Wert vier Testläufe durchgeführt.

// Hardware
Alle Tests werden auf einem Intel(R) Core(TM) i5-8350U Prozessor und 24 GB Arbeitsspeicher durchgeführt. Während der Testläufe laufen keine anderen Nutzeranwendungen, die die Leistungsfähigkeit des Computers signifikant beeinträchtigen. Die Algorithmen werden in einer Kotlin 2.2.20 Anwendung implementiert und getestet.

#question[
  - sind diese details zur software und hardware wichtig?
  - Zeitform: Algorithmen werden getestet? Algorithmen wurden getestet? Algorithmen sind getestet mithilfe.. ? ... ? 
]

// Berechnungsdauer eher unwichtig
Die Berechnungsdauer spielt im vorliegenden Anwendungsfall eher eine untergeordnete Rolle. Zwar ist eine möglichst kurze Rechenzeit wünschenswert, jedoch kann sie ohne Probleme mehrere Minuten bis in Extremfällen maximal eine Stunde dauern. Da das Temperieren des Harz getränkten Garns in etwa diese Zeit in Anspruch nimmt und ggf. auch mehrere gleiche Gitter abgelegt werden, kann währenddessen eine anschließend benötigte Konfiguration berechnet werden.
Zum Zeitpunkt der Verfassung dieser Arbeit können maximal 81 Umlenkelemente platziert werden und später weitere @UE hinzukommen, sodass es sich um ein vergleichsweise großes @TSP handelt. 

// Weitere Anforderungen, Einfachheit, Zuverlässigkeit
Bei der Konzeption und Implementierung der folgenden Lösungsansätze wird ein besonderer Schwerpunkt auf gute Verständlichkeit und Nachvollziehbarkeit gelegt. Dies erweist sich insbesondere vor dem Hintergrund als relevant, dass im Umfeld des @CBT interdisziplinäre Teams tätig sind, die nicht ganzheitlich über eine informatische Ausbildung verfügen. Vor diesem Hintergrund ist es erforderlich, dass der gewählte Lösungsansatz ein hohes Maß an Transparenz, Wartbarkeit und Zugänglichkeit aufweist. Dadurch soll er langfristig praktikabel bleiben; auch bei zukünftigen Änderungen der Anforderungen.

#todo[Kriterium "Zuverlässigkeit". Algs müssen immer gute ergebnisse liefern oder wenigstens sagen, wenn es keine guten gibt]