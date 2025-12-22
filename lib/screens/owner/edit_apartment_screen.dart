import 'package:flutter/material.dart';
import 'package:plproject/widgets/CTextField.dart';

class EditApartmentScreen extends StatefulWidget {
  const EditApartmentScreen({super.key});

  @override
  State<EditApartmentScreen> createState() => _EditApartmentScreenState();
}

class _EditApartmentScreenState extends State<EditApartmentScreen> {
  final _formKey = GlobalKey<FormState>();

  // Mock data controllers, pre-filled with existing data
  final _titleController = TextEditingController(text: 'Ocean View Villa');
  final _descriptionController = TextEditingController(text: 'An amazing villa with a breathtaking ocean view.');
  final _locationController = TextEditingController(text: 'Malibu, California');
  final _priceController = TextEditingController(text: '2800');
  final _areaController = TextEditingController(text: '320');
  final _bedroomsController = TextEditingController(text: '4');
  final _bathroomsController = TextEditingController(text: '3');

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
            CTextField(controller: _titleController, hintText: 'Apartment Title'),
            const SizedBox(height: 16),
            CTextField(controller: _descriptionController, hintText: 'Description', maxLines: 5),
            const SizedBox(height: 16),
            CTextField(controller: _locationController, hintText: 'Location'),
            const SizedBox(height: 24),

            _buildSectionHeader(theme, 'Specifications'),
            Row(
              children: [
                Expanded(child: CTextField(controller: _priceController, hintText: 'Price / night', textInputType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: CTextField(controller: _areaController, hintText: 'Area (sqft)', textInputType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: CTextField(controller: _bedroomsController, hintText: 'Bedrooms', textInputType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: CTextField(controller: _bathroomsController, hintText: 'Bathrooms', textInputType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(theme, 'Photos'),
            // In a real app, this would show the existing images
            Container(height: 120, color: Colors.grey[200]), 
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
        onPressed: () {
          // TODO: Save changes logic
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: const Text('Save Changes'),
      ),
    );
  }
}
