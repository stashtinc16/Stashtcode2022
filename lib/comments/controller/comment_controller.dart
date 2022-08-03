import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/comments/domain/comments_model.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/main.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/notifications/domain/notification_model.dart';
import 'package:stasht/utils/constants.dart';

class CommentsController extends GetxController {
  // RxList   List<CommentsModel>
  RxList commentsList = List.empty(growable: true).obs;
  final ScrollController scrollController = ScrollController();

  TextEditingController commentController = TextEditingController();
  StreamController<CommentsModel> streamController =
      StreamController<CommentsModel>();
  // int imageIndex = Get.arguments["imageIndex"];
  // // int mainIndex = Get.arguments["mainIndex"];
  // MemoriesModel memoriesModel = Get.arguments["list"];

  String memoryId = Get.arguments["memoryId"];
  String imageId = Get.arguments["imageId"];
  String imagePath = Get.arguments!["memoryImage"];
  RxBool hasData = false.obs;

  final commentsRef = FirebaseFirestore.instance
      .collection(commentsCollection)
      .withConverter<CommentsModel>(
        fromFirestore: (snapshots, _) =>
            CommentsModel.fromJson(snapshots.data()!),
        toFirestore: (comments, _) => comments.toJson(),
      );

  final usersRef = FirebaseFirestore.instance
      .collection(userCollection)
      .withConverter<UserModel>(
        fromFirestore: (snapshots, _) => UserModel.fromJson(snapshots.data()!),
        toFirestore: (users, _) => users.toJson(),
      );

  final memoryRef = FirebaseFirestore.instance
      .collection(memoriesCollection)
      .withConverter<MemoriesModel>(
        fromFirestore: (snapshots, _) =>
            MemoriesModel.fromJson(snapshots.data()!),
        toFirestore: (comments, _) => comments.toJson(),
      );

  final notificationsRef = FirebaseFirestore.instance
      .collection(notificationsCollection)
      .withConverter<NotificationsModel>(
        fromFirestore: (snapshots, _) =>
            NotificationsModel.fromJson(snapshots.data()!),
        toFirestore: (notifications, _) => notifications.toJson(),
      );

  @override
  void onInit() {
    super.onInit();
    // getCommentsAtOnce();
    startStreamAndGetList();
  }

  void getCommentsAtOnce() {
    FirebaseFirestore.instance
        .collection(commentsCollection)
        .where('memory_id', isEqualTo: memoryId)
        .where('image_id', isEqualTo: imageId)
        .orderBy('created_at', descending: false)
        .withConverter<CommentsModel>(
          fromFirestore: (snapshots, _) =>
              CommentsModel.fromJson(snapshots.data()!),
          toFirestore: (comments, _) => comments.toJson(),
        )
        .get()
        .then((event) async {
      // here count is a field name in firestore database

      List<CommentsModel> _commentList = List.empty(growable: true);
      print('EventDocs ${event.docs.length}');
      print('EventDocsChanged ${event.docChanges.length}');
      for (var element in event.docChanges) {
        print('DocChangesId ${element.doc.id}');
      }

      for (var element in event.docs) {
        print(
            'elementId ${element.id} => ${event.docs[event.docs.length - 1].id}');
        await usersRef.doc(element.data().userId).get().then((userValue) {
          CommentsModel commentsModel = CommentsModel();
          commentsModel = element.data();
          commentsModel.commentId = element.id;
          commentsModel.userModel = userValue.data()!;

          _commentList.add(commentsModel);
          print(
              'element.id ${element.id} => ${event.docs[event.docs.length - 1].id}');
          // streamController.sink.add(commentsModel);
          if (element.id == event.docs[event.docs.length - 1].id) {
            commentsList.clear();
            commentsList.value = _commentList;
            commentsList.sort((first, second) {
              return first.createdAt!.compareTo(second.createdAt!);
            });
            print('CommentList ${commentsList.length}');
            memoryRef.doc(commentsModel.memoryId).get().then((value) {
              MemoriesModel memoriesModel = value.data()!;

              outerLoop:
              for (int i = 0; i < memoriesModel.imagesCaption!.length; i++) {
                if (memoriesModel.imagesCaption![i].imageId == imageId) {
                  memoriesModel.imagesCaption![i].commentCount =
                      commentsList.length;

                  memoryRef
                      .doc(commentsModel.memoryId)
                      .set(memoriesModel)
                      .then((value) =>
                          {print('Comment Count updated  '), update()})
                      .onError((error, stackTrace) => {});
                  break outerLoop;
                }
              }
            });
          }
        });
      }
    });
  }

  void startStreamAndGetList() {
    FirebaseFirestore.instance
        .collection(commentsCollection)
        .where('memory_id', isEqualTo: memoryId)
        .where('image_id', isEqualTo: imageId)
        .orderBy('created_at', descending: false)
        .withConverter<CommentsModel>(
          fromFirestore: (snapshots, _) =>
              CommentsModel.fromJson(snapshots.data()!),
          toFirestore: (comments, _) => comments.toJson(),
        )
        .snapshots()
        .listen((event) async {
      hasData.value = true;
      if (event.docChanges.isEmpty) {
        update();
      }

      // here count is a field name in firestore database

      for (var element in event.docChanges) {
        usersRef.doc(element.doc.data()!.userId!).get().then((userValue) {
          CommentsModel commentsModel = CommentsModel();
          commentsModel = element.doc.data()!;
          commentsModel.commentId = element.doc.id;
          commentsModel.userModel = userValue.data()!;

          commentsList.value.add(commentsModel);
          print(
              'commentsList.length ${commentsList.length} => ${event.docs.length}');
          if (commentsList.length == event.docs.length) {
            commentsList.sort((first, second) {
              return first.createdAt!.compareTo(second.createdAt!);
            });
            update();
            Future.delayed(Duration(seconds: 1), (() {
              scrollDown();
              setCommentCount();
            }));
          }
        });
      }
    }).onDone(() {
      print('onDone ');
    });
  }

  void setCommentCount() {
    memoryRef.doc(memoryId).get().then((value) {
      if (value.data() != null) {
        MemoriesModel memoriesModel = value.data()!;
        outerLoop:
        for (int i = 0; i < memoriesModel.imagesCaption!.length; i++) {
          if (memoriesModel.imagesCaption![i].imageId == imageId) {
            memoriesModel.imagesCaption![i].commentCount = commentsList.length;

            memoryRef
                .doc(memoryId)
                .set(memoriesModel)
                .then((value) => {print('Comment Count updated  '), update()})
                .onError((error, stackTrace) => {});

            break outerLoop;
          }
        }
      }
    });
  }

  // Add comment to memory
  void addComment(String memoryId) {
    String comment = commentController.text.toString();
    commentController.text = "";
    CommentsModel commentsModel = CommentsModel(
        userId: userId,
        comment: comment,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        memoryId: memoryId,
        imageId: imageId);
    commentsRef.add(commentsModel).then(
        (value) => {scrollDown(), update(), getMemoryAndSendNotification()});
  }

  void getMemoryAndSendNotification() {
    memoryRef.doc(memoryId).get().then((value) {
      MemoriesModel memoriesModel = value.data()!;
      memoriesModel.memoryId = value.id;
      addCommentCountToMemories(memoryId, memoriesModel);
      sendCommentNotification(memoryId, memoriesModel, imagePath);
    });
  }

  Future<void> sendCommentNotification(
      String memoryID, MemoriesModel memoriesModel, String commentImage) async {
    List<String> registeredTokens = List.empty(growable: true);
    List<String> receiverIds = List.empty(growable: true);

    FirebaseFirestore.instance
        .collection(userCollection)
        .withConverter<UserModel>(
          fromFirestore: (snapshots, _) =>
              UserModel.fromJson(snapshots.data()!),
          toFirestore: (users, _) => users.toJson(),
        )
        .get()
        .then((event) {
      var sendToOwner = false;
      print(
          'GetUsers ${event.docs.length} => ${memoriesModel.memoryId} => ${memoriesModel.sharedWith!.length}');
      if (event.docs.isNotEmpty) {
        outerLoop:
        for (int j = 0; j < memoriesModel.sharedWith!.length; j++) {
          innerLoop:
          for (var element in event.docs) {
            if (!sendToOwner &&
                memoriesModel.createdBy != userId &&
                memoriesModel.createdBy == element.id) {
              sendToOwner = true;
              sendNotificationToAllUser(memoriesModel.memoryId!, memoriesModel,
                  element.data().deviceToken!, element.id, commentImage);
            }
            if (memoriesModel.sharedWith![j].status == 1 &&
                element.id == memoriesModel.sharedWith![j].userId &&
                userId != element.id) {
              sendNotificationToAllUser(memoriesModel.memoryId!, memoriesModel,
                  element.data().deviceToken!, element.id, commentImage);

              break innerLoop;
            }
          }
          // if (element.id == event.docs[event.docs.length - 1].id) {
          //   sendNotificationToAllUser(memoriesModel.memoryId!, registeredTokens,
          //       receiverIds, commentImage);
          // }
        }
      }
    });
  }

  void sendNotificationToAllUser(String memoryId, MemoriesModel memoriesModel,
      String deviceToken, String receiverId, String commentImage) {
    String title = "New Comment";
    String description =
        "$userName has commented on ${memoriesModel.title} memory.";
    // String receiverToken = globalNotificationToken;
    var dataPayload = jsonEncode({
      'to': deviceToken,
      // 'registration_ids': registeredTokens,
      'data': {
        "type": "comment",
        "priority": "high",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "sound": "default",
        "senderId": userId,
        "memoryID": memoryId,
        "memoryImage": commentImage,
        "imageId": imageId
      },
      'notification': {
        'title': title,
        'body': description,
        "badge": "1",
        "sound": "default"
      },
    });
    sendPushMessage(deviceToken, dataPayload);
    saveNotificationData(receiverId, memoriesModel, commentImage);
  }

  void scrollDown() {
    if (scrollController != null &&
        scrollController.positions != null &&
        scrollController.positions.isNotEmpty &&
        scrollController.position.maxScrollExtent != null) {
      scrollController.animateTo(
        Platform.isIOS
            ? scrollController.position.maxScrollExtent
            : scrollController.position.maxScrollExtent + 50,
        duration: Duration(seconds: 2),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  // Save Notification data in DB
  void saveNotificationData(
      String receivedId, MemoriesModel memoriesModel, String commentImage) {
    String memoryCover = memoriesModel.imagesCaption!.isNotEmpty
        ? memoriesModel.imagesCaption![0].image!
        : "";
    NotificationsModel notificationsModel = NotificationsModel(
        memoryTitle: memoriesModel.title,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        isRead: false,
        memoryCover: memoryCover,
        memoryId: memoriesModel.memoryId,
        memoryImage: commentImage,
        imageId: imageId,
        description: ' has commented on',
        type: 'comment',
        receivedId: receivedId,
        // receiverIds: receivedId,
        userId: userId);
    notificationsRef
        .add(notificationsModel)
        .then((value) => print('SaveNotification $value'));
    usersRef.doc(receivedId).get().then((value) => {
          usersRef.doc(receivedId).update({
            "notification_count": value.data()!.notificationCount != null
                ? value.data()!.notificationCount! + 1
                : 1
          })
        });
  }

  void addCommentCountToMemories(String memoryId, MemoriesModel memoriesModel) {
    MemoriesModel memoriesModels = MemoriesModel();
    memoriesModels = memoriesModel;

    memoryRef
        .doc(memoryId)
        .set(memoriesModel)
        .then((value) => {
              print('UpdateCaption '),
            })
        .onError((error, stackTrace) => {});
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    streamController.close();
  }
}
