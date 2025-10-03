class Friend {
  int? id;
  String name;
  String? email;
  double balance;

  Friend({this.id, required this.name, this.email, this.balance = 0.0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'balance': balance,
    };
  }

  factory Friend.fromMap(Map<String, dynamic> map) {
    return Friend(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      balance: map['balance'],
    );
  }
}
