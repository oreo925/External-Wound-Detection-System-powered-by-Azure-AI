import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:wounddetectionsystem/feature/home/screens/home_screen/first_aid_screen/first_aid_screen.dart';
import 'package:wounddetectionsystem/feature/home/screens/home_screen/wound_types_screen/wound_types.dart';
import 'package:wounddetectionsystem/feature/personalization/screens/profile/profile.dart';

import '../../../../common/widgets/appbar/appbar.dart';
import '../../../../common/widgets/custom_shape/containers/primary_header_container.dart';
import '../../../../common/widgets/text/section_heading.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utilis/constants/colors.dart';
import '../../../../utilis/constants/size.dart';
import '../../../../utilis/loaders/shimmers/shimmer.dart';
import '../../../personalization/controllers/user_controller.dart';
import '../home_screen/ocr_screen/image_to_text.dart';
import '../home_screen/widgets/grid_card.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  // AppBar
                  //HomeAppBar(),
                  TAppBar(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi Admin!',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .apply(
                                        color: WColors.grey,
                                      ),
                                ),
                                Obx(
                                  () {
                                    if (controller.profileloading.value) {
                                      // Display a shimmer loader while user profile is being loading
                                      return const TShimmerEffect(
                                          width: 80, height: 15);
                                    } else {
                                      return Text(
                                        "Hello ${controller.user.value.fullname}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall!
                                            .apply(
                                              color: WColors.white,
                                            ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  Get.to(const UserProfile());
                                },
                                icon: const Icon(
                                  Iconsax.user,
                                  size: 30,
                                  color: WColors.white,
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections * 2,
                  ),
                  // SearchBar
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  SectionHeading(
                    title: "Wound Detection System",
                    showActionButton: false,
                    onpressed: () {},
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GridCard(
                          imageurl: 'assets/home/tape.png',
                          texttitle: 'Manage Wound Types',
                          onpressed: () => Get.to(const WoundTypeScreen())),
                      GridCard(
                          imageurl: 'assets/home/first-aid-kit.png',
                          texttitle: 'Manage First Aid',
                          onpressed: () => Get.to(const FirstAidScreen())),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GridCard(
                          imageurl: 'assets/home/ocr.png',
                          texttitle: 'OCR',
                          onpressed: () => Get.to(const TextRecognition())),
                      GridCard(
                          imageurl: 'assets/home/logout.png',
                          texttitle: 'logout',
                          onpressed: () {
                            Get.defaultDialog(
                              title: 'Logout!',
                              middleText: 'Are You sure you went to Logout?',
                              onConfirm: () {
                                AuthenticationRepository.instance.logout();
                              },
                              onCancel: () => Get.back(),
                            );
                          }),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
