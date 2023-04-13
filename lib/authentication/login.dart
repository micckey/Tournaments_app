import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karateclash/authentication/registration.dart';
import 'package:karateclash/configurations/colors.dart';
import 'package:karateclash/configurations/customWidgets.dart';
import 'package:karateclash/controllers/userController.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final UserController controller = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                LayoutBuilder(builder:
                    (BuildContext context, BoxConstraints constraints) {
                  return Image.asset(
                    'assets/images/mainlogo.png',
                    width: constraints.maxWidth,
                    height: 300,
                    fit: BoxFit.fitWidth,
                  );
                }),
                myTextWidget(
                    '"KARATE NI SENTE NASHI" -O\'SENSEI FUNAKOSHI GICHIN',
                    20.0),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    color: CustomColors().mainColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          myTextField(
                              'username', controller.usernameController),
                          const SizedBox(height: 20),
                          TextField(
                            controller: controller.passwordController,
                            textAlign: TextAlign.center,
                            obscureText: true,
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.remove_red_eye),
                              iconColor: Colors.limeAccent[400],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'password',
                              labelStyle: const TextStyle(
                                fontFamily: 'Eczar',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                myButtonWidget('Login', controller.loginClicked),
                const SizedBox(height: 10),
                GestureDetector(
                  child: const Text('Forgot Password?'),
                  onTap: () {
                    print('Forgot Password');
                  },
                ),
                const SizedBox(height: 10),
                myButtonWidget('Sign Up', registerClicked),
                const SizedBox(height: 20),
              ],
            ),
          ),
        )),
      ]),
    );
  }
}

void registerClicked() {
  Get.to(() => const RegisterScreen());
}
