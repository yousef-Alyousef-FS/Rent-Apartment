import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/widgets/CTextField.dart'; // Using our custom text field

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final _cityController = TextEditingController();
  final _bedroomsController = TextEditingController();
  double _maxPrice = 5000;

  void _applyFilters() {
    final filters = <String, String>{};

    if (_cityController.text.isNotEmpty) {
      filters['city'] = _cityController.text;
    }
    if (_bedroomsController.text.isNotEmpty) {
      filters['bedrooms'] = _bedroomsController.text;
    }
    // Always include a max price
    filters['max_price'] = _maxPrice.round().toString();

    Provider.of<ApartmentProvider>(context, listen: false).fetchApartments(filters: filters);
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _cityController.dispose();
    _bedroomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Apartments'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(theme, 'Location'),
          CTextField(controller: _cityController, hintText: 'e.g., Damascus'),
          const SizedBox(height: 24),

          _buildSectionHeader(theme, 'Price'),
          Text('Max Price: \$${_maxPrice.round()}/night', style: theme.textTheme.titleMedium),
          Slider(
            value: _maxPrice,
            min: 50,
            max: 5000,
            divisions: 99,
            label: _maxPrice.round().toString(),
            onChanged: (value) {
              setState(() {
                _maxPrice = value;
              });
            },
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader(theme, 'Specifications'),
          CTextField(
            controller: _bedroomsController,
            hintText: 'Number of Bedrooms',
            textInputType: TextInputType.number,
          ),

        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
          onPressed: _applyFilters,
          child: const Text('Apply Filters'),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }
}
