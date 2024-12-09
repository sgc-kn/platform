This integrates the Swiss traffic count data on Constance' border
crossings into our platform. We obtain the data by e-mail from Swiss
ASTRA (Tägermoos) and DBU Thurgau (Kreuzlingen & Tägerwilen) via our ASU
department.

I drop the data into git-lfs and write a simple Python notebook to
import this into the new PostgresT system on our platform.

We're unsure about the license and put the data into the private
skn-kn/closed-data repository.

#### Datenformat

##### ZST 587 - Autobahnzoll Tägermoos (ASTRA)

`closed-data/traffic-ch/587vd*.csv`

R1 = Deutschland  
R2 = Frauenfeld/Kreuzlingen

Formatbeschreibung:

- ZST Messstellen-Nummer
- JJMMTT Datum (Jahr, Monat, Tag)
- R1H00 Wert der Stunde 00 Richtung 1
- R1H01 Wert der Stunde 01 Richtung 1
- ...
- R1H23 Wert der Stunde 23 Richtung 1
- R2H00 Wert der Stunde 00 Richtung 2
- R2H01 Wert der Stunde 01 Richtung 2
- ...
- R2H23 Wert der Stunde 23 Richtung 2

Klassifizierung = Gesamtverkehr


##### ZST 902 - Kreuzlingen Emmishofer Zoll (DBU)

`closed-data/traffic-ch/902-20*_CSV-Export.csv`

R1 Fahrtrichtung Schweiz  
R2 Fahrtrichtung Deutschland


##### ZST 903 - Kreuzlingen Tägerwiler Zoll (DBU)

`closed-data/traffic-ch/903-20*_CSV-Export.csv`

R1 Fahrtrichtung Schweiz  
R2 Fahrtrichtung Deutschland
