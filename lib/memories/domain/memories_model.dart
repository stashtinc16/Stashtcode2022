import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stasht/login_signup/domain/user_model.dart';

class MemoriesModel {
  String? memoryId;
  String? title;
  List<ImagesCaption>? imagesCaption;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? inviteLink;
  bool? published;
  String? createdBy;
  int? commentCount;
  List<SharedWith>? sharedWith;
  int? sharedWithCount=0;
  UserModel? userModel;
  List<UserModel>? collaborators;

  MemoriesModel(
      {this.imagesCaption,
      this.title,
      this.createdAt,
      this.updatedAt,
      this.inviteLink,
      this.commentCount,
      this.published,
      this.createdBy,
      this.sharedWith,
      this.sharedWithCount,
      this.collaborators,
      this.userModel});

  MemoriesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    inviteLink = json['invite_link'];
    published = json['published'];
    createdBy = json['created_by'];
    commentCount = json['comment_count'];
    if (json['images_caption'] != null) {
      imagesCaption = <ImagesCaption>[];
      json['images_caption'].forEach((v) {
        imagesCaption!.add(ImagesCaption.fromJson(v));
      });
    }
    if (json['shared_with'] != null) {
      sharedWith = <SharedWith>[];
      json['shared_with'].forEach((v) {
        sharedWith!.add(SharedWith.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    if (imagesCaption != null) {
      data['images_caption'] = imagesCaption!.map((v) => v.toJson()).toList();
    }
    if (sharedWith != null) {
      data['shared_with'] = sharedWith!.map((v) => v.toJson()).toList();
    }
    data['comment_count'] = commentCount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['invite_link'] = inviteLink;
    data['published'] = published;
    data['created_by'] = createdBy;

    return data;
  }
}

class ImagesCaption {
  String? caption;
  String? image;
  int? commentCount;
  String? imageId;
  String? userId;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  UserModel? userModel;

  ImagesCaption(
      {this.caption,
      this.image,
      this.commentCount,
      this.imageId,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.userModel});

  ImagesCaption.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    image = json['image'];
    commentCount = json['comment_count'];
    imageId = json['image_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caption'] = caption;
    data['image'] = image;
    data['comment_count'] = commentCount;
    data['image_id'] = imageId;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SharedWith {
  String? userId;
  int? status;
  UserModel? sharedUser;

  SharedWith({this.userId, this.status, this.sharedUser});

  SharedWith.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['status'] = status;
    return data;
  }
}
