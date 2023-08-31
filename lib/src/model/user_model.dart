import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:isar/isar.dart';
import 'isar_service.dart';

part 'user_model.g.dart';

@collection
class User {
  Id id = Isar.autoIncrement;
  String? password;
  String? email;
  String? userToken;

  User({
    this.password,
    this.email,
    this.userToken,
  });
}

class UserNotifier extends StateNotifier<User> {
  UserNotifier() : super(User());

  final IsarService isarService = IsarService();

  Future<void> saveUser({required String email, required String password, required String userToken}) async {
    isarService.clearUserDB();
    final user = User(email: email, password: password, userToken: userToken);

    state = user;

    await isarService.saveUserDB(state);
  }

  Future<User?> getUser() async {
    return await isarService.getUserDB();
  }
}

final userProvider = StateNotifierProvider<UserNotifier, User>((ref) => UserNotifier());
