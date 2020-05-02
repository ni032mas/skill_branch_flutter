import 'package:flutter_test/flutter_test.dart' show expect, group, isA, setUp, tearDownAll, test, throwsA;

import '../lib/models/user.dart';
import '../lib/user_holder.dart';

void main() {
  UserHolder holder;

  setUp(() {
    holder = UserHolder();
  });

  tearDownAll(() {
    holder = null;
  });

  test('registerUser', () {
    holder.registerUser("Skill Branch", "+79776150445", "kaparray@gmail.com");

    expect("kaparray@gmail.com", holder.users["kaparray@gmail.com"].login);
    expect("+79776150445", holder.users["kaparray@gmail.com"].phone);
    expect("kaparray@gmail.com", holder.users["kaparray@gmail.com"].email);
    expect("Skill Branch", holder.users["kaparray@gmail.com"].name);
  });

  test('getUserByLogin', () {
    User user = User(name: "Dan Tot", phone: "+15750761449", email: "dan.tot@yandex.ru");
    holder.users[user.login] = user;

    expect(user.login, holder.getUserByLogin(user.login).login);
    expect(user.phone, holder.getUserByLogin(user.login).phone);
    expect(user.name, holder.getUserByLogin(user.login).name);
    expect(user.email, holder.getUserByLogin(user.login).email);
  });

  group('Test: getUserByLogin()', () {
    test('registerUserByPhone', () {
      User user = holder.registerUserByPhone("John Ray", "+9-733 524-0185");

      expect(user.login, holder.getUserByLogin(user.login).login);
      expect(user.phone, holder.getUserByLogin(user.login).phone);
      expect(user.name, holder.getUserByLogin(user.login).name);
      expect(user.email, holder.getUserByLogin(user.login).email);
    });

    test('registerUserByPhone', () {
      expect(() => holder.registerUserByPhone("John Ray", "+9-733 524-085"), throwsA(isA<Exception>()));
    });
  });

  group('Test: getUserByLogin()', () {
    test('registerUserByEmail', () {
      User user = holder.registerUserByEmail("John Ray", "ray1550@yahoo.net");

      expect(user.login, holder.getUserByLogin(user.login).login);
      expect(user.phone, holder.getUserByLogin(user.login).phone);
      expect(user.name, holder.getUserByLogin(user.login).name);
      expect(user.email, holder.getUserByLogin(user.login).email);
    });

    test('Email is not valid registerUserByPhone', () {
      expect(() => holder.registerUserByEmail("John Ray", "dfdsag"), throwsA(isA<Exception>()));
    });

    test('Exception(A user with this email already exists) registerUserByPhone', () {
      holder.registerUserByEmail("John Ray", "ray1550@yahoo.net");

      expect(() => holder.registerUserByEmail("John Ray", "ray1550@yahoo.net"), throwsA(isA<Exception>()));
    });
  });

  test('setFriends', () {
    User user = User(name: "Dan Tot", phone: "+15750761449", email: "dan.tot@yandex.ru");
    holder.users[user.login] = user;

    List<User> friends = [
      User(name: "Ray Dalio", email: "ray.dalio@gmail.com"),
      User(name: "Warren Buffett", phone: "+1 833-914-92-65"),
    ];

    holder.setFriends(user.login, friends);

    expect(2, holder.users[user.login].friends.length);

    expect(friends[0].email, holder.users[user.login].friends[0].email);
    expect(friends[0].login, holder.users[user.login].friends[0].login);
    expect(friends[0].phone, holder.users[user.login].friends[0].phone);

    expect(friends[1].email, holder.users[user.login].friends[1].email);
    expect(friends[1].login, holder.users[user.login].friends[1].login);
    expect(friends[1].phone, holder.users[user.login].friends[1].phone);
  });

  group('findUserInFriends', () {
    test('findUserInFriends', () {
      User user = User(name: "Dan Tot", phone: "+15750761449", email: "dan.tot@yandex.ru");
      holder.users[user.login] = user;

      List<User> friends = [
        User(name: "Ray Dalio", email: "ray.dalio@gmail.com"),
        User(name: "Warren Buffett", phone: "+1 833-914-92-65"),
      ];

      holder.setFriends(user.login, friends);

      expect(friends[0], holder.findUserInFriends(user.login, friends[0]));
      expect(friends[1], holder.findUserInFriends(user.login, friends[1]));
    });

    test('findUserInFriends exception', () {
      User user = User(name: "Dan Tot", phone: "+15750761449", email: "dan.tot@yandex.ru");
      holder.users[user.login] = user;

      List<User> friends = [
        User(name: "Ray Dalio", email: "ray.dalio@gmail.com"),
        User(name: "Warren Buffett", phone: "+1 833-914-92-65"),
      ];

      expect(() => holder.findUserInFriends(user.login, friends[0]), throwsA(isA<Exception>()));
      expect(() => holder.findUserInFriends(user.login, friends[1]), throwsA(isA<Exception>()));
    });
  });

  test('Test: UserHolder.importUsers()', () {
    User user = User(name: "Dan Tot", phone: "+1 (231) 076-1449", email: "dan.tot@yandex.ru");

    List<User> users = holder.importUsers([
      """
      ${user.name};
      ${user.email};
      ${user.phone};
      """,
    ]);

    expect(users[0].login, user.login);
    expect(users[0].email, user.email);
    expect(users[0].phone, user.phone);
  });
}
