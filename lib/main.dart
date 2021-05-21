import 'package:flutter/material.dart';
import 'theme/theme.dart';
import 'package:mac_dt/componentsOnOff.dart';
import 'package:provider/provider.dart';
import 'dart:html';

import 'desktop.dart';

void main() {
  document.documentElement.requestFullscreen();
  runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(ThemeNotifier.darkTheme),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: OnOff(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chrisbin\'s MacBook Pro',
        theme: themeNotifier.getTheme(),
        home: MyHomePage(),
      ),
    );
  }
}