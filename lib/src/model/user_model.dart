import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'isar_service.dart';

part 'user_model.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  String? user;
  String? password;
  String? email;
  String? userToken;

  User({
    this.user,
    this.password,
    this.email,
  });
}

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  final IsarService isarService = IsarService();

  Future<void> createUser({
    required String login,
    required String senha,
  }) async {
    final userExists = await isarService.getUserDB();

    if (userExists == null) {
      final user = User(
        user: login,
        password: senha,
      );
      state = user;
      await isarService.saveUserDB(state);
    } else {
      state = userExists;
    }
  }

  Future<void> saveToken(String token) async {
    state.userToken = token;
    await isarService.saveUserDB(state);
  }

  User getUser() => state;
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());
