import 'package:flutter/material.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/widgets/apartment_card.dart';

class LocationMapScreen extends StatefulWidget {
  const LocationMapScreen({super.key});

  @override
  State<LocationMapScreen> createState() => _LocationMapScreenState();
}

class _LocationMapScreenState extends State<LocationMapScreen> {
  // Mock data for apartment locations
  final List<Apartment> _apartments = [
    Apartment(id: 1, title: 'Ocean View Villa', price: 2800, location: 'Malibu, California', bedrooms: 4, bathrooms: 3, area: 320, imageUrls: ['https://via.placeholder.com/400x250/FF5722/FFFFFF?Text=Villa'], description: ''),
    Apartment(id: 2, title: 'Urban Chic Loft', price: 1500, location: 'SoHo, New York', bedrooms: 2, bathrooms: 2, area: 150, imageUrls: ['https://via.placeholder.com/400x250/4CAF50/FFFFFF?Text=Loft'], description: ''),
     Apartment(id: 3, title: 'Rooftop Penthouse', price: 4500, location: 'Shibuya, Tokyo', bedrooms: 3, bathrooms: 3, area: 200, imageUrls: ['https://via.placeholder.com/400x300/E91E63/FFFFFF?Text=Penthouse'], description: ''),
  ];

  Apartment? _selectedApartment;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apartments Near You'),
      ),
      body: Stack(
        children: [
          // This is a placeholder for the actual map widget
          Image.network(
            'https://i.stack.imgur.com/gq6kS.png', // A generic map image
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          ),

          // Mock apartment markers
          _buildMarker(top: 150, left: 50, apartment: _apartments[0]),
          _buildMarker(top: 300, left: 200, apartment: _apartments[1]),
          _buildMarker(top: 450, left: 100, apartment: _apartments[2]),

          // Show selected apartment card at the bottom
          if (_selectedApartment != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.transparent, // Ensures the card itself provides the background
                child: ApartmentCard(apartment: _selectedApartment!),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMarker({required double top, required double left, required Apartment apartment}) {
    bool isSelected = _selectedApartment?.id == apartment.id;
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedApartment = apartment;
          });
        },
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.orange : Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text('\$${apartment.price.round()}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            ClipPath(
              clipper: _TriangleClipper(),
              child: Container(
                color: isSelected ? Colors.orange : Theme.of(context).primaryColor,
                height: 10,
                width: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// A custom clipper to create the triangle shape below the marker
class _TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
