import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _currentPriceRange = const RangeValues(500, 5000);
  int? _selectedBedrooms;
  final List<String> _amenities = ['Parking', 'Pool', 'Balcony', 'Wi-Fi', 'Pet Friendly'];
  final Set<String> _selectedAmenities = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          TextButton(onPressed: () {
            setState(() {
              _currentPriceRange = const RangeValues(500, 5000);
              _selectedBedrooms = null;
              _selectedAmenities.clear();
            });
          }, child: const Text('Reset')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader(theme, 'Price Range'),
          RangeSlider(
            values: _currentPriceRange,
            min: 0,
            max: 10000,
            divisions: 20,
            labels: RangeLabels(
              '\$${_currentPriceRange.start.round().toString()}',
              '\$${_currentPriceRange.end.round().toString()}',
            ),
            onChanged: (RangeValues values) {
              setState(() {
                _currentPriceRange = values;
              });
            },
          ),
          const SizedBox(height: 24),
          
          _buildSectionHeader(theme, 'Bedrooms'),
          _buildChoiceChips(),
          const SizedBox(height: 24),
          
          _buildSectionHeader(theme, 'Amenities'),
          _buildAmenitiesCheckboxes(),
        ],
      ),
      bottomNavigationBar: _buildApplyButton(theme),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }

  Widget _buildChoiceChips() {
    return Wrap(
      spacing: 8.0,
      children: [1, 2, 3, 4, 5].map((number) {
        return ChoiceChip(
          label: Text('$number'),
          selected: _selectedBedrooms == number,
          onSelected: (bool selected) {
            setState(() {
              _selectedBedrooms = selected ? number : null;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildAmenitiesCheckboxes() {
    return Column(
      children: _amenities.map((amenity) {
        return CheckboxListTile(
          title: Text(amenity),
          value: _selectedAmenities.contains(amenity),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _selectedAmenities.add(amenity);
              } else {
                _selectedAmenities.remove(amenity);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildApplyButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Apply filter logic
          Navigator.pop(context); // Close the filter screen
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: const Text('Apply Filters'),
      ),
    );
  }
}
