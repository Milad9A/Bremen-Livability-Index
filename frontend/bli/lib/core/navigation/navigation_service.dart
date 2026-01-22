import 'package:flutter/material.dart';
import 'package:bli/features/map/screens/map_screen.dart';
import 'package:bli/features/auth/screens/auth_screen.dart';
import 'package:bli/features/auth/screens/email_auth_screen.dart';

class NavigationService {
  static const _transitionDuration = Duration(milliseconds: 250);

  static void navigateToMap(BuildContext context, {bool replace = true}) {
    final route = PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const MapScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: _transitionDuration,
    );

    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }

  static void navigateToAuth(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AuthScreen()));
  }

  static void navigateToEmailAuth(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const EmailAuthScreen()));
  }

  static void pop(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void popToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}
