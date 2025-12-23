import 'package:flutter/material.dart';
import 'package:plproject/screens/dev/screen_gallery.dart'; // We will create this next
import 'package:plproject/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/auth_provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/admin_provider.dart';


// This is the entry point for the UI Development & Screen Gallery App
void main() {
  runApp(const ScreenGalleryApp());
}

class ScreenGalleryApp extends StatelessWidget {
  const ScreenGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => AuthProvider()),
          ChangeNotifierProvider(create: (context) => ApartmentProvider()),
          ChangeNotifierProvider(create: (context) => AdminProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Screen Gallery",
          theme: AppTheme.lightTheme,
          home: const ScreenGallery(),
        ));
  }
}
