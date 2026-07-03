# Self-Hosted Runner Notes

## Why this is the missing piece

GitHub Actions can be started from your phone, but your desktop command only runs if a runner is available on the desktop.

## Minimal desktop setup

1. Turn on the desktop.
2. Install a GitHub self-hosted runner on the desktop.
3. Register it to this repository.
4. Keep the runner service running.

## What this gives you

- Your phone starts the workflow.
- The workflow lands on your desktop runner.
- The desktop can open local tools like `Fubon` or Chromium.

## Limitation

- The desktop must be on for this to work.
- If the desktop is off, the phone can still trigger the workflow, but nothing local will run.

