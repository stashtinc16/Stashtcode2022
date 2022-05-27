import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stasht/forgot_password/presentation/forget_password.dart';
import 'package:stasht/login_signup/controllers/signup_controller.dart';
import 'package:stasht/login_signup/domain/sign_up.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';
import 'package:stasht/utils/constants.dart';

class SignIn extends GetView<SignupController> {
  int val = -1;
  bool isEmail = false;
  bool isLoggedIn = false;
  var profileData;

  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    this.isLoggedIn = isLoggedIn;
    this.profileData = profileData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(25),
            child: Form(
                key: controller.formkeySignin,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Center(child: SvgPicture.asset(stashtLogo))),
                      Expanded(
                          flex: 3,
                          child: Column(
                            children: [
                              InkWell(
                                onTap: () {
                                  Get.toNamed(AppRoutes.signup);
                                },
                                child: const Center(
                                  child: Text(
                                    "Sign-up",
                                    style: TextStyle(
                                      fontSize: 21,
                                      fontFamily: "gibsonsemibold",
                                      color: Color.fromRGBO(108, 96, 255, 1),
                                      fontWeight: FontWeight.w100,
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
                                controller: controller.email1Controller,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    labelText: "E-mail",
                                    labelStyle: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 11,
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color:
                                                AppColors.fieldBorderColor)),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color:
                                                AppColors.fieldBorderColor)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(50),
                                        borderSide: const BorderSide(
                                            color:
                                                AppColors.fieldBorderColor)),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 15.0, vertical: 7)),
                                style: const TextStyle(
                                    color: Colors.black, fontSize: 21),
                                cursorColor: AppColors.cursorColor,
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
                                  controller: controller.password1Controller,
                                  decoration: InputDecoration(
                                      labelText: "Password",
                                      labelStyle: const TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 11,
                                      ),
                                      hintText: 'Password',
                                      hintStyle: const TextStyle(
                                          color: AppColors.fieldBorderColor,
                                          fontSize: 21),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: const BorderSide(
                                              color: AppColors
                                                  .fieldBorderColor)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: const BorderSide(
                                              color: AppColors
                                                  .fieldBorderColor)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          borderSide: const BorderSide(
                                              color: AppColors
                                                  .fieldBorderColor)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                  cursorColor: AppColors.cursorColor,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Please enter password";
                                    }
                                   else if (value.length < 6) {
                                      return "Please enter at least 6 characters";
                                    }
                                    return null;
                                  },
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 21),
                                ),
                              )),
                              const SizedBox(height: 50),
                              GestureDetector(
                                onTap: () {
                                  controller.signIn();
                                },
                                child: Container(
                                  height: 42,
                                  width: 96,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(22)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Text(
                                        "Login",
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
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () {
                                  Get.toNamed(AppRoutes.forgotPassword);
                                },
                                child: const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Forgot your password? ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 14,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ))
                    ]))),
      ),
    ));
  }
}
