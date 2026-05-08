# LeoCast Scope Lock

LeoCast is a native Mac OS X Leopard podcatcher.

## Non-goals

- No iTunes clone.
- No media store.
- No YouTube/Vimeo/media extraction.
- No Qt.
- No GTK.
- No Python runtime.
- No KDE stack.
- No Electron.
- No feature monster.
- No sync requirement for V1.
- No plugin system for V1.

## Native-first rule

If Mac OS X 10.5.8 Leopard provides a suitable native capability, LeoCast must use it first.

Preferred native capabilities:

- PubSub.framework for RSS/Atom feeds and podcast feed handling.
- QTKit / QuickTime for media playback.
- Cocoa/AppKit for the user interface.
- SQLite for local state.
- AppleScript / Apple Events for automation.
- OPML for import and export.

## Application identity

LeoCast is a small Leopard application with a deeply scriptable system soul.

The UI should feel like something Apple could plausibly have shipped around 2009:
calm, native, restrained, and useful.
