#import "/util.typ": *
#import "@preview/diagraph:0.3.6": *
#import "@preview/cetz:0.4.2"

== Problemdefinition

// Allgemein
Gesucht ist eine Anordnung von anzufahrenden Umlenkelementen. Genauer ist eine Permutation aus der Menge aller Umlenkelemente gesucht, da für eine gleichmäßige Gitterstruktur alle @UE genutzt werden müssen. Damit handelt es sich um eine Instanz des Problems des Handlungsreisenden (engl. @TSP), welches ein kombinatorisches Optimierungsproblem darstellt @duanApplicationsHybridApproach2023a. Typischerweise wird unter allen Permutationen der anzufahrenden Punkte der kürzeste Hamiltonkreis, also ein Pfad der alle Punkte genau einmal besucht und wieder beim Startpunkt endet, gesucht @goyalSurveyTravellingSalesman. Die Anforderung an einen Kreis ist hier nicht nötig, da die Enden des Carbongarns an beliebigen @UE festgemacht werden können; es reicht also ein einfacher Hamiltonpfad.

// Modellierung
Oft wird eine Modellierung dieser Probleme durch eine Graphstruktur vorgenommen @goyalSurveyTravellingSalesman. Dabei sind die anzufahrenden Punkte bzw. Stationen die Knoten und mögliche Wege dazwischen die Kanten im Graph. Den Knoten bzw. hier den @UE werden Koordinaten zugeordnet, sodass Entfernungen zwischen ihnen berechnet und für die Wahl der kürzesten Route herangezogen werden können. Sei also die Knotenmenge definiert durch
$ V={(x_i, y_i, i) | i in {1,...,n}, x_i, y_i in NN_0^+} $
sowie $ v_((x))=x_i "und" v_((y))=y_i "von" v_i in V $
und die Wandbreite mit $0<= x_i <= w_b$ und Wandhöhe mit $0<= y_i <= w_h$ definiert. Der Graph ist vollständig, es ist also jeder Knoten mit jedem anderen Knoten durch eine Kante aus der Menge 
$ E = { (v,w) | v, w in V} $
verbunden. Die gesuchte Route wird durch $ R=(r_1, r_2,.., r_n), r_i in V, (r_(i), r_(i+1)) in E $ angegeben. Eine beispielhafte Route für eine kleine Wand ist in @fig:simple-route zu sehen. Es ist zu erkennen, dass manche @UE mehrmals angefahren werden müssen, wie zum Beispiel das @UE an Position $(4,3)$. Hier wird jeweils für die vertikalen und horizontalen Streben einmalig das @UE umfahren. Ebenfalls wird das in Pink markierte @UE an Position $(0,2)$ zweimalig angefahren; einmal für die horizontalen Streben und einmal für die letzte horizontale Strebe über dem Türausschnitt bevor die Route endet.

#figure(
  image("/images/basic-route.png", width: 70%),
  caption: [Einfache Route in einer kleinen Wandkonfiguration]
)<fig:simple-route>

// Doppelte Rollen
Damit dennoch ein Hamiltonpfad Betrachtungsgegenstand bleibt und somit jedes @UE nur einmalig in der Route vorkommt, werden diese @UE an besonderen Stellen erneut der Menge $V$ hinzugefügt, mit gleichen Koordinaten aber unterschiedlichem Index $v_i$. Zu diesen besonderen Stellen gehören beide @UE an den beiden oberen Ecken des Türausschnittes, spezifiziert durch
$ { v | cases(
  delim: #none, 
  (t_(x,1) <= v_(x) <= t_(x,1) + 1) and (t_(y,1) <= v_(y) <= t_(y,1) + 1),
    or (t_(x,2)-1 <= v_(x) <= t_(x,2)) and (t_(y,1) <= v_(y) <= t_(y,1) + 1) 
  ),  v in V
} $
sowie das in @fig:simple-route Pink markierte @UE an der linken oder rechten Seite der Wand direkt über dem Türausschnitt spezifiziert durch 
$ v_((y)) = t_(y,1) -1 and (v_((x)) = 0 or v_((x)) = "cols"-1), v in V $
für ein Ende der Route und die letzte horizontale Strebe. 

Ein ungünstiger Zusammenhang kann zwischen der Breite und Höhe des Türausschnitts entstehen. Wird das Padding ignoriert ($p=0$) und gilt sowohl $floor(t_b^* / r) mod 2 = 0$ als auch $floor(t_h^* / r) mod 2 = 1$, lässt sich eine Sonderstelle an der unteren linken Ecke des Türausschnitts nicht vermeiden. Dies gilt unabhängig davon, ob die Platzierung der @UE von der linken oder rechten Seite der Tür ausgeht, da sich dadurch auch die Positionen der @UE an der Oberseite der Tür und damit an der Oberseite der Wand verschieben.

Der Sachverhalt ist in @fig:sonderstelle-left-door-corner dargestellt. Würde die Routenplanung üblicherweise die Teilroute $(a,b,c,d)$ enthalten, könnte der Roboterarm nicht zwischen den @UE $b$ und $x$ hindurchfahren. 
//Eine Anpassung der Teilroute durch Hinzufügen des @UE $x$ zwischen $b "und" c$ ist nötig, sodass die Teilroute schlussendlich . 
Eine gesonderte Betrachtung ist bei der Routen- und Pfadplanung demnach unabdingbar.


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
  caption: [Unvermeidbare Sonderstelle am Türausschnitt]
)<fig:sonderstelle-left-door-corner>

Die Berechnungsdauer spielt im vorliegenden Anwendungsfall eher eine untergeordnete Rolle. Zwar ist eine möglichst kurze Rechenzeit wünschenswert, jedoch kann sie ohne Probleme mehrere Minuten bis in Extremfällen maximal eine Stunde dauern. Da das Temperieren des Harz getränkten Garns in etwa diese Zeit in Anspruch nimmt und ggf. auch mehrere gleiche Gitter abgelegt werden kann währenddessen eine anschließend benötigte Konfiguration berechnet werden.

Zum Zeitpunkt der Verfassung dieser Arbeit können maximal 81 Umlenkelemente platziert werden und später weitere @UE hinzukommen, sodass es sich bei dem @TSP um ein vergleichsweise großes @TSP handelt. 

Lösungsansätze sollten in der Implementierung und im zugrunde liegendem Konzept einfach anpassbar und verständlich sein. Da im @CBT größtenteils Menschen ohne Hintergrund in der Informatik arbeiten und zu Zwecken der Forschung und Entwicklung auch selbstständig kleinere Anpassungen vornehmen können müssen, sollte ein möglichst simpler Ansatz gewählt werden. 
