#import "/util.typ": *

= Pfadfindung für Roboterarm <sec:path-finding>

== Problemdefinition
- nach route muss berechnet werden, wie der roboter fahren muss, um die gewünschte struktur zu erzeugen
- dazu gehören u.A.: kollisionen vermeiden, garnhaftung an den rollen sicherstellen

// Werkzeug
- werkzeug ist eine außermittig angebrachte, aufrecht stehende rolle über die das getränkte garn abgewickelt wird
  - auch wenn sich die rolle um den werkzeugmittelpunkt drehen kann, ist für den roboterarm die werkzeugposition starr
  - #todo[ Bild einfügen]
- abstände zu @UE müssen eingehalten werden, damit werkzeug sich drehen kann und nicht in kontakt mit @UE kommt

- für haftung und gleichmäßigkeit des gitters essentiell: in welcher umlaufrichtung um rollen fahren
-   uhrzeigersinn (R') oder entgegen (R)
- falsche berechnung kann zu fehlerhaftem muster, kollisionen oder auslassungen führen
  - #todo[ Bild einfügen: falsche umlenkung um rolle, gute umlenkung um rolle, ähnlich zu #cite(<merschAutomation3DRobotic2025>, form: "prose", supplement: [S.7])]

== Stand der Forschung
- in string art @birsakStringArtComputational2018 gehen keine bestimmungen der pfade des roboters hervor
  - keine hindernisse, da die form konvex ist
  - umlaufrichtung ist bei diesen schmalen nägeln praktisch irrelevant, da in beiden richtungen ein fast identisches bild erzeugt werden würde
- die bestimmung der umlaufrichtung um die pins für 3d skelette nach @merschAutomation3DRobotic2025 können die gewonnenen erkenntnisse für das vorliegende problem teilweise appliziert werden
  - ergebnisse der anwendung werden in @sec:path-direction näher betrachtet
- die anforderung an gleichmäßige und flächenfüllende gitter erfordert allerdings weitere betrachtungen #todo[ ähnliche literatur für fehlendes?]
  
== Bestimmung der Umlaufrichtung <sec:path-direction>
// Umlaufrichtung: Bestimmung durch Vektor 
- für die bestimmung der umlaufrichtung wird unterschieden in gewöhnliche umlenkungen, wie sie bei den meisten @UE vollzogen wird, und den besonderen umlenkungen wie sie z.B. beim wechsel zwischen horizontalen und vertikalen streben vorgenommen wird, zumeist an den ecken der wand oder tür
  - math. Definition für Herzumlenkung, besserer Name?
- gewöhnliche umlenkungen: 2 ansätze zur bestimmung der umlaufrichtung, erste ist vektorbasiert nach @merschAutomation3DRobotic2025
- math. Definition
  - seien ein knotentripel $A, B "und" C$ aus der route
  - zur bestimmung der umlaufrichtung um B wird das Kreuzprodukt aus dem Vektor von A nach B und dem #todo[(C-A?)] gebildet
  - #todo[ math. Definition kreuzprodukt]
  - das vorzeichen verrät die seite von C relativ zur geraden $overline("AB")$
  - ist C rechts von $overline("AB")$ benötigt es eine umdrehung im uhrzeigersinn, links davon entgegen des uhrzeigersinns
  - unabhängig von winkel im raum von $overline("AB")$

// Umlaufrichtung: Bestimmung durch Umdrehen 
- andererseits bestimmung durch knotenfärbung
- bei jeder normalen umlenkung ändert sich die umlaufrichtung
- modellierung als 2-Färbung des durch den pfad aufgespannten Graphen, 1 Farbe für eine Umlaufrichtung
- ist stabil während normaler umlenkungen, aber korrekte initiale umlaufrichtung ist notwendig, da sonst das gesamte muster bis zu einer sonderumlenkung fehlerhaft wird
  -  2-färbung nur in den teilgraphen zwischen den sonderumlenkungen 

// Besondere Umlenkungen
- beide ansätze versagen beim wechsel zwischen den in @sec:route-puzzle-based definierten bereichen
- müssen gesondert betrachtet werden
  - herzumlenkungen: pausieren des wechsels und volle umkreisungen machen
    - #todo[ bild einfügen]
  - problem: bei manchen fällen nicht trivial entscheidbar, wann es ein sonderfall ist und wann nicht
- #todo[ lösung?]

// Pfad um die UE herum
- zur bestimmung des tatsächlichen pfades mithilfe der route und der umlaufrichtung:
  - modellierung durch liste von anzufahrenden punkten, an denen keine @UE liegen
- jede @UE hat jeweils einen ein- und ausgangspunkt
  - mittelpunkt dazwischen erzeugt dann den bogen
  - bestimmt durch position und den vorherigen und nachfolgenden knoten aus der route
  - bsp.: rolle $i$ an rechter seite der wand mit vorgänger $i-1$ und nachfolger $i+1$, wobei $y_i = y_(i-1) + 1$
    - mittelpunkt bei $(x_i+1, y_i)$, eingang bei $y_(i-1)$, ausgang bei $y_(i+1)$
- dadurch entsteht punkttripel
  - laufrichtung um rolle gibt an, ob reihenfolge des tripels invertiert wird oder nicht
  - zu beachten: position des mittelpunktes kann auch umlaufrichtung flippen
    - bsp: oben nach unten, mittelpkt rechts: im uhrzeigersinn, mittelpkt links: entgegen uhrzeigersinn
- punkttripel wird an bestehenden pfad angehängt



== Kollisionen
// Problemdefinition
- bei manchen verbindungen zwischen 2 @UE kann es zu kollisionen mit anderen @UE kommen, da sie zwischen start und zielpunkt eines berechneten teils des pfades liegen
- durch entstehendes zickzack-muster würde der roboter bei den streben nahe der Tür mit deren @UE kollidieren
  - das geschieht daher, dass #todo[ math.beschreibung für streben nahe der tür] MAYBE bild?
  - aber auch an den rändern der wand kann es passieren
- auch mit bereits verlegtem garn kann das ablagewerkzeug kollidieren, im garn festhängen und dann das gitter zerreißen 

// Volle umlenkungen
- für eine einfache und generalisierbare methode kann das knotentripel um zwei punkte erweitert werden
  - diese punkte haben gleiche x- und y-Koordinaten und ersetzen den ein- und ausgangspunkt, sodass eine ganze umkreisung des knotens gefahren wird
  - durch die spannung des garns wird es dennoch ordnungsgemäß verlegt
  - diese neuen punkte werden in hauptlaufrichtung in höhe des äußeren knotens gelegt, beispiel in folgendem bild
  - #todo[ bild einfügen]

// Weitere Kollisionen erkennen und beheben
- #todo[ math. Beschreibung, wann kollision]
- gefundene kollisionen beheben, indem ein neuer punkt in richtung des verbindungsvektors und passender distanz in den pfad eingereiht
- iterativ kollisionen erkennen, dann beheben und erneut überprüfen, ob neue kollisionen dazu gekommen sind


// Kollisionen mit bereits gelegtem Garn
- zur kollisionsvermeidung mit bereits verlegtem garn
  - erster und letzter punkt werden dupliziert und z komponente so angepasst, dass der roboter auf der höheren ebene zum ersten punkt fährt, dann senkrecht nach unten, die umlenkung über den mittelpunkt und dann wieder auf die obere ebene fährt, um zur nächsten @UE zu gelangen
  - mit z-Achse in positiver richtung vom Boden: \
    $(p_1,p_2,p_3)|-> (p'_1,p_1,p_2,p_3,p'_3) "mit" p'_1_((z)) = p'_3_((z)) > p_1_((z)) = p_2_((z)) = p_3_((z))$
- MAYBE pseudo code einfügen?