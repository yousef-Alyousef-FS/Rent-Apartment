import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/widgets/CTextField.dart';

class EditApartmentScreen extends StatefulWidget {
  final Apartment apartment;
  const EditApartmentScreen({super.key, required this.apartment});

  @override
  State<EditApartmentScreen> createState() => _EditApartmentScreenState();
}

class _EditApartmentScreenState extends State<EditApartmentScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;
  late TextEditingController _priceController;
  late TextEditingController _areaController;
  late TextEditingController _bedroomsController;
  late TextEditingController _bathroomsController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.apartment.title);
    _descriptionController = TextEditingController(text: widget.apartment.description);
    _locationController = TextEditingController(text: widget.apartment.location);
    _priceController = TextEditingController(text: widget.apartment.price.toString());
    _areaController = TextEditingController(text: widget.apartment.area.toString());
    _bedroomsController = TextEditingController(text: widget.apartment.bedrooms.toString());
    _bathroomsController = TextEditingController(text: widget.apartment.bathrooms.toString());
  }

  Future<void> _saveChanges() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _isLoading = true;
    });

    final apartmentProvider = Provider.of<ApartmentProvider>(context, listen: false);

    final updatedApartment = widget.apartment.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      price: double.tryParse(_priceController.text) ?? widget.apartment.price,
      area: int.tryParse(_areaController.text) ?? widget.apartment.area,
      bedrooms: int.tryParse(_bedroomsController.text) ?? widget.apartment.bedrooms,
      bathrooms: int.tryParse(_bathroomsController.text) ?? widget.apartment.bathrooms,
    );

    final success = await apartmentProvider.updateApartment(updatedApartment);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully!'), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(apartmentProvider.errorMessage ?? 'Failed to save changes.'), backgroundColor: Colors.red),
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
        title: const Text('Edit Apartment'),
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
            Container(height: 120, decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(12)), child: const Center(child: Text('Image management coming soon'))),
          ],
        ),
      ),
       bottomNavigationBar: _buildSaveChangesButton(theme),
    );
  }

   Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }

  Widget _buildSaveChangesButton(ThemeData theme) {
     return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveChanges,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: _isLoading 
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Save Changes'),
      ),
    );
  }
}
