import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/models/user.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => provider.logout(),
          ),
        ],
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, AdminProvider provider) {
    switch (provider.status) {
      case AdminStatus.Loading:
        return const Center(child: CircularProgressIndicator());
      case AdminStatus.Error:
        return Center(child: Text('Error: ${provider.errorMessage}'));
      case AdminStatus.Loaded:
        if (provider.pendingUsers.isEmpty) {
          return const Center(
            child: Text("No pending user registrations.", style: TextStyle(fontSize: 18, color: Colors.grey)),
          );
        }
        return _buildUserList(provider.pendingUsers);
      default: // Idle
        return const Center(child: Text("Welcome, Admin!"));
    }
  }

  Widget _buildUserList(List<User> users) {
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text('${user.first_name ?? 'No Name'} ${user.last_name ?? ''}'),
            subtitle: Text(user.phone ?? 'No Phone'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle, color: Colors.green),
                  tooltip: 'Approve',
                  onPressed: () => _showConfirmationDialog(context, 'Approve', () {
                    Provider.of<AdminProvider>(context, listen: false).approveUser(user.id!);
                  }),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  tooltip: 'Delete',
                  onPressed: () => _showConfirmationDialog(context, 'Delete', () {
                     Provider.of<AdminProvider>(context, listen: false).deleteUser(user.id!);
                  }),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, String action, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm $action'),
        content: Text('Are you sure you want to $action this user?'),
        actions: [
          TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(ctx).pop()),
          TextButton(child: Text(action), onPressed: () {
            Navigator.of(ctx).pop();
            onConfirm();
          }),
        ],
      ),
    );
  }
}
