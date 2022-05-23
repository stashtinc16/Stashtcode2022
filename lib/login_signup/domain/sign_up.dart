import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stasht/login_signup/controllers/signup_controller.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

class Signup extends GetView<SignupController> {
  int val = -1;
  bool isEmail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.only( left: 25, right: 25),
            child: Form(
                key: controller.formkey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Center(child: SvgPicture.asset(stashtLogo)),
                        flex: 1,
                      ),
                      Expanded(
                          flex: 3,
                        child: Column(
                          children: [
                            InkWell(
                              onTap: (() {
                                Get.back();
                              }),
                              child: const Center(
                                child: Text(
                                  "Sign-in",
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Color.fromRGBO(108, 96, 255, 1),
                                    // fontFamily: "gibsonsemibold",
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            MaterialButton(
                              onPressed: () {
                                // controller.facebookSignin();
                                controller.facebookLogin();
                              },
                              height: 40,
                              color: AppColors.colorBlue,
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
                                        fontSize: 14,
                                        fontFamily: robotoMedium,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromRGBO(255, 255, 255, 1)),
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
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.fieldBorderColor),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              // height: 50,
                              child: TextFormField(
                                controller: controller.userNameController,
                                textInputAction: TextInputAction.next,
                                decoration: const InputDecoration(
                                    labelText: "Username",
                                    labelStyle: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 11,
                                    ),
                                    border: InputBorder.none,
                                    // hintText: 'Username',
                                    // hintStyle: TextStyle(
                                    //     color: AppColors.fieldBorderColor,
                                    //     fontSize: 21),
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10, left: 15, top: 5)),
                                style: const TextStyle(color: Colors.black),
                                validator: (v) {
                                  if (v!.isEmpty ||
                                      !RegExp(r"^[a-zA-Z0-9]+").hasMatch(v)) {
                                    return 'Enter a valid username!';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.fieldBorderColor),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: TextFormField(
                                controller: controller.emailController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                    labelText: "E-mail",
                                    // hintText: 'E-mail',
                                    // hintStyle: TextStyle(
                                    //     color: AppColors.fieldBorderColor,
                                    //     fontSize: 21),
                                    labelStyle: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 11,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        bottom: 10, left: 15, top: 5)),
                                style: const TextStyle(color: Colors.black),
                                validator: (v) {
                                  if (v!.isEmpty) {
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
                              width: MediaQuery.of(context).size.width,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: AppColors.fieldBorderColor),
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.white,
                              ),
                              child: Center(
                                  child: Obx(
                                () => TextFormField(
                                  obscureText: controller.isObscure.value,
                                  controller: controller.passwordController,
                                  decoration: InputDecoration(
                                      labelText: "Password",
                                      // hintText: 'Password',
                                      // hintStyle: const TextStyle(
                                      //     color: AppColors.fieldBorderColor,
                                      //     fontSize: 21),
                                      labelStyle: const TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 11,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                          bottom: 10, left: 15, top: 5),
                                      suffixIcon: IconButton(
                                        icon: Icon(controller.isObscure.value
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off, size: 20,),
                                        onPressed: () {
                                          controller.isObscure.value =
                                              !controller.isObscure.value;
                                        },
                                      )),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter password";
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(color: Colors.black),
                                ),
                              )),
                            ),
                            const SizedBox(height: 50),
                            GestureDetector(
                              onTap: () {
                                controller.checkEmailExists();
                              },
                              child: Center(
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color:
                                          AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(22)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Create Account",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontFamily: gibsonSemiBold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      
                      )
                    ]))),
      ),
    ));
  }
}
