import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/forgot_password/controller/forgot_password_controller.dart';
import 'package:stasht/splash_screen.dart';

class ForgotPassword extends GetView<ForgotPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 25, right: 25),
        child: Column(
          children: [
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
              height: 50,
            ),
            const Center(
              child: Text(
                "Forget Password",
                style: TextStyle(
                  fontSize: 21, fontFamily: "gibsonsemibold",
                  color: Color.fromRGBO(108, 96, 255, 1),
                  fontWeight: FontWeight.w200,

                  //fontFamily: "adobe-clean-cufonfonts"),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Form(
              key: controller.formkey,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border:
                      Border.all(color: const Color.fromRGBO(169, 165, 218, 1)),
                  borderRadius: BorderRadius.circular(50),
                  color: Colors.white,
                ),
                child: TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
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
                    if (v!.isEmpty) {
                      return 'Enter a valid email!';
                    }
                    return null;
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            InkWell(
              onTap: () {
                controller.sendResendLink();
                //  Navigator.push(context, MaterialPageRoute(builder: (context)=> Step_2()));
              },
              child: Center(
                child: Container(
                  height: 42,
                  width: 96,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(108, 96, 255, 1),
                      borderRadius: BorderRadius.circular(18)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Send Link",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: const Center(
                child: Text(
                  "Back to login",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(108, 96, 255, 1),
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}
