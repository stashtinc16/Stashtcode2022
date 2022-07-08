import 'package:cloud_firestore/cloud_firestore.dart';

class ShareLinkModel {
  String? shareLink;
  bool? linkUsed;
  String? usedBy;
  String? memoryId;
  Timestamp? createdAt;
  ShareLinkModel(
      {this.shareLink,
      this.linkUsed,
      this.usedBy,
      this.createdAt,
      this.memoryId});

  ShareLinkModel.fromJson(Map<String, dynamic> json) {
    shareLink = json['share_link'];
    linkUsed = json['link_used'];
    usedBy = json['used_by'];
    createdAt = json['created_at'];
    memoryId = json['memory_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['share_link'] = shareLink;
    data['link_used'] = linkUsed;
    data['used_by'] = usedBy;
    data['created_at'] = createdAt;
    data['memory_id'] = memoryId;
    return data;
  }
}
