import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:transport_app/presentation/home.dart';

class LanguageDropdown extends StatefulWidget {
  final VoidCallback? onLanguageChanged;

  const LanguageDropdown({Key? key, this.onLanguageChanged}) : super(key: key);

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    return DropdownButton<Locale>(
      value: context.locale,
      onChanged: (locale) {
        if (locale != null) {
          setState(() {
            context.setLocale(locale);
            widget.onLanguageChanged?.call();
            // Home.homeKey.currentState?.rebuild();
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) => Home(),
            //   ),
            // );
          });
        }
      },
      items: context.supportedLocales.map(
        (Locale locale) {
          return DropdownMenuItem<Locale>(
            value: locale,
            child: Text(_getLanguageName(locale.languageCode)),
          );
        },
      ).toList(),
    );
  }

  String _getLanguageName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'am':
        return 'አማርኛ';
      case 'or':
        return 'Oromo';
      default:
        return '';
    }
  }
}
