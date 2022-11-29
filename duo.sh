#!/bin/sh

API_PARAMS=${1#*=}

URL=${1%%frame*}push/v2/activation/${API_PARAMS%-*}?customer_protocol=1

echo "URL: $URL"

RAW_RESPONSE=$(curl -s -X POST $URL \
    -H "User-Agent: okhttp/4.9.0" \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d 'jailbroken=false&architecture=arm64&region=US&app_id=com.duosecurity.duomobile&full_disk_encryption=true&passcode_status=true&platform=Android&app_version=3.49.0&app_build_number=323001&version=11&manufacturer=unknown&language=en&model=Generic HOTP&security_patch_level=2021-02-01')

echo "Response: $RAW_RESPONSE"

RESPONSE=$(jq -j .response <<< $RAW_RESPONSE)

STAT=$(jq -j .stat <<< $RAW_RESPONSE)

if [ "$STAT" = "OK" ]; then
    CUSTOMER=$(jq -j .customer_name <<< $RESPONSE)
    SECRET=$(jq -j .hotp_secret <<< $RESPONSE | base32)
    SECRET=${SECRET//[=]/}

    qrencode "otpauth://hotp/${CUSTOMER}?secret=${SECRET}&issuer=DUO&counter=0" -t UTF8
    echo "Raw HOTP Key: ${SECRET}"
else
    echo "Failed to get HOTP token from DUO"
    echo "Status: $STAT"
    echo "Error: $(jq -j .message <<< $RAW_RESPONSE) (code $(jq -j .code <<< $RAW_RESPONSE))"
    exit 1
fi
