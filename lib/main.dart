import 'package:flutter/material.dart';
import 'package:plproject/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/providers/booking_provider.dart';
import 'package:plproject/providers/review_provider.dart';
import 'package:plproject/providers/user_provider.dart';
import 'package:plproject/screens/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        
        ChangeNotifierProxyProvider<UserProvider, ApartmentProvider>(
          create: (context) => ApartmentProvider(),
          update: (context, userProvider, apartmentProvider) {
            apartmentProvider?.update(userProvider);
            return apartmentProvider!;
          },
        ),

        ChangeNotifierProxyProvider<UserProvider, BookingProvider>(
          create: (context) => BookingProvider(),
          update: (context, userProvider, bookingProvider) {
            bookingProvider?.update(userProvider);
            return bookingProvider!;
          },
        ),

        ChangeNotifierProxyProvider<UserProvider, ReviewProvider>(
          create: (context) => ReviewProvider(),
          update: (context, userProvider, reviewProvider) {
            reviewProvider?.update(userProvider);
            return reviewProvider!;
          },
        ),
        
        ChangeNotifierProvider(create: (context) => AdminProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Rent Apartments",
        theme: AppTheme.lightTheme,
        home: const AuthGate(),
      ),
    );
  }
}
