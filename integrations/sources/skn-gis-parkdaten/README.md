**Datenquelle**
- Aktuelle Belegung der Parkhäuser und -plätze in Konstanz
- Abruf aus öffentlicher [GIS
  Anwendung](https://services.gis.konstanz.digital/geoportal/rest/services/Fachdaten/Parkplaetze_Parkleitsystem/MapServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json)

**UDSP Integration**
- Abruf alle 15 Minuten
- NodeRed Flow in `./nodered` Submodule
