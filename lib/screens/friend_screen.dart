import 'package:flutter/material.dart';
import '../services/splitwise_app.dart';
import '../models/friend.dart';

class FriendsScreen extends StatelessWidget {
  final SplitwiseApp app;

  FriendsScreen({required this.app});

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
    List<Friend> friends = app.getBalances();

    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        centerTitle: true,
      ),
      body: friends.isEmpty
        ? Center(
            child: Text(
              "No friends added yet.",
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
        : Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final f = friends[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 6),
                  elevation: 3,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Text(f.name[0].toUpperCase(),
                          style: TextStyle(color: Colors.white)),
                    ),
                    title: Text(
                      f.name,
                      style: TextStyle(fontWeight: FontWeight.bold)
                    ),
                    subtitle: Text(
                      _getBalanceText(f.balance),
                      style: TextStyle(
                        color: _getBalanceColor(f.balance),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
    );
  }
}