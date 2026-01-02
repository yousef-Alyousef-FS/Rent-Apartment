import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/widgets/apartment_card.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  
  List<Apartment> _filteredApartments = [];
  Map<String, dynamic>? _activeFilters;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_runFilters);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final apartmentProvider = Provider.of<ApartmentProvider>(context);
      if (apartmentProvider.status == ApartmentStatus.Loaded) {
        _filteredApartments = apartmentProvider.allApartments;
        _isInitialized = true;
      }
    }
  }

  @override
  void dispose() {
    _searchController.removeListener(_runFilters);
    _searchController.dispose();
    super.dispose();
  }

  // --- UPDATED: Client-side filtering logic with correct fields ---
  void _runFilters() {
    final apartmentProvider = Provider.of<ApartmentProvider>(context, listen: false);
    final allApartments = apartmentProvider.allApartments;
    final query = _searchController.text.toLowerCase();
    
    List<Apartment> results = allApartments.where((apartment) {
      // 1. Search Query Filter
      final titleMatch = apartment.title.toLowerCase().contains(query);
      if (!titleMatch) return false;

      // 2. Filters from the Bottom Sheet
      if (_activeFilters != null) {
        if (_activeFilters!.containsKey('min_price') && apartment.price < _activeFilters!['min_price']!) return false;
        if (_activeFilters!.containsKey('max_price') && apartment.price > _activeFilters!['max_price']!) return false;
        if (_activeFilters!.containsKey('rooms') && (apartment.rooms ?? 0) < _activeFilters!['rooms']!) return false;
        
        final governorate = _activeFilters!['governorate']?.toLowerCase();
        final city = _activeFilters!['city']?.toLowerCase();

        if (governorate != null && !(apartment.governorate?.toLowerCase().contains(governorate) ?? false)) return false;
        if (city != null && !(apartment.city?.toLowerCase().contains(city) ?? false)) return false;
      }
      
      return true;
    }).toList();

    setState(() {
      _filteredApartments = results;
    });
  }

  void _applyFiltersFromSheet(Map<String, dynamic> newFilters) {
    setState(() {
      _activeFilters = newFilters;
    });
    _runFilters();
  }

  void _resetFilters() {
    _searchController.clear();
    setState(() {
      _activeFilters = null;
    });
    _runFilters();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _FilterSheet(
        onApply: _applyFiltersFromSheet,
        onReset: _resetFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore & Search')),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: Consumer<ApartmentProvider>(
              builder: (context, provider, child) {
                if (provider.status == ApartmentStatus.Loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.status == ApartmentStatus.Error) {
                  return Center(child: Text(provider.errorMessage ?? 'An error occurred.'));
                }
                
                if (!_isInitialized) {
                  _filteredApartments = provider.allApartments;
                  _isInitialized = true;
                }

                if (_filteredApartments.isEmpty && (_searchController.text.isNotEmpty || _activeFilters != null)) {
                  return const Center(child: Text('No apartments match your criteria.'));
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchApartments(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredApartments.length,
                    itemBuilder: (context, index) => ApartmentCard(apartment: _filteredApartments[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search places...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                filled: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterSheet,
          ),
        ],
      ),
    );
  }
}


class _FilterSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApply;
  final VoidCallback onReset;

  const _FilterSheet({required this.onApply, required this.onReset});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  RangeValues _priceRange = const RangeValues(100, 5000);
  final _governorateController = TextEditingController();
  final _cityController = TextEditingController();
  // --- UPDATED: from bedrooms to rooms, removed bathrooms ---
  int _rooms = 0;

  void _handleApply() {
    final filters = <String, dynamic>{
      'min_price': _priceRange.start.round(),
      'max_price': _priceRange.end.round(),
      'governorate': _governorateController.text,
      'city': _cityController.text,
      'rooms': _rooms,
    };
    filters.removeWhere((key, value) => value == null || (value is String && value.isEmpty) || (value is int && value == 0) );
    widget.onApply(filters);
    Navigator.of(context).pop();
  }

  void _handleReset() {
    widget.onReset();
    Navigator.of(context).pop();
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Filter Options', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          Text('Location', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: TextField(controller: _governorateController, decoration: const InputDecoration(labelText: 'Governorate'))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: _cityController, decoration: const InputDecoration(labelText: 'City'))),
            ],
          ),
          const SizedBox(height: 24),
          Text('Price Range', style: Theme.of(context).textTheme.titleLarge),
          Text('\$${_priceRange.start.round()} - \$${_priceRange.end.round()}'),
          RangeSlider(values: _priceRange, min: 0, max: 5000, divisions: 100, labels: RangeLabels(_priceRange.start.round().toString(), _priceRange.end.round().toString()), onChanged: (v) => setState(() => _priceRange = v)),
          const SizedBox(height: 16),
          Text('Specifications', style: Theme.of(context).textTheme.titleLarge),
          // --- UPDATED: Changed label, removed bathrooms counter ---
          _buildCounter('Min. Rooms', _rooms, (val) => setState(() => _rooms = val)),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: _handleReset, child: const Text('Reset'))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: _handleApply, child: const Text('Apply Filters'))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(String label, int value, ValueChanged<int> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.titleMedium),
          Row(
            children: [
              IconButton(icon: const Icon(Icons.remove_circle_outline), visualDensity: VisualDensity.compact, onPressed: value > 0 ? () => onChanged(value - 1) : null),
              Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.add_circle_outline), visualDensity: VisualDensity.compact, onPressed: () => onChanged(value + 1)),
            ],
          ),
        ],
      ),
    );
  }}
