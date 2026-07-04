# Mobile Control Bridge

This folder holds a simple phone-to-PC control workflow.

## Goal

Use the phone to send a command, and let the PC execute it locally.

## Recommended first version

1. A self-hosted GitHub Actions runner runs on the PC.
2. Your phone starts the `Phone Trigger Self Hosted` workflow.
3. The PC executes a pre-approved action.

## Why this shape

- It keeps the mobile side simple.
- It runs on the desktop you already own.
- It can still be connected to Gemini or a local bridge later.

## Suggested execution model

- Mobile: open GitHub Actions and dispatch the workflow.
- PC: run the self-hosted runner under your account.
- Safety: keep the allowed actions narrow.

## Next file to add

- `bridge.ps1`: an optional local listener and command dispatcher for Windows.
