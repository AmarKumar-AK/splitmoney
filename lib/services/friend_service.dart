import '../models/friend.dart';

class FriendService {
  final List<Friend> _friends = [];

  List<Friend> get friends => _friends;

  void addFriend(String name, {String? email}) {
    _friends.add(Friend(name: name, email: email, balance: 0.0));
  }

  void editFriend(int index, String name, {String? email}) {
    _friends[index].name = name;
    _friends[index].email = email;
  }

  bool deleteFriend(int index) {
    if (_friends[index].balance != 0) return false;
    _friends.removeAt(index);
    return true;
  }
}
