# LeoCast Architecture

LeoCast follows a native-first Leopard architecture.

## Core bricks

- App: application lifecycle and top-level coordination
- Feed: PubSub integration and feed refresh logic
- Library: local podcast and episode state
- Download: episode download queue and partial file handling
- Playback: QTKit / QuickTime playback integration
- Scripting: AppleScript and Apple Events support
- UI: Cocoa/AppKit user interface

## Design rule

LeoCast should not import a foreign application architecture.

Kasts may inspire visual restraint.
gPodder may inform podcast domain behavior.
Neither project is used as the architectural base.

