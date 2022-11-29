# Duo-HOTP-Extractor

A simple script to extract an HOTP token from Duo

## Why

This allows using any app which supports HOTP (Aegis, Authy, Google Authenticator) for Duo-authenticated services.
The Duo app is closed-source and telemetry-enabled, plus it's just nice to have all 2fa codes in a single place.

## How

Duo uses HOTP under the hood, it adds a layer of proprietary stuff over it. This script tricks Duo into surrendering the HOTP token, and lets you add it to any app.

## Is it secure?

Yes. The only online service this script makes contact with is Duo itself. You can easily audit the 32-line script yourself to verify this.

## How

1. Add a device to Duo, choosing "Tablet"
2. When Duo goves you a QR code, copy the image URL.
    > Recently, Duo has attempted to obscure the URL of the QR code image, you may have to inspect and select the element covering the image, and poke around for the URL
3. Run this script with the QR code URL as the argument: `./duo.sh https://api-AAAAAAA.duosecurity.com/frame/qr?value=BBBBBBBBBBBBBB-CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC`
4. The script will give a QR code which you can scan with any standard HOTP app.
