import 'dart:async';
import 'dart:convert';

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
  int imageIndex = Get.arguments["imageIndex"];
  // int mainIndex = Get.arguments["mainIndex"];
  MemoriesModel memoriesModel = Get.arguments["list"];
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
        .where('memory_id', isEqualTo: memoriesModel.memoryId)
        .where('image_id',
            isEqualTo: memoriesModel.imagesCaption![imageIndex].imageId)
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
      event.docChanges.forEach((element) {
        print('DocChangesId ${element.doc.id}');
      });

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
              memoriesModel.imagesCaption![imageIndex].commentCount =
                  commentsList.length;

              memoryRef
                  .doc(commentsModel.memoryId)
                  .set(memoriesModel)
                  .then((value) => {print('Comment Count updated  '), update()})
                  .onError((error, stackTrace) => {});
            });
          }
        });
      }
    });
  }

  void startStreamAndGetList() {
    FirebaseFirestore.instance
        .collection(commentsCollection)
        .where('memory_id', isEqualTo: memoriesModel.memoryId)
        .where('image_id',
            isEqualTo: memoriesModel.imagesCaption![imageIndex].imageId)
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
        await usersRef.doc(element.doc.data()!.userId!).get().then((userValue) {
          CommentsModel commentsModel = CommentsModel();
          commentsModel = element.doc.data()!;
          commentsModel.commentId = element.doc.id;
          commentsModel.userModel = userValue.data()!;

          commentsList.value.add(commentsModel);
          if (commentsList.length == event.docChanges.length) {
            commentsList.sort((first, second) {
              return first.createdAt!.compareTo(second.createdAt!);
            });
            memoryRef.doc(commentsModel.memoryId).get().then((value) {
              MemoriesModel memoriesModel = value.data()!;
              memoriesModel.imagesCaption![imageIndex].commentCount =
                  commentsList.length;

              memoryRef
                  .doc(commentsModel.memoryId)
                  .set(memoriesModel)
                  .then((value) => {print('Comment Count updated  '), update()})
                  .onError((error, stackTrace) => {});
            });
            // Future.delayed(Duration(seconds: 1), (() {
            //   scrollDown();
            // }));
          }
        });
      }
    }).onDone(() {
      print('onDone ');
    });
  }

  // Add comment to memory
  void addComment(String memoryId) {
    print(
        'memoriesModel.imagesCaption![mainIndex].imageId ${memoriesModel.imagesCaption![imageIndex].imageId}');
    CommentsModel commentsModel = CommentsModel(
        userId: userId,
        comment: commentController.text.toString(),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        memoryId: memoryId,
        imageId: memoriesModel.imagesCaption![imageIndex].imageId);
    commentsRef.add(commentsModel).then((value) => {
          print('CommentAdded $value'),
          commentController.text = "",
          addCommentCountToMemories(memoryId),
          scrollDown(),
          sendCommentNotification(
              // userId == memoriesModel.createdBy!?
              memoriesModel.imagesCaption![imageIndex].userId!
              // : memoriesModel.createdBy!
              ,
              memoriesModel.memoryId!,
              memoriesModel,
              memoriesModel.imagesCaption![imageIndex].image!),
          update(),
        });
  }

  Future<void> sendCommentNotification(String receiverId, String memoryID,
      MemoriesModel memoriesModel, String commentImage) async {
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
              sendNotificationToAllUser(memoriesModel.memoryId!,
                  element.data().deviceToken!, element.id, commentImage);
            }
            if (memoriesModel.sharedWith![j].status == 1 &&
                element.id == memoriesModel.sharedWith![j].userId &&
                userId != element.id) {
              sendNotificationToAllUser(memoriesModel.memoryId!,
                  element.data().deviceToken!, element.id, commentImage);

              print('Receiver');
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

  void sendNotificationToAllUser(String memoryId, String deviceToken,
      String receiverId, String commentImage) {
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
        "memoryID": memoryId
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
    if(scrollController.position!=null){
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 50,
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

    // for (int k = 0; k < receivedId.length; k++) {
    //   usersRef.doc(receivedId[k]).get().then((value) => {
    //         usersRef.doc(receivedId[k]).update({
    //           "notification_count": value.data()!.notificationCount != null
    //               ? value.data()!.notificationCount! + 1
    //               : 1
    //         })
    //       });
    // }
  }

  void addCommentCountToMemories(String memoryId) {
    MemoriesModel memoriesModels = MemoriesModel();
    memoriesModels = memoriesModel;
    print(
        'memoriesModels.imagesCaption![imageIndex].commentCount! ${memoriesModels.imagesCaption![imageIndex].commentCount!}');

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
