#import "@preview/lilaq:0.5.0" as lq

#let geneticX1234 = (
  "csv/large/genetic_1234_X_2026-02-27_23-03-06.csv",
  "csv/large/genetic_1234_X_2026-02-27_23-12-54.csv",
  "csv/large/genetic_1234_X_2026-02-27_23-19-17.csv",
  "csv/large/genetic_1234_X_2026-02-27_23-26-48.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(2).map((it) => it/1000), data.at(1), mark: none, color: rgb("#FF0000"), label: if i==1 [$s_1$]))

#let geneticX8427 = (
  "csv/large/genetic_84273915_X_2026-02-25_23-59-38.csv",
  "csv/large/genetic_84273915_X_2026-02-26_00-07-59.csv",
  "csv/large/genetic_84273915_X_2026-02-26_00-12-36.csv",
  "csv/large/genetic_84273915_X_2026-02-26_00-17-15.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(2).map((it) => it/1000), data.at(1), mark: none, color: rgb("#0000FF"), label: if i==1 [$s_2$]))

#let geneticXFigure = figure(
  lq.diagram(
    legend: (dx: 50%),
    xlabel: [Zeit (s)],
    ylabel: [Kosten],
    ylim: (0,3000),
    xlim: (0, 250),
    xaxis: (format-ticks: (ticks, ..) => ticks.map(str)),
    yaxis: (format-ticks: (ticks, ..) => ticks.map(str)),
    width: 70%,
    ..geneticX1234,
    ..geneticX8427
  ),
  caption: [Ergebnisse GA für Wandkonfiguration $w_3$ (min. Kosten: 390)],
)

#let geneticpuzzleX = (
  "csv/large/geneticpuzzle_1234_X_2026-02-27_22-40-21.csv",
  "csv/large/geneticpuzzle_1234_X_2026-02-27_22-40-32.csv",
  "csv/large/geneticpuzzle_1234_X_2026-02-27_22-40-42.csv",
  "csv/large/geneticpuzzle_1234_X_2026-02-27_22-40-54.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(2), data.at(1), mark: none, color: rgb("#FF0000"), label: if i==1 [$w_3$]))

#let geneticpuzzleY = (
  "csv/large/geneticpuzzle_1234_Y_2026-02-27_22-41-11.csv",
  "csv/large/geneticpuzzle_1234_Y_2026-02-27_22-41-27.csv",
  "csv/large/geneticpuzzle_1234_Y_2026-02-27_22-42-23.csv",
  "csv/large/geneticpuzzle_1234_Y_2026-02-27_22-42-34.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(2), data.at(1), mark: none, color: rgb("#0000FF"), label: if i==1 [$w_4$]))

#let geneticPuzzleFigure = figure(
  lq.diagram(
    legend: (dx: 50%),
    xlabel: [Zeit (ms)],
    ylabel: [Kosten],
    xlim: (0,1500),
    xaxis: (format-ticks: (ticks, ..) => ticks.map(str)),
    width: 70%,
    ..geneticpuzzleX,
    ..geneticpuzzleY
  ),
  caption: [Ergebnisse Puzzle GA für Wandkonfigurationen $w_3$ und $w_4$ mit Seed $s_1$ (min. Kosten: 15/1 und 1/1)],
)


