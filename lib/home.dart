import 'dart:async';
import 'package:flutter/material.dart';
import 'package:transport_app/add_bus/add_bus.dart';

import 'buy_tickets/buy_ticket.dart';
import 'enddrawer.dart';
import 'queue/queue.dart';
import 'sold_tickets/tickets.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> data_list = [
    {
      'title': 'Register Passenger',
      'image': 'assets/images/passenger.jpg',
    },
    {
      'title': 'Bus Queue Management',
      'image': 'assets/images/bus.jpg',
    },
    {
      'title': 'See Tickets Sold',
      'image': 'assets/images/tickets.jpg',
    },
    {
      'title': 'Add Bus',
      'image': 'assets/images/add_bus.png',
    },
  ];

  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void onDrawerItemClicked(String name) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xffF8FAFF),
        appBar: AppBar(
          backgroundColor: const Color(0xffF8FAFF),
          leading: IconButton(
            icon: const Icon(
              Icons.sort,
              color: Colors.black,
              size: 37,
            ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: const Text(
                "Transport App",
                style: TextStyle(
                  fontFamily: 'Urbanist-Bold',
                  fontSize: 23,
                ),
              )),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              // SizedBox(
              //   height: 130,
              //   child: PageView(
              //     controller: _pageController,
              //     children: [
              //       SizedBox(
              //         width: MediaQuery.of(context).size.width,
              //         child: ClipRRect(
              //           child: Image.asset(
              //             'assets/images/slider 4.jpg',
              //             fit: BoxFit.cover,
              //             width: double.infinity,
              //             height: double.infinity,
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         width: MediaQuery.of(context).size.width,
              //         child: ClipRRect(
              //           child: Image.asset(
              //             'assets/images/slider 2.png.jpg',
              //             fit: BoxFit.cover,
              //             width: double.infinity,
              //             height: double.infinity,
              //           ),
              //         ),
              //       ),
              //       SizedBox(
              //         width: MediaQuery.of(context).size.width,
              //         child: ClipRRect(
              //           child: Image.asset(
              //             'assets/images/slider 4.jpg',
              //             fit: BoxFit.cover,
              //             width: double.infinity,
              //             height: double.infinity,
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Text(
                  'Services',
                  style: TextStyle(
                    fontFamily: 'Urbanist-Bold',
                    color: Color.fromARGB(215, 7, 39, 15),
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Card 1
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BuyTicket(), //
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(190, 196, 202, 0.2),
                          blurRadius: 14,
                          offset: Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Card(
                      surfaceTintColor: Colors.white,
                      margin: const EdgeInsets.all(0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 60,
                            child: Image.asset(data_list[0]['image']),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                // textAlign: TextAlign.left,
                                data_list[0]['title'].toUpperCase(),
                                maxLines: 4,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Urbanist-Regular"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Card 2
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusQueue(), //
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(190, 196, 202, 0.2),
                          blurRadius: 14,
                          offset: Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Card(
                      surfaceTintColor: Colors.white,
                      margin: const EdgeInsets.all(0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 60,
                            child: Image.asset(data_list[1]['image']),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                // textAlign: TextAlign.left,
                                data_list[1]['title'].toUpperCase(),
                                maxLines: 4,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Urbanist-Regular"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ), // Card 2
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SoldTickets(), //
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(190, 196, 202, 0.2),
                          blurRadius: 14,
                          offset: Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Card(
                      surfaceTintColor: Colors.white,
                      margin: const EdgeInsets.all(0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 60,
                            child: Image.asset(data_list[2]['image']),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                // textAlign: TextAlign.left,
                                data_list[2]['title'].toUpperCase(),
                                maxLines: 4,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Urbanist-Regular"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddBus(), //
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.12,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(190, 196, 202, 0.2),
                          blurRadius: 14,
                          offset: Offset(0, 9),
                        ),
                      ],
                    ),
                    child: Card(
                      surfaceTintColor: Colors.white,
                      margin: const EdgeInsets.all(0),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 60,
                            child: Image.asset(data_list[3]['image']),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                // textAlign: TextAlign.left,
                                data_list[3]['title'].toUpperCase(),
                                maxLines: 4,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontFamily: "Urbanist-Regular"),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        drawer: const EndDrawers(),
      ),
    );
  }
}
