import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stasht/login_signup/domain/user_model.dart';

class NotificationsModel {
  String? id;
  String? memoryTitle;
  String? userId;
  String? memoryCover;
  String? memoryImage;
  String? description;
  String? type;
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
      this.memoryImage,
      this.memoryId,
      this.description,
      this.type,
      this.receiverId,
      this.createdAt,
      this.updatedAt,
      this.isRead,
      this.userModel});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memoryTitle = json['memory_title'];
    userId = json['user_id'];
    memoryCover = json['memory_cover'];
    memoryId = json['memory_id'];
    receiverId = json['receiver_id'];
    createdAt = json['created_at'];
    description = json['description'];
    memoryImage = json['memory_image'];
    type = json['type'];
    updatedAt = json['updated_at'];
    isRead = json['is_read'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['memory_title'] = memoryTitle;
    data['user_id'] = userId;
    data['memory_cover'] = memoryCover;
    data['memory_image'] = memoryImage;
    data['memory_id'] = memoryId;
    data['description'] = description;
    data['type'] = type;
    data['receiver_id'] = receiverId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_read'] = isRead;
    return data;
  }
}
