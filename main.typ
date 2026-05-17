#import "template.typ": *
#import "abstract.typ": abstract

#show: htwk-thesis.with(
  name: [Sosedow],
  vorname: [Tom],
  gebdatum: [29.03.1999],
  ort: [Jena],
  betreuer: [Prof. Dr. rer. nat. habil. Martin Grüttmüller],
  betreuer2: [M.Sc. Felix Tröger],
  thema: text(hyphenate: false)[Entwicklung und Evaluation von Algorithmen zur Routenplanung unter strukturellen und umgebungsbedingten Restriktionen im Carbonbetonbau],
  datum: [18.05.2026],
  abschluss: "msc",
  studiengang: [Informatik],
  fakultaet: [Fakultät Informatik und Medien],
  use-default-math-env: true,
  signature: image("assets/unterschrift.jpg", width: 80pt),
  zusammenfassung: abstract
)

#include "kapitel/einleitung.typ"
#include "kapitel/ue-platzierung/index.typ"
#include "kapitel/routenplanung/index.typ"
#include "kapitel/pfadplanung/index.typ"
#include "kapitel/auswertung/index.typ"
#include "kapitel/zsmfassung-ausblick.typ"

#bibliography("refs.bib", style: "american-psychological-association")

#include "appendix.typ"