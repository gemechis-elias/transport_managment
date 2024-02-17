import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transport_app/bloc/data_bloc.dart';
import 'package:transport_app/bloc/login%20bloc/login_state.dart';
import 'package:transport_app/bloc/registration%20bloc/register_bloc.dart';
import 'package:transport_app/bloc/registration%20bloc/register_state.dart';
import 'package:transport_app/bloc/upload/upload_bloc.dart';
import 'package:transport_app/bloc/upload/upload_state.dart';
import 'package:transport_app/presentation/auth/login_page.dart';
import 'package:transport_app/presentation/auth/pinScreen.dart';
import 'package:transport_app/data/bus_data.dart';
import 'package:transport_app/models/bus.dart';
import 'package:transport_app/models/queue_model.dart';
import 'package:transport_app/services/fetch_data.dart';
import 'package:transport_app/services/loginService.dart';

import 'bloc/login bloc/login_bloc.dart';
import 'presentation/home.dart';
import 'presentation/splash/splash_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

const vehiclesList = 'vehicle_list';
const tokenHive = 'token';
const pin_code = 'pin';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<String>(tokenHive);
  await Hive.openBox<String>(pin_code);
  WidgetsFlutterBinding.ensureInitialized();

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', "US"),
        Locale('am', 'ET'),
        Locale('or', 'ET')
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DataBloc>(
          create: (context) => DataBloc(DataService()),
        ),
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(UserInitial()),
        ),
        BlocProvider<UserRgistrationBloc>(
          create: (context) => UserRgistrationBloc(RegisterUserInitial()),
        ),
        BlocProvider<UploadBloc>(
          create: (context) => UploadBloc(UploadInitial()),
        ),
      ],
      // create: (context) => DataBloc(DataService()),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Transport App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 58, 183, 110)),
          useMaterial3: true,
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        home: FutureBuilder<Box<String>>(
          future: Hive.openBox<String>(tokenHive),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final tokenBox = snapshot.data!;
                final String? accessToken = tokenBox.get('token');
                final String? pin = Hive.box<String>(pin_code).get('pin');

                tokenBox.close();

                return (accessToken?.isNotEmpty == true &&
                        pin?.isNotEmpty == true)
                    ? const Pininput()
                    : const LoginPage();
              }
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<SharedPreferences>(
//       future: SharedPreferences.getInstance(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Return loading widget while SharedPreferences is being fetched
//           return const CircularProgressIndicator();
//         } else if (snapshot.hasError) {
//           // Handle error if SharedPreferences cannot be fetched
//           return Center(child: Text('Error: ${snapshot.error}'));
//         } else {
//           // Check if 'auth_token' exists in SharedPreferences
//           final prefs = snapshot.data!;
//           final accessToken = prefs.getString('access_token');
//           final pin = prefs.getString('pin');
//           final DataService dataService = DataService();

//           return BlocProvider(
//             create: (context) => DataBloc(dataService),
//             child: MaterialApp(
//               debugShowCheckedModeBanner: false,
//               title: 'Transport App',
//               theme: ThemeData(
//                 colorScheme: ColorScheme.fromSeed(
//                     seedColor: const Color.fromARGB(255, 58, 183, 110)),
//                 useMaterial3: true,
//               ),
//               localizationsDelegates: context.localizationDelegates,
//               supportedLocales: context.supportedLocales,
//               locale: context.locale,
//               home: (accessToken?.isNotEmpty == true && pin?.isNotEmpty == true)
//                   ? const Pininput()
//                   : const LoginPage(),
//             ),
//           );
//         }
//       },
//     );
//   }
// }
