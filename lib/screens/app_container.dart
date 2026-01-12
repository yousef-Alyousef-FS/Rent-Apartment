import 'package:flutter/material.dart';
import 'package:sakani/generated/app_localizations.dart';
import 'package:sakani/screens/booking/bookings_list_screen.dart';
import 'package:sakani/screens/main/explore_screen.dart';
import 'package:sakani/screens/main/favorites_screen.dart';
import 'package:sakani/screens/main/home_screen.dart';
import 'package:sakani/screens/owner/owner_dashboard.dart';

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<AppContainer> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int _selectedIndex = 0;

  static const List<Widget> _mainScreens = <Widget>[
    HomeScreen(),
    ExploreScreen(),
    FavoritesScreen(),
    OwnerDashboard(),
    BookingsListScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _mainScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: loc.navHome,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search_outlined),
            activeIcon: const Icon(Icons.search),
            label: loc.navExplore,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            activeIcon: const Icon(Icons.favorite),
            label: loc.navFavorites,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.business_outlined),
            activeIcon: const Icon(Icons.business),
            label: loc.navMyPlace,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bookmark_border),
            activeIcon: const Icon(Icons.bookmark),
            label: loc.navBookings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: false,
      ),
    );
  }
}
