import 'dart:convert';
import 'dart:io';

/// Loads portfolio_data.json once at startup and exposes each top-level section.
/// TODO: Make the JSON path configurable via the DATA_PATH environment variable.
class DataLoader {
  // Relative to where `dart run lib/main.dart` is executed (portfolio_backend/).
  // TODO: Override with DATA_PATH env var or a CLI argument if the layout changes.
  static const String _defaultPath = '../assets/data/portfolio_data.json';

  late final Map<String, dynamic> _data;

  Future<void> load([String? path]) async {
    final filePath =
        path ?? Platform.environment['DATA_PATH'] ?? _defaultPath;
    final file = File(filePath);
    if (!file.existsSync()) {
      throw FileSystemException(
        'portfolio_data.json not found. Set DATA_PATH or pass the path as an '
        'argument. Tried: $filePath',
      );
    }
    _data = json.decode(await file.readAsString()) as Map<String, dynamic>;
  }

  Map<String, dynamic> get hero =>
      (_data['hero'] ?? <String, dynamic>{}) as Map<String, dynamic>;

  Map<String, dynamic> get about =>
      (_data['about'] ?? <String, dynamic>{}) as Map<String, dynamic>;

  Map<String, dynamic> get experience =>
      (_data['experience'] ?? <String, dynamic>{}) as Map<String, dynamic>;

  Map<String, dynamic> get projects =>
      (_data['projects'] ?? <String, dynamic>{}) as Map<String, dynamic>;

  Map<String, dynamic> get contact =>
      (_data['contact'] ?? <String, dynamic>{}) as Map<String, dynamic>;
}
