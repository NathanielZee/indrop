import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/job_detail_screen/job_detail_screen.dart';
import '../presentation/messages_screen/messages_screen.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/profile_screen/profile_screen.dart';
import '../presentation/home_screen/home_screen.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splash = '/splash-screen';
  static const String jobDetail = '/job-detail-screen';
  static const String messages = '/messages-screen';
  static const String login = '/login-screen';
  static const String profile = '/profile-screen';
  static const String home = '/home-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splash: (context) => const SplashScreen(),
    jobDetail: (context) => const JobDetailScreen(),
    messages: (context) => const MessagesScreen(),
    login: (context) => const LoginScreen(),
    profile: (context) => const ProfileScreen(),
    home: (context) => const HomeScreen(),
    // TODO: Add your other routes here
  };
}
