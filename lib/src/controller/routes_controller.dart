import 'package:go_router/go_router.dart';

import '../view/pages/auth_page.dart';
import '../view/pages/cart_page.dart';
import '../view/pages/home_page.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage(), routes: [
      GoRoute(path: 'cart', builder: (context, state) => const CartPage()),
    ]),
  ],
);
