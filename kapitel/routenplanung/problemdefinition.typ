#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "@preview/cetz:0.4.2"

== Problemdefinition

// Allgemein
Gesucht ist eine Anordnung von anzufahrenden Umlenkelementen. Genauer ist eine Permutation aus der Menge aller Umlenkelemente gesucht, da für eine gleichmäßige Gitterstruktur alle @UE genutzt werden müssen. Damit handelt es sich um eine Instanz des Problems des Handlungsreisenden (engl. @TSP), welches ein kombinatorisches Optimierungsproblem darstellt @duanApplicationsHybridApproach2023a. Typischerweise wird unter allen Permutationen der anzufahrenden Punkte der kürzeste Hamiltonkreis, also ein Pfad, der alle Punkte genau einmal besucht und wieder beim Startpunkt endet, gesucht @goyalSurveyTravellingSalesman. Die Anforderung an einen Kreis ist hier nicht nötig, da die Enden des Carbongarns an beliebigen @UE festgemacht werden können; es reicht also ein einfacher Hamiltonpfad.

// Modellierung
Oft wird eine Modellierung dieser Probleme durch eine Graphstruktur vorgenommen @goyalSurveyTravellingSalesman. Dabei sind die anzufahrenden Punkte bzw. Stationen die Knoten und mögliche Wege dazwischen die Kanten im Graph. Den Knoten bzw. hier den @UE werden Koordinaten zugeordnet, sodass Entfernungen zwischen ihnen berechnet und für die Wahl der kürzesten Route herangezogen werden können. Sei also die Knotenmenge definiert durch
$ V={(x_i, y_i, i) | i in {1,...,n}, x_i, y_i in NN_0^+} $
sowie $ v_((x))=x_i "und" v_((y))=y_i "von" v_i in V $
und die Wandbreite mit $0<= x_i <= w_b$ und Wandhöhe mit $0<= y_i <= w_h$ definiert. Der Graph ist vollständig, es ist also jeder Knoten mit jedem anderen Knoten durch eine Kante aus der Menge 
$ E = { (v,w) | v, w in V} $
verbunden. Die gesuchte Route $pi$ ist Element der Menge aller möglichen Routen $R$, definiert durch 
$ R={(pi(1), pi(2),.., pi(n)) | & pi(i) in V, forall i, j in {1,...,n}: \ & i != j => pi(i) != pi(j)} $ 

// Route Aussehen/Struktur
Eine beispielhafte Route für eine kleine Wandkonfiguration ist in @fig:simple-route dargestellt. Zur Erzeugung der geforderten Gitterstruktur werden die @UE:pl:long in einem zickzackförmigen Muster angefahren. Im dargestellten Beispiel beginnt die Route an dem blau markierten @UE an Position (4,9). Anschließend wird das @UE an der Position (0,8) angesteuert, wodurch eine horizontal verlaufende, also achsenparallele Strebe entlang der x-Achse entsteht. Dieses Vorgehen wird fortgesetzt, bis das ebenfalls blau markierte @UE an der Position (1,0) erreicht ist. Bis zu diesem Punkt sind somit die horizontalen Streben für den Bereich oberhalb sowie links der Tür vollständig definiert. An diesem @UE erfolgt eine spezielle Umlenkung, die den Übergang zur Erzeugung vertikaler Streben einleitet, beginnend auf der linken Seite.

Durch dieses Zickzackmusters verändert sich in jedem Schritt entweder die x- oder die y-Koordinate des aktuellen @UE jeweils um genau eine Einheit. Die Richtung dieser Veränderung wird als Hauptrichtung definiert. Für die in @fig:simple-route initial erzeugten horizontalen Streben bis zum @UE an Position (1,0) verläuft die Hauptrichtung entsprechend vertikal aufsteigend.

Die Nebenrichtung sei definiert als zur Hauptrichtung orthogonal laufende Richtung und gibt an, ob eine Strebe in Hin- oder Rückrichtung verlegt ist; im Beispielabschnitt also nach links oder rechts. An nahezu jedem regulären @UE erfolgt ein Wechsel der Nebenrichtung, während die Hauptrichtung konstant bleibt. Lediglich an den blau markierten @UE kann es zu einem Wechsel der Hauptrichtung kommen. So wechselt die Hauptrichtung am @UE an Stelle (1,0)  folglich von senkrecht aufsteigend zu rechtsläufig.

#figure(
  image("/images/basic-route.png", width: 70%),
  caption: [Einfache Route in einer kleinen Wandkonfiguration]
)<fig:simple-route>

Es ist zu erkennen, dass manche @UE mehrmals angefahren werden müssen, wie zum Beispiel das @UE an Position $(4,3)$. Hier wird jeweils für die vertikalen und horizontalen Hauptrichtungen einmalig das @UE umfahren. Ebenfalls wird das in Pink markierte @UE an Position $(0,2)$ zweimalig angefahren; einmal für die horizontalen Streben und einmal für die letzte horizontale Strebe über dem Türausschnitt, bevor die Route endet.

// Doppelte Rollen
Damit dennoch ein Hamiltonpfad Betrachtungsgegenstand bleibt und somit jedes @UE nur einmalig in der Route vorkommt, werden diese @UE an besonderen Stellen erneut der Menge $V$ hinzugefügt, mit gleichen Koordinaten, aber unterschiedlichem Index $v_i$. Zu diesen besonderen Stellen gehören beide @UE an den beiden oberen Ecken des Türausschnittes, spezifiziert durch
$ { v mid(|) cases(
  delim: #none, 
  (t_(x,1) <= v_(x) <= t_(x,1) + 1) and (t_(y,1) <= v_(y) <= t_(y,1) + 1),
    or (t_(x,2)-1 <= v_(x) <= t_(x,2)) and (t_(y,1) <= v_(y) <= t_(y,1) + 1) 
  ),  v in V
} $
sowie das in @fig:simple-route Pink markierte @UE an der linken oder rechten Seite der Wand direkt über dem Türausschnitt spezifiziert durch 
$ v_((y)) = t_(y,1) -1 and (v_((x)) = 0 or v_((x)) = x_("max")-1), v in V $
für ein Ende der Route und die letzte horizontale Strebe. 

// Tür 2 Fälle
Werden Sonderstellen in den oberen Ecken des Türausschnitts vermieden, existieren in der Regel lediglich zwei valide Möglichkeiten zur Anordnung der @UE an der Tür. Diese ergeben sich entweder durch eine Verschiebung aller @UE in eine Richtung oder durch eine Spiegelung einer gültigen Lösung entlang der y-Achse.

// Sonderstelle an Tür
Ein für die Routenplanung einer gleichmäßigen Gitterstruktur ungünstiger Zusammenhang besteht zwischen der Breite und Höhe des Türausschnitts. Gilt sowohl $floor(t_b^* / r) mod 2 = 0$ als auch $floor(t_h^* / r) mod 2 = 1$ (mit Padding $p=0$), lässt sich eine Sonderstelle an der unteren linken Ecke des Türausschnitts bei der Platzierung der @UE nicht vermeiden. Ein Start der Platzierung auf der rechten statt der linken Seite des Türausschnitts spiegelt in diesem Fall das Problem auf die linke Seite der Tür. Der Sachverhalt ist in @fig:sonderstelle-left-door-corner dargestellt. Andere als die dargestellten Platzierungen der @UE:pl sind nicht den Anforderungen aus @sec:ue-place-problem entsprechend. Würde die Routenplanung üblicherweise die Teilroute $(a,b,c,d)$ enthalten, könnte der Roboterarm nicht zwischen den @UE $b$ und $x$ hindurchfahren. Eine gesonderte Betrachtung dieser Fälle ist demnach unabdingbar.

#figure(
  stack(
    dir: ltr,
    spacing: 10%,
    cetz.canvas({
      import cetz.draw: *
      scale(0.25)

      let dx = 2
      let dw = 7
      
      circle((dx, 2), fill:red) // vert
      content((dx, 2), [x]) // vert
      circle((dx, 6)) // vert
      
      circle((0, 0), fill: red) // hor
      content((0, 0), [b]) // hor
      circle((-4, 0)) // hor
  
      line((-6, -1), (3, -1)) // horizontal
      line((3, 6), (3, -1)) // vert
      line((3, 6), (3, 11), stroke: (dash: "dashed",)) // vert

      circle((dx, 14))
      circle((dx+dw*2, 16))
      // Türrollen
      for x in range(0,dw - 2) {
        if calc.even(x) {
          circle((2+dx + x*2, 18))
        }
      }
    
      for x in range(0,dw - 1) {
        circle((dx+4*x - 4,24))
      }
      content((dx - 4,24), [a])
      content((dx,24), [c])
      content((dx+2,18), [d])
      line((3,11),(3,17))
      line((3,17),(dx+dw*2-1,17))
      line((dx+dw*2-1,17),(dx+dw*2-1,11))
      line((dx+dw*2-1, 11),(dx+dw*2-1,0), stroke: (dash: "dashed",)) // vert
    }),
    cetz.canvas({
      import cetz.draw: *
      scale(x: -0.25, y: 0.25)

      let dx = 2
      let dw = 7
      
      circle((dx, 2), fill:red) // vert
      content((dx, 2), [x]) // vert
      circle((dx, 6)) // vert
      
      circle((0, 0), fill: red) // hor
      content((0, 0), [b]) // hor
      circle((-4, 0)) // hor
  
      line((-6, -1), (3, -1)) // horizontal
      line((3, 6), (3, -1)) // vert
      line((3, 6), (3, 11), stroke: (dash: "dashed",)) // vert

      circle((dx, 14))
      circle((dx+dw*2, 16))
      // Türrollen
      for x in range(0,dw - 2) {
        if calc.even(x) {
          circle((2+dx + x*2, 18))
        }
      }
    
      for x in range(0,dw - 1) {
        circle((dx+4*x - 4,24))
      }
      content((dx - 4,24), [a])
      content((dx,24), [c])
      content((dx+2,18), [d])
      line((3,11),(3,17))
      line((3,17),(dx+dw*2-1,17))
      line((dx+dw*2-1,17),(dx+dw*2-1,11))
      line((dx+dw*2-1, 11),(dx+dw*2-1,0), stroke: (dash: "dashed",)) // vert
      
    }),
  ),
  caption: [Unvermeidbare Sonderstelle am Türausschnitt, jeweils gespiegelt an der y-Achse bei gleichbleibenden Dimensionen]
)<fig:sonderstelle-left-door-corner>

