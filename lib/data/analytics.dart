import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService extends ChangeNotifier{
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() =>
      FirebaseAnalyticsObserver(analytics: analytics);

  Future<void> setCurrentScreen(String screen) async {
    print('Setting current screen to $screen');
    await analytics.setCurrentScreen(
      screenName: screen,
    );
  }

  Future<void> logCurrentScreen(String screen) async {
    print('Setting current screen to $screen');

    await analytics.setCurrentScreen(
      screenName: screen,
    );
    await analytics.logScreenView(
      screenName: screen,
    );
  }

  Future<void> logSearch(String search) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "safariSearch",
      parameters: {
        "search": search,
      },
    );
  }

  Future<void> logFolder(String name) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "folderName",
      parameters: {
        "name": name,
      },
    );
  }

  Future<void> logTerminal(String search) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "terminalCommand",
      parameters: {
        "command": search,
      },
    );
  }

  Future<void> logWallPaper(String search) async {
    await FirebaseAnalytics.instance.logEvent(
      name: "wallpaperChanged",
      parameters: {
        "wallpaper": search,
      },
    );
  }

  // User properties tells us what the user is
  Future setUserProperties({ required String value, required String name}) async {
    await analytics.setUserProperty(name: name, value: value);
  }

  Future setUserId({required String userId,}) async {
    await analytics.setUserId(id: userId);
  }

  Future logLogin(String method) async {
    await analytics.logLogin(loginMethod: method);
  }

  Future logSignUp(String method) async {
    await analytics.logSignUp(signUpMethod: method);
  }


  Future logOpened(String a) async {
    await analytics.logEvent(
      name: "appOpened",
      parameters: {'app': a,},
    );
  }
}
