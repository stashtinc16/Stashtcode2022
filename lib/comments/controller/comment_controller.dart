import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/comments/domain/comments_model.dart';
import 'package:stasht/login_signup/domain/user_model.dart';
import 'package:stasht/main.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/utils/constants.dart';

class CommentsController extends GetxController {
  RxList commentsList = List.empty(growable: true).obs;
  TextEditingController commentController = TextEditingController();
  StreamController<CommentsModel> streamController =
      StreamController<CommentsModel>();
  int imageIndex = Get.arguments["imageIndex"];
  int mainIndex = Get.arguments["mainIndex"];
  MemoriesModel memoriesModel = Get.arguments["list"];

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

  @override
  void onInit() {
    super.onInit();
    print('InitCommentController ');
    startStreamAndGetList();
  }

  void startStreamAndGetList() {
    print('ImageID ${memoriesModel.imagesCaption![imageIndex].imageId}');
    FirebaseFirestore.instance
        .collection(commentsCollection)
        .where('memory_id', isEqualTo: Get.arguments['memoryId'])
        .where('image_id',
            isEqualTo: memoriesModel.imagesCaption![imageIndex].imageId)
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
          // streamController.sink.add(commentsModel);
          print('Inside ${commentsList.length}');
          if (element.id == event.docs[event.docs.length - 1].id) {
            memoryRef.doc(commentsModel.memoryId).get().then((value) {
              MemoriesModel memoriesModel = value.data()!;
              memoriesModel.commentCount = commentsList.length;
              print('CommentCount ${commentsList.length}');
              // memoriesModel = memoryRef

              memoryRef
                  .doc(commentsModel.memoryId)
                  .set(memoriesModel)
                  .then((value) => {
                        print('Comment Count updated  '),
                      })
                  .onError((error, stackTrace) => {});
            });
          }
        });
      }
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
          update(),
        });
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
