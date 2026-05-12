#import "/util.typ": *
#import "@preview/cetz:0.4.2"

== Arten von Umlenkungen

Aus den vorangegangenen Betrachtungen ergeben sich vier verschiedene Arten von Umlenkbewegungen, welche in @fig:umlenkungsarten zusammenfassend dargestellt sind.

#figure(
  cetz.canvas({
    import cetz.draw: *

    scale(0.5)
    set-style(mark: (end: ">"))

    let pointsNormalRotation = ((0,4),(0,1),(1,0),(2,1),(2,4))
    circle((1,1), radius: 0.5)
    for i in range(pointsNormalRotation.len()-1) {
      line(pointsNormalRotation.at(i), pointsNormalRotation.at(i+1))
    }
    content((1,-2.4), [(1) Normal])

    translate(x: 6)

    let pointsFullRotation = ((0.8,4),(1,2),(0,1),(1,0),(2,1),(1,2),(1.2,4))
    circle((1,1), radius: 0.5)
    for i in range(pointsFullRotation.len()-1) {
      line(pointsFullRotation.at(i), pointsFullRotation.at(i+1))
    }
    content((1,-2.5), [(2) Vollständig])

    translate(x: 8)

    let pointsSpecialRotation = ((0.5,4),(0.9,1.9),(0,1),(1,0),(2,1),(3,2),(2,3),(1.1,2.1),(-1,2))
    circle((1,1), radius: 0.5)
    circle((2,2), radius: 0.5)
    for i in range(pointsSpecialRotation.len()-1) {
      line(pointsSpecialRotation.at(i), pointsSpecialRotation.at(i+1))
    }
    content((1,-2.5), [(3) Sonderumlenkung])

    translate(x: 7)

    let pointsCornerRotation = ((4,2),(2,2),(0,2),(0,0),(2,0),(2,2),(2,4))
    circle((1,1), radius: 0.5)
    for i in range(pointsCornerRotation.len()-1) {
      line(pointsCornerRotation.at(i), pointsCornerRotation.at(i+1))
    }
    content((1,-2.5), [(4) Ecke])
  }),
  caption: [Die vier verschiedenen Umlenkungsarten, welche je nach Position des UE ausgewählt werden (eigene Darstellung)]
)<fig:umlenkungsarten>

Normale Umlenkungen (1) werden dabei verwendet, um bei gleichbleibender Hauptrichtung einen Wechsel der Nebenrichtung zu vollziehen und somit eine vertikale oder horizontale Strebe zu verlegen. Diese Art der Umlenkung wird insbesondere dann eingesetzt, wenn sich Vorgänger- und Zielknoten in direkt benachbarten Spalten oder Zeilen befinden, also $Delta x = 1 xor Delta y = 1$ gilt.

Vollständige beziehungsweise volle Umlenkungen (2) kommen an den Enden von Teilrouten zum Einsatz, wenn eine Änderung der Hauptrichtung erfolgt und an der entsprechenden Ecke keine Sonderstelle besteht. So wird beispielsweise in @fig:pfad-garnannaeherung beim Übergang von $R V$ zu $R H^R$ jeweils eine Sonderumlenkung bei @UE 20 als Ende von $R V$ sowie eine am Beginn von $R H ^R$ bei @UE 62 eingesetzt, da zwischen beiden Teilrouten eine Änderung der Hauptrichtung stattfindet. Diese Art der Umlenkung ermöglicht ein kollisionsfreies Anfahren der Kreisbahn mit doppeltem Radius eines Umlenkelements, sodass die Richtungsänderung sicher ausgeführt werden kann. Ebenfalls wird diese Umlenkung bei dem @UE unmittelbar über dem Türausschnitt auf Höhe $y=ty1-1$ eingesetzt, also in @fig:pfad-garnannaeherung bei dem pink markiertem @UE 27, um eine Kollision mit den @UE des Türausschnittes zu verhindern. Zuletzt wird auf diese Umlenkung als Standardumlenkung zurückgegriffen, falls die Art der Umlenkung nicht anhand der Position des @UE durch andere Regeln bestimmt werden konnte. In @appendix:wandkonfigurationen ist das beim @UE 6 in Wand 27 zu sehen, da dort eine Navigation von @UE 60 auf @UE 6 erfolgt, welche sich in derselben Spalte befinden.

Sonderumlenkungen (3) werden ähnlich wie vollständige Umlenkungen ebenfalls an den Enden von Teilrouten bei einer Hauptrichtungsänderung eingesetzt. Dies geschieht jedoch ausschließlich dann, wenn die angrenzenden @UE eine Sonderstelle bilden und der Roboter somit nicht mit dem Werkzeug zwischen beiden @UE hindurch fahren kann. In @fig:pfad-garnannaeherung ist eine solche Umlenkung beispielsweise bei den @UE 20 und 0 erforderlich. Grundsätzlich werden hierbei zwei vollständige Umlenkungen durchgeführt, wobei der letzte Wegpunkt des ersten sowie der erste Wegpunkt des zweiten anzufahrenden Umlenkelements entfernt werden, um eine Kollision des Werkzeugs zwischen den @UE zu vermeiden.

Eckumlenkungen (4) werden eingesetzt, wenn es sich bei dem @UE um ein optionales @UE in einer der vier Wandecken oder in einer der beiden unteren Türecken handelt. Diese Art der Umlenkung ähnelt prinzipiell der vollständigen Umlenkung. Der Unterschied besteht jedoch darin, dass sich die Punkte für das kollisionsfreie Anfahren in den diagonal gegenüberliegenden Ecken der angrenzenden acht Felder befinden und nicht direkt oberhalb, unterhalb, links oder rechts des Mittelpunkts des @UE.

Um die Programmdateien für den Roboterarm zu erzeugen, werden je nach Umlenkungsart die einzelnen Wegpunkte als Koordinaten für die Bewegungsmuster des Roboterarms genutzt. So wird beispielsweise der erste Wegpunkt linear angefahren und anschließend die weiteren Punkte mit speziellen Anweisungen für Kreisbewegungen verknüpft, um die Programmzeilen der Gesamtbewegung zu bilden. In @appendix:robotcode ist exemplarisch für eine Wandkonfiguration der erzeugte Code sowie eine Abbildung des resultierenden Pfades des Werkzeugmittelpunkts in der Simulationssoftware dargestellt. 

