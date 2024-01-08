// admin stateless widget with a button to Create staff accounts, get all employees, get certain enployee by id and delete an enployee

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({Key? key}) : super(key: key);

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //receptionist button
            ElevatedButton.icon(
              onPressed: () async {
                // Perform a get request to get all staff
                final response = await http.get(
                  Uri.parse('$apiUrl/manager/getBookings'),
                );

                if (response.statusCode == 200) {
                  List<dynamic> staffList = jsonDecode(response.body);

                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return DraggableScrollableSheet(
                        initialChildSize: 0.95,
                        builder: (BuildContext context,
                            ScrollController scrollController) {
                          return Container(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: staffList.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ListTile(
                                    title: Text("RoomID: " +
                                        staffList[index][0].toString()),
                                    subtitle: Text("Available: " +
                                        (staffList[index][1].toString() ==
                                                "true"
                                            ? "Yes"
                                            : "No")));
                              },
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  print(
                      'Failed to get staff. Status code: ${response.statusCode}');
                  print('Response body: ${response.body}');
                }
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Report on rooms'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(200, 50),
              ),
            ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
