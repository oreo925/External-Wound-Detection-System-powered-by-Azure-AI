import 'package:cloud_firestore/cloud_firestore.dart';

class WoundTypeModel {
  String id;
  String title;
  String subtitle;
  String imageUrl;
  String description;

  WoundTypeModel({
    required this.id,
    required this.description,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  static WoundTypeModel empty() => WoundTypeModel(
        id: '',
        description: '',
        imageUrl: '',
        subtitle: '',
        title: '',
      );

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'WoundName': title,
      'WoundSubtitle': subtitle,
      'description': description,
      'Woundpic': imageUrl,
    };
  }

  factory WoundTypeModel.fromMap(Map<String, dynamic> data) {
    return WoundTypeModel(
      id: data['ID'] as String,
      title: data['WoundName'] as String,
      subtitle: data['WoundSubtitle'] as String,
      description: data['description'] as String,
      imageUrl: data['Woundpic'] as String,
    );
  }

  // Factory Constructor to create an addressModel from a DocumentSanpshot
  factory WoundTypeModel.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;

    return WoundTypeModel(
      id: snapshot.id,
      title: data['WoundName'] ?? '',
      subtitle: data['WoundSubtitle'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['Woundpic'] ?? '',
    );
  }
}
