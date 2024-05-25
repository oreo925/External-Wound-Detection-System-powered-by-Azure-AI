import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../controllers/model_result.dart'; // Import ModelResultPage
import '../../../../utilis/constants/colors.dart';
import '../../../../utilis/helpers/helper_function.dart';
import '../../controllers/wound_controller.dart';

class WoundDetectionScreen extends StatelessWidget {
  const WoundDetectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homecontroller = Get.put(WoundDetechController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: WColors.white),
        backgroundColor: WColors.primary,
        title: Text(
          'Wound Detection',
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(color: WColors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => homecontroller.selectedImagePath.value.isNotEmpty
                  ? Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(
                              File(homecontroller.selectedImagePath.value)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      height: 300,
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: dark ? WColors.white : WColors.black)),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Image(
                                  image: const AssetImage(
                                      'assets/home/image-gallery.png'),
                                  color: dark ? WColors.white : WColors.black,
                                  width: 150,
                                  height: 150,
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  textAlign: TextAlign.center,
                                  'Click your wound image / Select Image from Gallery',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ), // Display nothing if no image is selected
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    homecontroller.uploadUserWound();
                  },
                  child: const Text('Upload Image')),
            ),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomButton(
                  btnname: 'Analyse Wound',
                  icons: Iconsax.search_normal,
                  onpressed: () {
                    // Navigating to ModelResultPage and passing the image path
                    Get.to(() => ModelResultPage(imagePath: homecontroller.selectedImagePath.value));
                  },
                ),
                CustomButton(
                  btnname: 'Reset Image',
                  icons: Icons.refresh,
                  onpressed: () {
                    homecontroller.clearSelectedImagePath();
                  },
                ),
                CustomButton(
                  btnname: 'Download Report',
                  icons: Icons.download,
                  onpressed: () {
                    homecontroller.generateAndDownloadPDF();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.btnname,
    required this.icons,
    required this.onpressed,
    this.iconsize=28,
    this.fontsize=14
  });
  final String btnname;
  final double iconsize,fontsize;
  final IconData icons;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icons,
              size: iconsize,
            ),
            const SizedBox(
              height: 5,
            ),
            Text(textAlign: TextAlign.center, btnname,style: TextStyle(fontSize: fontsize),)
          ],
        ),
      ),
    );
  }
}
