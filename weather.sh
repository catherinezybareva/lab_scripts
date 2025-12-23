#!/bin/bash

CITY="$1"
OUTPUT="/var/www/html/index.html"
URL="https://wttr.in/${CITY}?format=j1"

if [ -z "$CITY" ]; then
  echo "Usage: $0 <city>"
  exit 1
fi

WEATHER_JSON=$(curl -s "$URL")

TEMP=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].temp_C')
HUMIDITY=$(echo "$WEATHER_JSON" | jq -r '.current_condition[0].humidity')

if [ -z "$TEMP" ] || [ -z "$HUMIDITY" ]; then
  echo "Failed to fetch output:" > "$OUTPUT"
  exit 1
fi

cat <<EOF > "$OUTPUT"
<html><body>
<h2>Weather in ${CITY}</h2>
<p>Temperature: ${TEMP}C</p>
<p>Humidity: ${HUMIDITY}%</p>
<p>Updated at: $(date +"%H:%M:%S")</p>
</body></html>
EOF
