import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/comments/controller/comment_controller.dart';
import 'package:stasht/utils/assets_images.dart';
import 'package:intl/intl.dart';

class Comments extends GetView<CommentsController> {
  String memoryId = Get.arguments["memoryId"];
  String imagePath = Get.arguments!["memoryImage"];

  Comments({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {

    return GetBuilder(
      builder: (CommentsController controller) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
          ),
          title: const Text(
            'Comments',
            style: TextStyle(
                fontSize: 20, fontFamily: robotoMedium, color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: CachedNetworkImageProvider(imagePath),
                  fit: BoxFit.cover)),
          child:   Container(
            decoration: BoxDecoration(color: Colors.black.withOpacity(0.49)),
            child: Column(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: controller.hasData.value ? Obx(() =>  ListView.builder(
                      // controller: controller.scrollController,
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: [
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 30,
                                        width: 30,
                                        margin: const EdgeInsets.only(right: 5),
                                        alignment: Alignment.center,
                                        decoration: const BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(30)),
                                          child: controller
                                                  .commentsList[index]
                                                  .userModel
                                                  .profileImage
                                                  .isNotEmpty
                                              ? CachedNetworkImage(
                                                  imageUrl: controller
                                                      .commentsList[index]
                                                      .userModel
                                                      .profileImage,
                                                  height: 30,
                                                  width: 30,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image.asset(
                                                  userIcon,
                                                  fit: BoxFit.fill,
                                                  color: Colors.white,
                                                ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            controller.commentsList[index]
                                                .userModel.displayName,
                                            style: const TextStyle(
                                                fontSize: 11.0,
                                                color: Colors.white,
                                                fontFamily: robotoBold),
                                          ),
                                          Text(
                                            controller
                                                .commentsList[index].comment,
                                            style: const TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.white),
                                          )
                                        ],
                                      )),
                                      Text(
                                        DateFormat("MMM dd/yy")
                                            .format(controller
                                                .commentsList[index].createdAt!
                                                .toDate())
                                            .toString(),
                                        style: const TextStyle(
                                            fontSize: 9.0, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 0.7,
                                  color: Colors.white,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 7),
                                )
                              ],
                            );
                          },
                          itemCount: controller.commentsList.length,
                          shrinkWrap: true,
                        ) ) : SizedBox(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(color: Colors.white,)), 
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: Colors.black,
                  ),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: Row(children: [
                    Expanded(
                        child: TextField(
                      controller: controller.commentController,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Add a comment',
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          hintStyle:
                              TextStyle(fontSize: 16.0, color: Colors.white)),
                      onChanged: (commentText) {
                        controller.update();
                      },
                      style:
                          const TextStyle(fontSize: 16.0, color: Colors.white),
                    )),
                    if (controller.commentController.text.trim().isNotEmpty)
                      IconButton(
                          onPressed: () {
                            if(controller.commentController.text.trim().isNotEmpty){
                            controller.addComment(memoryId);
                            controller
                                    .memoriesModel
                                    .imagesCaption![controller.imageIndex]
                                    .commentCount =
                                controller.commentsList.length + 1;
                                }
                          },
                          icon: const Icon(Icons.arrow_circle_right_outlined,
                              color: Colors.white))
                  ]),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }


}
