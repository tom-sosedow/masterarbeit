
#set page(
  numbering: none,
)
#show figure: it => {
  v(-1.5em)
  it
  v(0.5em)
}

#heading([Anhang], outlined: false, level: 1, numbering: none)
#heading([Anhang I: Ergebnisse für alle Wandkonfigurationen], outlined: false, level: 2, numbering: none)

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

#for i in range(0,31, step: 2) {
  figure(
    outlined: false,
    stack(
      dir: ltr,
      spacing: -4%,
      stack(dir: ttb, image("images/appendix/all-walls/wall-" + str(34+i) + ".png", width: 68%),[Wand #{i+1}: #get_descrip(i)]),
      stack(dir: ttb, image("images/appendix/all-walls/wall-" + str(34+i+1) + ".png", width: 68%),[Wand #{i+2}: #get_descrip(i+1)]),
    ),
  )
}