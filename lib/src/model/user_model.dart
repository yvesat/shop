import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'isar_service.dart';

part 'user_model.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  String? name;
  String? password;
  String? email;
  String? userToken;

  User({
    this.name,
    this.password,
    this.email,
    this.userToken,
  });
}

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  final IsarService isarService = IsarService();

  Future<void> createUser({required String name, required String email, required String password}) async {
    final userExists = await isarService.getUserDB();

    if (userExists == null) {
      final user = User(
        name: name,
        email: email,
        password: password,
      );
      state = user;
      await isarService.saveUserDB(state);
    } else {
      state = userExists;
    }
  }

  Future<void> saveToken(String userToken) async {
    state.userToken = userToken;
    await isarService.saveUserDB(state);
  }

  User getUser() => state;
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());
