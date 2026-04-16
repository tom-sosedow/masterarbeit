#import "@preview/lilaq:0.5.0" as lq

#let backtrackA = (
  "csv/small/backtrack_A_parallel_2026-02-25_19-54-10.csv",
  "csv/small/backtrack_A_parallel_2026-02-25_20-05-33.csv",
  "csv/small/backtrack_A_parallel_2026-02-25_20-07-18.csv",
  "csv/small/backtrack_A_parallel_2026-02-25_21-13-29.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(0).map((it) => it/1000), mark: none, data.at(2), color: rgb("#FF0000"), label: if i==1 [$w_1$]))

#let backtrackB = (
  "csv/small/backtrack_B_parallel_2026-02-25_20-08-13.csv",
  "csv/small/backtrack_B_parallel_2026-02-25_20-11-26.csv",
  "csv/small/backtrack_B_parallel_2026-02-25_20-17-49.csv",
  "csv/small/backtrack_B_parallel_2026-02-25_21-04-52.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(0).map((it) => it/1000), mark: none, data.at(2), color: rgb("#0000FF"), label: if i==1 [$w_2$]))

#let backtrackABFigure = figure(
  lq.diagram(
    legend: (dx: 50%),
    xlabel: [Zeit (s)],
    ylabel: [Kosten],
    width: 70%,
    ..backtrackA,
    ..backtrackB
  ),
  caption: [Ergebnisse Backtracking für Wandkonfigurationen $w_1$ und $w_2$ (min. Kosten jeweils 1)],
)

#let geneticBGen = (
  "csv/small/genetic_1234_B_2026-02-25_17-30-50.csv",
  "csv/small/genetic_1234_B_2026-02-25_17-31-44.csv",
  "csv/small/genetic_1234_B_2026-02-25_17-33-39.csv",
  "csv/small/genetic_1234_B_2026-02-25_17-34-37.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(0), data.at(1), mark: none, color: rgb("#0000FF"), label: if i==1 [$w_2$]))

#let geneticBGenFigure = figure(
  lq.diagram(
    legend: (dx: 50%),
    xlabel: [Generation],
    ylabel: [Kosten],
    xaxis: (format-ticks: (ticks, ..) => ticks.map(str)),
    yaxis: (format-ticks: (ticks, ..) => ticks.map(str)),
    xlim: (0,500),
    width: 70%,
    ..geneticBGen,
  ),
  caption: [Ergebnisse GA für Wandkonfiguration $w_2$ (min. Kosten 21 nach 411 Generationen)],
)

#let geneticB1234 = (
  "csv/small/genetic_1234_B_2026-02-25_17-30-50.csv",
  "csv/small/genetic_1234_B_2026-02-25_17-31-44.csv",
  "csv/small/genetic_1234_B_2026-02-25_17-33-39.csv",
  "csv/small/genetic_1234_B_2026-02-25_17-34-37.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(2).map((it) => it/1000), data.at(1), mark: none, color: rgb("#FF0000"), label: if i==1 [$s_1$]))

#let geneticB8427 = (
  "csv/small/genetic_84273915_B_2026-02-25_17-35-46.csv",
  "csv/small/genetic_84273915_B_2026-02-25_17-37-17.csv",
  "csv/small/genetic_84273915_B_2026-02-25_17-38-21.csv",
  "csv/small/genetic_84273915_B_2026-02-25_17-39-23.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(2).map((it) => it/1000), data.at(1), mark: none, color: rgb("#0000FF"), label: if i==1 [$s_2$]))

#let geneticBFigure = figure(
  lq.diagram(
    legend: (dx: 50%),
    xlabel: [Zeit (s)],
    ylabel: [Kosten],
    xlim: (0, 15),
    ylim: (0, 1000),
    yaxis: (format-ticks: (ticks, ..) => ticks.map(str)),
    width: 70%,
    ..geneticB1234,
    ..geneticB8427
  ),
  caption: [Ergebnisse GA für Wandkonfiguration $w_2$ mit Seed $s_1$ und $s_2$ (min. Kosten: 21 bzw. 23)],
)

#let geneticpuzzleA = (
  "csv/small/geneticpuzzle_1234_A_2026-02-27_16-05-59.csv",
  "csv/small/geneticpuzzle_1234_A_2026-02-27_16-06-33.csv",
  "csv/small/geneticpuzzle_1234_A_2026-02-27_16-06-40.csv",
  "csv/small/geneticpuzzle_1234_A_2026-02-27_16-06-50.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(2), data.at(1), mark: none, color: rgb("#FF0000"), label: if i==1 [$w_1$]))

#let geneticpuzzleB = (
  "csv/small/geneticpuzzle_1234_B_2026-02-27_16-10-51.csv",
  "csv/small/geneticpuzzle_1234_B_2026-02-27_16-11-00.csv",
  "csv/small/geneticpuzzle_1234_B_2026-02-27_16-11-09.csv",
  "csv/small/geneticpuzzle_1234_B_2026-02-27_16-11-16.csv"
).map((fileName) => lq.load-txt(read(fileName), skip-rows: 1)).enumerate(start: 1).map(((i, data)) => lq.plot(data.at(2), data.at(1), mark: none, color: rgb("#0000FF"), label: if i==1 [$w_2$]))

#let geneticPuzzleABFigure = figure(
  lq.diagram(
    legend: (dx: 50%),
    xlabel: [Zeit (ms)],
    ylabel: [Kosten],
    xlim: (0,800),
    xaxis: (format-ticks: (ticks, ..) => ticks.map(str)),
    width: 70%,
    ..geneticpuzzleA,
    ..geneticpuzzleB
  ),
  caption: [Ergebnisse Puzzle GA für Wandkonfigurationen $w_1$ und $w_2$ mit Seed $s_1$ (min. Kosten: 1 und 0)],
)