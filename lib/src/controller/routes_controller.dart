import 'package:go_router/go_router.dart';

import '../view/auth_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthPage()),
    // GoRoute(path: '/principal', builder: (context, state) => const PrincipalPage()),
  ],
  // redirect: (context, state) async {
  //   final isarService = IsarService();
  //   final usuario = await isarService.recuperarUsuarioDB();

  //   if (usuario == null) return '/';

  //   if (usuario.dataExpiracao != null) {
  //     if (usuario.dataExpiracao!.isAfter(DateTime.now())) return '/principal';
  //   }

  //   return null;
  // },
);
