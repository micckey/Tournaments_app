import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karateclash/authentication/login.dart';
import 'package:karateclash/configurations/colors.dart';
import 'package:karateclash/configurations/customWidgets.dart';
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String dropdownvalue = 'Grade';
  final List<String> ranks = [
    '10th KYU',
    '9th KYU',
    '8th KYU',
    '7th KYU',
    '6th KYU',
    '5th KYU',
    '4th KYU',
    '3rd KYU BROWN BELT',
    '2nd KYU BROWN BELT',
    '1st KYU BROWN BELT',
    '1st DAN BLACK BELT',
    '2nd DAN BLACK BELT',
    '3rd DAN BLACK BELT',
    '4th DAN BLACK BELT',
    '5th DAN BLACK BELT'
  ];
  String? selectedValue;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController clubController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool validateFields() {
    if (nameController.text.isEmpty ||
        userNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        clubController.text.isEmpty ||
        selectedValue == null ||
        ageController.text.isEmpty ||
        weightController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all the fields',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  Future<void> register() async {
    if (!validateFields()) {
      return;
    }

    const String url = 'https://owen.kimworks.buzz/create.php';
    final Map<String, String> data = {
      'Full_name': nameController.text,
      'Username': userNameController.text,
      'Email': emailController.text,
      'Club': clubController.text,
      'Rank': selectedValue ?? '',
      'Age': ageController.text,
      'Weight': weightController.text,
      'Password': passwordController.text,
    };
    final response = await http.post(Uri.parse(url), body: data);
    if (response.statusCode == 200) {
      // User created successfully
      Get.snackbar(
          'SUCCESS', 'Successfully created an account,\n proceed to Log In',
          snackPosition: SnackPosition.TOP);
      Get.to(() => LoginScreen());
    } else {
      Get.snackbar(
          'ERROR', 'An unexpected Error Occured! \n Try again in a moment.',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors().mainColor,
      body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
            child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Card(
                    color: CustomColors().mainColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 10),
                      child: Column(
                        children: [
                          // ],))
                          myTextField('Full Name', nameController),
                          const SizedBox(height: 20),
                          myTextField('Username', userNameController),
                          const SizedBox(height: 20),
                          myTextField('Email', emailController),
                          const SizedBox(height: 20),
                          myTextField('Club', clubController),
                          const SizedBox(height: 20),
                          DropdownButtonFormField2(
                            decoration: InputDecoration(
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            isExpanded: true,
                            hint: const Text(
                              'Select Your Rank',
                              style:
                                  TextStyle(fontSize: 14, fontFamily: 'Eczar'),
                            ),
                            items: ranks
                                .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(fontSize: 14),
                                    )))
                                .toList(),
                            validator: (value) {
                              if (value == null) {
                                return 'Please select rank!!';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                selectedValue = value.toString();
                              });
                            },
                            onSaved: (value) {
                              selectedValue = value.toString();
                            },
                            buttonStyleData: const ButtonStyleData(
                              height: 60,
                            ),
                            iconStyleData: const IconStyleData(
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black45,
                                ),
                                iconSize: 30),
                            dropdownStyleData: DropdownStyleData(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10)),
                                maxHeight: 200,
                                padding: null,
                                elevation: 8,
                                scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness: MaterialStateProperty.all(6),
                                    thumbVisibility:
                                        MaterialStateProperty.all(true))),
                          ),
                          const SizedBox(height: 20),
                          myTextField('Age', ageController),
                          const SizedBox(height: 20),
                          myTextField('Weight', weightController),
                          const SizedBox(height: 20),
                          TextField(
                            controller: passwordController,
                            textAlign: TextAlign.center,
                            obscureText: true,
                            decoration: InputDecoration(
                                suffixIcon: const Icon(Icons.remove_red_eye),
                                iconColor: Colors.limeAccent[400],
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                labelText: 'Password',
                                labelStyle: const TextStyle(
                                  fontFamily: 'Eczar',
                                )),
                          ),
                          // myButtonWidget('Create Account', () {
                          //   register();
                          // }),
                        ],
                      ),
                    )),
                const SizedBox(height: 20),
                myButtonWidget('Create Account', () {
                  register();
                }),
              ],
            ),
          ),
        )),
      ]),
    );
  }
}
