#import "/util.typ": *
#import "/forschungsfragen.typ": forschungsfragen
= Einleitung

== Motivation
Beton zählt zu den wichtigsten und am weitesten verbreiteten Baustoffen im modernen Wohnungsbau. Schätzungen zufolge werden weltweit jährlich etwa 15 bis 20 Milliarden Kubikmeter Beton verbaut @kaufmannUmweltfreundlicheBetonbauten2021. Dabei dominiert Stahlbeton, bei dem die hohe Zugfestigkeit von Stahl mit der Druckfestigkeit von Beton kombiniert wird @tietzeEcologicalEconomicAdvantages2022. Für die Herstellung von Beton werden jährlich rund 4,2 Milliarden Tonnen Zement als Bindemittel benötigt. Dies führt dazu, dass die Zementproduktion etwa 5 bis 8 % der globalen Treibhausgasemissionen verursacht und damit stärker ins Gewicht fällt als jeder andere Werkstoff @tietzeZurWirtschaftlichenWertschoepfungskette2025.

Hinzu kommt, dass mehr Beton eingesetzt werden muss, als für die reine Tragfähigkeit erforderlich wäre. Dies dient primär dem Schutz der innenliegenden Stahlbewehrung vor Korrosion und Witterungseinflüssen. Neben den dadurch erhöhten $"CO"_2$-Emissionen kommt es auch zu einer begrenzten Lebensdauer von Stahlbetonbauwerken, welche oftmals bereits nach wenigen Jahrzehnten strukturelle Schäden aufweisen.

Textile Bewehrungen sind Alternativen, welche die Rolle der Stahlstreben aus traditionellem Stahlbeton übernehmen. Insbesondere Carbonbewehrungen aus Carbonfasern weisen eine bis zu 8-mal höhere Zugfestigkeit im Vergleich zu Stahl auf @biermannNachhaltigkeitDurchBeton2026. Da diese Materialien nicht rosten, ergeben sich mehrere Vorteile. Zum einen ermöglichen sie leichtere und gleichzeitig tragfähigere Bauteile, wodurch der Betonbedarf reduziert und somit auch die $"CO"_2$-Emissionen gesenkt werden können. Zum anderen kann die Carbonatisierung, also die Reaktion von Kohlendioxid aus der Umgebungsluft mit den Bestandteilen des Zements, gezielt als Vorteil genutzt werden. Während dieser Prozess bei Stahlbeton aufgrund der Absenkung des alkalischen Milieus zur Korrosion der Bewehrung führt, kann er bei Carbonbewehrung zur dauerhaften Speicherung von Kohlendioxid im Material eingesetzt werden und somit die Umweltbilanz verbessern @biermannNachhaltigkeitDurchBeton2026 @tietzeEcologicalEconomicAdvantages2022.

Analog zu klassischen Stahlbewehrungen soll auch das Carbongarn innerhalb des Betons eine Gitterstruktur bilden, um Zugkräfte sowohl in horizontaler als auch in vertikaler Richtung aufzunehmen. Die automatisierte Herstellung solcher Carbonstrukturen ist eine wesentliche Voraussetzung für die industrielle Skalierung und breite Anwendung von Carbonbeton, wobei gleichzeitig hohe Anforderungen an Qualität und Wirtschaftlichkeit bedient werden.

Vor diesem Hintergrund wurde im Jahr 2022 das @CBT als Modellfabrik für Forschung und Entwicklung in Betrieb genommen. Ziel ist es, die gesamte Prozesskette, also von der Herstellung der Carbonbewehrung bis zur Aushärtung des Betons, im Hinblick auf eine industrielle Umsetzung zu untersuchen. Eines der Ziele der dortigen Forschungsgruppe ist die industrielle Umsetzung nachhaltiger und ressourcenschonender Bauweise. iDazu gehört insbesondere das Carbongelege mit minimaler Materialverschwendung vollautomatisiert herzustellen.

Im aktuellen Verfahren erfolgt die Ablage des Carbongarns durch einen Roboterarm, welcher das Carbongarn auf einem speziell konzipierten Rahmen verlegt. Dabei wird es um an den Rändern positionierte zylindrische @UE:pl geführt. Durch eine speziell gewählte Folge von Bewegungen entsteht somit in einem Zug die gewünschte Bewehrungsmatte. Ein Beispiel für ein solches Carbongitter ist in @fig:carbongitter dargestellt.

#figure(
  grid(
    columns: (auto,auto),
    rows: (auto,auto),
    row-gutter: 2%,
    image("/images/carbongitter.JPG", width: 80%),
    image("/images/carbongitter-in-wand.jpg", width: 80%),
    [(a)],
    [(b)],
  ),
  caption: [Bewehrungsmatte aus Carbongarn. Nach dem Verlegen durch den Roboter um die Umlenkelemente (a) und eingegossen in einer Betonwand für Demonstrationszwecke (b)]
)<fig:carbongitter>

Für einfache Wände ist die Berechnung der erforderlichen Bewegungsabläufe vergleichsweise unkompliziert und entsprechende automatisierte Lösungen sind bereits seit mehreren Jahren im Einsatz. Deutlich komplexer gestaltet sich hingegen die Planung für Wände mit Aussparungen, wie beispielsweise Türen oder Fenster. Die Entwicklung robuster automatisierter Verfahren für solche Wände ist jedoch eine zentrale Voraussetzung, um den Einsatz von Carbonbeton im Wohnungsbau industriell zu skalieren.

== Ziele
Um im @CBT und letztendlich in folgenden industriellen Produktionsstätten die automatisierte Produktion von Carbonbetonwänden für den Wohnungsbau zu ermöglichen, müssen Methoden zur Pfadbestimmung für den Roboterarm unter den gegebenen Rahmenbedingungen und prozessspezifischen Anforderungen erforscht werden.

Zu diesem Zweck wird das Problem in drei aufeinander aufbauende Teilprobleme aufgeteilt, die jeweils mit einem Abschnitt in der Prozesskette adressieren. Zunächst müssen die Positionen der @UE:pl:long bestimmt werden. Aufgrund der variablen Position und Abmessungen der Tür können sie frei auf der Ablagefläche platziert werden. Anschließend erfolgt eine Routenplanung zur Bestimmung der Reihenfolge, in der die @UE:pl angefahren und somit mit Garn umwickelt werden sollen. Abschließend wird aus der Route ein Pfad abgeleitet, der die physischen Wegpunkte für die Bewegung des Roboterarms beschreibt. 

Als Forschungsziel dieser Arbeit gilt die Beantwortung der folgenden drei Forschungsfragen, welche den drei Teilproblemen zugehörig sind. 

#[
  #set enum(numbering: "(I)")
  + #forschungsfragen.at(0)
  + #forschungsfragen.at(1)
  + #forschungsfragen.at(2)
]

Bei der Beantwortung der Fragen soll es ausschließlich um Wände mit einem einzigen einzuplanenden Türausschnitt gehen. Ein geeignetes Forschungsergebnis besteht in der Integration der drei für die jeweiligen Teilprobleme entwickelten Lösungsansätze zu einem Gesamtsystem, das eine vollautomatisierte Herstellung von Carbonbewehrungen unter Berücksichtigung struktureller sowie umgebungsbedingter Anforderungen ermöglicht. Neben der grundsätzlichen Anwendbarkeit und Effizienz der entwickelten Methoden ist insbesondere deren Einbettung in den Kontext von Forschung und Entwicklung zu prüfen. In diesem Umfeld sind häufige und weitreichende Änderungen zu erwarten, weshalb die Ansätze so gestaltet sein sollten, dass sie durch ein interdisziplinäres Forschungsteam mit vertretbarem Aufwand bei Bedarf angepasst werden können.

Als Eingabeparameter des Prozesses dienen die fünf geforderten Maße der Wand und Tür sowie der Radius der genutzten @UE. Als Ergebnis werden eine oder mehrere Programmdateien für einen Kawasaki BX130X Roboterarm erzeugt. Diese sollen es ermöglichen, dass der Roboterarm ohne zusätzliche manuelle Eingriffe ein vollständiges Carbongitter inklusive der Platzierung der @UE:pl:long erzeugt.


== Methodik

Um diese Ziele zu erreichen und insbesondere die Forschungsfragen zu beantworten, wird diese Arbeit in drei zentrale Kapitel untergliedert, von denen sich jedes auf die Beantwortung einer Forschungsfrage fokussiert. In jedem dieser Kapitel wird dafür zunächst das betrachtete Problem spezifiziert und mathematisch modelliert. Daraufhin wird relevante Literatur aufgearbeitet, um bestehende Ansätze einzuordnen, theoretische Grundlagen darzustellen und bestehende Forschungslücken zu identifizieren. Basierend darauf werden dann gewonnene Erkenntnisse und Lösungsansätze vorgestellt und eingeordnet. Abschließend werden die Ansätze anhand eines zuvor beschriebenem Testvorgehen evaluiert. Dabei erfolgt eine Bewertung hinsichtlich ihrer Leistungsfähigkeit in Bezug auf die zuvor formulierten Anforderungen, gefolgt von einer Darstellung und Analyse der erzielten Ergebnisse.

Nach der getrennten Betrachtung der drei Teilprobleme und der Identifikation geeigneter Lösungsansätze werden die Resultate in @sec:auswertung zusammengeführt, kritisch diskutiert und im Hinblick auf ihre praktische Anwendbarkeit bewertet. Den Abschluss der Arbeit bilden eine Zusammenfassung der gewonnenen Erkenntnisse sowie ein Ausblick auf mögliche zukünftige Arbeiten und bestehendes Optimierungspotenzial.