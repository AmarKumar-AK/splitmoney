import 'friend.dart';

class Expense {
  Map<Friend, double> payers;
  DateTime? date;
  String? description;

  Expense({
    required this.payers,
    this.date,
    this.description
  });
}
