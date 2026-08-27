# ConnectShare

ConnectShare is a mobile-first Wi-Fi hotspot marketplace and access platform. Providers publish hotspot locations and paid data plans; consumers discover available hotspots, complete checkout, and receive a time- and data-limited access token. A captive portal validates the token and binds access to the requesting device.

The project combines a Flutter application, a type-safe Serverpod API, and a generated Serverpod client package. It is intended for controlled hotspot deployments where providers manage the network hardware and ConnectShare manages discovery, authentication, payment verification, access, and usage records.

## Core capabilities

- Provider hotspot creation, activation, plan management, and session monitoring.
- Consumer hotspot discovery, plan selection, hosted Paystack checkout, and token issuance.
- Server-side Paystack verification before an access token is created.
- Captive-portal token validation with device binding, expiry, and metered-data limits.
- Email verification and password-reset delivery through Resend.
- Role-aware consumer, provider, and administrator workflows.
- Android system Wi-Fi tethering integration where the device and Android version permit it.

## Repository layout

```text
connect_share/
├── connect_share_flutter/   Flutter application and Android/iOS clients
├── connect_share_server/    Serverpod API, authentication, payments, and persistence
└── connect_share_client/    Generated Serverpod client and protocol models
```

## Technology stack

- Flutter and Dart
- Serverpod `3.4.12`
- PostgreSQL
- Redis
- Paystack for payment initialization and verification
- Resend for transactional email
- Docker Compose for local infrastructure

## Prerequisites

Install the following before starting development:

- Flutter SDK with Android tooling configured
- Dart SDK compatible with the installed Flutter release
- Docker Desktop with the Linux engine enabled
- A Paystack test or live secret key
- A Resend API key and verified sender address for email flows

## Local development

Start the database and Redis services:

```bash
cd connect_share_server
docker compose up --build --detach
```

Install dependencies in each Dart package:

```bash
cd connect_share_server
dart pub get

cd ../connect_share_client
dart pub get

cd ../connect_share_flutter
flutter pub get
```

Generate Serverpod protocol and endpoint code after changing models or endpoint signatures:

```bash
cd connect_share_server
serverpod generate
```

Run the API:

```bash
cd connect_share_server
dart bin/main.dart
```

Run the Flutter application in a second terminal:

```bash
cd connect_share_flutter
flutter run --dart-define=PAYSTACK_CALLBACK_URL=https://example.com/payment-callback
```

For an Android emulator, the default API URL is `http://10.0.2.2:8083/`. For a physical device, point the app to the development computer's LAN address:

```bash
flutter run \
  --dart-define=SERVERPOD_URL=http://192.168.x.x:8083/ \
  --dart-define=PAYSTACK_CALLBACK_URL=https://example.com/payment-callback
```

## Configuration

Keep secrets out of source control. Configure the active Serverpod mode in the local `connect_share_server/config/passwords.yaml` file:

```yaml
development:
  paystackSecretKey: 'sk_test_...'
  resendApiKey: 're_...'
  emailFrom: 'ConnectShare <noreply@your-domain.example>'
```

The Flutter client must never contain the Paystack secret. Payment initialization and verification are performed by the server.

## Android hotspot notes

Android controls system tethering behavior. Depending on the device, Android version, carrier policy, and permissions, the app may either start the system hotspot or open the system tethering settings. The operating system can ignore the SSID, password, or gateway address entered in the app. Production deployments should pair this client with a networking service that can provide the required captive-portal routing and traffic accounting privileges.

## Quality checks

Run the project-specific Flutter Android compatibility check:

```bash
cd connect_share_flutter
flutter analyze --suggestions
```

Run static analysis for the server:

```bash
cd connect_share_server
dart analyze .
```

The Android project uses AGP `8.7.0`, Kotlin Gradle Plugin `2.1.0`, and Gradle `8.9`; keep these versions aligned when upgrading Flutter or Android tooling.

## Security and production checklist

Before deploying to production:

- Replace all test credentials and configure secrets through the deployment environment.
- Use HTTPS for the API, captive portal, payment callback, and email provider integrations.
- Configure a verified Resend domain and a production Paystack account.
- Apply and verify database migrations before starting the server.
- Restrict administrative scopes and rotate credentials regularly.
- Test tethering, captive-portal routing, and data accounting on every supported Android device family.

## License

No license has been declared yet. Add a `LICENSE` file before distributing or accepting external contributions.

