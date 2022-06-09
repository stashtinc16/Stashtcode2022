import 'dart:io';
import 'dart:io' as io;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stasht/app_bar.dart';
import 'package:stasht/profile/controller/profile_controller.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';
import 'package:stasht/utils/constants.dart';

class Profile extends GetView<ProfileController> {
  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _image = File(image.path);
      uploadImageToDB(_image);
    } else {
      print('No image selected.');
    }
  }

  void uploadImageToDB(File? image) {
    EasyLoading.show(status: 'Uploading...');
    UploadTask uploadTask;
    // Create a Reference to the file
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('profile')
        .child('/${Timestamp.now().millisecondsSinceEpoch}');

    final metadata = SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {
        'picked-file-path': image!.path,
      },
    );

    print('metaData ${metadata.customMetadata}');

    uploadTask = ref.putFile(io.File(image.path), metadata);
    uploadTask.whenComplete(() => {
          uploadTask.snapshot.ref.getDownloadURL().then((value) => {
                print('URl $value'),
                userImage.value = value,
                controller.updateProfileImage(value),
                EasyLoading.dismiss()
              })
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: commonAppbar(
            context,
            settingsTitle,
            pageSelected: (isMemory, isPhotos, isNotification, isSettings) => {
              if (isMemory) {Get.toNamed(AppRoutes.memories)}
            },
          ),
          body: SingleChildScrollView(
              child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Column(
                children: [
                  InkWell(
                    onTap: () => getImage(),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 150,
                          color: AppColors.bgColor,
                          alignment: Alignment.center,
                          child: userImage.value.isNotEmpty
                              ? ValueListenableBuilder(
                                  builder: (context, value, child) {
                                    return ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(65)),
                                      child: Container(
                                        height: 108,
                                        width: 108,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: const Color.fromRGBO(
                                                207, 216, 220, 1),
                                          ),
                                        ),
                                        margin: const EdgeInsets.all(1.0),
                                        child: CachedNetworkImage(
                                          imageUrl: userImage.value,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }, valueListenable: userImage,
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(top: 0),
                                  child: Container(
                                    height: 108,
                                    width: 108,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color.fromRGBO(
                                          234, 243, 248, 1),
                                      border: Border.all(
                                        color: const Color.fromRGBO(
                                            207, 216, 220, 1),
                                      ),
                                    ),
                                    child: Image.asset(userIcon),
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
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: Obx(() => TextFormField(
                                      controller:
                                          controller.nameController.value,
                                      readOnly:
                                          !controller.changeUserName.value,
                                      decoration: const InputDecoration(
                                          labelText: "Display Name",
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.only(
                                              bottom: 10, top: 5)),
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 14),
                                    ))),
                            InkWell(
                                onTap: () {
                                  if (controller.changeUserName.value) {
                                    controller.changeUserNameFunc();
                                  }

                                  controller.changeUserName.value =
                                      !controller.changeUserName.value;
                                },
                                child: Obx(() => Text(
                                      controller.changeUserName.value
                                          ? "Save"
                                          : "Change",
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize:
                                            controller.changeUserName.value
                                                ? 12
                                                : 11,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ))),
                          ],
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Colors.grey,
                          margin: const EdgeInsets.only(bottom: 15),
                        ),
                        TextFormField(
                          controller: TextEditingController(text: userEmail),
                          readOnly: true,
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
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 1,
                          color: Colors.grey,
                          margin: const EdgeInsets.only(bottom: 15),
                        ),
                        // if (!isSocailUser)
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Expanded(
                        //           child: Obx(
                        //         () => TextFormField(
                        //           obscureText: controller.isObscure.value,
                        //           autovalidateMode:
                        //               AutovalidateMode.onUserInteraction,
                        //           controller: controller.passwordcontroller,
                        //           decoration: InputDecoration(
                        //               labelText: "Password",
                        //               labelStyle: const TextStyle(
                        //                 color: Colors.grey,
                        //                 fontSize: 12,
                        //                 fontWeight: FontWeight.w400,
                        //               ),
                        //               border: InputBorder.none,
                        //               contentPadding: const EdgeInsets.only(
                        //                   bottom: 10, top: 5),
                        //               suffixIcon: IconButton(
                        //                 icon: Icon(
                        //                   controller.isObscure.value
                        //                       ? Icons.visibility_outlined
                        //                       : Icons.visibility_off,
                        //                   color: Colors.grey,
                        //                 ),
                        //                 onPressed: () {
                        //                   controller.isObscure.value =
                        //                       !controller.isObscure.value;
                        //                 },
                        //               )),
                        //           style: const TextStyle(
                        //               color: Colors.black, fontSize: 14),
                        //         ),
                        //       )),
                        //       const Text(
                        //         "Change",
                        //         style: TextStyle(
                        //           color: AppColors.primaryColor,
                        //           fontSize: 11,
                        //           fontWeight: FontWeight.w400,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // if (!isSocailUser)
                        //   Container(
                        //     width: MediaQuery.of(context).size.width,
                        //     height: 1,
                        //     color: Colors.grey,
                        //   ),
                        const SizedBox(
                          height: 60,
                        ),
                        Center(
                          child: MaterialButton(
                            onPressed: () {
                              controller.logoutUser();
                            },
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            child: const Text('Logout',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.white)),
                            color: AppColors.primaryColor,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ))),
    );
  }
}
