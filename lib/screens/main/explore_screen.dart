import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sakani/providers/apartment_provider.dart';
import 'package:sakani/widgets/apartment_card.dart';
import 'package:sakani/models/apartment.dart';
import 'package:sakani/generated/app_localizations.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  Timer? _debounce;
  Map<String, String> _activeFilters = {};

  @override
  void initState() {
    super.initState();
    // Listen to search changes to apply local filtering
    _searchController.addListener(_onSearchChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ApartmentProvider>(context, listen: false);
      if (provider.allApartments.isEmpty) {
        provider.fetchApartments();
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // --- MODIFIED: Performs a local filter by just rebuilding the state ---
  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      // Rebuild the widget to apply the search query as a local filter
      setState(() {});
    });
  }

  // --- MODIFIED: Only sends active filters to the backend, search is local ---
  void _runFilters() {
    final provider = Provider.of<ApartmentProvider>(context, listen: false);
    // Search query is handled locally, so we only pass the sheet filters
    provider.fetchApartments(filters: _activeFilters);
  }

  void _applyFiltersFromSheet(Map<String, String> newFilters) {
    setState(() {
      _activeFilters = newFilters;
    });
    _runFilters();
  }

  void _resetFilters() {
    if (_searchController.text.isNotEmpty) {
      _searchController.clear(); // This will trigger a rebuild
    }
    setState(() {
      _activeFilters = {};
    });
    // Refetch from the backend with no filters
    _runFilters();
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _FilterSheet(
        initialFilters: _activeFilters,
        onApply: _applyFiltersFromSheet,
        onReset: _resetFilters,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.exploreScreenTitle)),
      body: Column(
        children: [
          _buildSearchBar(loc),
          Expanded(
            child: Consumer<ApartmentProvider>(
              builder: (context, provider, child) {
                if (provider.status == ApartmentStatus.Loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (provider.status == ApartmentStatus.Error) {
                  return Center(
                    child: Text(provider.errorMessage ?? loc.genericFetchError),
                  );
                }

                // --- NEW: Local search filtering logic ---
                final allApartments = provider.allApartments;
                final searchQuery = _searchController.text.trim().toLowerCase();

                final filteredApartments = searchQuery.isEmpty
                    ? allApartments
                    : allApartments.where((apartment) {
                        final title = apartment.title.toLowerCase();
                        final address = apartment.address?.toLowerCase() ?? '';
                        return title.contains(searchQuery) || address.contains(searchQuery);
                      }).toList();
                // --- End of local search logic ---

                if (filteredApartments.isEmpty) {
                  return Center(child: Text(loc.noResults));
                }

                return RefreshIndicator(
                  onRefresh: () => provider.fetchApartments(filters: _activeFilters),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: filteredApartments.length, // Use filtered list
                    itemBuilder: (context, index) => ApartmentCard(apartment: filteredApartments[index]), // Use filtered list
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: loc.searchPlaceholder,
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
  final Function(Map<String, String>) onApply;
  final VoidCallback onReset;
  final Map<String, String> initialFilters;

  const _FilterSheet({required this.onApply, required this.onReset, required this.initialFilters});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late RangeValues _priceRange;
  late TextEditingController _governorateController;
  late TextEditingController _cityController;
  late int _rooms;

  @override
  void initState() {
    super.initState();
    _governorateController = TextEditingController(text: widget.initialFilters['governorate']);
    _cityController = TextEditingController(text: widget.initialFilters['city']);
    _rooms = int.tryParse(widget.initialFilters['number_of_rooms'] ?? '0') ?? 0;
    final minPrice = double.tryParse(widget.initialFilters['min_price'] ?? '0') ?? 0;
    final maxPrice = double.tryParse(widget.initialFilters['max_price'] ?? '5000') ?? 5000;
    _priceRange = RangeValues(minPrice, maxPrice);
  }

  void _handleApply() {
    final filters = <String, String>{};
    if (_priceRange.start.round() > 0) {
      filters['min_price'] = _priceRange.start.round().toString();
    }
    if (_priceRange.end.round() < 5000) {
      filters['max_price'] = _priceRange.end.round().toString();
    }
    if (_governorateController.text.isNotEmpty) {
      filters['governorate'] = _governorateController.text;
    }
    if (_cityController.text.isNotEmpty) {
      filters['city'] = _cityController.text;
    }
    if (_rooms > 0) {
      filters['number_of_rooms'] = _rooms.toString();
    }
    widget.onApply(filters);
    Navigator.of(context).pop();
  }

  void _handleReset() {
    widget.onReset();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(loc.filterSheetTitle, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 24),
          Text(loc.filterLocation, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: TextField(controller: _governorateController, decoration: InputDecoration(labelText: loc.governorate))),
              const SizedBox(width: 10),
              Expanded(child: TextField(controller: _cityController, decoration: InputDecoration(labelText: loc.city))),
            ],
          ),
          const SizedBox(height: 24),
          Text(loc.filterPriceRange, style: Theme.of(context).textTheme.titleLarge),
          Text('\$${_priceRange.start.round()} - \$${_priceRange.end.round()}'),
          RangeSlider(values: _priceRange, min: 0, max: 5000, divisions: 100, labels: RangeLabels(_priceRange.start.round().toString(), _priceRange.end.round().toString()), onChanged: (v) => setState(() => _priceRange = v)),
          const SizedBox(height: 16),
          Text(loc.filterSpecifications, style: Theme.of(context).textTheme.titleLarge),
          _buildCounter(loc.minRooms, _rooms, (val) => setState(() => _rooms = val)),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(child: OutlinedButton(onPressed: _handleReset, child: Text(loc.reset))),
              const SizedBox(width: 10),
              Expanded(child: ElevatedButton(onPressed: _handleApply, child: Text(loc.applyFilters))),
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
  }
}
