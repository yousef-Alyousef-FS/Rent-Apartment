import 'package:flutter/material.dart';
import 'package:plproject/screens/dev/screen_gallery.dart';
import 'package:plproject/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/providers/review_provider.dart';

void main() {
  runApp(const ScreenGalleryApp());
}

class ScreenGalleryApp extends StatelessWidget {
  const ScreenGalleryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          // AuthProvider has been removed as it's no longer needed
          ChangeNotifierProvider(create: (context) => ApartmentProvider()),
          ChangeNotifierProvider(create: (context) => AdminProvider()),
          ChangeNotifierProvider(create: (context) => BookingProvider()),
          ChangeNotifierProvider(create: (context) => ReviewProvider()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: "Screen Gallery",
          theme: AppTheme.lightTheme,
          home: const ScreenGallery(),
        ));
  }
}
