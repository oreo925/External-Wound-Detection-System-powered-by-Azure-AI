import 'package:flutter/material.dart';
import 'package:get/get.dart';


import '../../../../common/widgets/custom_shape/containers/primary_header_container.dart';
import '../../../../common/widgets/custom_shape/containers/search_container.dart';
import '../../../../common/widgets/text/section_heading.dart';
import '../../../../utilis/constants/size.dart';
import '../wound_detection_screen/wound_detection.dart';
import 'first_aid_screen/first_aid_screen.dart';
import 'ocr_screen/image_to_text.dart';
import 'widgets/grid_card.dart';
import 'widgets/home_app_bar.dart';
import 'wound_types_screen/wound_types.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const TPrimaryHeaderContainer(
            child: Column(
              children: [
                // AppBar
                HomeAppBar(),
                SizedBox(
                  height: TSizes.spaceBtwSections,
                ),
                // SearchBar
                SearchContainer(text: "Search"),
                SizedBox(
                  height: TSizes.spaceBtwSections * 2,
                ),
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
                  height: TSizes.spaceBtwItem,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GridCard(
                        imageurl: 'assets/home/tape.png',
                        texttitle: 'Wound Types',
                        onpressed: () => Get.to(const WoundTypeScreen())),
                    GridCard(
                        imageurl: 'assets/home/analysis.png',
                        texttitle: 'Wound Detection',
                        onpressed: () => Get.to(const WoundDetectionScreen())),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GridCard(
                        imageurl: 'assets/home/first-aid-kit.png',
                        texttitle: 'First Aid',
                        onpressed: () => Get.to(const FirstAidScreen())),
                    GridCard(
                        imageurl: 'assets/home/ocr.png',
                        texttitle: 'OCR',
                        onpressed: () => Get.to(const TextRecognition())),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
