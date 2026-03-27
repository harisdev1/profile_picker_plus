## 1.0.1

* Declare explicit platform support (Android, iOS) in pubspec.yaml
* Update class names in README and CHANGELOG (`ProfilePicker`, `ProfileDisplay`, `ProfilePickerTheme`, etc.)
* Remove unused imports
* Sort dependencies alphabetically

## 1.0.0

* Initial release
* `ProfilePicker` — tap-to-pick widget with gallery/camera/crop pipeline
* `ProfileDisplay` — read-only display widget (file, URL, bytes, asset, initials)
* `ProfilePickerTheme` — unified theming for all widget UI
* `ProfilePickerThemeProvider` — app-wide InheritedWidget theme provider
* `ProfilePickerController` — programmatic open/close/clear/set
* `ProfilePickerStrings` — fully localizable UI labels
* Bottom sheet and dialog picker modes
* Badge position, layout mode (stack/overlay/none), inside/outside placement
* Trigger modes: onTap, onLongPress, onDoubleTap, none
* Custom builders: pickerBuilder, optionBuilder, headerBuilder, footerBuilder
* Child builder pattern for fully custom triggers
* Image compression via flutter_image_compress
* Max file-size guard
* Permission handling with graceful denied state + settings redirect
* iOS 12+, Android API 21+, Flutter Web (gallery), macOS, Windows
