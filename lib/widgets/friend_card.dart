import 'package:flutter/material.dart';
import '../models/friend.dart';

class FriendCard extends StatelessWidget {
  final Friend friend;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const FriendCard({super.key, required this.friend, required this.onEdit, required this.onDelete});

  // Helper to get balance text
  Color _getBalanceColor(double balance) {
    if (balance > 0) return Colors.green;
    if (balance < 0) return Colors.red;
    return Colors.grey;
  }

  String _getBalanceText(double balance) {
    if (balance > 0) return "Gets ${balance.toStringAsFixed(2)}";
    if (balance < 0) return "Owes ${(-balance).toStringAsFixed(2)}";
    return "Settled Up";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 3,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal,
          child: Text(
            friend.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(
          friend.name,
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          _getBalanceText(friend.balance),
          style: TextStyle(
            color: _getBalanceColor(friend.balance),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'edit') {
              onEdit();
            } else if (value == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Text('Edit'),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
