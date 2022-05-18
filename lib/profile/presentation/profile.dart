import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stasht/app_bar.dart';
import 'package:stasht/profile/controller/profile_controller.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';

class Profile extends GetView<ProfileController> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _image = File(image.path);
    } else {
      print('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: commonAppbar(
          context,
          'Memories',
          pageSelected: (isMemory, isPhotos, isNotification, isSettings) => {
            print('isMemory $isMemory'),
            if (isMemory) {Get.toNamed(AppRoutes.memories)}
          },
        ),
        body: SingleChildScrollView(
            child: SafeArea(
                child: Padding(
          padding: const EdgeInsets.only(top: 0),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 150,
                    color: AppColors.bgColor,
                    alignment: Alignment.center,
                    child: _image != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: InkWell(
                              onTap: () => getImage(),
                              child: Container(
                                height: 108,
                                width: 108,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(207, 216, 220, 1),
                                  ),
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                        _image!,
                                      )),
                                ),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: InkWell(
                              onTap: () => getImage(),
                              child: Container(
                                height: 108,
                                width: 108,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color.fromRGBO(234, 243, 248, 1),
                                  border: Border.all(
                                    color:
                                        const Color.fromRGBO(207, 216, 220, 1),
                                  ),
                                ),
                                child: Image.asset(userIcon),
                              ),
                            ),
                          ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Icon(
                      Icons.linked_camera_outlined,
                      color: Colors.white,
                      size: 30,
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: TextFormField(
                          decoration: const InputDecoration(
                              labelText: "Display Name",
                              labelStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.only(bottom: 10, top: 5)),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 14),
                        )),
                        const Text(
                          "Change",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.grey,
                      margin: const EdgeInsets.only(bottom: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: const InputDecoration(
                                labelText: "E-mail",
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    EdgeInsets.only(bottom: 10, top: 5)),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
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
                        const Text(
                          "Change",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.grey,
                      margin: const EdgeInsets.only(bottom: 15),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Obx(
                          () => TextFormField(
                            obscureText: controller.isObscure.value,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: controller.passwordcontroller,
                            decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                contentPadding:
                                    const EdgeInsets.only(bottom: 10, top: 5),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isObscure.value
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () {
                                    controller.isObscure.value =
                                        !controller.isObscure.value;
                                  },
                                )),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                        )),
                        const Text(
                          "Change",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 60,
                    ),
                    Center(
                      child: MaterialButton(
                        onPressed: () {
                          controller.logoutUser();
                        },
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                        child: const Text('Logout',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.white)),
                        color: AppColors.primaryColor,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ))));
  }
}
