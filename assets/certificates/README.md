# SSL Certificates

## How to add SSL certificate for mobile.cic-cairo.edu.eg

1. Place your `.crt` certificate file in this directory
2. Name it appropriately (e.g., `mobile-cic-cairo-edu-eg.crt`)
3. The certificate will be automatically loaded and validated by the app

## Current Status

- Directory is configured in `pubspec.yaml`
- Certificate validation is set up in `main.dart`
- Waiting for `.crt` file to be added

## Implementation Notes

The app currently allows connections to `mobile.cic-cairo.edu.eg` but logs certificate information for debugging. Once the proper certificate is added, the validation will be updated to use the certificate file.