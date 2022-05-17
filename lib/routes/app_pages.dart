import 'package:get/route_manager.dart';
import 'package:stasht/login_signup/bindings/signup_binding.dart';
import 'package:stasht/login_signup/presentation/sign_up.dart';
import 'package:stasht/memories/bindings/memories_binding.dart';
import 'package:stasht/memories/presentation/memories.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/login_signup/domain/sign_in.dart';
import 'package:stasht/splash_screen.dart';
import 'package:stasht/step_1.dart';
import 'package:stasht/step_2.dart';

class AppPages {
  static const initial = AppRoutes.splashScreen;
  static final routes = [
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
    ),
    GetPage(
        name: AppRoutes.signIn,
        page: () => SignIn(),
        binding: SignupBinding(),
        transitionDuration: const Duration(seconds: 1),
        transition: Transition.circularReveal),
    GetPage(
        name: AppRoutes.signup,
        page: () => SignUp(),
        // binding: SignupBinding(),
        transitionDuration: const Duration(seconds: 1),
        transition: Transition.leftToRight),
    GetPage(
        name: AppRoutes.memoriesStep1,
        page: () => const Step1(),
        binding: SignupBinding(),
        transitionDuration: const Duration(seconds: 1),
        transition: Transition.leftToRight),
    GetPage(
        name: AppRoutes.memoriesStep2,
        page: () => const Step_2(),
        binding: SignupBinding(),
        transitionDuration: const Duration(seconds: 1),
        transition: Transition.leftToRight),
    GetPage(
        name: AppRoutes.memories,
        page: () => Memories(),
        binding: MemoriesBinding(),
        transitionDuration: const Duration(seconds: 1),
        transition: Transition.leftToRight)
  ];
}
