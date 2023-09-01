// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shop/src/model/filtered_products_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../model/custom_exception.dart';
import '../model/enums/alert_type.dart';
import '../model/isar_service.dart';
import '../model/product_model.dart';
import '../model/user_model.dart' as local;
import '../model/user_model.dart';
import '../view/widgets/alert.dart';
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

  Future<void> logOff(BuildContext context, WidgetRef ref) async {
    final Alert alert = Alert();

    return alert.dialog(
      context,
      AlertType.warning,
      AppLocalizations.of(context)!.logOutFromAppConfirmation,
      onPress: () async {
        ref.read(productProvider.notifier).clearProductState();
        await FirebaseAuth.instance.signOut();
        Navigator.pop(context);
        return context.pushReplacement('/');
      },
    );
  }

  Future<void> login(BuildContext context, WidgetRef ref, String? email, String? password) async {
    try {
      if (email == null || email.isEmpty) throw CustomException(AppLocalizations.of(context)!.errorNoEMail);
      if (password == null || password.isEmpty) throw CustomException(AppLocalizations.of(context)!.errorNoPassword);

      state = const AsyncValue.loading();
      final userController = ref.read(userProvider.notifier);

      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);

      final token = credential.user!.uid;

      await userController.saveUser(email: email, password: password, userToken: token);

      await loadProductGoHome(context, ref);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw CustomException(AppLocalizations.of(context)!.errorUserNotFound);
      } else if (e.code == 'wrong-password') {
        throw CustomException(AppLocalizations.of(context)!.errorWrongPassword);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> signUp(BuildContext context, WidgetRef ref, String? email, String? password, String? confirmPassword) async {
    try {
      if (email == null || email.isEmpty || email.isEmpty) throw CustomException(AppLocalizations.of(context)!.errorNoEMail);

      final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
      if (!emailRegExp.hasMatch(email)) throw CustomException(AppLocalizations.of(context)!.errorInvalidEMailFormat);

      if (password == null || password.isEmpty) throw CustomException(AppLocalizations.of(context)!.errorNoPassword);
      if (password.length < 6) throw CustomException(AppLocalizations.of(context)!.errorPasswordTooShort);
      if (confirmPassword == null || confirmPassword.isEmpty) throw CustomException(AppLocalizations.of(context)!.errorNoConfirmationPassword);
      if (confirmPassword != password) throw CustomException(AppLocalizations.of(context)!.errorPasswordNoMatch);

      state = const AsyncValue.loading();
      final userController = ref.read(userProvider.notifier);

      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      final token = credential.user!.uid;

      await userController.saveUser(email: email, password: password, userToken: token);

      await loadProductGoHome(context, ref);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw CustomException(AppLocalizations.of(context)!.errorWeakPassword);
      } else if (e.code == 'email-already-in-use') {
        throw CustomException(AppLocalizations.of(context)!.errorEMailAlreadyUsed);
      }
    } catch (e) {
      rethrow;
    } finally {
      state = const AsyncValue.data(null);
    }
  }

  Future<void> loadProductGoHome(BuildContext context, WidgetRef ref) async {
    await ref.read(productsControllerProvider.notifier).loadProducts(ref);

    final originalState = ref.read(productProvider.notifier).productsList();
    ref.read(filteredProductsProvider.notifier).loadProducts(originalState);

    context.go('/home');
  }
}

final loginControllerProvider = StateNotifierProvider<LoginController, AsyncValue<void>>((ref) => LoginController());
