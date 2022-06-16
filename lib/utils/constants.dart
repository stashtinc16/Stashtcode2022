import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

String userId = "";
String userName = "";
var userImage = ValueNotifier<String>("");
String userEmail = "";
String globalNotificationToken = "";
bool isSocailUser = false;

bool fromShare = false;
String memoriesCollection = "memories";
String userCollection = "users";
String commentsCollection = "comments";

String memoriesTitle = "Memories";
String settingsTitle = "Settings";

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
              "key=AAAA2627rvU:APA91bGisn9zzHeXgs5i0rqS46twn2qFhW0tQCn_s97NmsxsOQW4GfsTbyYgA-zXqt4dw97vInpFIQE9Y2GovMUELIS08ryGuEC6zNpnKEaQTFEHE-rJZ9SL6r4MuVftUP4LFmRhOTWL",
        },
        body: payload);
    print("reason phrase....${response!.reasonPhrase}");
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
