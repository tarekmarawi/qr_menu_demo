// lib/controllers/menu_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/menu_item.dart';
import '../utils/app_colors.dart';

/// Manages the state and logic for the cafe menu.
/// Renamed to CafeMenuController to avoid conflict with Flutter's MenuController.
class CafeMenuController extends GetxController {
  /// Observable integer to track the index of the currently expanded category.
  /// Using RxInt makes it reactive, so the UI rebuilds automatically when it changes.
  final expandedIndex = Rxn<int>(); // Rxn<int> allows for null (no category expanded)

  /// Map to store the dedicated image path for each category button.
  /// This is separate from the item data to allow for distinct category images.
  final Map<String, String> categoryImages = {
    "Cold Drinks": 'assets/images/cold.jpg', // Placeholder, use your actual image path
    "Shisha": 'assets/images/shisha.webp', // Placeholder, use your actual image path
    "Hot Drinks": 'assets/images/hot.webp', // Placeholder, use your actual image path
  };

  /// The main data structure holding all menu items, grouped by category.
  /// The key is the category name (String), and the value is a list of MenuItems.
  final Map<String, List<MenuItem>> menuData = {
    "Cold Drinks": [
      MenuItem(name: "Soda", imagePath: 'assets/images/soda.jpg', details: "Classic carbonated drink."),
      MenuItem(name: "Pepsi", imagePath: 'assets/images/pepsi.jpg', details: "The original cola."),
      MenuItem(name: "Cola", imagePath: 'assets/images/cola.jpg', details: "Generic cola drink."),
      MenuItem(name: "Iced Tea", imagePath: 'assets/images/iced_tea.jpg', details: "Refreshing brewed tea over ice."),
      MenuItem(name: "Lemonade", imagePath: 'assets/images/lemonade.jpg', details: "Freshly squeezed lemon juice."),
      MenuItem(name: "Milkshake", imagePath: 'assets/images/milkshake.jpg', details: "Thick and creamy."),
      MenuItem(name: "Juice", imagePath: 'assets/images/juice.jpg', details: "Selection of fresh juices."),
      MenuItem(name: "Water", imagePath: 'assets/images/water.jpg', details: "Still or sparkling."),
      MenuItem(name: "Energy Drink", imagePath: 'assets/images/energy_drink.jpg', details: "For a quick boost."),
    ],
    "Shisha": [
      MenuItem(name: "Double Apple", imagePath: 'assets/images/double_apple.webp', details: "Classic sweet and tangy flavor."),
      MenuItem(name: "Mint", imagePath: 'assets/images/mint.webp', details: "Cool and refreshing."),
      MenuItem(name: "Grape", imagePath: 'assets/images/grape.webp', details: "Sweet grape flavor."),
      MenuItem(name: "Watermelon", imagePath: 'assets/images/watermelon.webp', details: "Juicy and light."),
      MenuItem(name: "Blue Mist", imagePath: 'assets/images/blue_mist.webp', details: "Berry and mint mix."),
      MenuItem(name: "Gum", imagePath: 'assets/images/gum.webp', details: "Sweet bubblegum flavor."),
      MenuItem(name: "Lemon Mint", imagePath: 'assets/images/lemon_mint.webp', details: "Zesty lemon with cool mint."),
      MenuItem(name: "Orange", imagePath: 'assets/images/orange.webp', details: "Citrusy and bright."),
      MenuItem(name: "Peach", imagePath: 'assets/images/peach.webp', details: "Sweet and fruity."),
    ],
    "Shisha1": [
      MenuItem(name: "Double Apple", imagePath: 'assets/images/double_apple.webp', details: "Classic sweet and tangy flavor."),
      MenuItem(name: "Mint", imagePath: 'assets/images/mint.webp', details: "Cool and refreshing."),
      MenuItem(name: "Grape", imagePath: 'assets/images/grape.webp', details: "Sweet grape flavor."),
      MenuItem(name: "Watermelon", imagePath: 'assets/images/watermelon.webp', details: "Juicy and light."),
      MenuItem(name: "Blue Mist", imagePath: 'assets/images/blue_mist.webp', details: "Berry and mint mix."),
      MenuItem(name: "Gum", imagePath: 'assets/images/gum.webp', details: "Sweet bubblegum flavor."),
      MenuItem(name: "Lemon Mint", imagePath: 'assets/images/lemon_mint.webp', details: "Zesty lemon with cool mint."),
      MenuItem(name: "Orange", imagePath: 'assets/images/orange.webp', details: "Citrusy and bright."),
      MenuItem(name: "Peach", imagePath: 'assets/images/peach.webp', details: "Sweet and fruity."),
    ],
    "Hot Drinks": [
      MenuItem(name: "Espresso", imagePath: 'assets/images/espresso.webp', details: "A strong shot of coffee."),
      MenuItem(name: "Cappuccino", imagePath: 'assets/images/cappuccino.webp', details: "Espresso with steamed milk and foam."),
      MenuItem(name: "Latte", imagePath: 'assets/images/latte.webp', details: "Espresso with steamed milk."),
      MenuItem(name: "Americano", imagePath: 'assets/images/americano.webp', details: "Espresso with hot water."),
      MenuItem(name: "Hot Chocolate", imagePath: 'assets/images/hot_chocolate.webp', details: "Rich and creamy."),
      MenuItem(name: "Green Tea", imagePath: 'assets/images/green_tea.webp', details: "Healthy and soothing."),
      MenuItem(name: "Black Tea", imagePath: 'assets/images/black_tea.webp', details: "Traditional English tea."),
      MenuItem(name: "Mocha", imagePath: 'assets/images/mocha.webp', details: "Chocolate and coffee."),
      MenuItem(name: "Macchiato", imagePath: 'assets/images/macchiato.webp', details: "Espresso with a dash of milk."),
    ],
  };

  /// A list of all category names, derived from the keys of `menuData`.
  /// This list is used to build the category buttons.
  List<String> get categories => menuData.keys.toList();

  /// Toggles the expansion state of a category.
  /// This is the core logic for the button tap.
  void toggleCategory(int index) {
    if (expandedIndex.value == index) {
      // If the same category is tapped, collapse it.
      expandedIndex.value = null;
    } else {
      // Otherwise, expand the new category.
      expandedIndex.value = index;
    }
  }

  /// Returns the list of items for the currently expanded category.
  /// Returns an empty list if no category is expanded.
  List<MenuItem> get currentItems {
    if (expandedIndex.value == null) {
      return [];
    }
    // Get the category name using the index.
    final categoryName = categories[expandedIndex.value!];
    // Return the list of items for that category.
    return menuData[categoryName] ?? [];
  }

  /// The URL that the QR code will point to.
  /// NOTE: In a real web app, this would be the actual deployed URL.
  final String qrCodeUrl = "https://your-cafe-menu-url.com";

  /// Displays a modal with the QR code and the link, using Flutter's native showDialog
  /// as requested by the user's reference code.
  void showQrCodeModal(BuildContext context ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Text(
          "Scan to View Menu",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
        ),
        content: SizedBox(
          width: 250, // Set a fixed width for the dialog content
          height: 300, // Set a fixed height for the dialog content
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // QR Code Image
              QrImageView(
                data: qrCodeUrl,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primaryDark,
              ),
              const SizedBox(height: 8),
              // Link Text
              SelectableText( // Use SelectableText as in the user's reference code
                qrCodeUrl,
                textAlign: TextAlign.center,
                maxLines: 2,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 14,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            // Use Navigator.pop to close the dialog, as in the user's reference code
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(color: AppColors.highlight, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}