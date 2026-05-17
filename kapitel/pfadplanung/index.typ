#import "/util.typ": *
#import "@preview/cetz:0.4.2"

= Pfadplanung für den Roboterarm <sec:path-finding>

Nachdem die Reihenfolge der anzufahrenden @UE:pl:long festgelegt wurde, ist im nächsten Schritt der konkrete Bewegungspfad des Roboterarms zu bestimmen. Ziel ist es dabei, das aus dem am Roboter montierten Werkzeug austretende Carbongarn so zu führen, dass es zuverlässig an den @UE:pl haftet und zugleich die gewünschte gleichmäßige Gitterstruktur entsteht.

#include "/kapitel/pfadplanung/01-problemdef.typ"
#include "/kapitel/pfadplanung/02-forschungsstand.typ"
#include "/kapitel/pfadplanung/03-umlaufrichtung.typ"
#include "/kapitel/pfadplanung/04-pfadgenerierung.typ"
#include "/kapitel/pfadplanung/05-kollisionen.typ"
#include "/kapitel/pfadplanung/06-umlenkungsarten.typ"
#include "/kapitel/pfadplanung/07-ergebnisse.typ"