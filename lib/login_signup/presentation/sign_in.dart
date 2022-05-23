import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:stasht/forgot_password/presentation/forget_password.dart';
import 'package:stasht/login_signup/controllers/signup_controller.dart';
import 'package:stasht/login_signup/domain/sign_up.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

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
                              Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          169, 165, 218, 1)),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                ),
                                child: TextFormField(
                                  controller: controller.email1Controller,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  decoration: const InputDecoration(
                                      labelText: "E-mail",
                                      labelStyle: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 11,
                                      ),
                                      // hintText: 'E-mail',
                                      // hintStyle: TextStyle(
                                      //     color: AppColors.fieldBorderColor,
                                      //     fontSize: 21),
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
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color.fromRGBO(
                                          169, 165, 218, 1)),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.white,
                                ),
                                child: Center(
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
                                        // hintText: 'Password',
                                        // hintStyle: const TextStyle(
                                        //     color: AppColors.fieldBorderColor,
                                        //     fontSize: 21),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.only(
                                            bottom: 10, left: 15, top: 5),
                                        suffixIcon: IconButton(
                                          icon: Icon(controller.isObscure.value
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off,size: 20,),
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
                                  controller.signIn();
                                },
                                child: Center(
                                  child: Container(
                                    height: 35,
                                    width: 90,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        color:    AppColors.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(22)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                              const SizedBox(
                                height: 15,
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
                                        color: Color.fromRGBO(108, 96, 255, 1),
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
