import 'package:get/instance_manager.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/splash/controllers/splash_controller.dart';

class SplashBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
    Get.put(MemoriesController());
  }
}
