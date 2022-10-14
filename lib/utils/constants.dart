import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';

String userId = "";
String userName = "";
String memoryName = "";
String memoryId = "";
Uri? memoryLink;
var userImage = ValueNotifier<String>("");
var notificationCount = ValueNotifier<int>(0);
String userEmail = "";
String globalNotificationToken = "";
bool isSocailUser = false;
String changePassword = "Change Password";

bool fromShare = false;
bool expandShareMemory = false;
var sharedMemoryCount = ValueNotifier<int>(0);
MemoriesModel? globalShareMemoryModel;
//collections
String memoriesCollection = "memories";
String userCollection = "users";
String shareLinkCollection = "share_links";
String commentsCollection = "comments";
String notificationsCollection = "notifications";

// App bar Titles
String memoriesTitle = "Memories";
String settingsTitle = "Settings";
String notifications = "Notifications";

bool checkValidEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

Future<void> sendPushMessage(var receiverFBToken, String payload) async {
  if (receiverFBToken == null || receiverFBToken == "") {
    print('Unable to send FCM message, no token exists.');
    return;
  }

  print("firebase token> $receiverFBToken =>  payload $payload");

  try {
    final response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        // await http.post(Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: {
          "X-Requested-With": "XMLHttpRequest",
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAASUsV4Fk:APA91bHKYQ2XsHzBAhTmIvQU24DYB5K9GGY6457CkPIm0_-vkHTPCgfLpLBWrOL1Zgvb-4cnc0AXRgzFFzGmQXo32q3MeptLclkIhuwihgcDrnpP-DtCEQVly6F0MDg5JLj7V3FERL4p",
        },
        body: payload);
    print("reason phrase....${response.reasonPhrase}");
    print("response=> ${response.request} ${response.statusCode}");

    if (response.statusCode == 200) {
      print('FCM request for device sent!');
      // If server returns an OK response, parse the JSON
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  } catch (e) {
    print(e);
  }
}

getOutlineBorder() {
  return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(color: AppColors.hintTextColor, width: 0.1));
}

getNormalTextStyle() {
  return const TextStyle(fontSize: 12.0, color: AppColors.greyColor);
}

goToMemories(bool fromShareLink) {
  Get.offNamed(AppRoutes.memories,
      arguments: {"fromSignupAndShare": fromShareLink});
}

goToMemoriesAndClearAll() {
  Get.offAllNamed(AppRoutes.memories, arguments: {"fromSignupAndShare": false});
}
