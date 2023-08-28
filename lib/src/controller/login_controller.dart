// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/custom_exception.dart';
import '../model/isar_service.dart';
import '../model/user_model.dart';

class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController() : super(const AsyncValue.data(null));

  // final UserRepository repositorioUsuario = UserRepository();
  final IsarService isarService = IsarService();

  Future<User?> loadUser() async {
    try {
      state = const AsyncValue.loading();
      return await isarService.getUserDB();
    } catch (_) {
      rethrow;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(BuildContext context, WidgetRef ref, String? email, String? senha) async {
    try {
      if (email == null || email.isEmpty) throw CustomException("Invalid e-mail");
      if (senha == null || senha.isEmpty) throw CustomException("Invalid password");

      state = const AsyncValue.loading();

      // await repositorioUsuario.logIn(ref, login, senha);

      // final userController = ref.read(userProvider.notifier);
      // final userState = ref.read(userProvider);

      // await repositorioUsuario.getToken(ref);
      context.go('/home');
    } catch (e) {
      rethrow;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> signUp(BuildContext context, WidgetRef ref, String? fullName, String? email, String? password, String? confirmPassword) async {
    try {
      if (fullName == null || fullName.isEmpty) throw CustomException("Please enter your full name.");
      if (email == null || email.isEmpty || email.isEmpty) throw CustomException("Please enter your e-mail");

      final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
      if (!emailRegExp.hasMatch(email)) throw CustomException("Invalid e-mail format");

      if (password == null || password.isEmpty) throw CustomException("Please enter a password.");
      if (password.length < 4) throw CustomException("Password must be at least 4 characters long.");
      if (confirmPassword == null || confirmPassword.isEmpty) throw CustomException("Please confirm your password.");
      if (confirmPassword != password) throw CustomException("Passwords do not match.");

      state = const AsyncValue.loading();

      // await repositorioUsuario.logIn(ref, login, senha);

      // final userController = ref.read(userProvider.notifier);
      // final userState = ref.read(userProvider);

      // await repositorioUsuario.getToken(ref);
      context.go('/home');
    } catch (e) {
      rethrow;
    } finally {
      state = const AsyncValue.data(null);
    }
  }
}

final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<void>>((ref) => LoginController());
