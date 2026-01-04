import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/generated/app_localizations.dart';

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
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _governorateController;
  late TextEditingController _priceController;
  late TextEditingController _areaController;
  late TextEditingController _roomsController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.apartment.title);
    _descriptionController = TextEditingController(text: widget.apartment.description);
    _addressController = TextEditingController(text: widget.apartment.address);
    _cityController = TextEditingController(text: widget.apartment.city);
    _governorateController = TextEditingController(text: widget.apartment.governorate);
    _priceController = TextEditingController(text: widget.apartment.price.toString());
    _areaController = TextEditingController(text: widget.apartment.area?.toString());
    _roomsController = TextEditingController(text: widget.apartment.rooms?.toString());
  }

  Future<void> _saveChanges() async {
    final loc = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    final apartmentProvider = Provider.of<ApartmentProvider>(context, listen: false);
    final updatedData = widget.apartment.copyWith(
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? widget.apartment.price,
      address: _addressController.text,
      city: _cityController.text,
      governorate: _governorateController.text,
      rooms: int.tryParse(_roomsController.text) ?? widget.apartment.rooms,
      area: int.tryParse(_areaController.text) ?? widget.apartment.area,
    );

    // --- SIMPLIFIED: Call the simplified provider method ---
    final success = await apartmentProvider.updateApartment(updatedData);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.changesSavedSuccess), backgroundColor: Colors.green),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(apartmentProvider.errorMessage ?? loc.failedToSaveChanges),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _governorateController.dispose();
    _priceController.dispose();
    _areaController.dispose();
    _roomsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(loc.editApartment)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionHeader(theme, loc.basicInformation),
            TextFormField(controller: _titleController, decoration: InputDecoration(labelText: loc.title), validator: (v) => v!.isEmpty ? loc.required : null),
            const SizedBox(height: 16),
            TextFormField(controller: _descriptionController, decoration: InputDecoration(labelText: loc.description), maxLines: 5, validator: (v) => v!.isEmpty ? loc.required : null),
            const SizedBox(height: 24),
            _buildSectionHeader(theme, loc.location),
            TextFormField(controller: _governorateController, decoration: InputDecoration(labelText: loc.governorate), validator: (v) => v!.isEmpty ? loc.required : null),
            const SizedBox(height: 16),
            TextFormField(controller: _cityController, decoration: InputDecoration(labelText: loc.city), validator: (v) => v!.isEmpty ? loc.required : null),
            const SizedBox(height: 16),
            TextFormField(controller: _addressController, decoration: InputDecoration(labelText: loc.detailedAddress), validator: (v) => v!.isEmpty ? loc.required : null),
            const SizedBox(height: 24),
            _buildSectionHeader(theme, loc.specifications),
            Row(
              children: [
                Expanded(child: TextFormField(controller: _priceController, decoration: InputDecoration(labelText: loc.pricePerNight), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? loc.required : null)),
                const SizedBox(width: 16),
                Expanded(child: TextFormField(controller: _areaController, decoration: InputDecoration(labelText: loc.areaSqm), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? loc.required : null)),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(controller: _roomsController, decoration: InputDecoration(labelText: loc.numberOfRooms), keyboardType: TextInputType.number, validator: (v) => v!.isEmpty ? loc.required : null),
            // --- DELETED: The entire photo management section is removed ---
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveChangesButton(loc),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }

  Widget _buildSaveChangesButton(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveChanges,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : Text(loc.saveChanges),
      ),
    );
  }
}
