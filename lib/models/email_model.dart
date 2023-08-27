// class EmailModel {
//   final String email;

//   EmailModel(this.email);
// }
import 'package:flutter/material.dart';

class AppData extends ChangeNotifier {
  String userEmail = ''; // Example state you want to manage

  void updateUserEmail(String newEmail) {
    userEmail = newEmail;
    notifyListeners(); // Notify listeners when the state changes
  }
}
