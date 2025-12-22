import 'package:flutter/material.dart';
import 'package:plproject/widgets/CTextField.dart'; // Reusing our custom text field

class AddApartmentScreen extends StatefulWidget {
  const AddApartmentScreen({super.key});

  @override
  State<AddApartmentScreen> createState() => _AddApartmentScreenState();
}

class _AddApartmentScreenState extends State<AddApartmentScreen> {
  final _formKey = GlobalKey<FormState>();

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
            CTextField(hintText: 'Apartment Title (e.g., Cozy Downtown Studio)'),
            const SizedBox(height: 16),
            CTextField(hintText: 'Description', maxLines: 5),
            const SizedBox(height: 16),
            CTextField(hintText: 'Location (e.g., City, Neighborhood)'),
            const SizedBox(height: 24),

            _buildSectionHeader(theme, 'Specifications'),
            Row(
              children: [
                Expanded(child: CTextField(hintText: 'Price / night', textInputType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: CTextField(hintText: 'Area (sqft)', textInputType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: CTextField(hintText: 'Bedrooms', textInputType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: CTextField(hintText: 'Bathrooms', textInputType: TextInputType.number)),
              ],
            ),
            const SizedBox(height: 24),

            _buildSectionHeader(theme, 'Photos'),
            _buildImageUploadSection(theme),
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

  Widget _buildImageUploadSection(ThemeData theme) {
    // Placeholder for image upload UI
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_a_photo_outlined, color: Colors.grey[600], size: 40),
            const SizedBox(height: 8),
            Text('Add Photos', style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(ThemeData theme) {
     return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Add apartment logic
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
        ),
        child: const Text('Add Apartment'),
      ),
    );
  }
}
