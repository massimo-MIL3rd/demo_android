import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class EditShopModel extends ChangeNotifier {
  EditShopModel(this.name, this.message) {
    nameController.text = name!;
    messageController.text = message!;
  }

  final nameController = TextEditingController();
  final messageController = TextEditingController();

  String? name;
  String? message;

  void setName(String name) {
    this.name = name;
    notifyListeners();
  }

  void setMessage(String message) {
    this.message = message;
    notifyListeners();
  }

  bool isUpdated() {
    return name != null || message != null;
  }

  Future update() async {
    this.name = nameController.text;
    this.message = messageController.text;

    // firestoreに追加
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'message': message,
    });
  }
}
