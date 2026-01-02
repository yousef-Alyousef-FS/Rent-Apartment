import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plproject/models/user.dart';
import 'package:plproject/providers/admin_provider.dart';
import 'package:plproject/screens/admin/admin_login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshData();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    final provider = Provider.of<AdminProvider>(context, listen: false);
    await Future.wait([provider.fetchPendingUsers(), provider.fetchAllUsers()]);
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
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'All Users'),
          ],
        ),
      ),
      body: Consumer<AdminProvider>(
        builder: (context, provider, child) {
          if (provider.status == AdminStatus.Loading && (provider.pendingUsers.isEmpty && provider.allUsers.isEmpty)) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.status == AdminStatus.Error) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }

          return RefreshIndicator(
            onRefresh: _refreshData,
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendingUsersList(provider.pendingUsers, provider),
                _buildAllUsersList(provider.allUsers, provider),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPendingUsersList(List<User> users, AdminProvider provider) {
    if (users.isEmpty) {
      return const Center(child: Text('No pending users for approval.'));
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: user.profileImageUrl != null ? NetworkImage(user.profileImageUrl!) : null, child: user.profileImageUrl == null ? const Icon(Icons.person) : null),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text(user.phone ?? 'No phone number'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.check_circle_outline, color: Colors.green), tooltip: 'Accept', onPressed: () => provider.acceptUser(user.id!)),
                IconButton(icon: const Icon(Icons.thumb_down_outlined, color: Colors.red), tooltip: 'Reject', onPressed: () => provider.rejectUser(user.id!)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAllUsersList(List<User> users, AdminProvider provider) {
    if (users.isEmpty) {
      return const Center(child: Text('No users found in the system.'));
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            leading: CircleAvatar(backgroundImage: user.profileImageUrl != null ? NetworkImage(user.profileImageUrl!) : null, child: user.profileImageUrl == null ? const Icon(Icons.person) : null),
            title: Text('${user.firstName} ${user.lastName}'),
            subtitle: Text('Status: ${user.status ?? 'N/A'}'),
            trailing: IconButton(icon: const Icon(Icons.delete_outline, color: Colors.red), tooltip: 'Delete', onPressed: () => provider.deleteUser(user.id!)),
          ),
        );
      },
    );
  }
}
