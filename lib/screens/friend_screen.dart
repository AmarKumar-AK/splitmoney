import 'package:flutter/material.dart';
import '../models/friend.dart';
import '../widgets/friend_card.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({super.key});

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<Friend> _friends = [];

  void _addFriend() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _friends.add(Friend(
          name: _nameController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          balance: 0.0,
        ));
        _nameController.clear();
        _emailController.clear();
      });
    }
  }

  void _editFriend(int index) {
    final friend = _friends[index];
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
            onPressed: () {
              setState(() {
                friend.name = _nameController.text;
                friend.email =
                    _emailController.text.isEmpty ? null : _emailController.text;
              });
              _nameController.clear();
              _emailController.clear();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteFriend(int index) {
    final friend = _friends[index];
    if (friend.balance != 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot delete friend. Balance must be 0.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _friends.removeAt(index);
    });
  }

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
                        onEdit: () => _editFriend(index),
                        onDelete: () => _deleteFriend(index),
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
