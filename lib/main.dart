import 'package:flutter/material.dart';
import 'package:nfc/screens/NfcHomePage.dart';
import 'core/app_theme.dart';

void main() {
  runApp(const NfcReaderApp());
}

/// Main application widget
class NfcReaderApp extends StatelessWidget {
  const NfcReaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NFC Reader',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const NfcHomePage(),
    );
  }
}
