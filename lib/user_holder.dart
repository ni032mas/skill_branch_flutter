import 'models/user.dart';

class UserHolder {
  Map<String, User> users = {};

  User getUserByLogin(String login) {
    if (users.containsKey(login)) {
      return users[login];
    } else {
      throw Exception("A user with this name already exists");
    }
  }

  void registerUser(String name, String phone, String email) {
    User user = User(name: name, phone: phone, email: email);
    if (!users.containsKey(user.login)) {
      users[user.login] = user;
    } else {
      throw Exception("A user with this name already exists");
    }
  }

  User registerUserByEmail(String fullName, String email) {
    User user = User(name: fullName, email: email);
    if (!users.containsKey(user.login)) {
      users[user.login] = user;
    } else {
      throw Exception("A user with this name already exists");
    }
    return user;
  }

  User registerUserByPhone(String fullName, String phone) {
    User user = User(name: fullName, phone: phone);
    if (!users.containsKey(user.login)) {
      users[user.login] = user;
    } else {
      throw Exception("A user with this name already exists");
    }
    return user;
  }

  void setFriends(String login, List<User> friends) {
    if (users.containsKey(login)) {
      users[login].addFriends(friends);
    } else {
      throw Exception("A user with this name already exists");
    }
  }

  User findUserInFriends(String login, User friend) {
    User findFriend;
    if (users.containsKey(login) && users[login].friends.length > 0) {
      findFriend = users[login]
          .friends
          .firstWhere((user) => user == friend, orElse: null);
    } else {
      throw Exception("${friend.login} is not a friend of the login");
    }
    if (findFriend == null)
      throw Exception("${friend.login} is not a friend of the login");
    return findFriend;
  }

  List<User> importUsers(List<String> listString) => listString.map((s) {
        List<String> list = s.split(";");
        return User(name: list[0].trim(), email: list[1].trim(), phone: list[2].trim());
      }).toList();
}
