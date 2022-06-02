String userId = "";
String userName = "";
String userImage = "";
String userEmail = "";
bool isSocailUser = false;

bool fromShare = false;
String memoriesCollection = "memories";
String userCollection = "users";
String commentsCollection = "comments";

bool checkValidEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}
