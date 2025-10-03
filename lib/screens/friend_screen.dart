import 'package:flutter/material.dart';
import '../models/friend.dart';

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
        ));
        _nameController.clear();
        _emailController.clear();
      });
    }
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
                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          elevation: 3,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.teal,
                              child: Text(friend.name[0].toUpperCase(),
                                  style: TextStyle(color: Colors.white)),
                            ),
                            title: Text(friend.name, style: TextStyle(fontSize: 18)),
                            subtitle: friend.email != null ? Text(friend.email!) : null,
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
