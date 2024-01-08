// admin stateless widget with a button to Create staff accounts, get all employees, get certain enployee by id and delete an enployee

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    String responseText = '';
    String role = 'Manager';
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //admin button
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Create Staff Account'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Username',
                            ),
                            onChanged: (String value) {
                              nameController.text = value;
                            },
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Password',
                            ),
                            onChanged: (String value) {
                              passwordController.text = value;
                            },
                          ),
                          const SizedBox(height: 10),
                          StatefulBuilder(builder: (context, setState) {
                            return DropdownButton<String>(
                              value: role,
                              icon: const Icon(Icons.arrow_downward),
                              iconSize: 24,
                              elevation: 16,
                              style: const TextStyle(color: Colors.deepPurple),
                              onChanged: (String? newValue) {
                                setState(() {
                                  role = newValue!;
                                });
                              },
                              items: <String>[
                                'Manager',
                                'Receptionist'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                );
                              }).toList(),
                            );
                          }),
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
                            //get the response fron the api  and print it
                            print(nameController.text);
                            final response = await http.post(
                              Uri.parse('$apiUrl/admin/addEmployee'),
                              headers: <String, String>{
                                'Content-Type': 'application/json',
                              },
                              body: jsonEncode({
                                "name": nameController.text,
                                "password": passwordController.text.toString(),
                                "role": role,
                              }),
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
              icon: const Icon(Icons.admin_panel_settings),
              label: const Text('Create Staff'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size(200, 50),
              ),
            ),
            const SizedBox(height: 10),
            //receptionist button
            ElevatedButton.icon(
              onPressed: () async {
                // Perform a get request to get all staff
                final response = await http.get(
                  Uri.parse('$apiUrl/admin/getEmployees'),
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
                                  title: Text(staffList[index]['name']),
                                  subtitle: Text(staffList[index]['role']),
                                );
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
              label: const Text('Get All Staff'),
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
                          title: const Text('Get Staff By Id'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Staff Id',
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
                                //get the response fron the api  and print it
                                print(nameController.text);
                                final response = await http.get(
                                  Uri.parse(
                                      '$apiUrl/admin/getEmployee/${nameController.text}'),
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
              label: const Text('Get Staff By Id'),
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
                          title: const Text('Delete Staff By Id'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              TextField(
                                controller: nameController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Staff Id',
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
                                //get the response fron the api  and print it
                                print(nameController.text);
                                final response = await http.delete(Uri.parse(
                                    '$apiUrl/admin/employee/${nameController.text}'));
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
                              child: const Text('Delete'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              icon: const Icon(Icons.receipt_long),
              label: const Text('Delete Staff'),
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
