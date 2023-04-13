import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:karateclash/authentication/login.dart';
import 'package:karateclash/configurations/colors.dart';
import 'package:karateclash/configurations/customWidgets.dart';
import 'package:karateclash/models/tournamentsmodel.dart';
import 'package:karateclash/models/usermodel.dart';
import 'package:http/http.dart' as http;
import 'package:karateclash/views/history.dart';
import 'package:karateclash/views/pay.dart';

class DashboardScreen extends StatefulWidget {
  final Karateka karateka;

  const DashboardScreen({Key? key, required this.karateka}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Tournament> _tournaments = [];

  final http.Client httpClient = http.Client();

  Future<void> _fetchTournaments() async {
    try {
      final response =
          await http.get(Uri.parse('https://owen.kimworks.buzz/read.php'));

      if (response.statusCode == 200) {
        // print(response.body);
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _tournaments = data.map((e) => Tournament.fromJson(e)).toList();
        });
      } else {
        Get.snackbar('ERROR!!', 'Failed to load tournaments',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occured',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTournaments();
  }

  void _showClubDialog() {
    TextEditingController clubController = TextEditingController();
    clubController.text = widget.karateka.club;

    Get.dialog(
      AlertDialog(
        backgroundColor: CustomColors().mainColor,
        title: const Text("Update Club Information"),
        content: TextField(
          controller: clubController,
          decoration: const InputDecoration(
            hintText: "Enter your new club",
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("CANCEL"),
            onPressed: () {
              Get.back();
            },
          ),
          TextButton(
            child: const Text("UPDATE"),
            onPressed: () {
              _updateClub(clubController.text);
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _updateClub(String newClub) async {
    var url = Uri.parse('https://owen.kimworks.buzz/update.php');
    var response = await http.post(url, body: {
      'ID': widget.karateka.email,
      'Club': newClub,
    });

    if (response.statusCode == 200) {
      setState(() {
        widget.karateka.club = newClub;
      });
    } else {
      Get.snackbar('ERROR!!', 'Failed to update your club info',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> _deleteClub() async {
    var url = Uri.parse('https://owen.kimworks.buzz/delete.php');
    var response = await http.post(url, body: {
      'ID': widget.karateka.email,
    });

    if (response.statusCode == 200) {
      // Update the user object with the new club information
      setState(() {
        widget.karateka.club = '';
        Get.snackbar('SUCCESS', 'Successfully Deleted your account',
            snackPosition: SnackPosition.TOP);
        Get.to(LoginScreen());
      });
    } else {
      Get.snackbar('ERROR!!', 'Failed to delete your account',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.off(() => LoginScreen());
        return true;
      },
      child: Scaffold(
        // appBar: AppBar(title: const Text('Dashboard')),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Card(
              color: CustomColors().mainColor,
              margin: const EdgeInsets.all(10),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Welcome, ${widget.karateka.fullname}',
                              style: const TextStyle(
                                fontFamily: 'Eczar',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                                onPressed: _showClubDialog,
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: _deleteClub,
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                        myTextWidget('Club: ${widget.karateka.club}', 16.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
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
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: (() {
                          Get.defaultDialog(
                            backgroundColor: CustomColors().mainColor,
                            title: "Logout",
                            middleText: "Are you sure you want to log out?",
                            confirm: TextButton(
                              onPressed: () {
                                Get.to(LoginScreen());
                              },
                              child: const Text('Yes'),
                            ),
                            cancel: TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text('No'),
                            ),
                          );
                        }),
                        icon: Icon(
                          Icons.arrow_circle_left_outlined,
                          color: CustomColors().colorAO,
                          size: 45,
                        )),
                    myButtonWidget('VIEW HISTORY', () {
                      Get.to(const HistoryScreen(),
                          arguments: [widget.karateka.id, _tournaments]);
                    })
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: _tournaments.isNotEmpty
                      ? ListView.builder(
                          itemCount: _tournaments.length,
                          itemBuilder: (context, index) {
                            final tournament = _tournaments[index];
                            return Card(
                              color: CustomColors().mainColor,
                              margin: const EdgeInsets.all(10),
                              child: ListTile(
                                title: myTextWidget(tournament.name, 18.0),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    myTextWidget(
                                        'Organizers: ${tournament.organizers}',
                                        16.0),
                                    myTextWidget(
                                        'Location: ${tournament.location}',
                                        16.0),
                                    myTextWidget(
                                        'Date: ${tournament.date}', 16.0),
                                    myTextWidget(
                                        'Kata price: ${tournament.kata}', 16.0),
                                    myTextWidget(
                                        'Kumite price: ${tournament.kumite}',
                                        16.0),
                                    myTextWidget(
                                        'Kata & Kumite price: ${tournament.both}',
                                        16.0),
                                    IconButton(
                                        onPressed: (() {
                                          Get.to(const PaymentScreen(),
                                              arguments: [
                                                tournament,
                                                widget.karateka.id,
                                                widget.karateka.rank
                                              ]);
                                        }),
                                        icon: Icon(
                                          Icons
                                              .keyboard_double_arrow_right_outlined,
                                          color: CustomColors().colorAO,
                                          size: 50,
                                        ))
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
