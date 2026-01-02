import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/apartment.dart';
import 'package:plproject/providers/apartment_provider.dart';

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

  final _picker = ImagePicker();
  List<String> _existingImageUrls = [];
  List<XFile> _newImages = [];
  List<String> _deletedImageUrls = [];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.apartment.title);
    _descriptionController = TextEditingController(
      text: widget.apartment.description,
    );
    _addressController = TextEditingController(text: widget.apartment.address);
    _cityController = TextEditingController(text: widget.apartment.city);
    _governorateController = TextEditingController(
      text: widget.apartment.governorate,
    );
    _priceController = TextEditingController(
      text: widget.apartment.price.toString(),
    );
    _areaController = TextEditingController(
      text: widget.apartment.area?.toString(),
    );
    _roomsController = TextEditingController(
      text: widget.apartment.rooms?.toString(),
    );
    _existingImageUrls = List.from(widget.apartment.imageUrls);
  }

  Future<void> _pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _newImages.addAll(pickedFiles);
      });
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _deletedImageUrls.add(_existingImageUrls[index]);
      _existingImageUrls.removeAt(index);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  Future<void> _saveChanges() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_existingImageUrls.isEmpty && _newImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one image.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final apartmentProvider = Provider.of<ApartmentProvider>(
      context,
      listen: false,
    );
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

    final success = await apartmentProvider.updateApartment(
      updatedData,
      newImages: _newImages,
      deletedImageUrls: _deletedImageUrls,
    );

    if (mounted) {
      final theme = Theme.of(context);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              apartmentProvider.errorMessage ?? 'Failed to save changes.',
            ),
            backgroundColor: theme.colorScheme.error,
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
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Apartment')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionHeader(theme, 'Basic Information'),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 5,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(theme, 'Location'),
            TextFormField(
              controller: _governorateController,
              decoration: const InputDecoration(labelText: 'Governorate'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'City'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Detailed Address'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(theme, 'Specifications'),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                      labelText: 'Price / night',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _areaController,
                    decoration: const InputDecoration(labelText: 'Area (sqm)'),
                    keyboardType: TextInputType.number,
                    validator: (v) => v!.isEmpty ? 'Required' : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _roomsController,
              decoration: const InputDecoration(labelText: 'Number of Rooms'),
              keyboardType: TextInputType.number,
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader(theme, 'Photos'),
            _buildImagePicker(theme),
          ],
        ),
      ),
      bottomNavigationBar: _buildSaveChangesButton(),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }

  Widget _buildSaveChangesButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveChanges,
        child: _isLoading
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text('Save Changes'),
      ),
    );
  }

  Widget _buildImagePicker(ThemeData theme) {
    return SizedBox(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._existingImageUrls.asMap().entries.map(
            (entry) => _buildImageThumbnail(entry.value, true, entry.key),
          ),
          ..._newImages.asMap().entries.map(
            (entry) => _buildImageThumbnail(entry.value.path, false, entry.key),
          ),
          _buildAddMoreButton(theme),
        ],
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
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade400,
              style: BorderStyle.solid,
            ),
          ),
          child: Icon(Icons.add, size: 40, color: Colors.grey[600]),
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(String imagePath, bool isExisting, int index) {
    ImageProvider imageProvider = isExisting
        ? NetworkImage(imagePath)
        : FileImage(File(imagePath)) as ImageProvider;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image(
              image: imageProvider,
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
              // --- THIS LINE IS NOW COMPLETE ---
              onPressed: () => isExisting
                  ? _removeExistingImage(index)
                  : _removeNewImage(index),
            ),
          ),
        ],
      ),
    );
  }
}
