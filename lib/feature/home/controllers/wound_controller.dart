import 'dart:io';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../../../utilis/loaders/loaders.dart';
import '../screens/wound_detection_screen/wound_detection.dart';

class WoundDetechController extends GetxController {
  static WoundDetechController get instance => Get.find();

  RxString selectedImagePath = ''.obs; // Observable to hold selected image path

  Future<void> generateAndDownloadPDF() async {
    try {
      if (selectedImagePath.isEmpty) {
        TLoaders.errorSnackBar(
            title: 'Error', message: 'Please select an image first.');
        return;
      }
      // Show toast message
      TLoaders.successSnackBar(
          title: 'Downloading',
          message: 'Please wait while the report is being generated...');

      // Generate PDF content
      final pdf = await generatePDFContent();

      // Get the directory where the PDF file will be saved
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/wound_report.pdf';

      // Save the PDF file
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      // Open the PDF file in a PDF viewer
      await OpenFile.open(filePath);
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error', message: 'Failed to generate or open PDF: $e');
    }
  }

  void clearSelectedImagePath() {
    selectedImagePath.value = '';
  }

  uploadUserWound() async {
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
                        final image = await ImagePicker().pickImage(
                          source: ImageSource.camera,
                          imageQuality:
                              100, // Set image quality to maximum (original)
                          maxWidth: 512,
                          maxHeight: 512,
                        );
                        if (image != null) {
                          selectedImagePath.value =
                              image.path; // Set selected image path
                        }
                      },
                    ),
                    CustomButton(
                      btnname: 'Gallery',
                      icons: Icons.image,
                      onpressed: () async {
                        Navigator.pop(context); // Close the bottom sheet
                        final image = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                          imageQuality:
                              100, // Set image quality to maximum (original)
                          maxWidth: 512,
                          maxHeight: 512,
                        );
                        if (image != null) {
                          selectedImagePath.value =
                              image.path; // Set selected image path
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

  Future<pw.Document> generatePDFContent() async {
    // Generate PDF content
    final pdf = pw.Document();

  
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        final pw.MemoryImage image =
            pw.MemoryImage(File(selectedImagePath.value).readAsBytesSync());
        // table data
        final List<Map<String, String>> tableData = [
          {
            'Date': '2024-4-25',
            'Type': 'Laceration',
            'Location': 'Hand',
          },
        ];

        // Create table
        final List<pw.TableRow> rows = tableData.map((data) {
          return pw.TableRow(
            children: [
              pw.Center(
                child: pw.Text(data['Date'] ?? ''),
              ),
              pw.Center(
                child: pw.Text(data['Type'] ?? ''),
              ),
              pw.Center(
                child: pw.Text(data['Location'] ?? ''),
              ),
            ],
          );
        }).toList();

        return pw.Center(
          child: pw.Column(
            children: [
              pw.Text('Wound Detection System',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                        'Date: ${DateFormat('MM-dd-yyyy').format(DateTime.now())}',
                        style: const pw.TextStyle(fontSize: 14)),
                    pw.Text(
                        'Time: ${DateFormat('hh:mm a').format(DateTime.now())}',
                        style: const pw.TextStyle(fontSize: 14)),
                  ]),
              pw.SizedBox(height: 20),
              pw.Text('Health Report',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: ['Date', 'Type', 'Location']
                        .map((title) => pw.Center(
                            child: pw.Text(title,
                                style: pw.TextStyle(
                                    fontSize: 12,
                                    fontWeight: pw.FontWeight.bold))))
                        .toList(),
                  ),
                  ...rows,
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(children: [
                      pw.Text('Original Image',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 20),
                      pw.Container(
                        width: 300,
                        height: 300,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Image(image,
                            width: 230, height: 230, fit: pw.BoxFit.cover),
                      ),
                    ]),
                    pw.Column(children: [
                      pw.Text('Analyis Image',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 20),
                      pw.Container(
                        width: 300,
                        height: 300,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(),
                        ),
                        child: pw.Image(image,
                            width: 230, height: 230, fit: pw.BoxFit.cover),
                      ),
                    ]),
                  ]),
              pw.SizedBox(height: 20),
              pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                        textAlign: pw.TextAlign.start,
                        'Description',
                        style: pw.TextStyle(
                            fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 10),
                    pw.Text(
                        textAlign: pw.TextAlign.justify,
                        'Laceration - Lacerations are cuts, slices, or tears in the skin. Lacerations are often caused by sharp objects like knives or broken glass. Bleeding may occur quickly in the cases of deep lacerations, so it is important to stop the bleeding by covering the wound and applying pressure.',
                        style: const pw.TextStyle(fontSize: 12)),
                  ]),
              pw.Spacer(),
              pw.Text(
                'Legal Notice: This report is for informational purposes only and is not intended for legal or insurance purposes. Consult with a qualified healthcare professional for specific medical advice and treatment.',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        );
      },
    ));

    return pdf;
  }
}
