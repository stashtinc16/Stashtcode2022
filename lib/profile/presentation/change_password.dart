import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/profile/controller/profile_controller.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/constants.dart';

class ChangePassword extends GetView<ProfileController> {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(controller
            .allowBackPressOnPw.value); // if true allow back else block it
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.chevron_left_sharp,
                color: Colors.black,
              )),
          centerTitle: false,
          title: Text(
            changePassword,
            style:
                const TextStyle(fontSize: 16.0, color: AppColors.primaryColor),
          ),
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formkeyPassword,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(
                  () => TextFormField(
                    controller: controller.oldPasswordcontroller.value,
                    decoration: InputDecoration(
                        hintText: 'Current Password',
                        labelText: 'Current Password',
                        hintStyle: getNormalTextStyle(),
                        labelStyle: getNormalTextStyle(),
                        border: getOutlineBorder(),
                        enabledBorder: getOutlineBorder(),
                        focusedBorder: getOutlineBorder(),
                        fillColor: AppColors.hintTextColor,
                        filled: true,
                        suffixIcon: IconButton(
                            onPressed: () {
                              controller.isObscureOld.value =
                                  !controller.isObscureOld.value;
                            },
                            icon: Icon(
                              controller.isObscureOld.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off,
                              size: 15,
                              color: AppColors.hintPrimaryColor,
                            ))),
                    validator: (currentPassword) {
                      if (currentPassword!.isEmpty) {
                        return 'Please enter current password';
                      } else if (currentPassword.length < 6) {
                        return 'Please enter at least 6 characters';
                      }
                      return null;
                    },
                    obscureText: controller.isObscureOld.value,
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => TextFormField(
                    controller: controller.newPasswordcontroller.value,
                    decoration: InputDecoration(
                        hintText: 'New Password',
                        labelText: 'New Password',
                        hintStyle: getNormalTextStyle(),
                        labelStyle: getNormalTextStyle(),
                        border: getOutlineBorder(),
                        enabledBorder: getOutlineBorder(),
                        focusedBorder: getOutlineBorder(),
                        fillColor: AppColors.hintTextColor,
                        filled: true,
                        suffixIcon: IconButton(
                            onPressed: () {
                              controller.isObscureNew.value =
                                  !controller.isObscureNew.value;
                            },
                            icon: Icon(
                              controller.isObscureNew.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off,
                              size: 15,
                              color: AppColors.hintPrimaryColor,
                            ))),
                    validator: (newPassword) {
                      if (newPassword!.isEmpty) {
                        return 'Please enter new password';
                      } else if (newPassword.length < 8) {
                        return 'Please enter at least 8 characters';
                      } else if (newPassword ==
                          controller.oldPasswordcontroller.value.text) {
                        return 'New password should be different from old current password';
                      }
                      return null;
                    },
                    obscureText: controller.isObscureNew.value,
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPasswordcontroller.value,
                    decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        labelText: 'Confirm Password',
                        hintStyle: getNormalTextStyle(),
                        labelStyle: getNormalTextStyle(),
                        border: getOutlineBorder(),
                        enabledBorder: getOutlineBorder(),
                        focusedBorder: getOutlineBorder(),
                        fillColor: AppColors.hintTextColor,
                        filled: true,
                        suffixIcon: IconButton(
                            onPressed: () {
                              controller.isObscureConfirm.value =
                                  !controller.isObscureConfirm.value;
                            },
                            icon: Icon(
                              controller.isObscureConfirm.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off,
                              size: 15,
                              color: AppColors.hintPrimaryColor,
                            ))),
                    validator: (confirmPassword) {
                      if (confirmPassword!.isEmpty) {
                        return 'Please enter confirm password';
                      } else if (confirmPassword !=
                          controller.newPasswordcontroller.value.text) {
                        return 'Password mismatch';
                      }
                      return null;
                    },
                    obscureText: controller.isObscureConfirm.value,
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Min 8 characters',
                    style: TextStyle(fontSize: 12.0, color: Colors.grey),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    controller.changePassword();
                  },
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(changePassword,
                        style: const TextStyle(
                            fontSize: 15.0, color: Colors.white)),
                  ),
                  color: AppColors.primaryColor,
                  height: 45,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
