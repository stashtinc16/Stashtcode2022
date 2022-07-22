import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stasht/login_signup/domain/user_model.dart';

class MemoriesModel {
  dynamic memoryId;
  dynamic title;
  List<ImagesCaption>? imagesCaption;
  Timestamp? createdAt;
  Timestamp? publishedCreatedAt;
  Timestamp? sharedCreatedAt;
  Timestamp? updatedAt;
  dynamic inviteLink;
  dynamic publishLink;
  bool? published;
  dynamic createdBy;
  dynamic commentCount;
  List<SharedWith>? sharedWith;
  dynamic sharedWithCount = 0;
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
      this.publishLink,
      this.publishedCreatedAt,
      this.sharedCreatedAt,
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
    publishLink = json['publish_link'];
    publishedCreatedAt = json['published_created_at'];
    sharedCreatedAt = json['shared_created_at'];
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
    data['publish_link'] = publishLink;
    data['invite_link'] = inviteLink;
    data['published_created_at'] = publishedCreatedAt;
    data['shared_created_at'] = sharedCreatedAt;
    data['published'] = published;
    data['created_by'] = createdBy;

    return data;
  }
}

class ImagesCaption {
  dynamic caption;
  dynamic image;
  dynamic commentCount;
  dynamic imageId;
  dynamic userId;
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
  dynamic userId;
  dynamic status;
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
