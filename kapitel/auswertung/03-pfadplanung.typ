#import "/util.typ": *
#import "/forschungsfragen.typ": forschungsfragen
#import "@preview/cetz:0.4.2"

/*
Aufbau
1. Ziel und Kontext einordnen (kurz): Fragestellung. Warum ist das Problem wichtig für das Gesamtproblem
2. Bewertung der Lösung
  - funktioniert es? Nur teilweise? Unter Bedingungen?
  - Qualität, Genauigkeit, Effizienz, Robustheit, Skalierbarkeit, Laufzeit
  - Stärken der Lösung
    - Was ist besonders gut? Wo Mehrwert?
    - innovativ, einfache Impl., Performance, ...
  - Schwächen
    - Wo funktioniert es nicht gut? Welche Annahmen? Limitationen? Problematische Randbedingungen?
    - Warum treten diese Schwächen auf?
3. Literaturvergleich
  - Vergleich mit bestehenden Ansätzen
  - Inwiefern besser/schlechter?
4. Verbesserungspotential
  - Weitere Arbeiten
  - Zukunft
  - vielversprechende Ansätze
5. Fazit
  - Zusammenfassung, ob Frage beantwortet wurde
  - Ziele erreicht?
*/

// Kriterien
// - strukturelle anforderungen: erzeugt es eine gute struktur? gibt es fehler?
// - anwendbarkeit: pass es gut in den prozess? wie verständlich/wartbar/erweiterbar ist es?
// - geschwindigkeit: wie schnell ist es?
// - weitere betrachtungen: gibt es dinge zu beachten, caviats? alternativen? 

*Pfadberechnung*

// 1. Ziel und Kontext
Zur Beantwortung der Forschungsfrage (III) "_#forschungsfragen.at(2)_" wurde ein Algorithmus zur Planung eines Pfades entwickelt und implementiert. Dieser generiert Wegpunkte auf Basis der zuvor erstellten Route zwischen den Umlenkelementen. Die Beantwortung der Forschungsfrage ist essentiell für das Hauptproblem, da ohne eine gute Pfadplanung kein Carbongitter vollautomatisiert erstellt werden kann, welches die strukturellen Anforderungen erfüllt.

\

// 2. Bewertung
- vektorbasierte bestimmung der umlaufrichtung besserer ansatz, da stabiler und garantiert richtig, bis auf die ränder
  
- lokale betrachtung des umlenkelements mit position und hauptrichtung der route ausreichend für bestimmung der position und reihenfogle der wegpunkte
  - positionierung der umlenkpunkte geht davon aus, dass noch keine schalungselemente verlegt wurden und der roboter sich somit temporär außerhalb der grenzen der bewehrung bewegen kann
- anpassbar und verständliche vorgehensweise gut für wartung und längeren support
  - auch hinsichtlich eines fensterausschnittes
- kollisionserkennung für UE einfach und effektiv
- kollisionserkennung mit garn ausreichend, aber durch fehlende modellierung des garns unter spannung eventuell nicht genau genug, vorallem bei vollständigen umlenkungen, da dort der pfad ggf näher am rand ist, als es der pfad vermuten lässt
- laufzeit mit wenigen millisekunden vollkommen zweckmäßig
  - anzahl der rollen hat kaum einfluss auf die laufzeit, da die berechnung von wegpunkten nicht auf vorherige wegpunkte zurückgreifen muss und somit theoretisch die wegpunkte an allen @UE parallel berechnet werden kann

// 3. Literaturvergleich
#todo[Vergleich mit Forschungsstand CBT]

// 4. Verbesserungspotential
- an UE, an denen die hauptrichtung wechselt, fehlt definitiv eine regel zur korrekten bestimmung der umlaufrichtung
  - eine sehr lange und deskriptive fallunterscheidung könnte funktionieren, ist aber ggf sehr komplex und wenig anpassbar an zukünftige anforderungen
- ein modell des garns unter spannung könnte die bestimmung der punkte für die höhenverstellung präziser machen
  - der derzeitige ansatz kann schon eine gute näherung an das entstehende garnmuster geben, aber nicht ausreichend um minimale vertikale kräfte auf das garn auszuwirken
    - aber durch die vollständigen umlenkungen an den rändern verlaufen die resultierenden streben nicht ganz dort, wo sie in wirklichkeit liegen werden, was zu fehlern führen kann
  #maybe[Bild einfügen?]
- anwendbarkeit für 3D formen oder wölbungen nicht gesichert und erfordert weitere tests

// 5. Fazit
- innovativer ansatz 
- erzeugt garantiert gleichmäßige gitterstrukturen bis auf die ränder
- garantiert kollisionsfrei mit UE
- nicht garantiert kollisionsfrei mit verlegtem garn aufgrund der unterschiede zwischen approximation und echter garnstruktur
- unter den genannten limitationen kann ff III nur bedingt mit diesem ansatz beantwortet werden
- weitere untersuchungen nötig