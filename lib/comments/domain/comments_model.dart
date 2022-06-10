import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stasht/login_signup/domain/user_model.dart';

class CommentsModel {
  String? userId;
  String? commentId;
  String? comment;
  String? memoryId;
  String? imageId;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  UserModel? userModel;

  CommentsModel(
      {this.userId,
      this.comment,
      this.memoryId,
      this.createdAt,
      this.imageId,
      this.updatedAt});

  CommentsModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    comment = json['comment'];
    memoryId = json['memory_id'];
    imageId = json['image_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['memory_id'] = this.memoryId;
    data['image_id'] = this.imageId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
