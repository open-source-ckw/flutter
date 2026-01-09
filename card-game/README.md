A starter Flutter project with a minimal shell of a board game
including the following features:

- main menu screen
- basic navigation
- game-y theming
- settings
- sound
- drag and drop
- minimal game state management

You can jump directly into building your game in `lib/play_session/`.

# Development

To run the app in debug mode:

    flutter run

It is often convenient to develop your game as a desktop app.
For example, you can run `flutter run -d macOS`, and get the same UI
in a desktop window on a Mac. That way, you don't need to use a
simulator/emulator or attach a mobile device.


## Code organization

Code is organized in a loose and shallow feature-first fashion.
In `lib/`, you'll therefore find directories such as `audio`,
`main_menu` or `settings`. Nothing fancy, but usable.

```text
lib
├── app_lifecycle
├── audio
├── game_internals
├── main_menu
├── play_session
├── player_progress
├── settings
├── style
├── win_game
│
├── main.dart
└── router.dart
```

The state management approach is intentionally low-level. That way, it's easy to
take this project and run with it, without having to learn new paradigms, or having
to remember to run `flutter pub run build_runner watch`. 