import 'dart:io';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utilis/constants/colors.dart';
import '../../../../../utilis/helpers/helper_function.dart';
import '../../../controllers/ocr_controller.dart';
import '../../wound_detection_screen/wound_detection.dart';

class TextRecognition extends StatelessWidget {
  const TextRecognition({super.key});

  @override
  Widget build(BuildContext context) {
    final ocrcontroller = Get.put(OCRController());
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: WColors.white),
          backgroundColor: WColors.primary,
          title: Text(
            'Text Recognition',
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(color: WColors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                GestureDetector(
                  onTap: () => ocrcontroller.uploadpicture(),
                  child: Obx(
                    () => ocrcontroller.selectedImagePath.value.isNotEmpty
                        ? Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(
                                    ocrcontroller.selectedImagePath.value)),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 200,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1,
                                    color:
                                        dark ? WColors.white : WColors.black),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                        image: const AssetImage(
                                            'assets/home/image-gallery.png'),
                                        color: dark
                                            ? WColors.white
                                            : WColors.black,
                                        width: 100,
                                        height: 100,
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        textAlign: TextAlign.center,
                                        'Upload Picture',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ), // Display nothing if no image is selected
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                        width: 1, color: dark ? WColors.white : WColors.black),
                  ),
                  child: Obx(() => SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(ocrcontroller.extractedText.value.isEmpty
                              ? "Extract text here..."
                              : ocrcontroller.extractedText.value),
                        ),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButton(
                      btnname: 'Extract Text',
                      icons: Iconsax.text,
                      onpressed: () => ocrcontroller.extractText(),
                    ),
                    CustomButton(
                      btnname: 'Reset',
                      icons: Icons.refresh,
                      onpressed: () => ocrcontroller.clearSelectedImagePath(),
                    ),
                    CustomButton(
                      btnname: 'Speak',
                      icons: Icons.volume_up,
                      onpressed: () {
                        ocrcontroller.isSpeaking.isTrue
                            ? null
                            : ocrcontroller.speakText();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
