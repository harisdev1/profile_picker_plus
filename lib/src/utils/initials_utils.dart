/// Utility for deriving display initials from a name string.
class InitialsUtils {
  InitialsUtils._();

  /// Returns up to 2 uppercase initials from [name].
  ///
  /// Examples:
  /// - 'Jane Doe'     → 'JD'
  /// - 'alice'        → 'A'
  /// - 'John Michael Doe' → 'JD'
  /// - ''             → ''
  static String derive(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}
