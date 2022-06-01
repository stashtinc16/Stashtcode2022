import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/memories/controllers/memories_controller.dart';
import 'package:stasht/memories/domain/memories_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class Memory_Lane extends GetView<MemoriesController> {
  int? mainIndex;
  MemoriesModel? memoriesModel;

  @override
  Widget build(BuildContext context) {
    mainIndex = Get.arguments['mainIndex'];
    memoriesModel = Get.arguments['list'];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  image: DecorationImage(
                      image:
                          NetworkImage(memoriesModel!.imagesCaption![0].image!),
                      fit: BoxFit.cover),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () => Get.back(),
                            icon: const Icon(
                              Icons.arrow_back_ios_outlined,
                              color: Colors.white,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.createDynamicLink(
                                  memoriesModel!.memoryId!, true, mainIndex!);
                            },
                            child: const Icon(
                              Icons.person_add_alt_1_outlined,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                      Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: memoriesModel!.userModel != null &&
                                    memoriesModel!
                                        .userModel!.profileImage!.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(30)),
                                    child: CachedNetworkImage(
                                        imageUrl: memoriesModel!
                                            .userModel!.profileImage!))
                                : Container(),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(
                                top: 5,
                              ),
                              child: Text(
                                memoriesModel!.title!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 18),
                              ))
                        ],
                      )),
                    ],
                  ),
                )),
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0, top: 8.0),
                child: ListView.builder(
                  itemCount: memoriesModel!.imagesCaption!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 45,
                              width: 45,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                  border: Border.all(
                                      color: Colors.white, width: 2)),
                              child: memoriesModel!.userModel != null
                                  ? ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(30)),
                                      child: CachedNetworkImage(
                                        imageUrl: memoriesModel!
                                            .userModel!.profileImage!,
                                      ),
                                    )
                                  : Text(
                                      memoriesModel!.userModel!.userName!
                                          .toString()
                                          .substring(0, 1)
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          color: Colors.white,
                                          fontFamily: gibsonSemiBold),
                                    ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    memoriesModel!.userModel!.userName!,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: '',
                                      style: const TextStyle(
                                          color: Colors.black, fontSize: 10),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: DateFormat("MMM dd/yy")
                                                .format(memoriesModel!
                                                    .createdAt!
                                                    .toDate())
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.blue,
                                                fontSize: 10)),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const Text(
                              "0",
                              style: TextStyle(color: Colors.black),
                            ),
                            const Icon(
                              Icons.chat_bubble_outline,
                              color: Colors.black,
                              size: 16,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 400,
                          decoration: BoxDecoration(
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(20)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                SizedBox(
                                  height: 400,
                                  width: MediaQuery.of(context).size.width,
                                  child: CachedNetworkImage(
                                      progressIndicatorBuilder: (context, url,
                                              progress) =>
                                          Center(
                                            child: CircularProgressIndicator(
                                              value: progress.progress,
                                            ),
                                          ),
                                      fit: BoxFit.cover,
                                      imageUrl: memoriesModel!
                                          .imagesCaption![index].image!),
                                ),
                                Positioned(
                                  right: 10,
                                  top: 10,
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(12)),
                                        color: AppColors.primaryColor),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Get.toNamed(AppRoutes.addCaption, arguments: {
                              'mainIndex': mainIndex,
                              'imageIndex': index
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(top: 10),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            child: Text(
                                memoriesModel!
                                        .imagesCaption![index].caption!.isEmpty
                                    ? 'Add caption to this Post...'
                                    : memoriesModel!
                                        .imagesCaption![index].caption!,
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    color: memoriesModel!.imagesCaption![index]
                                            .caption!.isEmpty
                                        ? AppColors.textColor
                                        : AppColors.darkColor,
                                    fontSize: memoriesModel!
                                            .imagesCaption![index]
                                            .caption!
                                            .isEmpty
                                        ? 12
                                        : 14,
                                    fontStyle: FontStyle.italic)),
                          ),
                        ),
                        // Container(
                        //   height: 1,
                        //   width: MediaQuery.of(context).size.width,
                        //   color: Colors.grey,
                        // ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      // bottomSheet: Container(
      //     height: 60,
      //     color: Colors.white,
      //     child:Padding(padding: const EdgeInsets.only(left: 30,right: 30),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: const [

      //           Icon(Icons.insert_drive_file_outlined,color: Colors.grey,size: 25,),
      //           Icon(Icons.share_outlined,color: Colors.grey,size: 25,),
      //           Icon(Icons.web_outlined,color: Colors.grey,size: 25,),

      //         ],
      //       ),)
      // ),
    );
  }
}
