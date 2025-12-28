import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/widgets/CTextField.dart';

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  final _bedroomsController = TextEditingController();
  final _bathroomsController = TextEditingController();

  bool _isLoading = false;

  Future<void> _saveApartment() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
    });

    final apartmentProvider = Provider.of<ApartmentProvider>(context, listen: false);

    // Create the apartment object from the form data
    final newApartment = Apartment(
      id: 0, // The backend will assign the ID
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      area: int.tryParse(_areaController.text) ?? 0,
      bedrooms: int.tryParse(_bedroomsController.text) ?? 0,
      bathrooms: int.tryParse(_bathroomsController.text) ?? 0,
      imageUrls: [], // Image handling will be added later
    );

    final success = await apartmentProvider.addApartment(newApartment);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Apartment added successfully!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apartmentProvider.errorMessage ?? 'Failed to add apartment.'), backgroundColor: Colors.red),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    // Dispose all controllers
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _bedroomsController.dispose();
    _bathroomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Apartment'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionHeader(theme, 'Basic Information'),
            CTextField(controller: _titleController, hintText: 'Apartment Title', validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            CTextField(controller: _descriptionController, hintText: 'Description', maxLines: 5, validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 16),
            CTextField(controller: _locationController, hintText: 'Location', validator: (v) => v!.isEmpty ? 'Required' : null),
            const SizedBox(height: 24),

            _buildSectionHeader(theme, 'Specifications'),
            Row(
              children: [
                Expanded(child: CTextField(controller: _priceController, hintText: 'Price / night', textInputType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
                const SizedBox(width: 16),
                Expanded(child: CTextField(controller: _areaController, hintText: 'Area (sqft)', textInputType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: CTextField(controller: _bedroomsController, hintText: 'Bedrooms', textInputType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
                const SizedBox(width: 16),
                Expanded(child: CTextField(controller: _bathroomsController, hintText: 'Bathrooms', textInputType: TextInputType.number, validator: (v) => v!.isEmpty ? 'Required' : null)),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(theme, 'Photos'),
            // TODO: Add image upload UI
            Container(height: 120, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), child: const Center(child: Text('Image upload coming soon'))),
          ],
        ),
      ),
       bottomNavigationBar: _buildAddButton(theme),
    );
  }

   Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }

  Widget _buildAddButton(ThemeData theme) {
     return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveApartment,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Add Apartment'),
      ),
    );
  }
}
