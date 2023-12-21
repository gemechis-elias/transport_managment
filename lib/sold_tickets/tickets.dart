import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/core/my_colors.dart';
import 'package:transport_app/models/ticket.dart';
import 'dart:convert';

import '../result/ticket_result.dart';

class SoldTickets extends StatefulWidget {
  const SoldTickets({Key? key});

  @override
  SoldTicketsState createState() => SoldTicketsState();
}

class SoldTicketsState extends State<SoldTickets> {
  List<Ticket> _ticketList = [];
  List<Ticket> _filteredTicket = [];

  @override
  void initState() {
    super.initState();
    _loadBusList();
  }

  Future<void> _loadBusList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userJson = prefs.getString('user_registration') ?? '[]';
    List<dynamic> userData = json.decode(userJson);
    List<Ticket> users = userData.map((data) => Ticket.fromJson(data)).toList();
    // reverse the list to show the latest user first
    users = users.reversed.toList();

    setState(() {
      _ticketList = users;
      _filteredTicket = users; // Initialize filtered list with all users
    });
  }

  void _filterUsers(String searchText) {
    setState(() {
      _filteredTicket = _ticketList
          .where((user) =>
              user.tailure.toLowerCase().contains(searchText.toLowerCase()) ||
              user.plate.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sold tickets'),
        actions: [
          SizedBox(
            width: 110,
            height: 40,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: MyColors.primary, elevation: 0),
              child: const Text(
                "Upload",
                style:  TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontFamily: 'Poppins-Regular',
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () async {},
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar with a button to search for a specific user
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged:
                  _filterUsers, // Call _filterUsers method on text change
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search a User',
              ),
            ),
          ),

          Expanded(
            child: _filteredTicket.isEmpty
                ? const Center(child: Text('No matching users found.'))
                : ListView.builder(
                    itemCount: _filteredTicket.length,
                    itemBuilder: (context, index) {
                      Ticket ticket = _filteredTicket[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultPage(
                                ticket: ticket,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          child: ListTile(
                            title: Text('Name: ${ticket.tailure}'),

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
