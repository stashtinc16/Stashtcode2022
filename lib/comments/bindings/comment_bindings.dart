import 'package:get/get.dart';
import 'package:stasht/comments/controller/comment_controller.dart';

class CommentsBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CommentsController());
  }
}
