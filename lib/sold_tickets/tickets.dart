import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/models/user.dart';
import 'dart:convert';

import '../tickets_result.dart/result.dart';

class SoldTickets extends StatefulWidget {
  const SoldTickets({Key? key});

  @override
  SoldTicketsState createState() => SoldTicketsState();
}

class SoldTicketsState extends State<SoldTickets> {
  List<User> _userList = [];
  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _loadBusList();
  }

  Future<void> _loadBusList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = prefs.getString('user_registration') ?? '[]';
    List<dynamic> userData = json.decode(userJson);
    List<User> users = userData.map((data) => User.fromJson(data)).toList();
    // reverse the list to show the latest user first
    users = users.reversed.toList();

    setState(() {
      _userList = users;
      _filteredUsers = users; // Initialize filtered list with all users
    });
  }

  void _filterUsers(String searchText) {
    setState(() {
      _filteredUsers = _userList
          .where((user) =>
              user.firstName.toLowerCase().contains(searchText.toLowerCase()) ||
              user.lastName.toLowerCase().contains(searchText.toLowerCase()) ||
              user.busNumber.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sold tickets'),
      ),
      body: Column(
        children: [
          // Search bar with a button to search for a specific user
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged:
                  _filterUsers, // Call _filterUsers method on text change
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search a User',
              ),
            ),
          ),

          Expanded(
            child: _filteredUsers.isEmpty
                ? Center(child: Text('No matching users found.'))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      User user = _filteredUsers[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultPage(
                                user: user,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          child: ListTile(
                            title: Text(
                                'Name: ${user.firstName} ${user.lastName}'),
                            subtitle: Text('Bus No: ${user.busNumber}'),
                            // Add more details here if needed
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
