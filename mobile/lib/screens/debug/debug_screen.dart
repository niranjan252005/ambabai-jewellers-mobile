import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/local_database_service.dart';
import '../../models/user.dart';

class DebugScreen extends StatefulWidget {
  const DebugScreen({super.key});

  @override
  State<DebugScreen> createState() => _DebugScreenState();
}

class _DebugScreenState extends State<DebugScreen> {
  List<User> _allUsers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAllUsers();
  }

  Future<void> _loadAllUsers() async {
    try {
      final users = await LocalDatabaseService.getUsers();
      setState(() {
        _allUsers = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error loading users: $e');
    }
  }

  Future<void> _createTestUser() async {
    final result = await LocalDatabaseService.registerUser(
      username: 'Test Customer',
      email: 'customer@test.com',
      password: 'test123',
      role: 'user',
    );
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? result['message'] : result['error']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );
    
    if (result['success']) {
      _loadAllUsers();
    }
  }

  Future<void> _approveUser(int userId) async {
    final result = await LocalDatabaseService.approveUser(userId);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? result['message'] : result['error']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
      ),
    );
    
    if (result['success']) {
      _loadAllUsers();
    }
  }

  Future<void> _testLogin(String email, String password) async {
    final result = await LocalDatabaseService.loginUser(email, password);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result['success'] ? 'Login successful!' : result['error']),
        backgroundColor: result['success'] ? Colors.green : Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _resetDatabase() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Database'),
        content: const Text('This will delete all users except admin and recreate the database. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              // Delete database file and recreate
              try {
                await LocalDatabaseService.resetDatabase();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Database reset successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadAllUsers();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error resetting database: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Reset', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Debug - User Approval System',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Test Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _createTestUser,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Create Test User (customer@test.com)'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testLogin('admin@ambabaijewellers.com', 'admin123'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Test Admin Login'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _testLogin('customer@test.com', 'test123'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Test Customer Login'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _resetDatabase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Reset Database (Delete All Users)'),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Users List
                  Text(
                    'All Users in Database:',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  
                  Expanded(
                    child: _allUsers.isEmpty
                        ? const Center(
                            child: Text('No users found'),
                          )
                        : ListView.builder(
                            itemCount: _allUsers.length,
                            itemBuilder: (context, index) {
                              final user = _allUsers[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: user.isAdmin 
                                        ? Colors.red 
                                        : user.isApproved 
                                            ? Colors.green 
                                            : Colors.orange,
                                    child: Icon(
                                      user.isAdmin 
                                          ? Icons.admin_panel_settings
                                          : user.isApproved 
                                              ? Icons.check 
                                              : Icons.pending,
                                      color: Colors.white,
                                    ),
                                  ),
                                  title: Text(
                                    user.username,
                                    style: GoogleFonts.lato(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Email: ${user.email}'),
                                      Text('Role: ${user.role}'),
                                      Text('Approved: ${user.isApproved ? "YES" : "NO"}'),
                                    ],
                                  ),
                                  trailing: !user.isApproved && !user.isAdmin
                                      ? ElevatedButton(
                                          onPressed: () => _approveUser(user.id),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Approve'),
                                        )
                                      : null,
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
    );
  }
}