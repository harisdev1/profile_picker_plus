# iOS Native Setup for profile_picker_plus

## Why is this needed?

Apple's App Store **rejects apps** that access camera or photo library without
a human-readable usage description in `Info.plist`. This is an Apple policy
enforced at both runtime (permission dialog shows your string) and at review.

**Dart packages cannot inject `Info.plist` keys automatically.**

`image_cropper`'s iOS implementation (TOCropViewController) also requires
iOS 12.0+ set as the deployment target.

**This is a one-time, copy-paste setup — roughly 2 minutes.**

---

## Step 1 — `ios/Runner/Info.plist`

Add these three keys inside the root `<dict>`. Customize the strings — Apple
reviewers read them:

```xml
<!-- Camera: used by image_picker camera source -->
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME) needs camera access to take your profile photo.</string>

<!-- Photo library read: used by image_picker gallery source -->
<key>NSPhotoLibraryUsageDescription</key>
<string>$(PRODUCT_NAME) needs photo library access to choose your profile picture.</string>

<!-- Photo library add: saving the cropped result (iOS 14+) -->
<key>NSPhotoLibraryAddUsageDescription</key>
<string>$(PRODUCT_NAME) saves your cropped photo to your library.</string>
```

---

## Step 2 — `ios/Podfile`

Set iOS deployment target to 12.0 (required by image_cropper):

```ruby
platform :ios, '12.0'
```

Add this `post_install` block to ensure all pods respect the minimum version
(prevents Xcode 15 build warnings from pod transitive deps):

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
```

Then run:
```bash
cd ios && pod install --repo-update
```

---

## What profile_picker_plus handles automatically

| Feature | Handled by package |
|---|---|
| Requesting camera permission at runtime | ✅ |
| Requesting photo library permission at runtime | ✅ |
| Showing "Open Settings" when denied | ✅ |
| Launching gallery picker (PHPickerViewController) | ✅ |
| Launching camera (UIImagePickerController) | ✅ |
| Launching crop screen (TOCropViewController) | ✅ |
| Image compression | ✅ |

You only add the three `Info.plist` keys and set `platform :ios, '12.0'` —
everything else is handled.
