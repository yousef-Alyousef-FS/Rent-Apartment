import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:sakani/models/apartment.dart';
import 'package:sakani/models/apartment_image.dart';
import 'package:sakani/providers/apartment_provider.dart';
import 'package:sakani/generated/app_localizations.dart';

class EditApartmentScreen extends StatefulWidget {
  final Apartment apartment;
  const EditApartmentScreen({super.key, required this.apartment});

  @override
  State<EditApartmentScreen> createState() => _EditApartmentScreenState();
}

class _EditApartmentScreenState extends State<EditApartmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _governorateController;
  late TextEditingController _priceController;
  late TextEditingController _areaController;
  late TextEditingController _roomsController;

  bool _isSavingText = false;
  final Set<int> _imagesBeingDeleted = {};
  bool _isUploadingImage = false;

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

  Future<void> _saveTextChanges() async {
    final loc = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSavingText = true);

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

    final success = await apartmentProvider.updateApartment(updatedData);
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(loc.changesSavedSuccess), backgroundColor: Colors.green));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(apartmentProvider.errorMessage ?? loc.failedToSaveChanges), backgroundColor: Theme.of(context).colorScheme.error));
    }
    setState(() => _isSavingText = false);
  }

  // ---MODIFIED---
  Future<void> _deleteImage(int imageId) async {
    setState(() => _imagesBeingDeleted.add(imageId));
    final provider = Provider.of<ApartmentProvider>(context, listen: false);
    // The provider now expects a list of IDs, so we wrap the single ID in a list.
    final success = await provider.removeImageFromApartment(widget.apartment.id, imageId);
    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.errorMessage ?? 'Failed to delete image'), backgroundColor: Colors.red));
    }
    // This will correctly remove the image from the set regardless of success or failure,
    // as the provider handles reverting the state on failure.
    setState(() => _imagesBeingDeleted.remove(imageId));
  }

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    setState(() => _isUploadingImage = true);
    final provider = Provider.of<ApartmentProvider>(context, listen: false);
    final success = await provider.uploadImageToApartment(widget.apartment.id, image);
    if (!mounted) return;

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(provider.errorMessage ?? 'Failed to upload image'), backgroundColor: Colors.red));
    }
    setState(() => _isUploadingImage = false);
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
    
    final apartment = context.watch<ApartmentProvider>().myApartments.firstWhere((a) => a.id == widget.apartment.id, orElse: () => widget.apartment);

    return Scaffold(
      appBar: AppBar(title: Text(loc.editApartment), actions: [IconButton(icon: const Icon(Icons.done), onPressed: () => Navigator.of(context).pop(), tooltip: 'Finish Editing')]),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionHeader(theme, loc.photos),
            _buildImageManagementSection(apartment.images),
            const SizedBox(height: 24),

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
            _buildSaveChangesButton(loc),
          ],
        ),
      ),
    );
  }

  Widget _buildImageManagementSection(List<ApartmentImage> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
      itemCount: images.length + 1,
      itemBuilder: (context, index) {
        if (index == images.length) {
          return _buildAddImageButton();
        }

        final image = images[index];
        final isBeingDeleted = _imagesBeingDeleted.contains(image.id);

        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(image.imageUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.error)),
            ),
            if (isBeingDeleted)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(child: CircularProgressIndicator(color: Colors.white)),
              )
            else
              Positioned(
                top: 0,
                right: 0,
                child: Material(
                  color: Colors.black.withOpacity(0.6),
                  shape: const CircleBorder(),
                  child: InkWell(
                    onTap: () => _deleteImage(image.id),
                    customBorder: const CircleBorder(),
                    child: const Padding(padding: EdgeInsets.all(4.0), child: Icon(Icons.close, color: Colors.white, size: 18)),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _pickAndUploadImage,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400, width: 2), borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: _isUploadingImage
              ? const CircularProgressIndicator()
              : Column(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.add_a_photo_outlined), SizedBox(height: 4), Text('Add')]),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0, top: 8.0),
      child: Text(title, style: theme.textTheme.titleLarge),
    );
  }

  Widget _buildSaveChangesButton(AppLocalizations loc) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.save_alt_outlined),
        onPressed: _isSavingText ? null : _saveTextChanges,
        label: _isSavingText ? const CircularProgressIndicator(color: Colors.white) : Text(loc.saveChanges),
        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
      ),
    );
  }
}
