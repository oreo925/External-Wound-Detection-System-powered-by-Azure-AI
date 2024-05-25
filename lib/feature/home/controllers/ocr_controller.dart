import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utilis/loaders/loaders.dart';
import '../screens/wound_detection_screen/wound_detection.dart';

class OCRController extends GetxController {
  static OCRController get instance => Get.find();

  // Text-to-Speech instance
  final FlutterTts flutterTts = FlutterTts();

  // variables
  RxString selectedImagePath = ''.obs; // Observable to hold selected image path
  RxString extractedText = ''.obs;
  RxBool isSpeaking = false.obs;
  String scannedText = "";

  // clear method
  void clearSelectedImagePath() async {
    selectedImagePath.value = '';
    extractedText.value = '';
    await flutterTts.stop();
  }

  // extract text from image
  Future<void> extractText() async {
    if (selectedImagePath.isEmpty) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Please select image first');
    } else {
      final inputImage = InputImage.fromFilePath(selectedImagePath.value);
      final textRecognizer = GoogleMlKit.vision.textRecognizer();
      try {
        final RecognizedText recognizedText =
            await textRecognizer.processImage(inputImage);
        scannedText = ""; // Clear previous text
        for (TextBlock block in recognizedText.blocks) {
          for (TextLine line in block.lines) {
            scannedText += "${line.text}\n";
          }
        }
        if (scannedText.isEmpty) {
          // Update observable to trigger UI update with no text found message
          TLoaders.errorSnackBar(title: 'Error', message: 'No text recognized. Please try a different image');
        } else {
          extractedText.value =
              scannedText; // Update observable with recognized text
        }
      } catch (e) {
        extractedText.value = "Failed to recognize text: $e";
      } finally {
        textRecognizer.close();
      }
    }
  }

  // speak Text
  Future<void> speakText() async {
    if (extractedText.isEmpty) {
      TLoaders.errorSnackBar(title: 'Error', message: 'Please extract text first');
    } else {
      isSpeaking.value = true;
      await flutterTts.speak(extractedText.value);
      isSpeaking.value = false;
    }
  }

  uploadpicture() async {
    try {
      await showModalBottomSheet(
        context: Get.context!,
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Choose an option'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CustomButton(
                      btnname: 'Camera',
                      icons: Icons.camera_alt,
                      onpressed: () async {
                        Navigator.pop(context); // Close the bottom sheet
                        final imagePicker = ImagePicker();
                        XFile? image = await imagePicker.pickImage(
                          source: ImageSource.camera,
                          imageQuality:
                              100, // Set image quality to maximum (original)
                          maxWidth: 1000,
                          maxHeight: 1000,
                        );
                        if (image != null) {
                          image = await cropImage(image.path); // Returns XFile?
                          if (image != null) {
                            selectedImagePath.value = image.path;
                          }
                        }
                      },
                    ),
                    CustomButton(
                      btnname: 'Gallery',
                      icons: Icons.image,
                      onpressed: () async {
                        Navigator.pop(context); // Close the bottom sheet
                        final imagePicker = ImagePicker();
                        XFile? image = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                          imageQuality:
                              100, // Set image quality to maximum (original)
                          maxWidth: 1000,
                          maxHeight: 1000,
                        );
                        if (image != null) {
                          image = await cropImage(image.path); // Returns XFile?
                          if (image != null) {
                            selectedImagePath.value = image.path;
                          }
                        }
                      },
                    )
                  ],
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      TLoaders.errorSnackBar(
        title: 'Opps!',
        message: 'Something went wrong: $e',
      );
    }
  }

  Future<XFile?> cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    );

    if (croppedFile != null) {
      // Convert CroppedFile to XFile
      return XFile(croppedFile.path);
    }
    return null;
  }
}
