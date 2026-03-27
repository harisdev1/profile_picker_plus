# Android Native Setup for profile_picker_plus

## Why is this needed?

`profile_picker_plus` uses `image_cropper` (uCrop) for its crop screen.
uCrop is a full Android Activity — Android requires it to be declared in
`AndroidManifest.xml` before it can be launched. **Dart packages cannot
inject this declaration automatically.** This is a Flutter/Android platform
constraint.

`image_picker` and `permission_handler` need camera/storage permissions,
also declared in the manifest.

**This is a one-time, copy-paste setup — roughly 2 minutes.**

---

## Step 1 — `android/app/src/main/AndroidManifest.xml`

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <!-- ══ Permissions ══════════════════════════════════════ -->

    <!-- Camera (image_picker camera source) -->
    <uses-permission android:name="android.permission.CAMERA" />

    <!-- Android 13+ (API 33+) -->
    <uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />

    <!-- Android ≤ 12 (API 32) -->
    <uses-permission
        android:name="android.permission.READ_EXTERNAL_STORAGE"
        android:maxSdkVersion="32" />

    <application ...>

        <!-- ══ uCrop Activity — REQUIRED by image_cropper ══ -->
        <!-- Without this the crop screen will crash with ActivityNotFoundException -->
        <activity
            android:name="com.yalantis.ucrop.UCropActivity"
            android:screenOrientation="portrait"
            android:theme="@style/Theme.AppCompat.Light.NoActionBar" />

        <!-- ══ FileProvider — for camera temp files ════════ -->
        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="${applicationId}.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths" />
        </provider>

    </application>

    <!-- Android 12+ (API 31+) — allow resolving camera/gallery intents -->
    <queries>
        <intent>
            <action android:name="android.media.action.IMAGE_CAPTURE" />
        </intent>
        <intent>
            <action android:name="android.intent.action.GET_CONTENT" />
        </intent>
    </queries>

</manifest>
```

---

## Step 2 — `android/app/src/main/res/xml/file_paths.xml` (create if missing)

```xml
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <external-path name="external_files" path="." />
    <cache-path name="cache" path="." />
    <external-cache-path name="external_cache" path="." />
    <files-path name="files" path="." />
</paths>
```

---

## Step 3 — `android/app/build.gradle`

`image_cropper` 9.x requires `compileSdk 34` minimum:

```groovy
android {
    compileSdk 34

    defaultConfig {
        minSdk 21        // profile_picker_plus minimum
        targetSdk 34
    }
}
```

---

## Step 4 — `android/build.gradle` (root level)

Ensure Kotlin ≥ 1.9:

```groovy
buildscript {
    ext.kotlin_version = '1.9.10'
}
```

---

## What profile_picker_plus handles automatically

| Feature | Handled by package |
|---|---|
| Requesting CAMERA permission at runtime | ✅ |
| Requesting READ_MEDIA_IMAGES at runtime | ✅ |
| Showing "Open Settings" when denied | ✅ |
| Launching gallery picker | ✅ |
| Launching camera capture | ✅ |
| Launching uCrop crop screen | ✅ |
| Image compression | ✅ |

You only provide the manifest declarations above — everything else is handled.
