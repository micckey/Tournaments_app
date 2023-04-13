import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karateclash/configurations/colors.dart';
import 'package:karateclash/configurations/customWidgets.dart';
import 'package:karateclash/models/tournamentsmodel.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final Tournament _tournament;
  final uid = Get.arguments[1];
  final rank = Get.arguments[2];
  final List<String> championship = ['Kata', 'Kumite', 'Both'];
  String? selectedValue;

  Future<String> getChampionship(String val) async {
    if (val == 'Kata') {
      return _tournament.kata;
    } else if (val == 'Kumite') {
      return _tournament.kumite;
    } else if (val == 'Both') {
      return _tournament.both;
    } else {
      return 'Select a Championship!!';
    }
  }

  String getCategory(String val) {
    if (val == '10th KYU' ||
        val == '9th KYU' ||
        val == '8th KYU' ||
        val == '7th KYU' ||
        val == '6th KYU' ||
        val == '5th KYU' ||
        val == '4th KYU') {
      return 'Novice';
    } else {
      return 'Senior';
    }
  }

  Future<void> sendPayment() async {
    String karatekaId = uid;
    String tournamentId = _tournament.id;
    String category = getCategory(rank);
    String championship = selectedValue ?? '';

    Uri url = Uri.parse('https://owen.kimworks.buzz/pay.php');
    var response = await http.post(url, body: {
      "Karateka_id": karatekaId,
      "Tournament_id": tournamentId,
      "Category": category,
      "Championship": championship
    });

    if (response.statusCode == 200) {
      // Payment successful, show a success message
      Get.snackbar('Payment Successful', 'See you in the TATAMI!',
          snackPosition: SnackPosition.TOP);
      // Get.to(() => DashboardScreen());
    } else {
      // Payment failed, show an error message
      Get.snackbar('Payment Failed',
          'There was an error processing your payment,\n Try again in a moment.',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  void initState() {
    super.initState();
    _tournament = Get.arguments[0] as Tournament;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tournament.name,
            style: const TextStyle(
                fontSize: 25,
                fontFamily: 'Eczar',
                fontWeight: FontWeight.w800)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Card(
            color: CustomColors().mainColor,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(70),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  myTextWidget('Organizers: ${_tournament.organizers}', 16.0),
                  const SizedBox(height: 10),
                  myTextWidget('Location: ${_tournament.location}', 16.0),
                  const SizedBox(height: 10),
                  myTextWidget('Organizers: ${_tournament.organizers}', 16.0),
                  const SizedBox(height: 10),
                  myTextWidget('Date: ${_tournament.date.toString()}', 16.0),
                  const SizedBox(height: 10),
                  myTextWidget('Kata price: ${_tournament.kata}', 16.0),
                  const SizedBox(height: 10),
                  myTextWidget('Kumite price: ${_tournament.kumite}', 16.0),
                  const SizedBox(height: 10),
                  myTextWidget(
                      'Kata & Kumite price: ${_tournament.both}', 16.0),
                  const SizedBox(height: 20),
                  DropdownButtonFormField2(
                    decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    isExpanded: true,
                    hint: const Text(
                      'Select a Championship to participate in',
                      style: TextStyle(fontSize: 14, fontFamily: 'Eczar'),
                    ),
                    items: championship
                        .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(fontSize: 14),
                            )))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select championship!!';
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
                            thumbVisibility: MaterialStateProperty.all(true))),
                  ),
                  const SizedBox(height: 20),
                  myTextWidget('TOTAL AMOUNT DUE:', 15.0),
                  FutureBuilder<String>(
                    future: getChampionship(selectedValue ?? ''),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return myTextWidget(snapshot.data!, 20.0);
                      } else if (snapshot.hasError) {
                        return myTextWidget('Error: ${snapshot.error}', 20.0);
                      } else {
                        return myTextWidget('Select Championship', 20.0);
                      }
                    },
                  ),
                  myButtonWidget2('PROCEED TO PAYMENT', () {
                    Get.defaultDialog(
                      backgroundColor: CustomColors().mainColor,
                      title: "Make Payments",
                      middleText:
                          "Are you sure you want register for this tournament",
                      textConfirm: "Yes",
                      onConfirm: () {
                        sendPayment();
                        Get.back();
                      },
                      textCancel: "Cancel",
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
