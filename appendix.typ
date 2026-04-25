#let appendix(body) = {
  set heading(numbering: none, supplement: [Anhang])
  pagebreak()
  [= Anhang] 
  v(-4em)

  set heading(numbering: "A", supplement: [Anhang])
  show figure: it => {
    v(-1.5em)
    it
    v(0.5em)
  }
  counter(heading).update(0)
  body
}


#show: appendix

= Ergebnisse für alle Wandkonfigurationen <appendix:wandkonfigurationen>

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