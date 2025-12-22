import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';

// --- Import ALL screens ---

// Auth
import '../auth/welcome_auth_screen.dart';
import '../auth/login.dart';
import '../auth/register.dart';
import '../auth/forgot_password_screen.dart';
import '../auth/complete_profile.dart';
import '../auth/pending_approval_screen.dart';

// Main App
import '../main/home_screen.dart';
import '../main/explore_screen.dart';
import '../apartments/apartment_details_screen.dart';
import '../main/search_screen.dart';
import '../main/filter_screen.dart';
import '../main/location_map_screen.dart';
import '../main/settings_screen.dart';
import '../apartments/apartment.dart';

// Booking
import '../booking/booking_screen.dart';
import '../booking/bookings_list_screen.dart';
import '../booking/booking_detail_screen.dart';
import '../booking/review_screen.dart';
import '../booking/booking_success_screen.dart';

// Owner
import '../owner/owner_dashboard.dart';
import '../owner/add_apartment_screen.dart';
import '../owner/my_apartments_screen.dart';
import '../owner/edit_apartment_screen.dart';
import '../owner/owner_bookings_screen.dart';
import '../owner/manage_booking_screen.dart';
import '../owner/owner_profile_screen.dart';

// User Profile
import '../profile/profile_screen.dart';
import '../profile/edit_profile_screen.dart';
import '../profile/change_password_screen.dart';
import '../profile/my_reviews_screen.dart';

// Common
import '../common/splash_screen.dart';
import '../common/no_internet_screen.dart';
import '../common/error_screen.dart';
import '../common/loading_screen.dart';

// Admin
import '../admin/admin_login_screen.dart';
import '../admin/admin_dashboard_screen.dart';


class ScreenGallery extends StatelessWidget {
  const ScreenGallery({super.key});

  Widget _buildNavButton(BuildContext context, String title, Widget screen) {
    return ListTile(
      title: Text(title),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mockApartment = Apartment(
      id: 1, title: 'Luxury Villa', description: '...', 
      price: 3500, location: 'Beverly Hills', bedrooms: 5, bathrooms: 4, area: 450, 
      imageUrls: []
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Screen Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCategoryHeader('Auth Flow'),
          _buildNavButton(context, 'Welcome Screen', const WelcomeAuthScreen()),
          _buildNavButton(context, 'Login Screen', const LoginScreen()),
          _buildNavButton(context, 'Register Screen', const RegisterPage()),
          _buildNavButton(context, 'Forgot Password', const ForgotPasswordScreen()),
          _buildNavButton(context, 'Complete Profile', const CompleteProfile()),
          _buildNavButton(context, 'Pending Approval', const PendingApprovalScreen()),
          
          _buildCategoryHeader('Main App Flow'),
          _buildNavButton(context, 'Home Screen', const HomeScreen()),
          _buildNavButton(context, 'Explore Screen', const ExploreScreen()),
          _buildNavButton(context, 'Apartments List', const Apartments()),
          _buildNavButton(context, 'Apartment Details', ApartmentDetailsScreen(apartment: mockApartment)),
          _buildNavButton(context, 'Search Screen', const SearchScreen()),
          _buildNavButton(context, 'Filter Screen', const FilterScreen()),
          _buildNavButton(context, 'Location Map', const LocationMapScreen()),
          _buildNavButton(context, 'Settings', const SettingsScreen()),

          _buildCategoryHeader('Booking Flow'),
          _buildNavButton(context, 'Booking Screen',  BookingScreen()),
          _buildNavButton(context, 'My Bookings List', const BookingsListScreen()),
          _buildNavButton(context, 'Booking Detail', const BookingDetailScreen()),
          _buildNavButton(context, 'Write a Review', const ReviewScreen()),
          _buildNavButton(context, 'Booking Success', const BookingSuccessScreen()),

          _buildCategoryHeader('Owner Flow'),
           _buildNavButton(context, 'Owner Dashboard', const OwnerDashboard()),
          _buildNavButton(context, 'Add Apartment', const AddApartmentScreen()),
          _buildNavButton(context, 'My Apartments', const MyApartmentsScreen()),
          _buildNavButton(context, 'Edit Apartment', const EditApartmentScreen()),
          _buildNavButton(context, 'Owner Bookings', const OwnerBookingsScreen()),
          _buildNavButton(context, 'Manage Booking', const ManageBookingScreen()),
          _buildNavButton(context, 'Owner Profile', const OwnerProfileScreen()),

          _buildCategoryHeader('User Profile'),
          _buildNavButton(context, 'Profile Screen', const ProfileScreen()),
          _buildNavButton(context, 'Edit Profile', const EditProfileScreen()),
          _buildNavButton(context, 'Change Password', const ChangePasswordScreen()),
          _buildNavButton(context, 'My Reviews', const MyReviewsScreen()),

          _buildCategoryHeader('Common Screens'),
          _buildNavButton(context, 'Splash Screen', const SplashScreen()),
          _buildNavButton(context, 'No Internet', const NoInternetScreen()),
          _buildNavButton(context, 'Error Screen', const ErrorScreen()),
          _buildNavButton(context, 'Loading Screen', const LoadingScreen()),

           _buildCategoryHeader('Admin Flow'),
          _buildNavButton(context, 'Admin Login', const AdminLoginScreen()),
          _buildNavButton(context, 'Admin Dashboard', const AdminDashboardScreen()),
        ],
      ),
    );
  }
}
