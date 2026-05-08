#import "/util.typ": *

#let appendix(body) = {
  heading([Anhang], outlined: false, numbering: none)
  v(-4em)
  set heading(
    numbering: num => {
      "Anhang " + numbering("A", num)
    }, 
    supplement: [Anhang],
    
  )
  show figure: it => {
    v(-1.5em)
    it
    v(0.5em)
  }
  counter(heading).update(0)
  body
}


#show: appendix

#heading([Ergebnisse für alle Wandkonfigurationen ],numbering: "A") <appendix:wandkonfigurationen>

#let dimens = range(0,6, step:5).map(dw => {
                range(0,6, step:5).map(dh => {
                  range(0,6, step:5).map(w => {
                    range(0,6, step:5).map(h => {
                      range(0,6, step:5).map(dx => {
                        (w: 210+w, h:105+h, dw: 50+dw, dh: 70+dh, dx: 75+dx)
                      })
                    }).flatten()
                  }).flatten()
                }).flatten()
              }).flatten()

#let perms = (
[($"LH"$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$, $"TH"^R$)],
[($"LH"^R$, $"TH"^R$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$)],
[($"LH"$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$, $"TH"^R$)],
[($"LH"$, $"O"$, $"LV"$, $"TV"$, $"RV"$, $"TH"$, $"RH"$)],
[($"LH"$, $"LV"$, $"TV"$, $"RV"$, $"TH"$, $"RH"$)],
[($"LH"^R$, $"TH"^R$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$)],
[($"LH"$, $"LV"$, $"TV"$, $"RV"$, $"TH"$, $"RH"$)],
[($"LH"$, $"O"$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$, $"TH"^R$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LV"^R$, $"TH"$, $"LH"$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LV"^R$, $"TH"$, $"LH"$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LV"^R$, $"LH"^R$, $"TH"^R$)],
[($"LH"$, $"O"$, $"LV"$, $"TV"$, $"RV"$, $"TH"$, $"RH"$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LV"^R$, $"TH"$, $"LH"$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LV"^R$, $"TH"$, $"LH"$)],
[($"RH"^R$, $"TH"^R$, $"RV"^R$, $"TV"^R$, $"LV"^R$, $"LH"^R$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LV"^R$, $"TH"$, $"LH"$)],
[($"LH"$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$, $"TH"^R$)],
[($"LH"^R$, $"TH"^R$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$)],
[($"LH"$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$, $"TH"^R$)],
[($"LH"$, $"O"$, $"LV"$, $"TV"$, $"RV"$, $"TH"$, $"RH"$)],
[($"LH"$, $"LV"$, $"TV"$, $"RV"$, $"TH"$, $"RH"$)],
[($"LH"^R$, $"TH"^R$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$)],
[($"LH"$, $"LV"$, $"TV"$, $"RV"$, $"TH"$, $"RH"$)],
[($"LH"$, $"O"$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$, $"TH"^R$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LH"^R$, $"TH"^R$, $"LV"$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LH"^R$, $"TH"^R$, $"LV"$)],
[($"LH"$, $"O"$, $"LV"$, $"TV"$, $"RV"$, $"TH"$, $"RH"$)],
[($"LH"$, $"LV"$, $"TV"$, $"RV"$, $"RH"^R$, $"TH"^R$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LH"^R$, $"TH"^R$, $"LV"$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LH"^R$, $"TH"^R$, $"LV"$)],
[($"RH"$, $"RV"^R$, $"TV"^R$, $"LH"^R$, $"TH"^R$, $"LV"$)],
[($"LH"$, $"LV"$, $"TV"$, $"RV"$, $"TH"$, $"RH"$)],
[($"LH"$, $"O"$, $"LV"$, $"TV"$, $"RV"$, $"TH"$, $"RH"$)],
)

#let get_descrip = i => {
  let dim = dimens.at(i)
  [
    $w_h^*=#dim.h$cm, $w_b^*=#dim.w$cm, $t_h^*=#dim.dh$cm, $t_b^*=#dim.dw$cm, $t_x^*=#dim.dx$cm, $p=2,5$cm \
    Route: #perms.at(i)
  ]
}

Im Folgenden sind die Ergebnisse der besten Lösungsansätze der drei Teilprobleme für alle 32 Wandkonfigurationen dargestellt. Die Positionen der @UE:pl:long wurden mithilfe des in @sec:ue-place vorgestellten iterativen Ansatz berechnet. Darauf aufbauend erfolgte die Routenplanung durch einen Brute-Force Algorithmus auf Basis der Modellierung mittels Teilrouten aus @sec:route-puzzle-based-exact. Schließlich wurde die in @sec:path-finding vorgestellte Pfadplanung genutzt, um aus der Route einen validen Pfad in Form einer Liste von Wegpunkten zu generieren. Die Annäherung an das unter Spannung verlegte Garn ist in halbtransparentem Rot dargestellt.

Zu jedem der Ergebnisse sind unterhalb des Bildes die genauen Maße angegeben, die als parametrische Anforderungen an den Algorithmus übergeben wurden, sowie die berechnete Abfolge von Teilrouten aus @sec:route-puzzle-based. 

#for i in range(0,31) {
  figure(
    outlined: false,
    stack(
      dir: ttb, 
      image("images/appendix/all-walls/wall-" + str(34+i) + ".png", width: 120%),
      [Wand #{i+1}: #get_descrip(i)]
    ),
  )
}

#heading([Ergebnisse des praktischen Tests],numbering: "A") <appendix:robotcode>


Nachfolgend sind die Ergebnisse des praktischen Tests hinterlegt. Getestet wurde Wandkonfiguration 5 aus @appendix:wandkonfigurationen mit kleineren Maßen. Es erfolgte ebenfalls keine Harztränkung des Garns, sodass sich die Reibung des Garns an den @UE im Vergleich zum realen Einsatz unterscheidet. In @fig:praktischer-test-garn ist die resultierende Garnstruktur des Tests dargestellt. 

#figure(
  image("images/praktischer-test-garn.jpg"),
  caption: [Resultierendes Carbongitter des praktischen Tests von Wandkonfiguration 5 aus @appendix:wandkonfigurationen.]
)<fig:praktischer-test-garn>

#todo[Bild der Simulation einfügen, wie der Robi fährt]

Der für diese Wand generierte Programmcode für einen Kawasaki BX130X ist im Folgenden dargestellt. Das Programm #text(font: "FreeMono", hyphenate: false)[Rollenablage] beinhaltet die Platzierung der @UE und das Programm #text(font: "FreeMono", hyphenate: false)[Garnablage] die Garnablage.

#show raw: set text(font: "FreeMono")

#raw(read("/assets/rd_program.pg"), syntaxes: "/assets/KawasakiPG.sublime-syntax")

\

\

#raw(read("/assets/yd_program.pg"), syntaxes: "/assets/KawasakiPG.sublime-syntax")