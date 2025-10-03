import '../models/friend.dart';
import '../models/expense.dart';

class SplitwiseApp {
  List<Friend> friends = [];
  List<Expense> expenses = [];

  void addFriend(String name) {
    friends.add(Friend(name: name, balance: 0.0));
  }

  void addExpense(String description, Map<Friend, double> payers) {
    expenses.add(Expense(description: description, payers: payers, date: DateTime.now()));
    _updateBalances(payers);
  }

  void _updateBalances(Map<Friend, double> payers) {
    // Calculate the total amount of the expense
    double totalAmount = payers.values.fold(0, (sum, amount) => sum + amount);

    // Calculate the amount each friend should pay (equal split for now)
    double splitAmount = totalAmount / (friends.length);

    // Update balances for each friend
    for (var friend in friends) {
      // Check if the friend is a payer
      if (payers.containsKey(friend)) {
        // If the friend is a payer, subtract the amount they paid from their share
        friend.balance -= (payers[friend]! - splitAmount);
      } else {
        // If the friend is not a payer, add their share to their balance
        friend.balance += splitAmount;
      }
    }
  }

  double getFriendBalance(Friend friend) {
    return friend.balance;
  }

  double getTotalBalance() {
    return friends.fold(0.0, (sum, f) => sum - f.balance);
  }

  // void splitExpenseEqually(String payer, double amount, String description) {
  //   int n = friends.length;
  //   double share = amount / n;

  //   for (var f in friends) {
  //     if (f.name == payer) {
  //       f.balance += (amount - share);
  //     } else {
  //       f.balance -= share;
  //     }
  //   }

  //   expenses.add(Expense(payer, amount, description));
  // }

  List<Friend> getBalances() {
    return friends;
  }
}
