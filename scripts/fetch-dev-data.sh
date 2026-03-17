#!/bin/bash
# Fetches data during local development, bypassing GitHub Actions

TEMP_FILE=$(mktemp)

echo "Fetching server data..."
echo "[" > $TEMP_FILE
curl -s "https://api.gamemonitoring.net/servers/11181191" | jq '.response' >> $TEMP_FILE # Duplicate this line as needed for additional servers
echo "]" >> $TEMP_FILE

# Only overwrite the real file if the fetch was successful
if grep -q "id" $TEMP_FILE; then
    mv $TEMP_FILE src/lib/server-data.json
    echo "Done!"
else
    echo "Fetch failed or returned empty data. Keeping old file."
    rm $TEMP_FILE
fi