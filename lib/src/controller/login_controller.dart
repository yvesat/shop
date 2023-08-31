// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/custom_exception.dart';
import '../model/isar_service.dart';
import '../model/user_model.dart' as local;
import '../model/user_model.dart';
import 'products_controller.dart';

class LoginController extends StateNotifier<AsyncValue<void>> {
  LoginController() : super(const AsyncValue.data(null));

  // final UserRepository repositorioUsuario = UserRepository();
  final IsarService isarService = IsarService();
  Future<local.User?> loadUser() async {
    try {
      state = const AsyncValue.loading();
      return await isarService.getUserDB();
    } catch (_) {
      rethrow;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> login(BuildContext context, WidgetRef ref, String? email, String? password) async {
    try {
      if (email == null || email.isEmpty) throw CustomException("Please enter your e-mail");
      if (password == null || password.isEmpty) throw CustomException("Please enter a password");

      state = const AsyncValue.loading();
      final userController = ref.read(userProvider.notifier);

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      final token = credential.user!.uid;

      await userController.saveUser(email: email, password: password, userToken: token);

      await loadProductGoHome(context, ref);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw CustomException('No user found for that email');
      } else if (e.code == 'wrong-password') {
        throw CustomException('Wrong password provided for that user');
      }
    } catch (e) {
      rethrow;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> signUp(BuildContext context, WidgetRef ref, String? email, String? password, String? confirmPassword) async {
    try {
      if (email == null || email.isEmpty || email.isEmpty) throw CustomException("Please enter your e-mail");

      final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
      if (!emailRegExp.hasMatch(email)) throw CustomException("Invalid e-mail format");

      if (password == null || password.isEmpty) throw CustomException("Please enter a password");
      if (password.length < 6) throw CustomException("Password must be at least 6 characters long");
      if (confirmPassword == null || confirmPassword.isEmpty) throw CustomException("Please confirm your password");
      if (confirmPassword != password) throw CustomException("Passwords do not match");

      state = const AsyncValue.loading();
      final userController = ref.read(userProvider.notifier);

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final token = credential.user!.uid;

      await userController.saveUser(email: email, password: password, userToken: token);

      await loadProductGoHome(context, ref);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw CustomException('The account already exists for that email.');
      }
    } catch (e) {
      rethrow;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> loadProductGoHome(BuildContext context, WidgetRef ref) async {
    await ref.read(productsControllerProvider.notifier).loadProducts(ref);
    context.go('/home');
  }
}

final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<void>>((ref) => LoginController());


//TODO: LANGUAGE