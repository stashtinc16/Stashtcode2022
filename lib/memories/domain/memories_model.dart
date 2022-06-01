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
  List<SharedWith>? sharedWith;
  UserModel? userModel;

  MemoriesModel(
      {this.imagesCaption,
      this.title,
      this.createdAt,
      this.updatedAt,
      this.inviteLink,
      this.published,
      this.createdBy,
      this.sharedWith,this.userModel});

  MemoriesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    inviteLink = json['invite_link'];
    published = json['published'];
    createdBy = json['created_by'];
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

  ImagesCaption({this.caption, this.image});

  ImagesCaption.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['caption'] = caption;
    data['image'] = image;
    return data;
  }
}

class SharedWith {
  String? userId;
  int? status;

  SharedWith({this.userId, this.status});

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
