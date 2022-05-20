import 'package:cloud_firestore/cloud_firestore.dart';

class MemoriesModel {
  String? memoryId;
  String? caption;
  String? title;
  List<String>? images;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  String? inviteLink;
  bool? published;
  String? createdBy;
  List<String>? users;

  MemoriesModel(
      {this.caption,
      this.title,
      this.images,
      this.createdAt,
      this.updatedAt,
      this.inviteLink,
      this.published,
      this.createdBy,
      this.users});

  MemoriesModel.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    title = json['title'];
    images = json['images'].cast<String>();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    inviteLink = json['invite_link'];
    published = json['published'];
    createdBy = json['created_by'];
    users = json['users'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['caption'] = caption;
    data['title'] = title;
    data['images'] = images;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['invite_link'] = inviteLink;
    data['published'] = published;
    data['created_by'] = createdBy;
    data['users'] = users;
    return data;
  }
}
