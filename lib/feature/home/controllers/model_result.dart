import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class ModelResultPage extends StatelessWidget {
  final String imagePath;
  final FlutterTts flutterTts = FlutterTts();

  ModelResultPage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Model Result'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => processImage(context),
          child: Text('Process Image'),
          style: ElevatedButton.styleFrom(
            minimumSize: Size(200, 60), // Increase button size
          ),
        ),
      ),
    );
  }

  Future<void> processImage(BuildContext context) async {
    try {
      File imageFile = File(imagePath);
      
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 20),
                  Text("Processing..."),
                ],
              ),
            ),
          );
        },
      );

      String result = await sendImageToEndpoint(imageFile);
      Navigator.pop(context);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Wound Detection Result'),
            content: Text(result),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => speakResult(result, true),
                child: Text('Narration'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(100, 40), // Decrease button size
                ),
              ),
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      Navigator.pop(context);
      print('Error: $e');
    }
  }

  Future<String> sendImageToEndpoint(File imageFile) async {
    var url = Uri.parse('https://woundmodel-prediction.cognitiveservices.azure.com/customvision/v3.0/Prediction/71106831-7ea6-4e57-bb27-c4276c48af04/classify/iterations/Iteration1/image');
    var bytes = await imageFile.readAsBytes();

    try {
      var response = await http.post(
        url,
        headers: {
          'Prediction-Key': 'a22b5e83700948e6b891f226bdbe4488',
          'Content-Type': 'application/octet-stream',
        },
        body: bytes,
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        return processResponse(responseData);
      } else {
        return "Failed to connect to server with status code: ${response.statusCode}";
      }
    } catch (e) {
      return "Error sending image: $e";
    }
  }

  String processResponse(Map<String, dynamic> data) {
    String highestWound = '';
    double highestProb = 0.0;
    for (var prediction in data['predictions']) {
      if (prediction['probability'] > highestProb) {
        highestProb = prediction['probability'];
        highestWound = prediction['tagName'];
      }
    }
    String remedy = getRemedyForWound(highestWound);
    String remedyUrdu = getUrduRemedyForWound(highestWound);
    return 'Detected Wound: $highestWound\nRemedy: $remedy\nRemedy in Urdu: $remedyUrdu';
  }

  String getRemedyForWound(String woundType) {
    switch (woundType) {
      case 'Puncture':
        return 'Remedy for Puncture: Clean the wound with soap and water, apply an antibiotic ointment, and cover with a bandage.';
      case 'Avulsion':
        return 'Remedy for Avulsion: Stop bleeding by applying pressure, clean the wound with saline solution, and seek medical attention for deep wounds.';
      case 'Laceration':
        return 'Remedy for Laceration: Clean the wound with mild soap and water, apply pressure to stop bleeding, and cover with a sterile bandage.';
      case 'Abrasion':
        return 'Remedy for Abrasion: Wash the wound with mild soap and water, apply an antibiotic ointment, and cover with a clean bandage.';
      default:
        return 'Remedy: Seek medical attention for proper treatment.';
    }
  }

  String getUrduRemedyForWound(String woundType) {
    switch (woundType) {
      case 'Puncture':
        return 'پنکچر کا علاج: زخم کو صابن اور پانی سے صاف کریں، اینٹی بایوٹک مرہم لگائیں اور پٹی باندھیں۔';
      case 'Avulsion':
        return 'اوولشن کا علاج: خون بہنا روکنے کے لئے دباو ڈالیں، زخم کو سیلائن سلوشن سے دھوئیں اور گہرے زخموں کے لئے طبی مدد حاصل کریں۔';
      case 'Laceration':
        return 'لیسریشن کا علاج: زخم کو ہلکے صابن اور پانی سے دھوئیں، خون بہنا روکنے کے لئے دباو ڈالیں، اور اسٹریل بینڈیج سے ڈھانپیں۔';
      case 'Abrasion':
        return 'ایبریشن کا علاج: زخم کو ہلکے صابن اور پانی سے دھوئیں، اینٹی بایوٹک مرہم لگائیں اور صاف پٹی سے ڈھانپیں۔';
      default:
        return 'علاج: مناسب علاج کے لئے طبی مدد حاصل کریں۔';
    }
  }

  void speakResult(String result, bool inUrdu) {
    // Assuming the Urdu remedy is always at the end of the result string
    String toSpeak = inUrdu ? result.split('Remedy in Urdu: ')[1] : result;
    flutterTts.setLanguage("ur-PK");
    flutterTts.speak(toSpeak);
  }

  
}
