import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/screens/admin/admin_login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch users, assuming the admin is already logged in
      Provider.of<AdminProvider>(context, listen: false).fetchPendingUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              Provider.of<AdminProvider>(context, listen: false).logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const AdminLoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.status == AdminStatus.Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.status == AdminStatus.Error) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }
          if (provider.pendingUsers.isEmpty) {
            return const Center(child: Text('No pending users for approval.'));
          }

          return RefreshIndicator(
            onRefresh: () => provider.fetchPendingUsers(),
            child: ListView.builder(
              itemCount: provider.pendingUsers.length,
              itemBuilder: (context, index) {
                final user = provider.pendingUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: user.profile_image != null ? NetworkImage(user.profile_image!) : null,
                      child: user.profile_image == null ? const Icon(Icons.person) : null,
                    ),
                    title: Text('${user.first_name} ${user.last_name}'),
                    subtitle: Text(user.phone ?? 'No phone number'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check, color: Colors.green),
                          tooltip: 'Approve',
                          onPressed: () => provider.approveUser(user.id!),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.red),
                          tooltip: 'Delete',
                          onPressed: () => provider.deleteUser(user.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
