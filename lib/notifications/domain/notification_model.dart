import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stasht/login_signup/domain/user_model.dart';

class NotificationsModel {
  String? id;
  String? memoryTitle;
  String? userId;
  String? memoryCover;
  String? memoryId;
  String? receiverId;
  Timestamp? createdAt;
  Timestamp? updatedAt;
  bool? isRead;
  UserModel? userModel;

  NotificationsModel(
      {this.id,
      this.memoryTitle,
      this.userId,
      this.memoryCover,
      this.memoryId,
      this.receiverId,
      this.createdAt,
      this.updatedAt,
      this.isRead,this.userModel});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memoryTitle = json['memory_title'];
    userId = json['user_id'];
    memoryCover = json['memory_cover'];
    memoryId = json['memory_id'];
    receiverId = json['receiver_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isRead = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['memory_title'] = this.memoryTitle;
    data['user_id'] = this.userId;
    data['memory_cover'] = this.memoryCover;
    data['memory_id'] = this.memoryId;
    data['receiver_id'] = this.receiverId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['is_read'] = this.isRead;
    return data;
  }
}
