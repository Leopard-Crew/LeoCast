# LeoCast AppleScript Model

AppleScript is a first-class LeoCast interface.

## Scriptable objects

- application
- podcast
- episode
- download queue
- download

## Initial commands

- subscribe to URL
- unsubscribe podcast
- refresh podcast
- refresh all podcasts
- download episode
- download new episodes
- play episode
- pause playback
- mark episode as played
- mark episode as new
- import OPML
- export OPML

## Example

tell application "LeoCast"
    refresh all podcasts
    download new episodes
end tell

## Bundle Integration Status

LeoCast is configured as a scriptable Cocoa application.

The application Info.plist contains:

- NSAppleScriptEnabled = true
- OSAScriptingDefinition = LeoCast.sdef

The scripting definition is copied into:

- LeoCast.app/Contents/Resources/LeoCast.sdef

This means LeoCast exposes its AppleScript dictionary through the native
Mac OS X Leopard application bundle mechanism.
