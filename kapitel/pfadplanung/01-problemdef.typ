#import "/util.typ": *
#import "@preview/cetz:0.4.2"

== Problemdefinition

Im Rahmen der Planung der Bewegungsabläufe des Roboterarms sind mehrere Aspekte zu berücksichtigen. Neben der Festlegung der Umlaufrichtung um die jeweiligen @UE:pl spielt insbesondere die Kollisionserkennung und -vermeidung eine zentrale Rolle, sowohl mit @UE:pl als auch mit bereits verlegten Garnstreben. Darüber hinaus müssen Anforderungen wie die Aufrechterhaltung einer ausreichenden Garnspannung und die Sicherstellung der Haftung gegenüber vertikalem Abrutschen von den @UE einbezogen werden. Ferner ist auch die Überführung der geplanten Trajektorien in mit dem Roboter kompatible Bewegungsmuster erforderlich.

// Werkzeug
Zum Verlegen des Garns wird ein Werkzeug eingesetzt, das aus einer außermittig angebrachten, aufrecht stehenden Rolle besteht, über die das Garn in die Austrittsdüse geführt wird. Der Aufbau ist in @fig:werkzeug-garnablage abgebildet. Aufgrund der Rotierbarkeit des Werkzeugs kann es sich im Ganzen um den Mittelpunkt herum drehen, sobald seitliche Kräfte auf die Austrittsdüse einwirken. Dies ist beispielsweise der Fall, wenn um ein @UE gefahren wird. Durch die kontinuierliche Richtungsänderung der Kreisbewegung wird das Garn zum letzten Auflagepunkt am @UE gezogen, die Düse besitzt dabei allerdings noch dieselbe Orientierung. Die Rotation entsteht also automatisch, ohne Hilfe eines Motors. Für den Roboter ist diese Rotation irrelevant und kann nicht erkannt werden, da der Mittelpunkt des Werkzeugs statisch konfiguriert wird und keine Sensoren die aktuelle Rotation des Werkzeuges aufnehmen.
Durch die Breite und Rotation des Werkzeugs muss beim Umfahren der @UE ein Mindestabstand eingehalten werden, damit sich das Werkzeug frei drehen kann.

#figure(
  image("/images/roboter-werkzeug.jpg", width: 60%),
  caption: [Werkzeug des Roboterarms zum Verlegen des Carbongarns]
)<fig:werkzeug-garnablage>

Da das Garn in etwa mittig aus der Austrittsdüse herauskommt und somit der untere Teil der Düse niedriger als das austretende Garn ist, kann eine bereits verlegte Strebe beim Überqueren durch die Düse beschädigt werden. Hier kann es zum Spleißen oder Verziehen des Garns kommen. Im schlimmsten Fall kann das Garn auch reißen. Es muss also eine Möglichkeit gefunden werden, Kollisionen mit bereits verlegten Garnstreben sichergestellt zu vermeiden. Auch Kollisionen mit @UE müssen vermieden werden, da u.a. durch den Türausschnitt @UE:pl zwischen der direkten Verbindung zweier Umlenkpunkte liegen können.

// Umlaufrichtung
Für die Gleichmäßigkeit des Gittermusters ist entscheidend, in welcher Richtung die @UE:pl umfahren werden. Dabei wird, von oben auf den Ablagetisch gesehen, zwischen dem Uhrzeigersinn $R'$ und entgegen des Uhrzeigersinns $R$ unterschieden. Bei einer falsch gewählten Richtung entstehen keine achsenparallelen Streben, welche für die Lastverteilung und strukturelle Integrität unerlässlich sind. Der Zusammenhang ist in @fig:pfad-zu-muster dargestellt. Dargestellt ist eine Teilroute um die zwei @UE:pl:long $P$ und $Q$, für die je @UE drei Wegpunkte zum Abfahren durch den Roboter definiert wurden. Folgt der Roboterarm dem Pfad $(a,b,c,d,e,f)$, wie im linken Bild blau dargestellt, entstehen achsenparallele, horizontale Streben des Carbongarns (rot dargestellt). 
Wird hingegen bei unveränderter Reihenfolge der anzufahrenden @UE die Umlaufrichtung invertiert, so ergibt sich effektiv eine Umkehr der lokalen Wegpunktreihenfolge. Die resultierende Sequenz lautet in diesem Fall $(c,b,a,f,e,d)$. Wie im rechten Teil der Abbildung zu erkennen ist, verlaufen die erzeugten Streben dadurch nicht mehr parallel, sondern weisen teilweise Kreuzungen in Hauptrichtung auf.
Analog dazu kann eine fehlerhafte Festlegung der zugehörigen Wegpunkte sowie ihrer Reihenfolge dazu führen, dass einzelne @UE:pl ausgelassen werden, Lücken in der Gitterstruktur entstehen oder Kollisionen mit benachbarten @UE auftreten @merschAutomation3DRobotic2025.

#figure(
  grid(
    columns:(auto, 15%, auto),
    rows:(auto, auto),
    cetz.canvas({
      import cetz.draw: *

      scale(0.6)
      content((4,6), [Pfad: $(...,d,a,b,c,d,e,f,c,...)$])
      // links
      circle((0,0))
      circle((0,4), stroke: (dash: "dashed", paint: gray))
      content((0,0), [Q])
      let points1 = ((0,2),(-2, 0),(0,-2))

      for (p,letter) in points1.zip(("d","e","f")) {
        circle(p, radius: 0.2)
        content((p.at(0) + 0, p.at(1) + 0.6), [#letter])
      }

      arc((-1.5,1.5), delta: 180deg, start: 95deg, radius: 1.5, mark: (end: ">"), stroke: (paint: purple))
      content((-3.5,1), text(fill: purple)[$R$])

      
      // rechts
      circle((8,2))
      content((8,2), [P])
      circle((8,-2), stroke: (dash: "dashed", paint: gray))

      let points3 = ((8,2+2),(8+2, 2),(8,2-2))
      
      for (p, letter) in points3.zip(("a","b","c")) {
        circle(p, radius: 0.2)
        content((p.at(0) + 0, p.at(1) + 0.6), [#letter])
      }

      set-style(mark: (end: ">>"), stroke: (paint: blue))
      line(points3.at(0),points3.at(1))
      line(points3.at(1),points3.at(2))       
      line(points1.at(0),points1.at(1))
      line(points1.at(1),points1.at(2))
      line(points3.last(), points1.first())
      line(points1.first(), points3.first())
      line(points1.last(), points3.last())

      set-style(mark: none, stroke: (paint: red))
      line((0,-1.1), (8,-1))
      line((0,1.1), (8,0.9))
      line((0,3), (8,3.1))
      arc((0,-1.1), radius: 1.1, start: -90deg, delta: -180deg)
      arc((8,1 - 0.1), radius: 1.1, start: -90deg, delta: 180deg)
    }),
    [],
    cetz.canvas({
      import cetz.draw: *

      scale(0.6)
      content((4,7), [Pfad: $(...,c,b,a,f,e,d,...)$])
      // links
      circle((0,0))
      circle((0,4), stroke: (dash: "dashed", paint: gray))
      content((0,0), [Q])
      let points1 = ((0,2),(-2, 0),(0,-2)).rev()
      

      for (p,letter) in points1.zip(("d","e","f").rev()) {
        circle(p, radius: 0.2)
        content((p.at(0) + 0, p.at(1) + 0.6), [#letter])
      }

      // rechts
      circle((8,2))
      circle((8,-2), stroke: (dash: "dashed", paint: gray))
      content((8,2), [P])

      let points3 = ((8,2+2),(8+2, 2),(8,2-2)).rev()
      
      for (p, letter) in points3.zip(("a","b","c").rev()) {
        circle(p, radius: 0.2)
        content((p.at(0) + 0, p.at(1) + 0.6), [#letter])
      }

      arc((-1.5,-1.5), delta: -180deg, start: -95deg, radius: 1.5, mark: (end: ">"), stroke: (paint: purple))
      content((-3.5,1), text(fill: purple)[$R'$])

      set-style(mark: (end: ">>"), stroke: (paint: blue))
      line(points3.at(0),points3.at(1))
      line(points3.at(1),points3.at(2))       
      line(points1.at(0),points1.at(1))
      line(points1.at(1),points1.at(2))
      line((0,6), points3.first())
      line(points3.last(), points1.first())
      line(points1.last(), (8,-4))

      set-style(mark: none, stroke: (paint: red))
      line((0.2,-1.1), (8-0.4,3))
      line((0.2,1.1),(8-0.25,-3))
      line((0.2,5.1),(8-0.2,0.9))
      arc((0.3,-1.05), radius: 1.1, start: -75deg, delta: -210deg)
      arc((8-0.2,1 - 0.09), radius: 1.1, start: -100deg, delta: 210deg)
    }),
    [(a)],
    [],
    [(b)],
  ),
  caption: [Pfad des Roboters (Blau) aus Route $(..., P, Q, ...)$ und daraus resultierende Garnstruktur (Rot) um zwei Umlenkelemente mit korrekter Umlaufrichtung (a) und vertauschter Umlaufrichtung (b)]
)<fig:pfad-zu-muster>


