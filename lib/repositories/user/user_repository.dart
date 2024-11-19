import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:tasklist_backend/hash_extension.dart';

/// temp database for user
@visibleForTesting
Map<String, User> userDb = {};

/// User class
class User extends Equatable {
  /// User constructor
  const User({
    required this.id,
    required this.name,
    required this.username,
    required this.password,
  });

  /// User's id
  final String id;

  /// User's name
  final String name;

  /// User's username
  final String username;

  /// User's password
  final String password;

  @override
  List<Object?> get props => [
        id,
        name,
        password,
        username,
      ];
}

/// User's Repository
class UserRepository {
  /// Incorporating an empty user for null checks
  final User emptyUser = const User(
    id: '',
    name: '',
    password: '',
    username: '',
  );

  /// Checks in the database for a user with the provided username and password
  Future<User> userFromCredentials(String username, String password) async {
    final hashedPassword = password.hashValue;
    final users = userDb.values.where(
      (user) => user.username == username && user.password == hashedPassword,
    );

    if (users.isNotEmpty) {
      return users.first;
    }
    // return null;
    // Update: doesn't seem to like handling NULL
    // Gonna create an emptyUser
    return emptyUser;
  }

  /// Search for a user by id
  Future<User?> userFromId(String id) async {
    return Future.value(userDb[id]);
  }

  /// Creates a new user
  Future<String> createUser({
    required String name,
    required String username,
    required String password,
  }) async {
    final id = username.hashValue;
    final user = User(
      id: id,
      name: name,
      username: username,
      password: password.hashValue,
    );

    userDb[id] = user;

    return Future.value(id);
  }

  /// Delete a user
  void deleteUser(String id) {
    userDb.remove(id);
  }

  /// Update user
  Future<void> updateUser({
    required String id,
    required String? name,
    required String? username,
    required String? password,
  }) async {
    final currentUser = userDb[id];

    if (currentUser == null) {
      return Future.error(Exception('User not found'));
    }

    if (password != null) {
      password = password.hashValue;
    }

    final user = User(
      id: id,
      name: name ?? currentUser.name,
      username: username ?? currentUser.username,
      password: password ?? currentUser.password,
    );

    userDb[id] = user;
  }
}
