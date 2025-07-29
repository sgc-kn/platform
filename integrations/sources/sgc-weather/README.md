**SGC Wetterstationen**

Wir betreiben Wetterstationen im Stadtgebiet. Jede Station sendet alle
15 Minuten Wetterbeobachtungen über LoRaWAN an TTI (The Thing
Industries) Server. Dort werden die Nachrichten für einige Tage
zwischengespeichert.

Ein Dienstleister betreibt weitere Stationen. Dieser Dienstleister
liefert auch Wetterprognosen.

Wir
- persistieren den Nachrichten-Stream in S3/DeltaLake (`./*.ipynb`,
  `./jobs.py`)
- persistieren die Wetter-Aufzeichnungen in der UDSP
  (`./nodered`)
- teilen die Aufzeichnungen mit dem Dienstleister
  (`./nodered`)
- spiegeln Aufzeichnungen und Prognosen von dem Dienstleister in die
  UDSP (`./nodered`)
