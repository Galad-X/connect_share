# connect_share_flutter

A new Flutter project with Serverpod.

## Getting Started

This project is a starting point for a Flutter application that is using
Serverpod.

A great starting point for learning Serverpod is our documentation site at:
[https://docs.serverpod.dev](https://docs.serverpod.dev).

To run the project, first make sure that the server is running, then do:

    flutter run --dart-define=PAYSTACK_CALLBACK_URL=https://example.com/payment-callback

The app uses `localhost` for desktop/web and `10.0.2.2` for the Android
emulator. For a physical device, provide the computer's LAN URL explicitly:

    flutter run --dart-define=SERVERPOD_URL=http://192.168.x.x:8083/ --dart-define=PAYSTACK_CALLBACK_URL=https://example.com/payment-callback

Full internet tethering and captive-portal traffic control require a separate
privileged Android networking service. Where Android permits the public
tethering API, the app starts the system-configured hotspot; Android may ignore
the SSID/password entered in the app and may use a device-specific gateway
address.
