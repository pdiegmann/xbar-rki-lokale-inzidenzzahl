#!/bin/bash
#  <xbar.title>COVID-19 Landkreis Inzidenz</xbar.title>
#  <xbar.version>v1.0</xbar.version>
#  <xbar.author>Phil Hennel</xbar.author>
#  <xbar.author.github>pdiegmann</xbar.author.github>
#  <xbar.desc>Lädt die aktuelleste COVID-19 Inzidenzzahl laut RKI für einen Landkreis, sowie das zugehörige Bundesland.</xbar.desc>
#  <xbar.dependencies>curl,jq</xbar.dependencies>
#  <xbar.abouturl>https://github.com/pdiegmann/xbar-rki-lokale-inzidenzzahl</xbar.abouturl>
# 
#  <xbar.var>string(COUNTY="OBERBERGISCHER KREIS"): Landkreis / County.</xbar.var>

export PATH="/opt/homebrew/bin:$PATH"
export LC_NUMERIC="de_DE.UTF-8"
export LANG="de_DE.UTF-8"

curl -s "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?where=GEN%20%3D%20'$(jq -rn --arg x "$COUNTY" '$x|@uri')'&outFields=cases7_per_100k_txt&outSR=4326&f=json&returnGeometry=false" | jq ".features[]?.attributes.cases7_per_100k_txt" | cut -d "\"" -f 2

echo "---"
curl -s "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?where=GEN%20%3D%20'$(jq -rn --arg x "$COUNTY" '$x|@uri')'&outFields=cases7_bl_per_100k&outSR=4326&f=json&returnGeometry=false" | jq ".features[]?.attributes.cases7_bl_per_100k" | xargs printf "Landesweit: %0.1f\n"
curl -s "https://services7.arcgis.com/mOBPykOjAyBO2ZKk/arcgis/rest/services/RKI_Landkreisdaten/FeatureServer/0/query?where=GEN%20%3D%20'$(jq -rn --arg x "$COUNTY" '$x|@uri')'&outFields=last_update&outSR=4326&f=json&returnGeometry=false" | jq ".features[]?.attributes.last_update" | xargs printf "Aktualisiert: %s %s\n"
