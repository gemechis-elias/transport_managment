import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transport_app/bloc/data_bloc.dart';
import 'package:transport_app/bloc/data_event.dart';
import 'package:transport_app/bloc/data_state.dart';
import 'package:transport_app/core/my_text.dart';
import 'package:transport_app/presentation/widgets/home_shimmer.dart';
import 'package:transport_app/presentation/widgets/language_dropdowns.dart';
import '../core/my_colors.dart';
import 'buy_tickets/buy_ticket.dart';
import 'widgets/enddrawer.dart';
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
      'title': 'Generate ticket',
      'image': 'assets/images/passenger.jpg',
    },
    {
      'title': 'Bus queue',
      'image': 'assets/images/bus.png',
    },
    {
      'title': 'sold tickets',
      'image': 'assets/images/tickets.jpg',
    },
  ];

  late PageController _pageController;
  late Timer _timer;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // context.read<DataBloc>().add(LoadDataEvent());
    // BlocProvider.of<DataBloc>(context).add(GetAllDataEvent());
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<_HomeState> homeKey = GlobalKey<_HomeState>();

  void onDrawerItemClicked(String name) {
    Navigator.pop(context);
  }

  void rebuild() {
    setState(() {});
  }

  void _showSnackbar(String message, Color bgcolor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
        backgroundColor: bgcolor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = context.locale;
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xffF8FAFF),
        appBar: AppBar(
          backgroundColor: MyColors.primary,
          leading: IconButton(
            icon: const Icon(
              Icons.sort,
              color: Colors.white,
              size: 37,
            ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          title: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Text(
              "Transport".tr(),
              style: const TextStyle(
                fontFamily: 'Poppins-Regular',
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: [
            LanguageDropdown(onLanguageChanged: () {
              homeKey.currentState?.setState(() {});
              rebuild();
            }),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Text(
                  'Services'.tr(),
                  style: const TextStyle(
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
                        builder: (context) => BuyTicket(), //
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
                                "${data_list[0]['title']}".tr(),
                                maxLines: 4,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Poppins-Regular',
                                ),
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
                                "${data_list[1]['title']}".tr(),
                                maxLines: 4,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Poppins-Regular',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ), // Card 3
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
                                "${data_list[2]['title']}".tr(),
                                maxLines: 4,
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontFamily: 'Poppins-Regular',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
              ),
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.primary, elevation: 0),
                    child: _isRefreshing
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : BlocConsumer<DataBloc, DataState>(
                            listener: (context, state) {
                              if (state is DataErrorState) {
                                _showSnackbar('Failed to refresh!', Colors.red);
                              } else if (state is DataLoadedState) {
                                _showSnackbar('Successfully refreshed!',Colors.green);
                              }
                            },
                            builder: (context, state) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.refresh,
                                      color: Colors.white),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "Refresh".tr(),
                                    style: MyText.subhead(context)!
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              );
                            },
                          ),
                    onPressed: () {
                      print('refresh is pressed!!');
                      setState(() {
                        _isRefreshing = true;
                      });
                      Future.delayed(
                        const Duration(seconds: 3),
                        () {
                          setState(() {
                            _isRefreshing = false;

                            BlocProvider.of<DataBloc>(context)
                                .add(GetAllDataEvent());
                          });
                        },
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        drawer: EndDrawers(),
      ),
    );
  }
}
