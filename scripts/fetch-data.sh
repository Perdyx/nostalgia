#!/bin/bash
# Fetches data during local development, bypassing GitHub Actions

TEMP_FILE=$(mktemp)
TARGET_FILE="src/lib/server-data.json"
SERVER_IDS=($(cat .serverids))

echo "Fetching server data..."
echo "[" > "$TEMP_FILE"

VALID_COUNT=0

for ID in "${SERVER_IDS[@]}"; do
    
    # Fetch data and extract .response
    RAW_RESPONSE=$(curl -s "https://api.gamemonitoring.net/servers/$ID")
    DATA=$(echo "$RAW_RESPONSE" | jq '.response')

    # Check if DATA is not null and contains an id
    if [ "$DATA" != "null" ] && [ "$DATA" != "" ]; then
        # Add comma if this isn't the first valid item
        if [ $VALID_COUNT -gt 0 ]; then
            echo "," >> "$TEMP_FILE"
        fi
        
        echo "$DATA" >> "$TEMP_FILE"
        ((VALID_COUNT++))
        echo "Successfully fetched $ID"
    else
        echo "FAILED: Server $ID returned no data. Skipping..." >&2
    fi
done

echo "]" >> "$TEMP_FILE"

# Only overwrite if we successfully got at least one server
if [ $VALID_COUNT -gt 0 ]; then
    mv "$TEMP_FILE" "$TARGET_FILE"
    echo "Done! Updated $TARGET_FILE with $VALID_COUNT servers."
else
    echo "CRITICAL: No valid data fetched. Local data file was NOT updated." >&2
    rm "$TEMP_FILE"
    exit 1
fi