import 'dart:html' as html;
import 'dart:js';

// Lia Batlle

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mac_dt/components/wallpaper/wallpaper.dart';
import 'package:mac_dt/data/system_data.dart';
import 'package:mac_dt/data/system_data_CRUD.dart';
import 'package:mac_dt/system/folders/folders.dart';
import 'package:mac_dt/providers.dart';
import 'data/analytics.dart';
import 'firebase_options.dart';
import 'system/openApps.dart';
import 'theme/theme.dart';
import 'package:mac_dt/system/componentsOnOff.dart';
import 'package:provider/provider.dart';

import 'system/desktop.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  html.window.document.onContextMenu.listen((evt) => evt.preventDefault());


  ///Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);


  ///Hive
  await Hive.initFlutter();
  Hive.registerAdapter(SystemDataAdapter());
  Hive.registerAdapter(WallDataAdapter());
  Hive.registerAdapter(FolderPropsAdapter());

  await Hive.openBox<SystemData>('systemData');
  await Hive.openBox<FolderProps>('folders');


  runApp(ChangeNotifierProvider<ThemeNotifier>(
      create: (_) => ThemeNotifier(SystemDataCRUD.getTheme()),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OnOff>(
          create: (context) => OnOff(),
        ),
        ChangeNotifierProvider<DataBus>(
          create: (context) => DataBus(),
        ),
        ChangeNotifierProvider<Apps>(
          create: (context) => Apps(),
        ),
        ChangeNotifierProvider<Folders>(
          create: (context) => Folders(),
        ),
        ChangeNotifierProvider<AnalyticsService>(
          create: (context) => AnalyticsService(),
        ),
      ],
      child: Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lia\'s MacBook Pro',
      navigatorObservers: [
        Provider.of<AnalyticsService>(context, listen: false)
            .getAnalyticsObserver()
      ],
      theme: themeNotifier.getTheme(),
      home: MacOS(),
    );
  }
}


void fullscreenWorkaround(Element element) {
  var elem = new JsObject.fromBrowserObject(element);

  if (elem.hasProperty("requestFullscreen")) {
    elem.callMethod("requestFullscreen");
  }
  else {
    List<String> vendors = ['moz', 'webkit', 'ms', 'o'];
    for (String vendor in vendors) {
      String vendorFullscreen = "${vendor}RequestFullscreen";
      if (vendor == 'moz') {
        vendorFullscreen = "${vendor}RequestFullScreen";
      }
      if (elem.hasProperty(vendorFullscreen)) {
        elem.callMethod(vendorFullscreen);
        return;
      }
    }
  }
}