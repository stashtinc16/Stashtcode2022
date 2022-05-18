import 'package:get/instance_manager.dart';
import 'package:stasht/splash/controllers/splash_controller.dart';

class SplashBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}
