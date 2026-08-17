# Security

Control Center v6 introduces an optional Passkey Panel Guard.

- Keep `PANEL_GUARD_ENABLED=0` until `JOURNAL_DATABASE_URL`, `JOURNAL_SECRET`,
  `PANEL_SESSION_SECRET`, `PANEL_SETUP_TOKEN`, and exact `PANEL_ALLOWED_ORIGINS`
  are configured.
- Never commit any of those values.
- The setup token is one-time enrollment authorization and should be rotated
  or removed after the first passkey is enrolled.
- Control tokens, game sessions, passwords, passkey public-key records, and
  durable recovery specs must never be printed in logs.
- Autonomous policy mode forbids automatic premium-resource spending.
- The legacy experimental race-condition endpoint is disabled by the v6 installer.
