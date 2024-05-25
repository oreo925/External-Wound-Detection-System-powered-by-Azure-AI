import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../feature/home/models/wound_type_model.dart';
import '../../utilis/exceptions/firebase_exceptions.dart';
import '../../utilis/exceptions/format_exceptions.dart';
import '../../utilis/exceptions/platform_exceptions.dart';

class WoundsRepository extends GetxController {
  static WoundsRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<WoundTypeModel>> fetchWoundDetails() async {
    try {
      final result = await _db.collection('Wounds').get();
      return result.docs
          .map((documentSnapshot) =>
              WoundTypeModel.fromDocumentSnapshot(documentSnapshot))
          .toList();
    } catch (e) {
      throw 'Something went wrong while fetching Address Information.Try agian later';
    }
  }
  
  // Update any field in specific Users Collection
  Future<void> updateSingleField(Map<String, dynamic> json, String wid) async {
    try {
      await _db.collection("Wounds").doc(wid).update(json);
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Somthing went wrong. Please try again';
    }
  }

  Future<String> addwounddetails(WoundTypeModel address) async {
    try {
      final currentwound = await _db.collection('Wounds').add(address.toJson());
      return currentwound.id;
    } catch (e) {
      throw 'Something went wrong while Saving Address Information.Try agian later';
    }
  }

  // Function to remove user data from firbase
  Future<void> removewoundrecord(carid) async {
    try {
      await _db.collection("Wounds").doc(carid).delete();
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Somthing went wrong. Please try again';
    }
  }

  // Upload any Image
  Future<String> uploadImage(String path, XFile image) async {
    try {
      final ref = FirebaseStorage.instance.ref(path).child(image.name);
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Somthing went wrong. Please try again';
    }
  }
}
