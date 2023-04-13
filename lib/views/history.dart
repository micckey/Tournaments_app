import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:karateclash/configurations/colors.dart';
import 'package:karateclash/configurations/customWidgets.dart';
import 'package:karateclash/models/historymodel.dart';
import 'package:karateclash/models/tournamentsmodel.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final karatekaID = Get.arguments[0];
  late final List<Tournament> _tournaments = Get.arguments[1];

  List<History> _history = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final response = await http.post(
        Uri.parse('https://owen.kimworks.buzz/history.php'),
        body: {'ID': karatekaID},
      );
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _history = data.map((json) => History.fromJson(json)).toList();
      });
    } catch (e) {
      Get.snackbar('Error', 'Error Loading History',
          snackPosition: SnackPosition.TOP);
    }
  }

  Future<void> _deleteRecord(val) async {
    try {
      final response = await http.post(
        Uri.parse('https://owen.kimworks.buzz/deletetourn.php'),
        body: {'ID': val},
      );

      if (response.statusCode == 200) {
        setState(() {
          _fetchHistory();
          Get.snackbar('Tournament Cancelled Successfully!',
              'You will receive your refund in 24hrs',
              snackPosition: SnackPosition.TOP);
        });
      } else {
        Get.snackbar('Error', 'Failed to Cancel Tournament.',
            snackPosition: SnackPosition.TOP);
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexcpected error occurred!!',
          snackPosition: SnackPosition.TOP);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'History',
          style: TextStyle(
            fontFamily: 'Eczar',
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _history.isNotEmpty
              ? ListView.builder(
                  itemCount: _history.length,
                  itemBuilder: (BuildContext context, int index) {
                    final history = _history[index];
                    for (final tournament in _tournaments) {
                      if (tournament.id == history.tournamentID) {
                        return Card(
                          color: CustomColors().mainColor,
                          margin: const EdgeInsets.all(10),
                          child: ListTile(
                            title: myTextWidget(tournament.name, 18.0),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                myTextWidget(
                                    'Location: ${tournament.location}', 16.0),
                                myTextWidget('Date: ${tournament.date}', 16.0),
                                myTextWidget(
                                    'Category: ${history.category}', 16.0),
                                myTextWidget(
                                    'Championship: ${history.championship}',
                                    16.0),
                                myButtonWidget2('CANCEL', () {
                                  Get.defaultDialog(
                                    backgroundColor: CustomColors().mainColor,
                                    title: "CANCEL TOURNAMENT",
                                    middleText:
                                        "Are you sure you want to cancel this tournament?",
                                    textConfirm: "Yes",
                                    onConfirm: () {
                                      _deleteRecord(history.id);
                                      Get.back();
                                    },
                                    textCancel: "Cancel",
                                  );
                                })
                              ],
                            ),
                          ),
                        );
                      }
                    }
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ],
      ),
    );
  }
}
