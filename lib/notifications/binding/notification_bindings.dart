import 'package:get/get.dart';
import 'package:stasht/notifications/controller/notification_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NotificationController());
  }
}
