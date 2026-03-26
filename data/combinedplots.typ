#import "largeplots.typ": *
#import "smallplots.typ": *

#let combinedBYFigure = figure(
  stack(
    dir: ltr,
    spacing: 5%,
    lq.diagram(
      title: [Wandkonf. $w_2$],
      legend: none,
      xlabel: [Zeit (s)],
      ylabel: [Kosten],
      xlim: (0, 15),
      ylim: (0, 1000),
      yaxis: (format-ticks: (ticks, ..) => ticks.map(str)),
      width: 40%,
      ..geneticB1234,
      ..geneticB8427
    ),
    lq.diagram(
      title: [Wandkonf. $w_3$],
      legend: (dx: 50%),
      xlabel: [Zeit (s)],
      ylabel: [Kosten],
      ylim: (0,3000),
      xlim: (0, 250),
      xaxis: (format-ticks: (ticks, ..) => ticks.map(str)),
      yaxis: (format-ticks: (ticks, ..) => ticks.map(str)),
      width: 60%,
      ..geneticX1234,
      ..geneticX8427
    ),
  ),
  caption: [Ergebnisse für GA für Wandkonfiguration $w_2$ und $w_3$ mit Seeds $s_1$ und $s_2$]
)