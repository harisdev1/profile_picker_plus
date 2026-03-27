/// profile_picker_plus — The complete Flutter profile picture toolkit.
///
/// Pick, crop, and display profile images with a single drop-in widget.
///
/// ## Quick Start
/// ```dart
/// ProfilePicker(
///   fallbackInitials: 'AK',
///   onImageSelected: (file) => setState(() => _profileFile = file),
/// )
/// ```
library profile_picker_plus;

// Widgets
export 'src/widgets/profile_picker.dart';
export 'src/widgets/profile_display.dart';
export 'src/widgets/picker_bottom_sheet.dart';
export 'src/widgets/picker_dialog.dart';

// Models
export 'src/models/profile_picker_theme.dart';
export 'src/models/profile_picker_strings.dart';
export 'src/models/profile_picker_mode.dart';
export 'src/models/badge_position.dart';
export 'src/models/badge_layout_mode.dart';
export 'src/models/profile_trigger_mode.dart';
export 'src/models/option_type.dart';
export 'src/models/profile_picker_actions.dart';

// Controller
export 'src/models/profile_picker_controller.dart';

// Provider
export 'src/provider/profile_picker_theme_provider.dart';

// Services (exposed for advanced customization)
export 'src/services/image_picker_service.dart';
export 'src/services/image_cropper_service.dart';
export 'src/services/permission_service.dart';

// Utils
export 'src/utils/initials_utils.dart';
