import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:stasht/step_2.dart';

import '../authentication.dart';

class SignIn extends StatefulWidget {
  @override
  State<SignIn> createState() {
    return _SignIn();
  }
}

class _SignIn extends State<SignIn> {
  bool _iisObscure = true;
  int val = -1;
  bool isEmail = false;
  var passwordcontroller = TextEditingController();
  var namecontroller = TextEditingController();
  var Emailcontroller = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final AuthenticationService _auth = AuthenticationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.only(top: 100, left: 25, right: 25),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Center(
              child: Text(
                "stasht.",
                style: TextStyle(
                    fontSize: 53,
                    color: Color.fromRGBO(108, 96, 255, 1),
                    fontWeight: FontWeight.w800,
                    fontFamily: "gibsonsemibold"),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Center(
              child: Text(
                "Sign-in",
                style: TextStyle(
                  fontSize: 21,
                  color: Color.fromRGBO(108, 96, 255, 1),
                  fontFamily: "gibsonsemibold",
                ),
              ),
            ),
            const SizedBox(height: 15),
            MaterialButton(
              onPressed: () {
                // _trySubmitForm();
              },
              height: 40,
              color: const Color.fromRGBO(2, 152, 216, 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
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
                        fontSize: 15,
                        //fontFamily: "adobe-clean-cufonfonts",
                        fontWeight: FontWeight.w400,
                        color: Color.fromRGBO(255, 255, 255, 1)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(children: const <Widget>[
              Expanded(
                  child: Divider(
                height: 1,
                color: Colors.grey,
              )),
              SizedBox(
                width: 11,
              ),
              Text(
                "or",
                style: TextStyle(color: Colors.grey),
              ),
              SizedBox(
                width: 11,
              ),
              Expanded(
                  child: Divider(
                height: 1,
                color: Colors.grey,
              )),
            ]),
            const SizedBox(
              height: 20,
            ),
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
            const SizedBox(
              height: 20,
            ),

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
                    labelText: "E-mail",
                    labelStyle: TextStyle(
                      color: Color.fromRGBO(108, 96, 255, 1),
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

            const SizedBox(
              height: 20,
            ),

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
                        color: Color.fromRGBO(108, 96, 255, 1),
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

            const SizedBox(height: 50),
            GestureDetector(
              onTap: () {
                if (_formkey.currentState?.validate() ?? true) {
                  createUser();
                }
              },
              child: Center(
                child: Container(
                  height: 40,
                  width: 150,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(108, 96, 255, 1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Create Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ])),
    ));
  }

  void createUser() async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: Emailcontroller.text,
        password: passwordcontroller.text,
      )
          .then((value) {
        print("FirebaseAuthExceptionValue $value");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const Step_2()));
      }).onError((error, stackTrace) {
        print("FirebaseAuthExceptionError $error");
      });
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException $e");
      return;
    }
  }
}
