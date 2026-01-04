import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';
import 'package:plproject/generated/app_localizations.dart'; // Import localizations

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _governorateController = TextEditingController();
  final _priceController = TextEditingController();
  final _areaController = TextEditingController();
  final _roomsController = TextEditingController();

  final _picker = ImagePicker();
  List<XFile> _selectedImages = [];

  bool _isLoading = false;

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(pickedFiles);
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<void> _saveApartment() async {
    final loc = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(loc.pleaseAddOneImage), backgroundColor: Colors.orange));
      return;
    }

    setState(() => _isLoading = true);

    final apartmentProvider = Provider.of<ApartmentProvider>(context, listen: false);

    final newApartment = Apartment(
      id: 0,
      userId: 0,
      title: _titleController.text,
      description: _descriptionController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      isRented: false,
      address: _addressController.text,
      city: _cityController.text,
      governorate: _governorateController.text,
      rooms: int.tryParse(_roomsController.text) ?? 0,
      area: int.tryParse(_areaController.text) ?? 0,
      imageUrls: [],
    );

    final success = await apartmentProvider.addApartment(newApartment, _selectedImages);

    if (mounted) {
      final theme = Theme.of(context);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.apartmentAddedSuccess), backgroundColor: Colors.green));
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apartmentProvider.errorMessage ?? loc.failedToAddApartment), backgroundColor: theme.colorScheme.error));
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
      appBar: AppBar(title: Text(loc.addNewApartment)),
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
            const SizedBox(height: 24),
            _buildSectionHeader(theme, loc.photos),
            _buildImagePicker(theme, loc),
          ],
        ),
      ),
      bottomNavigationBar: _buildAddButton(loc),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }

  Widget _buildAddButton(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveApartment,
        child: _isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white))
            : Text(loc.addApartment),
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme, AppLocalizations loc) {
    return Column(
      children: [
        SizedBox(
          height: 120,
          child: _selectedImages.isEmpty
              ? _buildImagePickerPlaceholder(theme, loc)
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _selectedImages.length + 1,
            itemBuilder: (context, index) {
              if (index == _selectedImages.length) {
                return _buildAddMoreButton(theme);
              }
              return _buildImageThumbnail(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImagePickerPlaceholder(ThemeData theme, AppLocalizations loc) {
    return InkWell(
      onTap: _pickImages,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: theme.cardColor.withOpacity(0.5), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey[600]),
            const SizedBox(height: 8),
            Text(loc.addPhotos),
          ],
        ),
      ),
    );
  }

  Widget _buildAddMoreButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: _pickImages,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          decoration: BoxDecoration(color: theme.cardColor.withOpacity(0.5), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid)),
          child: Icon(Icons.add, size: 40, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(_selectedImages[index].path),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              icon: const CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black54,
                child: Icon(Icons.close, size: 14, color: Colors.white),
              ),
              onPressed: () => _removeImage(index),
            ),
          ),
        ],
      ),
    );
  }
}