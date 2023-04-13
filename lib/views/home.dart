import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karateclash/authentication/login.dart';
import 'package:karateclash/configurations/colors.dart';
import 'package:karateclash/configurations/customWidgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors().mainColor,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                'assets/images/home.png',
                width: 500,
                height: 400,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(height: 10),
              myTextWidget('STEP INTO THE RING', 20.0),
              myTextWidget('WITH', 20.0),
              const Text(
                'KARATE CLASH',
                style: TextStyle(
                    fontSize: 35,
                    fontFamily: 'Eczar',
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 100),
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: getStarted,
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(CustomColors().colorAO),
                      foregroundColor:
                          MaterialStateProperty.all(CustomColors().textColor),
                      overlayColor:
                          MaterialStateProperty.all(CustomColors().colorAKA),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'GET STARTED',
                        style: TextStyle(
                            fontFamily: 'Eczar',
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.chevron_right_outlined,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      )),
    );
  }
}

void getStarted() {
  Get.to(() => LoginScreen());
}
