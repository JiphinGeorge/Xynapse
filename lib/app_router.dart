import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/auth/admin_login_screen.dart'; // ✅ Added
import 'screens/user_home_screen.dart';
import 'screens/admin/admin_dashboard.dart';

/// 🌐 Centralized route management for Xynapse
class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String adminLogin = '/adminLogin'; // ✅ Added
  static const String adminDashboard = '/adminDashboard'; // Renamed for clarity
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());

      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());

      case Routes.home:
        return MaterialPageRoute(builder: (_) => const UserHomeScreen());

      case Routes.adminLogin: // ✅ New route
        return MaterialPageRoute(builder: (_) => const AdminLoginScreen());

      case Routes.adminDashboard:
        return MaterialPageRoute(builder: (_) => const AdminDashboard());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                '⚠️ No route defined for ${settings.name}',
                style: const TextStyle(fontSize: 16, color: Colors.redAccent),
              ),
            ),
          ),
        );
    }
  }
}
