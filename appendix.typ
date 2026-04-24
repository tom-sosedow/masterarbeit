

#show figure: it => {
  v(-1.5em)
  it
  v(0.5em)
}

#heading([Anhang], level: 1, numbering: none)
#heading([Anhang I: Ergebnisse für alle Wandkonfigurationen], level: 2, numbering: none)

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

#let get_descrip = i => {
  let dim = dimens.at(i)
  [
    $w_h^*=#dim.h$cm, $w_b^*=#dim.w$cm, $t_h^*=#dim.dh$cm,\    
    $t_b^*=#dim.dw$cm, $t_x^*=#dim.dx$cm, $p=2,5$cm
  ]
}

Im Folgenden sind die Ergebnisse der besten Lösungsansätze der drei Teilprobleme für alle 32 Wandkonfigurationen dargestellt. Die Positionen der @UE:pl:long wurden mithilfe des in @sec:ue-place vorgestellten iterativen Ansatz berechnet. Darauf aufbauend erfolgte die Routenplanung durch einen Brute-Force Algorithmus auf Basis der Modellierung mittels Teilrouten aus @sec:route-puzzle-based-exact. Schließlich wurde die in @sec:path-finding vorgestellte Pfadplanung genutzt, um aus der Route einen validen Pfad in Form einer Liste von Wegpunkten zu generieren.

Zu jedem der Ergebnisse sind unterhalb des Bildes die genauen Maße angegeben, die als parametrische Anforderungen an den Algorithmus übergeben wurden. 

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