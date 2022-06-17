import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/notifications/domain/notification_model.dart';
import 'package:stasht/utils/constants.dart';

class NotificationController extends GetxController {
  final notificationsRef = FirebaseFirestore.instance
      .collection(notificationsCollection)
      .withConverter<NotificationsModel>(
        fromFirestore: (snapshots, _) =>
            NotificationsModel.fromJson(snapshots.data()!),
        toFirestore: (notifications, _) => notifications.toJson(),
      );

  final usersRef = FirebaseFirestore.instance
      .collection(userCollection)
      .withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (users, _) => users.toJson(),
      );
  RxList notificationList = List.empty(growable: true).obs;
  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  getNotifications() {
    notificationList.clear();
    notificationsRef
        .where("receiver_id", isEqualTo: userId)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        for (var element in event.docs) {
          NotificationsModel notificationsModel = element.data();
          notificationsModel.id = element.id;
          usersRef.doc(element.data().userId).get().then((userValue) {
            print('userValue.data() ${userValue.data()!.displayName!}');
            notificationsModel.userModel = userValue.data();
            notificationList.value.add(notificationsModel);
            if (element.id == event.docs[event.docs.length - 1].id) {
              update();
            }
          });
          // notificationList.value.add(element.data());
        }
      }
    });
  }
}
