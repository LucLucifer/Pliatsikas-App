import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '/pages/home_page.dart';
import '/theme/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('el', null);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Διαχείριση Παραγγελιών Πλιάτσικας',
      theme: AppTheme.lightTheme,
      // Add localization support
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Define supported locales
      supportedLocales: const [
        Locale('el', ''), // Greek
        Locale('en', ''), // English
      ],
      // Set default locale to Greek
      locale: const Locale('el', ''),
      home: const HomePage(),
    );
  }
}