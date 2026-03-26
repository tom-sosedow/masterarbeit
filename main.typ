#import "template.typ": *

#show: htwk-thesis.with(
  name: [Sosedow],
  vorname: [Tom],
  gebdatum: [29.03.1999],
  ort: [Jena],
  betreuer: [Prof. Dr. rer. nat. habil. Martin Grüttmüller],
  betreuer2: [M.Sc. Felix Tröger],
  matrikelnummer: [82017],
  thema: [Entwicklung und Evaluation von Algorithmen zur Routenplanung unter strukturellen und umgebungsbedingten Restriktionen im Carbonbetonbau],
  datum: [18.05.2026],
  abschluss: "msc",
  studiengang: [Informatik],
  fakultaet: [Fakultät Informatik und Medien],
  use-default-math-env: true,
)

#show table.cell: set text(size: 10pt)
#set text(size: 12pt, font: font)

#include "kapitel/einleitung.typ"
#include "kapitel/ue-platzierung.typ"
#include "kapitel/routenplanung/index.typ"
#include "kapitel/pfadfindung.typ"
#include "kapitel/auswertung.typ"

#bibliography("refs.bib", style: "american-psychological-association")