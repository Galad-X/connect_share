# connect_share_server

This is the starting point for your Serverpod server.

To run your server, you first need to start Postgres and Redis. It's easiest to do with Docker.

    docker compose up --build --detach

Then you can start the Serverpod server.

    dart bin/main.dart

When you are finished, you can shut down Serverpod with `Ctrl-C`, then stop Postgres and Redis.

    docker compose stop

For payments, set `paystackSecretKey` in `config/passwords.yaml` for the active
Serverpod mode. Never put this secret in the Flutter application.

Signup and password reset use Resend. Set `resendApiKey` and a verified
`emailFrom` address in the same local passwords file; the server now fails the
auth request when email delivery is not configured instead of reporting a false
success.
