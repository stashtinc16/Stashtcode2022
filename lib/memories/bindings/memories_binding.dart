import 'package:get/get.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';

class MemoriesBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<MemoriesController>(MemoriesController());
  }
}
