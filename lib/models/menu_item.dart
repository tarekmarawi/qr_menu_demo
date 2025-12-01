// lib/models/menu_item.dart

/// A model class to represent a single item in the cafe menu.
/// This structure is flexible and can be easily extended.
class MenuItem {
  /// The name of the item, e.g., "Espresso", "Pepsi", "Double Apple".
  final String name;

  /// The path to the image asset for the item.
  final String imagePath;

  /// A detailed description or notes about the item.
  final String details;

  /// Constructor for the MenuItem model.
  MenuItem({
    required this.name,
    required this.imagePath,
    required this.details,
  });
}