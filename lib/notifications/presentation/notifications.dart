import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stasht/app_bar.dart';
import 'package:stasht/notifications/controller/notification_controller.dart';
import 'package:stasht/notifications/domain/notification_model.dart';
import 'package:stasht/routes/app_routes.dart';
import 'package:stasht/utils/app_colors.dart';
import 'package:stasht/utils/assets_images.dart';
import 'package:stasht/utils/constants.dart';

class Notifications extends GetView<NotificationController> {
  Notifications({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      builder: (NotificationController controller) {
        return Scaffold(
            appBar: commonAppbar(
              context,
              notifications,
              pageSelected: (isMemory, isPhotos, isNotification, isSettings) =>
                  {
                if (isMemory)
                  {Get.toNamed(AppRoutes.memories)}
                else if (isSettings)
                  {Get.toNamed(AppRoutes.profile)}
              },
            ),
            body: Obx(() => controller.notificationList.isNotEmpty
                ? ListView.builder(
                    itemCount: controller.notificationList.length,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      print(
                          'MemoryId ${controller.notificationList[index].memoryId}');
                      return Column(
                        children: [
                          InkWell(
                              onTap: () {
                                if (!controller
                                    .notificationList[index].isRead) {
                                  controller.notificationList[index].isRead =
                                      !controller
                                          .notificationList[index].isRead;
                                  controller.updateReadStatus(
                                      controller.notificationList[index]);
                                  controller.update();
                                }
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 11),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          child: controller
                                                  .notificationList[index]
                                                  .memoryCover!
                                                  .isNotEmpty
                                              ? CachedNetworkImage(
                                                  fit: BoxFit.fill,
                                                  height: 40,
                                                  width: 40,
                                                  imageUrl: controller
                                                      .notificationList[index]
                                                      .memoryCover!,
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress))
                                              : Image.asset(userIcon),
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                        ),
                                        const SizedBox(
                                          width: 8,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: controller
                                                .notificationList[index]
                                                .userModel!
                                                .displayName!,
                                            style: const TextStyle(
                                                fontFamily: robotoBold,
                                                color: Color.fromRGBO(
                                                    108, 96, 255, 1),
                                                fontSize: 12),
                                            children: <TextSpan>[
                                              const TextSpan(
                                                  text:
                                                      ' added you a public memory\n',
                                                  style: TextStyle(
                                                      fontFamily: robotoRegular,
                                                      color: Colors.black,
                                                      fontSize: 12)),
                                              TextSpan(
                                                  text: controller
                                                      .notificationList[index]
                                                      .memoryTitle!,
                                                  style: const TextStyle(
                                                      fontFamily: robotoMedium,
                                                      color: AppColors
                                                          .primaryColor,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  if (!controller
                                      .notificationList[index].isRead)
                                    Positioned.fill(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: !controller
                                                .notificationList[index].isRead!
                                            ? const Color.fromRGBO(
                                                    108, 96, 255, 1)
                                                .withOpacity(0.3)
                                            : Colors.transparent,
                                      ),
                                    ),
                                ],
                              )),
                          const SizedBox(
                            height: 4,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 0.5,
                            color: AppColors.primaryColor,
                          )
                        ],
                      );
                    },
                  )
                : Container(
                    alignment: Alignment.center,
                    child: Text(
                      'No Notifications!',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontFamily: robotoMedium),
                    ),
                  )));
      },
    );
  }
}
