import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/models/booking.dart';
import 'package:plproject/models/user.dart';

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
import '../main/settings_screen.dart';

// Booking
import '../booking/bookings_list_screen.dart';
import '../booking/review_screen.dart';
import '../booking/booking_success_screen.dart';

// Owner
import '../owner/owner_dashboard.dart';
import '../owner/add_apartment_screen.dart';
import '../owner/my_apartments_screen.dart';
import '../owner/edit_apartment_screen.dart';
import '../owner/owner_bookings_screen.dart';

// User Profile
import '../profile/profile_screen.dart';
import '../profile/edit_profile_screen.dart';


class ScreenGallery extends StatelessWidget {
  const ScreenGallery({super.key});

  Widget _buildNavButton(BuildContext context, String title, Widget screen) {
    return ListTile(
      title: Text(title),
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => screen)),
      trailing: const Icon(Icons.chevron_right),
    );
  }

  Widget _buildCategoryHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).primaryColor)),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- MOCK DATA --- 
    final mockApartment = Apartment(id: 1, title: 'Luxury Villa', description: 'A beautiful villa with a stunning view.', price: 350, location: 'Beverly Hills, CA', bedrooms: 5, bathrooms: 4, area: 450, imageUrls: ['https://via.placeholder.com/400x250.png/007BFF/FFFFFF?text=Villa', 'https://via.placeholder.com/400x250.png/6c757d/FFFFFF?text=Living+Room'], average_rating: 4.8, reviews_count: 62);
    final mockUser = User(id: 1, first_name: 'John', last_name: 'Doe', phone: '+123456789');
    final mockBooking = Booking(id: 1, checkInDate: DateTime.now(), checkOutDate: DateTime.now().add(const Duration(days: 5)), totalPrice: 1750, status: 'pending_approval', apartment: mockApartment, user: mockUser);

    return Scaffold(
      appBar: AppBar(title: const Text('Screen Gallery')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildCategoryHeader(context, 'Auth Flow'),
          _buildNavButton(context, 'Welcome Screen', const WelcomeAuthScreen()),
          _buildNavButton(context, 'Login Screen', const LoginScreen()),
          _buildNavButton(context, 'Register Screen', const RegisterPage()),
          _buildNavButton(context, 'Forgot Password', const ForgotPasswordScreen()),
          _buildNavButton(context, 'Complete Profile', CompleteProfile(phone: 'mock', password: 'mock')),
          _buildNavButton(context, 'Pending Approval', const PendingApprovalScreen()),
          
          _buildCategoryHeader(context, 'Main App Flow'),
          _buildNavButton(context, 'Home Screen', const HomeScreen()),
          _buildNavButton(context, 'Apartment Details', ApartmentDetailsScreen(apartment: mockApartment)),
          _buildNavButton(context, 'Explore Screen', const ExploreScreen()),
          _buildNavButton(context, 'Search Screen', const SearchScreen()),
          _buildNavButton(context, 'Filter Screen', const FilterScreen()),
          _buildNavButton(context, 'Settings', const SettingsScreen()),

          _buildCategoryHeader(context, 'Booking Flow'),
          _buildNavButton(context, 'My Bookings List', const BookingsListScreen()),
          _buildNavButton(context, 'Write a Review', ReviewScreen(apartmentId: mockApartment.id)),
          _buildNavButton(context, 'Booking Success', const BookingSuccessScreen()),

          _buildCategoryHeader(context, 'Owner Flow'),
           _buildNavButton(context, 'Owner Dashboard', const OwnerDashboard()),
          _buildNavButton(context, 'Add Apartment', const AddApartmentScreen()),
          _buildNavButton(context, 'My Apartments', const MyApartmentsScreen()),
          _buildNavButton(context, 'Edit Apartment', EditApartmentScreen(apartment: mockApartment)),
          _buildNavButton(context, 'Owner Bookings', const OwnerBookingsScreen()),

          _buildCategoryHeader(context, 'User Profile'),
          _buildNavButton(context, 'Profile Screen', const ProfileScreen()),
          _buildNavButton(context, 'Edit Profile', const EditProfileScreen()),
        ],
      ),
    );
  }
}
