// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info/package_info.dart';

import '../controller/login_controller.dart';
import '../model/enums/auth_mode.dart';
import '../model/user_model.dart';
import 'widgets/button.dart';
import 'widgets/login_text_field.dart';
import 'widgets/progress.dart';
import 'widgets/alert.dart';

class AuthPage extends ConsumerStatefulWidget {
  const AuthPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<AuthPage> {
  bool _hidePassword = true;

  String _version = "";

  late Future<User?> _user;

  final _edtEmail = TextEditingController(text: "");
  final _edtFullName = TextEditingController(text: "");
  final _edtPassword = TextEditingController(text: "");
  final _edtConfirmationPassword = TextEditingController(text: "");

  AuthMode _authMode = AuthMode.logIn;

  @override
  void initState() {
    super.initState();
    _user = LoginController().loadUser();
    _loadVersion();
  }

  @override
  Widget build(BuildContext context) {
    final alertProvider = Provider<Alert>((ref) => Alert());
    final alert = ref.watch(alertProvider);

    final loginState = ref.watch(loginControllerProvider);
    final loginController = ref.read(loginControllerProvider.notifier);

    final size = MediaQuery.sizeOf(context);
    return FutureBuilder(
      future: _user,
      builder: (context, snapshot) {
        if (snapshot.hasData && _edtEmail.text.isEmpty && _edtPassword.text.isEmpty) {
          _edtEmail.text = snapshot.data!.user!;
          _edtPassword.text = snapshot.data!.password!;
        }
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                SizedBox(
                  width: size.width,
                  height: size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Image.asset("assets/images/icon_title.png", height: size.height * 0.25),
                      const SizedBox(height: 16),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        width: size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            if (_authMode == AuthMode.signUp)
                              LoginTextField(
                                controller: _edtFullName,
                                label: "Full name",
                                hide: false,
                                keyboardType: TextInputType.name,
                                maxLength: 100,
                              ),
                            LoginTextField(
                              controller: _edtEmail,
                              label: "e-mail",
                              hide: false,
                              keyboardType: TextInputType.emailAddress,
                              maxLength: 100,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Stack(
                                alignment: Alignment.centerRight,
                                children: <Widget>[
                                  LoginTextField(
                                    controller: _edtPassword,
                                    label: "Password",
                                    hide: _hidePassword,
                                    keyboardType: TextInputType.visiblePassword,
                                    maxLength: 20,
                                  ),
                                  IconButton(
                                    icon: Icon(_hidePassword ? FontAwesomeIcons.eye : FontAwesomeIcons.eyeSlash),
                                    onPressed: () => setState(() => _hidePassword = !_hidePassword),
                                  )
                                ],
                              ),
                            ),
                            if (_authMode == AuthMode.signUp)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: <Widget>[
                                    LoginTextField(
                                      controller: _edtConfirmationPassword,
                                      label: "Confirm Password",
                                      hide: _hidePassword,
                                      keyboardType: TextInputType.visiblePassword,
                                      maxLength: 20,
                                    ),
                                  ],
                                ),
                              ),
                            Button(
                              label: _authMode == AuthMode.signUp ? "SIGN UP" : "LOG IN",
                              onTap: () async {
                                try {
                                  _authMode == AuthMode.signUp
                                      ? await loginController.signUp(context, ref, _edtFullName.text, _edtEmail.text, _edtPassword.text, _edtConfirmationPassword.text)
                                      : await loginController.login(
                                          context,
                                          ref,
                                          _edtEmail.text,
                                          _edtPassword.text,
                                        );
                                } catch (e) {
                                  alert.snack(context, e.toString());
                                }
                              },
                            ),
                            //TODO: Implementar função
                            TextButton(
                              onPressed: () {},
                              child: const Text("Forgot Password?"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _authMode == AuthMode.signUp ? _authMode = AuthMode.logIn : _authMode = AuthMode.signUp;
                                });
                              },
                              child: Text(_authMode == AuthMode.signUp ? "Already have an account? Log in instead." : "Don't have an account? Create one here.", textAlign: TextAlign.center),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(bottom: 16, right: 16, child: Text("Version: $_version")),
                if (loginState.isLoading) Progress(size),
              ],
            ),
          ),
        );
        // : Progress(size);
      },
    );
  }

  void _loadVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }
}
