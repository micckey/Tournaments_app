import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:karateclash/models/usermodel.dart';
import 'package:karateclash/views/dashboard.dart';
import 'dart:convert';

class UserController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> loginClicked() async {
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar('Login Failed', 'Please enter username and password',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final url = Uri.parse('https://owen.kimworks.buzz/login.php');
    final response = await http.post(url, body: {
      'Username': username,
      'Password': password,
    });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      if (jsonData != '0 results') {
        final karateka = Karateka.fromJson(jsonData);
        Get.off(() => DashboardScreen(karateka: karateka));
      } else {
        Get.snackbar('Login Failed', 'Invalid username or password',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      Get.snackbar('Error', 'Failed to login',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
