import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  RxBool hasNotification = true.obs;
  ScrollController scrollController = ScrollController();
  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  getNotifications() {
    notificationList.clear();
    notificationsRef
        .where("receiver_id", isEqualTo: userId)
        .orderBy("created_at", descending: true)
        .snapshots()
        .listen((event) {
     hasNotification.value = event.docChanges.isNotEmpty;
      if (event.docChanges.isNotEmpty) {
        for (var element in event.docChanges) {
          NotificationsModel notificationsModel = element.doc.data()!;
          notificationsModel.id = element.doc.id;
          usersRef.doc(element.doc.data()!.userId).get().then((userValue) {
            notificationsModel.userModel = userValue.data();
            int index = 0;
            var notificationValue = notificationList.where((p0) {
              index = notificationList.indexOf(p0);
              return p0.id == element.doc.id;
            });

            if (notificationValue.isNotEmpty) {
              notificationList[index] = notificationsModel;
            } else {
              notificationList.add(notificationsModel);
            }

            if (notificationList.length == event.docChanges.length) {
              try {
                notificationList.sort((first, second) {
                  return second.createdAt!.compareTo(first.createdAt!);
                });
              } catch (e) {
                e.toString();
              }
              update();
            }
          });
        }
      } else {
        hasNotification.value = true;
        update();
      }
    });
  }

// update notification read status
  void updateReadStatus(NotificationsModel notificationList) {
    notificationsRef
        .doc(notificationList.id)
        .update({"is_read": true}).then((value) {});
    notificationCount.value = notificationCount.value - 1;
    if (notificationCount.value >= 0) {
      usersRef
          .doc(userId)
          .update({"notification_count": notificationCount.value});
    }
  }
}
