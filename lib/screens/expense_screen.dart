import 'package:flutter/material.dart';
import '../services/splitwise_app.dart';
import '../models/friend.dart';
import 'friend_screen.dart';
import 'expense_screen.dart';

class ExpenseScreen extends StatefulWidget {
  final SplitwiseApp app;

  ExpenseScreen({required this.app});
  @override
  _ExpenseScreenState createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {

  final Map<Friend, TextEditingController> payerControllers = {};
  final TextEditingController descriptionController = TextEditingController();

  List<Friend> selectedPayers = [];

  @override
  void initState() {
    super.initState();
    // Initialize a TextEditingController for each friend
    for (var friend in widget.app.friends) {
      payerControllers[friend] = TextEditingController();
    }
  }

  @override
  void dispose() {
    // Dispose of all TextEditingControllers
    for (var controller in payerControllers.values) {
      controller.dispose();
    }
    super.dispose();
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

  void _addExpense() {
    Map<Friend, double> payers = {};
    for (var friend in selectedPayers) {
      double? amount = double.tryParse(payerControllers[friend]!.text);
      if (amount != null) {
        payers[friend] = amount;
      }
    }

    if (payers.isNotEmpty) {
      setState(() {
        widget.app.addExpense(descriptionController.text, payers);
        descriptionController.clear();
        // Clear the amount for each payer
        for (var controller in payerControllers.values) {
          controller.clear();
        }
        selectedPayers.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Friend> balances = widget.app.getBalances();

    return Scaffold(
      appBar: AppBar(
        title: Text("Expenses"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Description
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: "Description",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),

            // Multiple Payer Selection
            Expanded(
              child: ListView.builder(
                itemCount: balances.length,
                itemBuilder: (context, index) {
                  final friend = balances[index];
                  return CheckboxListTile(
                    title: Row(
                      children: [
                        Text(friend.name),
                        SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: payerControllers[friend],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Amount",
                              border: OutlineInputBorder(),
                            ),
                            enabled: selectedPayers.contains(friend),
                          ),
                        ),
                      ],
                    ),
                    value: selectedPayers.contains(friend),
                    onChanged: (bool? value) {
                      setState(() {
                        if (value == true) {
                          selectedPayers.add(friend);
                        } else {
                          selectedPayers.remove(friend);
                        }
                      });
                    },
                  );
                },
              ),
            ),

            // Add Expense button
            ElevatedButton.icon(
              onPressed: _addExpense,
              icon: Icon(Icons.attach_money),
              label: Text("Add Expense"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
              ),
            ),
          ],
        ),
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("Expenses"),
    //     centerTitle: true,
    //   ),
    //   body: Padding(
    //     padding: const EdgeInsets.all(16.0),
    //     child: Column(
    //       children: [
    //         // Add Expense
    //         Column(
    //           children: [
    //             DropdownButtonFormField<String>(
    //               decoration: InputDecoration(
    //                 border: OutlineInputBorder(),
    //                 labelText: "Payer",
    //               ),
    //               hint: Text("Select Payer"),
    //               value: selectedPayer,
    //               onChanged: (value) {
    //                 setState(() {
    //                   selectedPayer = value;
    //                 });
    //               },
    //               items: balances.map((f) {
    //                 return DropdownMenuItem(
    //                   value: f.name,
    //                   child: Text(f.name),
    //                 );
    //               }).toList(),
    //             ),
    //             SizedBox(height: 8),
    //             TextField(
    //               controller: amountController,
    //               keyboardType: TextInputType.number,
    //               decoration: InputDecoration(
    //                 labelText: "Amount",
    //                 border: OutlineInputBorder(),
    //               ),
    //             ),
    //             SizedBox(height: 8),
    //             TextField(
    //               controller: descriptionController,
    //               decoration: InputDecoration(
    //                 labelText: "Description",
    //                 border: OutlineInputBorder(),
    //               ),
    //             ),
    //           ],
    //         ),
    //         SizedBox(height: 20),

    //         // Add Expense button
    //         Row(
    //           children: [
    //             Expanded(
    //               child: ElevatedButton.icon(
    //                 onPressed: _addExpense,
    //                 icon: Icon(Icons.attach_money),
    //                 label: Text("Add"),
    //                 style: ElevatedButton.styleFrom(
    //                   backgroundColor: Colors.teal,
    //                 ),
    //               ),
    //             ),
    //             SizedBox(width: 16),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
  }
}