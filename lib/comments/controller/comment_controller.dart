import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/comments/domain/comments_model.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/utils/constants.dart';

class CommentsController extends GetxController {
  RxList commentsList = List.empty(growable: true).obs;
  TextEditingController commentController = TextEditingController();
  StreamController<CommentsModel> streamController =
      StreamController<CommentsModel>();

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
      .withConverter<CommentsModel>(
        fromFirestore: (snapshots, _) =>
            CommentsModel.fromJson(snapshots.data()!),
        toFirestore: (comments, _) => comments.toJson(),
      );
  @override
  void onInit() {
    super.onInit();
    startStreamAndGetList();
  }

  void startStreamAndGetList() {
    FirebaseFirestore.instance
        .collection(commentsCollection)
        .where('memory_id', isEqualTo: Get.arguments['memoryId'])
        .orderBy('created_at', descending: false)
        .withConverter<CommentsModel>(
          fromFirestore: (snapshots, _) =>
              CommentsModel.fromJson(snapshots.data()!),
          toFirestore: (comments, _) => comments.toJson(),
        )
        .snapshots()
        .listen((event) {
      // here count is a field name in firestore database
      print('OutSide => ${commentsList.length}');
      commentsList.clear();
      for (var element in event.docs) {
        usersRef.doc(element.data().userId).get().then((userValue) {
          CommentsModel commentsModel = CommentsModel();
          commentsModel = element.data();
          commentsModel.commentId = element.id;
          commentsModel.userModel = userValue.data()!;

          commentsList.add(commentsModel);
          streamController.sink.add(commentsModel);
          print('Inside ${commentsList.length}');
        });
        print('OutSide ${commentsList.length}');
      }
    });
  }

  // Add comment to memory
  void addComment(String memoryId) {
    CommentsModel commentsModel = CommentsModel(
        userId: userId,
        comment: commentController.text.toString(),
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        memoryId: memoryId);
    commentsRef.add(commentsModel).then((value) =>
        {print('CommentAdded $value'), commentController.text = "", update()});

    print('CommentsListSize ${commentsList.length}');
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
    streamController.close();
  }
}
