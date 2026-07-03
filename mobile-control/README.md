# Mobile Control Bridge

This folder will hold a simple phone-to-PC control workflow.

## Goal

Use the phone to send a command, and let the PC execute it locally.

## Recommended first version

1. A small HTTP endpoint runs on the PC.
2. Your phone calls that endpoint with a secret token.
3. The PC executes a pre-approved action.

## Why this shape

- It does not depend on the PC being manually opened to a browser session.
- It keeps the mobile side simple.
- It can later be connected to Gemini, GitHub Actions, or any other trigger.

## Suggested execution model

- Mobile: send a request from a browser shortcut, automation app, or a webhook client.
- PC: run a local listener that accepts only trusted commands.
- Safety: require a shared secret and keep the allowed actions narrow.

## Next file to add

- `bridge.ps1`: a local listener and command dispatcher for Windows.

