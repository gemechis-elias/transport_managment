import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/bloc/upload/upload_bloc.dart';
import 'package:transport_app/bloc/upload/upload_event.dart';
import 'package:transport_app/bloc/upload/upload_state.dart';
import 'package:transport_app/core/my_colors.dart';
import 'package:transport_app/models/report.dart';
import 'package:transport_app/models/ticket.dart';
import 'package:transport_app/presentation/home.dart';
import 'package:transport_app/services/report_upload.dart';
import 'dart:convert';

import '../result/ticket_result.dart';

class SoldTickets extends StatefulWidget {
  const SoldTickets({Key? key});

  @override
  SoldTicketsState createState() => SoldTicketsState();
}

class SoldTicketsState extends State<SoldTickets> {
  List<ReportModel> _reportList = [];
  List<ReportModel> _filteredReport = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReportList();
  }

  // Future<void> _loadBusList() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String userJson = prefs.getString('user_registration') ?? '[]';
  //   List<dynamic> userData = json.decode(userJson);
  //   List<Ticket> users = userData.map((data) => Ticket.fromJson(data)).toList();
  //   // reverse the list to show the latest user first
  //   users = users.reversed.toList();

  //   setState(() {
  //     _ticketList = users;
  //     _filteredTicket = users; // Initialize filtered list with all users
  //   });
  // }
  Future<void> _loadReportList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> reportJsonList = prefs.getStringList('reports') ?? [];
    List<ReportModel> reports = reportJsonList
        .map((data) => ReportModel.fromJson(json.decode(data)))
        .toList();
    reports = reports.reversed.toList();

    setState(() {
      _reportList = reports;
      _filteredReport = reports;
    });
  }

  void _filterReport(String searchText) {
    setState(() {
      _filteredReport = _reportList
          .where((report) =>
              report.name.toLowerCase().contains(searchText.toLowerCase()) ||
              report.plate.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    });
  }

  void _removeReportFromLocal(ReportModel report) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the report from the list
    _reportList.remove(report);

    // Save the updated list to SharedPreferences
    await prefs.setString('reports',
        json.encode(_reportList.map((bus) => bus.toJson()).toList()));

    // Refresh the UI
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UploadBloc, UploadState>(
      listener: (context, state) {
        if (state is UploadedReportState) {
          setState(() {
            _isLoading = false;
          });
          // Navigate to Home page on successful login
          // Navigator.pushReplacement(
          //   context,
          //   MaterialPageRoute(builder: (context) => Home()),
          // );
        } else if (state is UploadLoading) {
          setState(() {
            _isLoading = true;
          });
        } else if (state is UploadError) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title:  Text(
              'Sold tickets'.tr(),
              style: const TextStyle(
                fontSize: 18,
                fontFamily: 'Poppins-Regular',
              ),
            ),
            actions: [
              SizedBox(
                width: 110,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primary, elevation: 0),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          "Upload".tr(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontFamily: 'Poppins-Regular',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  onPressed: () async {
                    // ReportService reportService = ReportService();
                    for (ReportModel report in _reportList) {
                      BlocProvider.of<UploadBloc>(context)
                          .add(UploadReportEvent(report: report));
                      // bool isUploaded = await reportService.upload(report);

                      _removeReportFromLocal(report);
                    }
                  },
                ),
              ),
              const SizedBox(
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
                      _filterReport, // Call _filterUsers method on text change
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Search a Report',
                  ),
                ),
              ),

              Expanded(
                child: _filteredReport.isEmpty
                    ? const Center(child: Text('No sold tickets found.'))
                    : ListView.builder(
                        itemCount: _filteredReport.length,
                        itemBuilder: (context, index) {
                          ReportModel report = _filteredReport[index];
                          return Container(
                            child: ListTile(
                              title: Text('Name: ${report.name}'),
                              subtitle: Text('Plate: ${report.plate}'),
                              trailing: Text('date: ${report.date}'),

                              // Add more details here if needed
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
