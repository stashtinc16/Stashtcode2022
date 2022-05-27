import 'package:get/route_manager.dart';
import 'package:stasht/forgot_password/bindings/forgot_password_binding.dart';
import 'package:stasht/forgot_password/presentation/forget_password.dart';
import 'package:stasht/login_signup/bindings/signup_binding.dart';
import 'package:stasht/login_signup/presentation/sign_in.dart';
import 'package:stasht/memories/bindings/memories_binding.dart';
import 'package:stasht/memories/presentation/add_caption.dart';
import 'package:stasht/memories/presentation/memories.dart';
import 'package:stasht/memories/presentation/memory_lane.dart';
import 'package:stasht/profile/bindings/profile_binding.dart';
import 'package:stasht/profile/presentation/profile.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/login_signup/domain/sign_up.dart';
import 'package:stasht/splash/bindings/splash_bindings.dart';
import 'package:stasht/splash_screen.dart';
import 'package:stasht/step_1.dart';
import 'package:stasht/step_2.dart';

class AppPages {
  static const initial = AppRoutes.splashScreen;
  static final routes = [
    GetPage(
      name: AppRoutes.splashScreen, page: () => const SplashScreen(), binding: SplashBindings()),
    GetPage(
        name: AppRoutes.signIn, page: () => SignIn(), binding: SignupBinding()),
    GetPage(
        name: AppRoutes.signup, page: () => Signup(), binding: SignupBinding()),
    GetPage(
        name: AppRoutes.memoriesStep1, page: () => Step1(), binding: MemoriesBinding()),
    GetPage(
        name: AppRoutes.memoriesStep2, page: () => Step_2(), binding: MemoriesBinding()),
    GetPage(
        name: AppRoutes.memories, page: () => Memories(), binding: MemoriesBinding()),
    GetPage(
        name: AppRoutes.profile, page: () => Profile(), binding: ProfileBinding()),
    GetPage(
        name: AppRoutes.forgotPassword, page: () => ForgotPassword(), binding: ForgotPasswordBindings()),
    GetPage(
        name: AppRoutes.memoryList, page: () => Memory_Lane(), binding: MemoriesBinding()),
    GetPage(
        name: AppRoutes.addCaption, page: () => AddCaption(), binding: MemoriesBinding())
  ];
}
