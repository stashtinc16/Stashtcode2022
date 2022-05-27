import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stasht/login_signup/controllers/signup_controller.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';
import 'package:stasht/utils/constants.dart';

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
            padding: const EdgeInsets.only(left: 25, right: 25),
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
                                    color: AppColors.primaryColor,
                                    fontFamily: gibsonSemiBold,
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
                            TextFormField(
                              controller: controller.userNameController,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                labelText: "Username",
                                labelStyle: const TextStyle(
                                  color: AppColors.primaryColor,
                                  fontSize: 11,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: const BorderSide(
                                        color: AppColors.fieldBorderColor)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: const BorderSide(
                                        color: AppColors.fieldBorderColor)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: const BorderSide(
                                        color: AppColors.fieldBorderColor)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 7),
                                hintText: 'Username',
                                hintStyle: const TextStyle(
                                    color: AppColors.fieldBorderColor,
                                    fontSize: 21),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (v) {
                                if (v!.isEmpty ||
                                    !RegExp(r"^[a-zA-Z0-9]+").hasMatch(v)) {
                                  return 'Enter a valid username!';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: controller.emailController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                  labelText: "E-mail",
                                  hintText: 'E-mail',
                                  hintStyle: const TextStyle(
                                      color: AppColors.fieldBorderColor,
                                      fontSize: 21),
                                  labelStyle: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 11,
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: const BorderSide(
                                          color: AppColors.fieldBorderColor)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: const BorderSide(
                                          color: AppColors.fieldBorderColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50),
                                      borderSide: const BorderSide(
                                          color: AppColors.fieldBorderColor)),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 7)),
                              style: const TextStyle(color: Colors.black),
                              validator: (v) {
                                if (v!.isEmpty) {
                                  return 'Enter a valid email!';
                                } else if (!checkValidEmail(v)) {
                                  return 'Please enter valid email address';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Center(
                                child: Obx(
                              () => TextFormField(
                                obscureText: controller.isObscure.value,
                                controller: controller.passwordController,
                                decoration: InputDecoration(
                                    labelText: "Password",
                                    hintText: 'Password',
                                    hintStyle: const TextStyle(
                                        color: AppColors.fieldBorderColor,
                                        fontSize: 21),
                                    labelStyle: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 11,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: AppColors.fieldBorderColor)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: AppColors.fieldBorderColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color: AppColors.fieldBorderColor)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 7),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        controller.isObscure.value
                                            ? Icons.visibility_outlined
                                            : Icons.visibility_off,
                                        size: 20,
                                        color: AppColors.fieldBorderColor,
                                      ),
                                      onPressed: () {
                                        controller.isObscure.value =
                                            !controller.isObscure.value;
                                      },
                                    )),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter password";
                                  } else if (value.length < 6) {
                                    return "Please enter at least 6 characters";
                                  }
                                  return null;
                                },
                                style: const TextStyle(color: Colors.black),
                              ),
                            )),
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
                                      color: AppColors.primaryColor,
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
