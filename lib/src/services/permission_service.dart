import 'package:permission_handler/permission_handler.dart';

/// Handles runtime permissions for camera and photo gallery.
class PermissionService {
  /// Requests camera permission.
  /// Returns true if granted.
  Future<bool> requestCamera() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Requests photo/gallery permission.
  /// Returns true if granted.
  Future<bool> requestGallery() async {
    // On Android 13+ READ_MEDIA_IMAGES; older = READ_EXTERNAL_STORAGE
    final status = await Permission.photos.request();
    if (status.isGranted) return true;
    // Fallback for older Android
    final storage = await Permission.storage.request();
    return storage.isGranted;
  }

  /// Returns true if camera permission is permanently denied.
  Future<bool> isCameraPermanentlyDenied() async {
    return Permission.camera.isPermanentlyDenied;
  }

  /// Returns true if gallery permission is permanently denied.
  Future<bool> isGalleryPermanentlyDenied() async {
    final photos = await Permission.photos.isPermanentlyDenied;
    final storage = await Permission.storage.isPermanentlyDenied;
    return photos && storage;
  }

  /// Opens the app settings so the user can manually grant permissions.
  Future<bool> openSettings() => openAppSettings();
}
