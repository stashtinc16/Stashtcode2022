import 'package:cloud_firestore/cloud_firestore.dart';

class MemoriesModel {
  String? memoryId;
  String? title;
  List<ImagesCaption>? imagesCaption;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? inviteLink;
  bool? published;
  String? createdBy;
  List<String>? users;

  MemoriesModel(
      {this.imagesCaption,
      this.title,
      this.createdAt,
      this.updatedAt,
      this.inviteLink,
      this.published,
      this.createdBy,
      this.users});

  MemoriesModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
  
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    inviteLink = json['invite_link'];
    published = json['published'];
    createdBy = json['created_by'];
    users = json['users'].cast<String>();
    if (json['images_caption'] != null) {
      imagesCaption = <ImagesCaption>[];
      json['images_caption'].forEach((v) {
        imagesCaption!.add( ImagesCaption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
   if (imagesCaption != null) {
      data['images_caption'] =
          imagesCaption!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['invite_link'] = inviteLink;
    data['published'] = published;
    data['created_by'] = createdBy;
    data['users'] = users;
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