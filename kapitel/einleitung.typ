#import "/util.typ": *

= Einleitung

#todo[Ganzes Kapitel]
== Motivation
Beton zählt zu den wichtigsten und am weitesten verbreiteten Baustoffen im modernen Wohnungsbau. Schätzungen zufolge werden weltweit jährlich etwa 15 bis 20 Milliarden Kubikmeter Beton verbaut @kaufmannUmweltfreundlicheBetonbauten2021. Dabei dominiert Stahlbeton, bei dem die hohe Zugfestigkeit von Stahl mit der Druckfestigkeit von Beton kombiniert wird @tietzeEcologicalEconomicAdvantages2022. Für die Herstellung von Beton werden jährlich rund 4,2 Milliarden Tonnen Zement als Bindemittel benötigt. Dies führt dazu, dass die Zementproduktion etwa 5 bis 8 % der globalen Treibhausgasemissionen verursacht und damit stärker ins Gewicht fällt als jeder andere Werkstoff @tietzeZurWirtschaftlichenWertschoepfungskette2025.

Hinzu kommt, dass mehr Beton eingesetzt werden muss, als für die reine Tragfähigkeit erforderlich wäre. Dies dient primär dem Schutz der innenliegenden Stahlbewehrung vor Korrosion und Witterungseinflüssen. Neben den dadurch erhöhten $"CO"_2$-Emissionen kommt es auch zu einer begrenzten Lebensdauer von Stahlbetonbauwerken, welche oftmals bereits nach wenigen Jahrzehnten strukturelle Schäden aufweisen.

Textile Bewehrungen sind Alternativen, welche die Rolle der Stahlstreben aus traditionellem Stahlbeton übernehmen. Insbesondere Carbonbewehrungen aus Carbonfasern weisen eine bis zu 8-mal höhere Zugfestigkeit im Vergleich zu Stahl auf @biermannNachhaltigkeitDurchBeton2026. Da diese Materialien nicht rosten, ergeben sich mehrere Vorteile. Zum einen ermöglichen sie leichtere und gleichzeitig tragfähigere Bauteile, wodurch der Betonbedarf reduziert und somit auch die $"CO"_2$-Emissionen gesenkt werden können. Zum anderen kann die Carbonatisierung, also die Reaktion von $"CO"_2$ aus der Umgebungsluft mit den Bestandteilen des Zements, gezielt als Vorteil genutzt werden. Während dieser Prozess bei Stahlbeton aufgrund der Absenkung des alkalischen Milieus zur Korrosion der Bewehrung führt, kann er bei Carbonbewehrung zur dauerhaften Speicherung von Kohlendioxid im Material eingesetzt werden und somit die Umweltbilanz verbessern @biermannNachhaltigkeitDurchBeton2026 @tietzeEcologicalEconomicAdvantages2022.

Analog zu klassischen Stahlbewehrungen soll auch das Carbongarn innerhalb des Betons eine Gitterstruktur bilden, um Zugkräfte sowohl in horizontaler als auch in vertikaler Richtung aufzunehmen. Die automatisierte Herstellung solcher Carbonstrukturen ist eine wesentliche Voraussetzung für die industrielle Skalierung und breite Anwendung von Carbonbeton, wobei gleichzeitig hohe Anforderungen an Qualität und Wirtschaftlichkeit bedient werden.

Vor diesem Hintergrund wurde im Jahr 2022 das Carbonbetontechnikum Leipzig (CBT) als Modellfabrik für Forschung und Entwicklung in Betrieb genommen. Ziel ist es, die gesamte Prozesskette, also von der Herstellung der Carbonbewehrung bis zur Aushärtung des Betons, im Hinblick auf eine industrielle Umsetzung zu untersuchen. Eines der Ziele der dortigen Forschungsgruppe ist die industrielle Umsetzung nachhaltiger und ressourcenschonender Bauweise. Dazu gehört insbesondere das Carbongelege mit minimaler Materialverschwendung vollautomatisiert herzustellen.

Im aktuellen Verfahren erfolgt die Ablage des Carbongarns durch einen Roboterarm, welcher das Carbongarn auf einem speziell konzipierten Rahmen verlegt. Dabei wird es um an den Rändern positionierte zylindrische @UE:pl geführt. Durch eine speziell gewählte Folge von Bewegungen entsteht somit in einem Zug die gewünschte Bewehrungsmatte. Ein Beispiel für ein solches Carbongitter ist in @fig:carbongitter dargestellt.

#figure(
  image("/images/carbongitter.JPG", width: 40%),
  caption: [Foo]
)<fig:carbongitter>

Für einfache Wände ist die Berechnung der erforderlichen Bewegungsabläufe vergleichsweise unkompliziert und entsprechende automatisierte Lösungen sind bereits seit mehreren Jahren im Einsatz. Deutlich komplexer gestaltet sich hingegen die Planung für Wände mit Aussparungen, wie beispielsweise Türen oder Fenster. Die Entwicklung robuster automatisierter Verfahren für solche Wände ist jedoch eine zentrale Voraussetzung, um den Einsatz von Carbonbeton im Wohnungsbau industriell zu skalieren und zu ermöglichen.

== Ziele
- um im cbt und damit auch folgenden werken die automatisierte produktion aller wände, auch mit aussparungen für die tür, zu ermöglichen, müssen methoden zur pfadbestimmung für den roboter erforscht werden 
- um diese zu finden wird das problem in drei teilprobleme aufgeteilt
- als forschungsziel gilt die beantwortung der drei den teilproblemen zugeordneten forschungsfragen
#[
  #set enum(numbering: "(I)")
  + Position der @UE bestimmen
  + Routenplanung zwischen platzierten @UE
  + Pfadfindung für den Roboterarm entlang der berechneten Route
]

- dabei geht es ausschließlich um wände, an denen eine aussparung für eine einzige tür einzuplanen ist
- eine lösung des problems ist eine vollautomatisierte methode zur generierung von carbongittern nach eingabe der gewünschten Dimensionen
- Ansätze müssen, neben ihrer anwendbarkeit und effizienz, auch auf die einbettung im kontext der forschung und entwicklung geprüft werden
- in diesem kontext kann es häufig zu drastischen änderungen der anforderungen kommen
- das interdisziplinäre team muss eigenständig änderungen am vorgehen vornehmen können 
- als ausgabe des zu erforschenden ansatzes sollen eine oder mehrere ausführbare programmdateien für den genutzten kawasaki (modellname) roboterarm generiert werden, welche ohne weitere manuelle zuarbeit ein korrektes carbongitter entstehen lassen

== Methodik

- wissenschaftliches vorgehen zum erreichen der ziele und beantwortung der forschungsfragen
- zur beantwortung der forschungsfragen ist die arbeit in 3 große kapitel untergliedert
- jedes fokussiert sich jeweils auf die beantwortung einer der forschungsfragen
- aufbau immer pro kapitel, jedes problem für sich betrachtet
  + problemdefinition und math. Modellierung des Problems, Eingrenzung, einordnung
  + stand der forschung zum vorliegenden problem mit fortschritten und lücken, ggf. theoretische grundlagen
  + erklärung des gewählten ansatzes/methode
  + ergebnisse darstellen, performance und resultate, fehler (alles objektiv)
- anschließend (teilweise subjektive) auswertung um zu bewerten, ob ergebnisse der untersuchungen das ziel der arbeit erfüllen
- fazit und ausblick