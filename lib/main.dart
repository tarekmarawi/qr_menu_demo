// lib/main.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/menu_controller.dart';
import 'views/menu_page.dart';
import 'utils/app_colors.dart';

/// The initial binding for the application.
/// This ensures the MenuController is instantiated and available
/// before the MenuPage is built.
class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Lazy put the MenuController, meaning it's created only when first used.
    // This is the GetX way of making the controller available globally.
    Get.lazyPut<CafeMenuController>(() => CafeMenuController());
  }
}

void main() {
  // Use GetMaterialApp instead of MaterialApp for GetX features.
  runApp(const CoffeeMenuApp());
}

/// The root widget of the application, now using GetMaterialApp.
class CoffeeMenuApp extends StatelessWidget {
  const CoffeeMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'The Cozy Corner Cafe Menu',
      // Define the initial route and binding.
      initialRoute: '/',
      initialBinding: InitialBinding(),
      getPages: [
        // Define the main page route
        GetPage(
          name: '/',
          page: () => const MenuPage(),
          binding: InitialBinding(),
        ),
      ],
      // Define a custom theme using the cafe colors.
      theme: ThemeData(
        primaryColor: AppColors.primaryDark,
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: const AppBarTheme(
          color: AppColors.primaryDark,
          iconTheme: IconThemeData(color: AppColors.textLight),
          titleTextStyle: TextStyle(
            color: AppColors.textLight,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Set the default text color for the app
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: AppColors.textDark,
          displayColor: AppColors.textDark,
        ),
        useMaterial3: true,
      ),
    );
  }
}