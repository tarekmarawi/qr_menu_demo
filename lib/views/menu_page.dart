// lib/views/menu_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/menu_controller.dart';
import '../utils/app_colors.dart';

/// The main page of the cafe menu, now a StatelessWidget using GetX.
class MenuPage extends GetView<CafeMenuController> {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen width for responsive design, as in the original code.
    final double screenWidth = MediaQuery.of(context).size.width;
    const double infoContainerHeight = 90; // Define the height of the info container

    // The Scaffold will now contain a Stack to layer the scrollable content
    // and the fixed information container.
    return Scaffold(
      // Use AppColors for a cafe theme
      backgroundColor: AppColors.highlight2,
      body: Stack(
        children: [
          // 1. Scrollable Content (AppBar, Image, Categories, Items)
          Column(
            children: [
              // New AppBar for Title and QR Code Button
              AppBar(
                title: const Text(
                  "The Cozy Corner Cafe",
                  style: TextStyle(color: AppColors.textLight),
                ),
                centerTitle: true,
                backgroundColor: AppColors.primaryDark,
                actions: [
                  // QR Code Button
                  IconButton(
                    icon: const Icon(Icons.qr_code_2, color: AppColors.textLight),
                    onPressed: () => controller.showQrCodeModal(context),
                  ),
                ],
              ),
              // Flexible Space (Image) - Now a separate widget
              Container(
                height: 250, // Reduced height to accommodate the new AppBar
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/shop.jpg'), fit: BoxFit.cover),
                ),
              ),
              // The rest of the content is wrapped in Expanded and SingleChildScrollView
              // The category buttons are now outside the SingleChildScrollView to keep them fixed.
              // Category Buttons Row (now a horizontal scrollable, centered Row)
              SizedBox(height: 20,),
              _buildCategoryButtons(screenWidth),
              SizedBox(height: 20,),
              Expanded(
                child: SingleChildScrollView(
                  // Add padding at the bottom equal to the height of the info container
                  // so the last item is not hidden behind the fixed container.
                  padding: const EdgeInsets.only(bottom: infoContainerHeight + 10), // Height of info container + margin
                  child: Column(
                    children: [
                      // Item Grid (Reactive with Obx)
                      // Obx listens to changes in controller.expandedIndex
                      Container(width: 1800,
                        child: Obx(
                              () => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) {
                              // Preserving the original SizeTransition animation
                              return SizeTransition(
                                sizeFactor: animation,
                                axis: Axis.vertical,
                                child: child,
                              );
                            },
                            // Use a unique key for the grid to ensure AnimatedSwitcher works correctly
                            key: ValueKey(controller.expandedIndex.value),
                            // The key changes when the expandedIndex changes, triggering the animation
                            child: controller.expandedIndex.value != null
                                ? _buildGrid(context, controller.expandedIndex.value!)
                                : const SizedBox.shrink(key: ValueKey('empty')),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 2. Fixed Information Container (at the bottom)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildInfoContainer(infoContainerHeight),
          ),
        ],
      ),
    );
  }

  /// Builds the row of category buttons, now using a SingleChildScrollView with a Row
  /// to allow for centering when there are few categories, and scrolling when there are many.
  Widget _buildCategoryButtons(double screenWidth) {
    return SizedBox(
      height: 220, // Fixed height for the category buttons row
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // Center the content when it doesn't fill the screen width
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(controller.categories.length, (index) {
            // Add some padding/margin for better spacing
            const double horizontalPadding = 10;
            final margin = EdgeInsets.only(left: horizontalPadding, right: horizontalPadding);

            // Get the category name
            final categoryName = controller.categories[index];
            // Use the image path from the first item in the category as the button image
            final imagePath = controller.menuData[categoryName]!.first.imagePath;

            return GestureDetector(
              // Call the controller's method to handle the tap and update the state.
              onTap: () => controller.toggleCategory(index),
              child: Obx(() {
                // Obx is used here to reactively change the button's appearance
                // when it is the currently expanded one.
                final isExpanded = controller.expandedIndex.value == index;
//categories width height
                return Container(
                  margin: margin,
                  height: 600,
                  width: 650, // Fixed width for horizontal scrolling buttons
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // Highlight the border if the category is expanded
                    border: isExpanded
                        ? Border.all(color: AppColors.highlight, width: 4)
                        : null,
                    boxShadow: isExpanded
                        ? [
                      BoxShadow(
                        color: AppColors.highlight.withOpacity(0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      )
                    ]
                        : null,
                    color: AppColors.primaryDark, // Fallback color
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                      fit: BoxFit.fill,
                      // Darken the image slightly for better text contrast
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.3), BlendMode.darken),
                    ),
                  ),
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    // Use a semi-transparent background for the text
                    color: Colors.black54,
                    padding: const EdgeInsets.all(4),
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }),
            );
          }),
        ),
      ),
    );
  }

  /// Builds the wide container for cafe contact and info.
  Widget _buildInfoContainer(double height) {
    return Container(
      width: double.infinity,
      height: height, // Fixed height for the info container
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.primaryDark, // Dark background for contrast
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Contact & Info:",
            style: TextStyle(
              color: AppColors.highlight,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 4),
          Text(
            "Phone: +12 345 6789 | Address: 123 Cozy Corner St. | Hours: 9AM - 11PM",
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the grid of items for the selected category.
  Widget _buildGrid(BuildContext context, int index) {
    // Get the list of items for the current category reactively.
    final items = controller.currentItems;
    final screenWidth = MediaQuery.of(context).size.width;

    // Determine crossAxisCount based on screen width for responsiveness
    int crossAxisCount;
    if (screenWidth < 600) {
      crossAxisCount = 2; // Phone
    } else if (screenWidth < 1000) {
      crossAxisCount = 3; // Tablet/iPad
    } else if (screenWidth < 1400) {
      crossAxisCount = 4; // Small Desktop
    } else {
      crossAxisCount = 5; // Large Desktop
    }

    return Container(
      key: ValueKey(index), // Key is essential for AnimatedSwitcher
      padding: const EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // Adjust childAspectRatio for better look on different screen sizes
        childAspectRatio: screenWidth < 600 ? 0.8 : 1,
        // Use the actual list of items from the controller
        children: items.map((item) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.accentLight.withOpacity(0.8), // Cafe-themed color
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// Item Image
                ClipRRect(borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    width: 190,
                    height: 160,
                  ),
                ),

                /// Item Name
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    item.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Item Details (can be displayed on tap or hover in a real app)
                // For now, we'll just show a small indicator or part of the details
                ///Detailes
                Text(
                  item.details,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textDark.withOpacity(0.7),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}