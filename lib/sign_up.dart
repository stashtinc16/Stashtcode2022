import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stasht/forget_password.dart';
import 'package:stasht/sign_in.dart';
import 'package:stasht/step_1.dart';

import 'authentication.dart';





class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  @override
State<StatefulWidget> createState() {
  return _SignUp();
}
}
class _SignUp extends State<SignUp> {
  bool _iisObscure=true;
  int val = -1;
  bool isEmail=false;
  var Emailcontroller=TextEditingController();
  var passwordcontroller=TextEditingController();
  var namecontroller=TextEditingController();
  bool isLoggedIn = false;
  var profileData;
  var facebookLogin = FacebookLogin();
  AuthenticationService _auth = AuthenticationService();

  final _formkey = GlobalKey<FormState>();

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
  }



@override
  Widget build(BuildContext context) {
    return Scaffold(
        body:SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.only(top: 100,left: 25,right: 25),
              child:Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "stasht.",
                        style: TextStyle(
                            fontSize: 53,
                            color: Color.fromRGBO(108, 96, 255, 1),
                            fontWeight: FontWeight.w800,
                            fontFamily: "gibsonsemibold"
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    InkWell(onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Sign_In()));
                    },
                      child:

                      Center(
                      child: Text(
                        "Sign-up",
                        style: TextStyle(
                          fontSize: 21,
                          fontFamily: "gibsonsemibold",
                          color:Color.fromRGBO(108, 96, 255, 1),
                          fontWeight: FontWeight.w100,

                        ),
                      ),
                    ),
            ),
                    const SizedBox(height:15),
                    MaterialButton(
                      onPressed: (){
                        // _displayLoginButton();
                        signInFb(context);
                      },
                      // onPressed: () => facebookLogin.isLoggedIn
                      //     .then((isLoggedIn) => isLoggedIn ? signInFb(context):_logout()),
                      height: 50,
                      color: const Color.fromRGBO(2, 152, 216, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/fb.svg",
                            height: 16,
                            width: 8,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 10,
                            height: 2,
                          ),
                          const Text(
                            'Sign-in with Facebook',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "adobe-clean-cufonfonts",
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(255, 255, 255, 1)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height:20),
                    Row(
                        children: const <Widget>[
                          Expanded(
                              child: Divider(height: 1,color: Colors.grey,)
                          ),
                          SizedBox(width: 11,),
                          Text("or",
                            style: TextStyle(color: Colors.grey),),
                          SizedBox(width: 11,),
                          Expanded(
                              child: Divider(height: 1,color: Colors.grey,)
                          ),
                        ]
                    ),
                    const SizedBox(height:20,),
                    // Form(
                    //     key: _formKey,
                    // child:
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromRGBO(169, 165, 218, 1)),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: "Username",
                            labelStyle: TextStyle(
                                color: Color.fromRGBO(108, 96, 255, 1),
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                fontFamily: "assets/fonts/roboto_regular.ttf"
                            ),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.only(bottom: 10, left: 15, top: 5)),
                        style: const TextStyle(color: Colors.black),
                        validator: (v) {
                          if (v!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(v)) {
                            return 'Enter a valid email!';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20,),


                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color:const Color.fromRGBO(169, 165, 218, 1)),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        decoration: const InputDecoration(
                            labelText: "E-mail",
                            labelStyle: TextStyle(
                              color:  Color.fromRGBO(108, 96, 255, 1),
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.only(bottom: 10, left: 15, top: 5)),
                        style: const TextStyle(color: Colors.black),
                        validator: (v) {
                          if (v!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(v)) {
                            return 'Enter a valid email!';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 20,),

            Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                border: Border.all(color: const Color.fromRGBO(169, 165, 218, 1)),
                borderRadius: BorderRadius.circular(50),
                color: Colors.white,
              ),
              child: Center(
                child: TextFormField(
                  obscureText: _iisObscure,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: passwordcontroller,
                  decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: const TextStyle(
                        color:  Color.fromRGBO(108, 96, 255, 1),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.only(bottom: 10, left: 15, top: 5),
                      suffixIcon: IconButton(
                        icon: Icon(_iisObscure
                            ? Icons.visibility_outlined
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _iisObscure = !_iisObscure;
                          });
                        },
                      )),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),


                    const SizedBox(height:50),
                    GestureDetector(
                      onTap: () {
                        if(_formkey.currentState?.validate()??true) {
                          signInUser();
                        }
                      },
                      child:
                      Center(
                        child: Container(
                          height: 35,
                          width: 90,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color:
                              const Color.fromRGBO(108, 96, 255, 1),
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                "Login",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15,),
            InkWell(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> Forget_Password()));
            },
                child:

                Center(
                      child: Text(
                        "Forgot your password? ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color.fromRGBO(108, 96, 255, 1),
                          fontSize: 14,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
            )
                  ]
              )
          ),
        )
    );
  }

  void signInFb(BuildContext context) async {
    print("Asdas");
    final fbLogin = FacebookLogin();
    final FacebookLoginResult result = await fbLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
      // FacebookPermission.userFriends
    ]);
    print("Email : ${FacebookPermission.email}");

    print('Facebook Error= $result');
    print('Facebook Error>>= ${result.error}');
    print('Facebook Error ${result.error!.developerMessage}');

    // Send access token to server for validation and auth
    print('Status ${result.status.name}');
    final FacebookAccessToken? accessToken = result.accessToken;
    print('Access token: ${accessToken!.token}');

    // Get profile data
    final profile = await fbLogin.getUserProfile();
    print('Hello, ${profile!.name}! You ID: ${profile.userId}');

    // Get user profile image url
  }




// _displayLoginButton() {
//   return RaisedButton(
//     child: Text("Login with Facebook"),
//     onPressed: () => initiateFacebookLogin(),
//   );
// }
//
// _logout() async {
//   await facebookLogin.logOut();
//   onLoginStatusChanged(false);
//   print("Logged out");
// }
  void signInUser() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: Emailcontroller.text, password: passwordcontroller.text).then((value){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Step1()));
      });
    }on FirebaseAuthException catch(e){
      if (e.code == 'user-not-found') {
        print("User not found");
        return Future.error(
            "User Not Found", StackTrace.fromString("User Not Found"));
      } else if (e.code == 'wrong-password') {
        print("Incorrect password");

        return Future.error(
            "Incorrect password", StackTrace.fromString("Incorrect password"));
      } else {
        print("Login Failed");
        return Future.error(
            "Login Failed", StackTrace.fromString("Unknown error"));

      }
    }
  }
}




