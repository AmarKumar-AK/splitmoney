import 'package:flutter/material.dart';
import '../services/splitwise_app.dart';
import '../models/friend.dart';
import 'friend_screen.dart';
import 'expense_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SplitwiseApp app = SplitwiseApp();
  final TextEditingController friendController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedPayer;
  int _selectedIndex = 0;

  List<Widget> get _screens => [
      buildHomeTab(),
      FriendsScreen(app: app),
      ExpenseScreen(app: app),
    ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // building navigation
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Friends'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: 'Expenses'),
        ],
      ),
    );
  }

  void _addFriend() {
    if (friendController.text.isNotEmpty) {
      setState(() {
        app.addFriend(friendController.text);
        friendController.clear();
        emailController.clear();
      });
    }
  }

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

  Widget buildHomeTab() {
    List<Friend> balances = app.getBalances();

    return Scaffold(
      appBar: AppBar(
        title: Text("Friends"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Add Friend
            Column(
              children: [
                TextField(
                  controller: friendController,
                  decoration: InputDecoration(
                    labelText: "Friend name",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Friend email (optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addFriend,
                    icon: Icon(Icons.person_add),
                    label: Text("Add"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            
            // Show balances
            Expanded(
              child: balances.isEmpty
                  ? Center(
                      child: Text(
                        "No friends added yet",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: balances.length,
                      itemBuilder: (context, index) {
                        final f = balances[index];
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
                              style: TextStyle(fontWeight: FontWeight.bold),
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
          ],
        ),
      ),
    );
  }
}
