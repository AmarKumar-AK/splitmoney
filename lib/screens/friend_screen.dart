import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../widgets/friend_card.dart';
import '../services/friend_service.dart';
import '../database/db_helper.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final DBHelper _dbHelper = DBHelper();
  List<Friend> _friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriends();
  }

  Future<void> _loadFriends() async {
    final data = await _dbHelper.getFriends();
    setState(() => _friends = data);
  }

  Future<void> _addFriend() async {
    if (_formKey.currentState!.validate()) {
      final friend = Friend(
        name: _nameController.text,
        email: _emailController.text.isEmpty ? null : _emailController.text,
      );
      await _dbHelper.addFriend(friend);
      _nameController.clear();
      _emailController.clear();
      _loadFriends();
    }
  }

  Future<void> _editFriend(Friend friend) async {
    _nameController.text = friend.name;
    _emailController.text = friend.email ?? '';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Friend'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email (optional)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final updated = Friend(
                id: friend.id,
                name: _nameController.text,
                email: _emailController.text.isEmpty ? null : _emailController.text,
                balance: friend.balance,
              );
              await _dbHelper.updateFriend(updated);
              Navigator.pop(context);
              _loadFriends();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteFriend(Friend friend) async {
    if (friend.balance != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete friend. Balance must be 0.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    await _dbHelper.deleteFriend(friend.id!);
    _loadFriends();
  }

  // final FriendService _friendService = FriendService();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add Friend Form
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Name is required' : null,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email (optional)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _addFriend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Add Friend'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Display List of Friends
            Expanded(
              child: _friends.isEmpty
                ? const Center(child: Text('No friends added yet'))
                : ListView.builder(
                    itemCount: _friends.length,
                    itemBuilder: (context, index) {
                      final friend = _friends[index];
                      return FriendCard(
                        friend: friend,
                        onEdit: () => _editFriend(friend),
                        onDelete: () => _deleteFriend(friend),
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
