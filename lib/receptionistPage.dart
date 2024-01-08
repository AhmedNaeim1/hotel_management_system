// admin stateless widget with a button to Create staff accounts, get all employees, get certain enployee by id and delete an enployee

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hotel_management_system/constants.dart';
import 'package:http/http.dart' as http;

class ReceptionistPage extends StatefulWidget {
  const ReceptionistPage({Key? key}) : super(key: key);

  @override
  State<ReceptionistPage> createState() => _ReceptionistPageState();
}

class _ReceptionistPageState extends State<ReceptionistPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController roomIDController = TextEditingController();
    final TextEditingController customerIdController = TextEditingController();
    final TextEditingController nameController = TextEditingController();

    final TextEditingController checkInDateController = TextEditingController();
    final TextEditingController checkOutDateController =
        TextEditingController();

    String responseText = '';

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //receptionist button
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Create Booking'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          // Room Section
                          TextField(
                            controller: roomIDController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Room ID',
                            ),
                            onChanged: (String value) {
                              roomIDController.text = value;
                            },
                          ),

                          const SizedBox(height: 10),
                          // Customer Section
                          TextField(
                            controller: customerIdController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Customer ID',
                            ),
                            onChanged: (String value) {
                              customerIdController.text = value;
                            },
                          ),
                          const SizedBox(height: 10),
                          // Booking Dates
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: checkInDateController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Check-In Date',
                                  ),
                                  onChanged: (String value) {
                                    checkInDateController.text = value;
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: checkOutDateController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Check-Out Date',
                                  ),
                                  onChanged: (String value) {
                                    checkOutDateController.text = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            // Perform the post request to create a booking
                            final response = await http.post(
                              Uri.parse('$apiUrl/receptionists/bookRoom'),
                              headers: <String, String>{
                                'Content-Type': 'application/json',
                              },
                              body: jsonEncode(
                                {
                                  "roomID": int.parse(roomIDController.text),
                                  "customerID":
                                      int.parse(customerIdController.text),
                                  "checkInDate": checkInDateController.text,
                                  "checkOutDate": checkOutDateController.text,
                                },
                              ),
                            );

                            if (response.statusCode == 200) {
                              // Successful response, print the result
                              print("API Response: ${response.body}");
                            } else {
                              // Error response, print the status code
                              print("API Error: ${response.statusCode}");
                            }

                            Navigator.pop(context);
                          },
                          child: const Text('Create'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: const Icon(Icons.book),
              label: const Text('Create Booking'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(200, 50),
              ),
            ),
            const SizedBox(height: 10),
            //receptionist button
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return AlertDialog(
                          title: const Text('Get bookings By RoomId'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Room Id',
                                ),
                                onChanged: (String value) {
                                  nameController.text = value;
                                },
                              ),
                              const SizedBox(height: 10),
                              // Display the response below the button
                              Text('Response: $responseText'),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                print(nameController.text);
                                final response = await http.get(
                                  Uri.parse(
                                      '$apiUrl/receptionists/getBookings/${nameController.text}'),
                                );
                                if (response.statusCode == 200) {
                                  // Successful response, print the result
                                  print("API Response: ${response.body}");
                                  setState(() {
                                    responseText = response.body;
                                  });
                                } else {
                                  print(
                                      'Failed to get staff. Status code: ${response.statusCode}');
                                  print('Response body: ${response.body}');
                                }
                              },
                              child: const Text('Get'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Get bookings By RoomId'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(200, 50),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (BuildContext context, setState) {
                        return AlertDialog(
                          title: const Text('Get Room Availability By Id'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Room Id',
                                ),
                                onChanged: (String value) {
                                  nameController.text = value;
                                },
                              ),
                              const SizedBox(height: 10),
                              // Display the response below the button
                              Text('Response: $responseText'),
                            ],
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                print(nameController.text);
                                final response = await http.get(
                                  Uri.parse(
                                      '$apiUrl/receptionists/getRoom/${nameController.text}'),
                                );
                                if (response.statusCode == 200) {
                                  // Successful response, print the result
                                  print("API Response: ${response.body}");
                                  setState(() {
                                    responseText = response.body;
                                  });
                                } else {
                                  print(
                                      'Failed to get staff. Status code: ${response.statusCode}');
                                  print('Response body: ${response.body}');
                                }
                              },
                              child: const Text('Get'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Get Room Availability By RoomId'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(200, 50),
              ),
            ),
            const SizedBox(height: 10),

            ElevatedButton.icon(
              onPressed: () async {
                // Perform a get request to get all staff
                final response = await http.get(
                  Uri.parse('$apiUrl/receptionists/getBookings'),
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
                                    title: Text("Room: " +
                                        staffList[index]["room"].toString()),
                                    subtitle: Text("Customer: " +
                                        staffList[index]["customer"]
                                            .toString()));
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
              label: const Text('Report on bookings'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(200, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
