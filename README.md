# profile_picker_plus

**The complete Flutter profile picture toolkit — pick, crop, display.**

[![pub.dev](https://img.shields.io/pub/v/profile_picker_plus.svg)](https://pub.dev/packages/profile_picker_plus)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Flutter](https://img.shields.io/badge/Flutter-%3E%3D3.10-blue)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%3E%3D3.0-blue)](https://dart.dev)

Drop-in `AvatarPicker` and `AvatarDisplay` widgets with gallery/camera
selection, built-in image cropping, bottom-sheet & dialog modes, fallback
initials, deep theming, and a programmatic controller — all in one package.

---

## Features

| Feature | Status |
|---|---|
| Gallery & Camera image picking | ✅ |
| Built-in image cropping (uCrop / TOCropViewController) | ✅ |
| Bottom sheet **and** dialog picker modes | ✅ |
| Fallback initials avatar | ✅ |
| Network / File / Asset / Bytes image display | ✅ |
| Full theming via `ProfilePickerPlusTheme` | ✅ |
| App-wide theme with `ProfilePickerPlusThemeProvider` | ✅ |
| Programmatic controller (`ProfilePickerPlusController`) | ✅ |
| Badge position, layout mode, and custom badge widget | ✅ |
| Trigger mode (tap / long-press / double-tap / none) | ✅ |
| Custom builders (header, footer, option tiles, full sheet) | ✅ |
| Image compression | ✅ |
| Max file-size guard | ✅ |
| Permission handling with graceful denied state | ✅ |
| Localizable strings (`ProfilePickerPlusStrings`) | ✅ |
| 100% null-safe, Dart 3, Material 3 | ✅ |

---

## Demos

<table>
  <tr>
    <td align="center"><b>Minimal Usage</b></td>
    <td align="center"><b>Bottom Sheet Picker</b></td>
    <td align="center"><b>Dialog Picker</b></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/harisdev1/profile_picker_plus/main/assets/gifs/1_minimial_usage.gif" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/harisdev1/profile_picker_plus/main/assets/gifs/2_bottom_sheet_picker.gif" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/harisdev1/profile_picker_plus/main/assets/gifs/3_dialog_picker.gif" width="250"/></td>
  </tr>
  <tr>
    <td align="center"><b>Theming</b></td>
    <td align="center"><b>Badge Position</b></td>
    <td align="center"><b>Trigger Modes</b></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/harisdev1/profile_picker_plus/main/assets/gifs/4_theming.gif" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/harisdev1/profile_picker_plus/main/assets/gifs/5_batch_position.gif" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/harisdev1/profile_picker_plus/main/assets/gifs/6_trigger_modes.gif" width="250"/></td>
  </tr>
  <tr>
    <td align="center"><b>Custom Builder</b></td>
    <td align="center"><b>Display Variations</b></td>
    <td align="center"><b>Controller API</b></td>
  </tr>
  <tr>
    <td><img src="https://raw.githubusercontent.com/harisdev1/profile_picker_plus/main/assets/gifs/7_custom_builder.gif" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/harisdev1/profile_picker_plus/main/assets/gifs/8_display_variations.gif" width="250"/></td>
    <td><img src="https://raw.githubusercontent.com/harisdev1/profile_picker_plus/main/assets/gifs/9_controller_api.gif" width="250"/></td>
  </tr>
</table>

---

## Quick Start

### 1. Add dependency

```yaml
dependencies:
  profile_picker_plus: ^1.0.0
```

> **One import, everything included.**
> `profile_picker_plus` bundles `image_picker`, `image_cropper`,
> `permission_handler`, `flutter_image_compress`, and `cached_network_image`
> as transitive dependencies. You do **not** add them separately in your
> `pubspec.yaml` — just `profile_picker_plus`.

---

### 2. Why do I still need to touch native files?

**Short answer:** Dart packages cannot inject native Android/iOS config on your
behalf. This is a Flutter/platform constraint, not a package limitation. The
two packages that require it are:

| Package | What needs native config | Why |
|---|---|---|
| `image_cropper` | uCrop `<activity>` in AndroidManifest + `compileSdk 34` | uCrop is a full Android Activity — the OS must know it exists before it can be launched |
| `image_picker` + `permission_handler` | iOS `Info.plist` permission strings | Apple rejects apps that access camera/photos without a usage description in the plist |

Everything else (`image_picker` camera/gallery flow, `flutter_image_compress`,
`cached_network_image`) works automatically once these two items are in place.

**This is a one-time, copy-paste setup — about 2 minutes per platform.**

---

### 3. Android setup (copy-paste, 2 minutes)

**`android/app/src/main/AndroidManifest.xml`** — add inside `<manifest>` and `<application>`:

```xml
<!-- ── Permissions (inside <manifest>) ── -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"
    android:maxSdkVersion="32" />

<!-- ── uCrop Activity (inside <application>) ── -->
<!-- REQUIRED by image_cropper — without this, the crop screen will crash -->
<activity
    android:name="com.yalantis.ucrop.UCropActivity"
    android:screenOrientation="portrait"
    android:theme="@style/Theme.AppCompat.Light.NoActionBar" />
```

**`android/app/build.gradle`** — `image_cropper` requires `compileSdk 34`:

```groovy
android {
    compileSdk 34          // must be 34+
    defaultConfig {
        minSdk 21          // profile_picker_plus minimum
    }
}
```

---

### 4. iOS setup (copy-paste, 2 minutes)

**`ios/Runner/Info.plist`** — add inside the root `<dict>`:

```xml
<!-- Camera — image_picker camera source -->
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME) needs camera access to take your profile photo.</string>

<!-- Photo library read — image_picker gallery source -->
<key>NSPhotoLibraryUsageDescription</key>
<string>$(PRODUCT_NAME) needs photo library access to choose your profile picture.</string>

<!-- Photo library add — saving cropped images (iOS 14+) -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>$(PRODUCT_NAME) saves your cropped photo to your library.</string>
```

**`ios/Podfile`** — set minimum iOS version:

```ruby
platform :ios, '12.0'
```

Then run:
```bash
cd ios && pod install
```

---

### 5. Use the widget

```dart
import 'package:profile_picker_plus/profile_picker_plus.dart';

AvatarPicker(
  fallbackInitials: 'AK',
  onImageSelected: (file) {
    setState(() => _profileFile = file);
  },
)
```

---

## AvatarPicker

The main interactive widget. Tap to open the picker, run the crop + compress
pipeline, and receive a `File?` via `onImageSelected`.

### Minimal

```dart
AvatarPicker(
  fallbackInitials: 'JD',
  onImageSelected: (file) => setState(() => _photo = file),
)
```

### Fully customised

```dart
AvatarPicker(
  radius: 60,
  pickerMode: AvatarPickerMode.dialog,
  cropAspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
  allowRemove: true,
  compressionQuality: 75,
  fallbackInitials: 'JD',
  badgePosition: BadgePosition.bottomRight,
  theme: ProfilePickerPlusTheme(
    primaryColor: Colors.teal,
    sheetBorderRadius: 24,
  ),
  onImageSelected: (file) => _handleImage(file),
)
```

### Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `onImageSelected` | `Function(File?)` | **required** | Called after pick + crop. Null when photo removed. |
| `radius` | `double` | `48.0` | Avatar radius in logical pixels. |
| `pickerMode` | `AvatarPickerMode` | `.bottomSheet` | `bottomSheet` or `dialog`. |
| `cropEnabled` | `bool` | `true` | Enable/disable the crop step. |
| `cropAspectRatio` | `CropAspectRatio?` | `null` | Lock aspect ratio. Null = free crop. |
| `allowGallery` | `bool` | `true` | Show gallery option. |
| `allowCamera` | `bool` | `true` | Show camera option. |
| `allowRemove` | `bool` | `false` | Show "Remove photo" option. |
| `compressionQuality` | `int` | `85` | JPEG compression 0–100. |
| `maxFileSizeKB` | `int?` | `null` | Max file size guard in KB. |
| `fallbackInitials` | `String?` | `null` | Initials or full name for fallback avatar. |
| `initialsBackgroundColor` | `Color?` | `null` | Background color for initials circle. |
| `placeholder` | `Widget?` | `null` | Widget shown when no image and no initials. |
| `badgeWidget` | `Widget?` | `null` | Replaces the default pencil badge. |
| `badgePosition` | `BadgePosition` | `.bottomRight` | Corner snap position for the badge. |
| `badgeAlignment` | `Alignment?` | `null` | Pixel-perfect badge placement (overrides `badgePosition`). |
| `badgeOffset` | `Offset?` | `null` | Nudge the badge by (dx, dy) pixels. |
| `badgeInside` | `bool` | `false` | Clip badge inside avatar boundary. |
| `badgeLayoutMode` | `BadgeLayoutMode` | `.stack` | `stack`, `overlay`, or `none`. |
| `badgeVisible` | `bool` | `true` | Show/hide badge without removing from tree. |
| `triggerMode` | `AvatarTriggerMode` | `.onTap` | `onTap`, `onLongPress`, `onDoubleTap`, `none`. |
| `controller` | `ProfilePickerPlusController?` | `null` | Programmatic open/close/clear/set. |
| `child` | `AvatarPickerBuilder?` | `null` | `(context, open) => YourWidget()` builder pattern. |
| `pickerBuilder` | `AvatarPickerSheetBuilder?` | `null` | Fully replace sheet/dialog content. |
| `optionBuilder` | `AvatarOptionBuilder?` | `null` | Override individual option tiles. |
| `headerBuilder` | `WidgetBuilder?` | `null` | Replace sheet/dialog title area. |
| `footerBuilder` | `WidgetBuilder?` | `null` | Add custom footer to sheet/dialog. |
| `theme` | `ProfilePickerPlusTheme?` | `null` | Theme override for this widget. |
| `pickerStrings` | `ProfilePickerPlusStrings?` | `null` | Localizable UI labels. |
| `loadingWidget` | `Widget?` | `null` | Replace default loading indicator. |
| `enabled` | `bool` | `true` | Disable all interaction. |
| `shape` | `ShapeBorder?` | `CircleBorder` | Custom clip shape. |

---

## AvatarDisplay

Read-only avatar widget. No picker. Perfect for lists, headers, chat bubbles.

```dart
// Network URL with initials fallback
AvatarDisplay(
  imageUrl: user.avatarUrl,
  fallbackInitials: user.name,
  radius: 32,
)

// Rounded rectangle shape with border
AvatarDisplay(
  imageFile: _localFile,
  radius: 40,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  border: Border.all(color: Colors.teal, width: 2),
)
```

---

## ProfilePickerPlusTheme

```dart
AvatarPicker(
  theme: ProfilePickerPlusTheme(
    primaryColor: Colors.deepPurple,       // badges, active controls
    badgeColor: Colors.deepPurple,
    badgeIcon: Icons.camera_alt,
    sheetBorderRadius: 28,
    cropToolbarColor: Colors.deepPurple,
    barrierColor: Color(0xAA000000),
  ),
  onImageSelected: (f) {},
)
```

For **app-wide** theming, wrap your `MaterialApp`:

```dart
ProfilePickerPlusThemeProvider(
  theme: ProfilePickerPlusTheme(primaryColor: Colors.teal),
  child: MaterialApp(home: MyApp()),
)
```

### Advanced Badge Styling

`ProfilePickerTheme` now supports deeper badge styling while keeping default
behavior unchanged if you do not set these values.

```dart
AvatarPicker(
  theme: ProfilePickerPlusTheme(
    badgeColor: Colors.teal,
    badgeIcon: Icons.camera_alt,
    badgeIconColor: Colors.white,
    badgeIconSize: 18,
    badgeBorderColor: Colors.white,
    badgeBorderWidth: 2,
    badgeIconPadding: EdgeInsets.all(2),
    badgeGradient: LinearGradient(
      colors: [Color(0xFF0E7C7B), Color(0xFFF4A261)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    badgeBoxShadow: [
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 8,
        offset: Offset(0, 3),
      ),
    ],
  ),
  fallbackInitials: 'BD',
  onImageSelected: (file) {},
)
```

Badge-focused theme properties:

| Property | Type | Default | Description |
|---|---|---|---|
| `badgeColor` | `Color` | `Color(0xFF6C63FF)` | Solid background color (used when `badgeGradient` is null). |
| `badgeIcon` | `IconData` | `Icons.edit` | Icon shown inside the badge. |
| `badgeIconColor` | `Color` | `Colors.white` | Badge icon color. |
| `badgeSize` | `double` | `28.0` | Badge diameter base size. |
| `badgeIconSize` | `double` | `16.0` | Icon size basis for badge scaling. |
| `badgeBorderColor` | `Color?` | `null` | Border color (used when `badgeBorderWidth > 0`). |
| `badgeBorderWidth` | `double` | `0.0` | Border width for badge. |
| `badgeIconPadding` | `EdgeInsetsGeometry` | `EdgeInsets.zero` | Inner icon padding. |
| `badgeGradient` | `Gradient?` | `null` | Optional gradient background (overrides solid color). |
| `badgeBoxShadow` | `List<BoxShadow>` | `black26, blur 4, y 2` | Shadow list for badge container. |

---

## ProfilePickerPlusController

```dart
final _controller = ProfilePickerPlusController();

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

// In build():
AvatarPicker(
  controller: _controller,
  triggerMode: AvatarTriggerMode.none,
  badgeLayoutMode: BadgeLayoutMode.none,
  onImageSelected: (file) {},
),
ElevatedButton(
  onPressed: () => _controller.open(),
  child: Text('Change Photo'),
),
```

| Method | Description |
|---|---|
| `open()` | Programmatically open the picker |
| `close()` | Dismiss the picker |
| `clearImage()` | Remove current image |
| `setImage(File)` | Set image without picker |
| `isOpen` | Whether picker is visible |
| `hasImage` | Whether an image is set |
| `dispose()` | Must call in parent's `dispose()` |

---

## Custom Builders

### Custom option tile

```dart
AvatarPicker(
  allowRemove: true,
  optionBuilder: (type, action) {
    if (type == OptionType.remove) {
      return ListTile(
        leading: Icon(Icons.delete_forever, color: Colors.red),
        title: Text('Delete Photo', style: TextStyle(color: Colors.red)),
        onTap: action,
      );
    }
    return null; // default for gallery & camera
  },
  onImageSelected: (file) {},
)
```

### Custom trigger (child builder)

```dart
AvatarPicker(
  triggerMode: AvatarTriggerMode.none,
  badgeLayoutMode: BadgeLayoutMode.none,
  child: (context, open) => ElevatedButton(
    onPressed: open,
    child: Text('Select Photo'),
  ),
  onImageSelected: (file) {},
)
```

---

## Localisation

```dart
AvatarPicker(
  pickerStrings: ProfilePickerPlusStrings(
    pickerTitle: 'Foto de Perfil',
    galleryLabel: 'Elegir de la Galería',
    cameraLabel: 'Tomar una Foto',
    removeLabel: 'Eliminar Foto',
    cancelLabel: 'Cancelar',
  ),
  onImageSelected: (file) {},
)
```

---

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `image_picker` | `^1.2.1` | Gallery & camera image selection |
| `image_cropper` | `^9.0.0` | Native crop UI (uCrop / TOCropViewController) |
| `permission_handler` | `^11.4.0` | Runtime permission requests |
| `flutter_image_compress` | `^2.3.0` | Optional JPEG compression |
| `cached_network_image` | `^3.4.1` | Network image display with caching |

---

## License

MIT — see [LICENSE](LICENSE).
