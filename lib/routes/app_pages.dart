import 'package:get/route_manager.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/routes/sign_in.dart';
import 'package:stasht/sign_up.dart';
import 'package:stasht/splash_screen.dart';

class AppPages {
  static const INITIAL = AppRoutes.SplashScreen;
  static final routes = [
    GetPage(
        name: AppRoutes.SplashScreen,
        page: () => const SplashScreen(),
        children: [
          GetPage(name: AppRoutes.SignIn, page: () => SignIn()),
          GetPage(name: AppRoutes.Signup, page: () => const SignUp())
        ])
  ];
}
