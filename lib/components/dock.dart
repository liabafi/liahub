import 'dart:developer' as dev;
import 'dart:html' as html;
import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mac_dt/apps/messages/messages.dart';
import 'package:provider/provider.dart';
import '../apps/about.dart';
import '../apps/calendar.dart';
import '../apps/systemPreferences.dart';
import '../data/analytics.dart';
import '../system/componentsOnOff.dart';
import '../system/folders/folders.dart';
import '../system/openApps.dart';
import '../providers.dart';
import '../widgets.dart';
import 'finderWindow.dart';
import '../sizes.dart';
import '../apps/feedback/feedback.dart';
import '../apps/spotify.dart';
import '../apps/terminal/terminal.dart';
import '../apps/vscode.dart';
import '../apps/safari/safariWindow.dart';

//TODO: Icons are not clickable outside of Dock. Known issue of framework. Need to find a Workaround.

class Docker extends StatefulWidget {
  const Docker({
    Key? key,
  }) : super(key: key);

  @override
  _DockerState createState() => _DockerState();
}

class _DockerState extends State<Docker> {
  late DateTime now;
  bool _animate = false;
  var _offsetX = 0.0;
  var _offsetY = 0.0;
  bool? safariOpen, vsOpen, messageOpen,spotifyOpen, fbOpen, calendarOpen, terminalOpen;
  final bool isWebMobile = kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);


  @override
  void initState() {
    now = DateTime.now();
    super.initState();
  }

  ///This function gives the path of the arc which the apps should follow.
  /// x : center of the Dock Item.
  /// x0 : _getCursor = position of the cursor.
  /// 2 :  we want the animation to affect 4 items centered in x0.


  double _getPath(double x, double x0, ) {
    x=(x)/100;
    if (_offsetX == 0) return 0;
    var z = (x - x0) * (x - x0) - 2;
    if (z > 0) return 0;
    ///Following if  has been added to obtain the gradual increase of size when coming from top.
    if (_offsetY<screenHeight(context, mulBy: 0.06))
      return sqrt(-z / 2)*(_offsetY/50);
    return sqrt(-z / 2);
  }

  double _getCursor() {
    return _offsetX / 100;
  }

  double getWidth(){
    dev.log((_offsetX).toString());

    if(_offsetX<100){
      return (screenWidth(context, mulBy: 0.55)+screenWidth(context, mulBy: 0.06*_offsetX/100));
    }
    else{
      if(_offsetX>1070){
        return (screenWidth(context, mulBy: 0.55)+screenWidth(context, mulBy: 0.06*(1170-_offsetX)/100));
      }
      return screenWidth(context, mulBy: 0.61);
    }

  }


  @override
  Widget build(BuildContext context) {
    safariOpen = Provider.of<Apps>(context).isOpen(ObjectKey("safari"));
    vsOpen = Provider.of<Apps>(context).isOpen(ObjectKey("vscode"));
    messageOpen = Provider.of<Apps>(context).isOpen(ObjectKey("messages"));
    spotifyOpen = Provider.of<Apps>(context).isOpen(ObjectKey("spotify"));
    String fs = Provider.of<OnOff>(context).getFS;
    bool fsAni = Provider.of<OnOff>(context).getFSAni;
    fbOpen = Provider.of<Apps>(context).isOpen(ObjectKey("feedback"));
    calendarOpen = Provider.of<Apps>(context).isOpen(ObjectKey("calendar"));
    terminalOpen = Provider.of<Apps>(context).isOpen(ObjectKey("terminal"));

    return AnimatedPositioned(
      duration: Duration(milliseconds: (fsAni) ? 400 : 0),
      top: (fs == "")
          ? screenHeight(context, mulBy: 0.86)
          : screenHeight(context, mulBy: 1.05),
      left: screenWidth(context, mulBy: 0.225),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    CustomBoxShadow(
                        color: Theme.of(context).colorScheme.secondary,
                        //color: Colors.black.withOpacity(0.2),
                        spreadRadius: 10,
                        blurRadius: 15,
                        offset: Offset(0, 8),
                        blurStyle: BlurStyle.normal),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  child: BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 70.0, sigmaY: 70.0),
                    child: Container(
                      padding: EdgeInsets.only(bottom: 2),
                      width: screenWidth(context, mulBy: 0.55),
                      height: screenHeight(context, mulBy: 0.06),
                      decoration: BoxDecoration(
                          color: Theme.of(context).focusColor,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(bottom: 2),
                width: screenWidth(context, mulBy: 0.55),
                height: screenHeight(context, mulBy: 0.06),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      DockerItem(
                        iName: "Finder",
                        on: true,
                        dx: _getPath(screenWidth(context, mulBy: 0.0196), _getCursor(),),
                        onTap: () {
                          setState(() {
                            _animate = !_animate;
                          });
                          tapFunctions(context);
                          Provider.of<OnOff>(context, listen: false)
                              .maxFinder();
                          Provider.of<Apps>(context, listen: false).openApp(
                              Finder(
                                  key: ObjectKey("finder"),
                                  initPos: Offset(
                                      screenWidth(context, mulBy: 0.2),
                                      screenHeight(context, mulBy: 0.18))),
                              Provider.of<OnOff>(context, listen: false)
                                  .maxFinder()
                          );
                        },
                      ),
                      DockerItem(
                        iName: "Launchpad",
                        on: false,
                        dx: _getPath(screenWidth(context, mulBy: 0.0588), _getCursor(), ),
                        onTap: () {
                          Provider.of<Folders>(context, listen: false).deSelectAll();
                          Provider.of<OnOff>(context, listen: false).offNotifications();
                          Provider.of<OnOff>(context, listen: false).offFRCM();
                          Provider.of<OnOff>(context, listen: false).offRCM();
                          Provider.of<OnOff>(context, listen: false).toggleLaunchPad();
                          Provider.of<AnalyticsService>(context, listen: false)
                              .logCurrentScreen("Launchpad");
                        },
                      ),
                      DockerItem(
                        iName: "Safari",
                        on: safariOpen,
                        dx: _getPath(screenWidth(context, mulBy: 0.098), _getCursor(),),
                        onTap: () {
                          tapFunctions(context);
                          Provider.of<OnOff>(context, listen: false)
                              .maxSafari();
                          Provider.of<Apps>(context, listen: false).openApp(
                              Safari(
                                  key: ObjectKey("safari"),
                                  initPos: Offset(
                                      screenWidth(context, mulBy: 0.21),
                                      screenHeight(context, mulBy: 0.14))),
                              Provider.of<OnOff>(context, listen: false)
                                  .maxSafari()
                          );
                        },
                      ),
                      DockerItem(
                        iName: "Messages",
                        on: messageOpen,
                        dx: _getPath(screenWidth(context, mulBy: 0.1372), _getCursor(), ),
                        onTap: () {
                          tapFunctions(context);

                          Provider.of<OnOff>(context, listen: false)
                              .maxMessages();
                          Provider.of<Apps>(context, listen: false).openApp(
                              Messages(
                                  key: ObjectKey("messages"),
                                  initPos: Offset(
                                      screenWidth(context, mulBy: 0.27),
                                      screenHeight(context, mulBy: 0.2))),
                              Provider.of<OnOff>(context, listen: false)
                                  .maxMessages()
                          );
                        },
                      ),
                      DockerItem(
                        iName: "assets/apps/about me.png",
                        on: false,
                        dx: _getPath(screenWidth(context, mulBy: 0.1764), _getCursor(), ),
                        onTap: () {
                          tapFunctions(context);
                          Provider.of<OnOff>(context, listen: false)
                              .maxAbout();
                          Provider.of<Apps>(context, listen: false).openApp(
                              About(
                                  key: ObjectKey("about"),
                                  initPos: Offset(
                                      screenWidth(context, mulBy: 0.2),
                                      screenHeight(context, mulBy: 0.12))),
                              Provider.of<OnOff>(context, listen: false)
                                  .maxAbout()
                          );
                        },
                      ),
                      DockerItem(
                        iName: "Spotify",
                        on: spotifyOpen,
                        dx: _getPath(screenWidth(context, mulBy: 0.2156), _getCursor(), ),
                        onTap: () {
                          tapFunctions(context);

                          Provider.of<OnOff>(context, listen: false)
                              .maxSpotify();
                          Provider.of<Apps>(context, listen: false).openApp(
                              Spotify(
                                  key: ObjectKey("spotify"),
                                  initPos: Offset(
                                      screenWidth(context, mulBy: 0.24),
                                      screenHeight(context, mulBy: 0.15)
                                  )),
                              Provider.of<OnOff>(context, listen: false)
                                  .maxSpotify()
                          );

                        },
                      ),
                      DockerItem(
                        iName: "Terminal",
                        on: terminalOpen,
                        dx: _getPath(screenWidth(context, mulBy: 0.2548), _getCursor(), ),
                        onTap: () {
                          tapFunctions(context);

                          Provider.of<OnOff>(context, listen: false)
                              .maxTerminal();
                          Provider.of<Apps>(context, listen: false).openApp(
                              Terminal(
                                  key: ObjectKey("terminal"),
                                  initPos: Offset(
                                      screenWidth(context, mulBy: 0.28),
                                      screenHeight(context, mulBy: 0.2))),
                              Provider.of<OnOff>(context, listen: false)
                                  .maxTerminal()
                          );

                        },
                      ),
                      DockerItem(
                        iName: "Visual Studio Code",
                        on: vsOpen,
                        dx: _getPath(screenWidth(context, mulBy: 0.294), _getCursor(), ),
                        onTap: () {
                          tapFunctions(context);

                          Provider.of<OnOff>(context, listen: false).maxVS();
                          Provider.of<Apps>(context, listen: false).openApp(
                              VSCode(
                                  key: ObjectKey("vscode"),
                                  initPos: Offset(
                                      screenWidth(context, mulBy: 0.24),
                                      screenHeight(context, mulBy: 0.15))),
                              Provider.of<OnOff>(context, listen: false).maxVS()
                          );

                        },
                      ),
                      DockerItem(
                        iName: "Photos",
                        on: false,
                        dx: _getPath(screenWidth(context, mulBy: 0.3332), _getCursor(), ),
                        onTap: (){
                          Provider.of<DataBus>(context, listen: false).setNotification(
                              "App has not been installed. Create the app on GitHub.",
                              "https://github.com/liabafi",
                              "photos",
                              "Not installed"
                          );
                          Provider.of<OnOff>(context, listen: false).onNotifications();
                        },
                      ),
                      InkWell(
                        mouseCursor: SystemMouseCursors.basic,
                        child: AnimatedContainer(
                            duration: const Duration(milliseconds: 80),
                            transform: Matrix4.identity()
                              ..scale((.6*_getPath(screenWidth(context, mulBy: 0.3724), _getCursor(), ))+1,(.6*_getPath(screenWidth(context, mulBy: 0.3724), _getCursor(), ))+1)
                              ..translate(-_getPath(screenWidth(context, mulBy: 0.3724), _getCursor(), )*8, -(_getPath(screenWidth(context, mulBy: 0.3724), _getCursor(), )*18), 0,
                              ),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                vertical: 3
                              ),
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        Color(0xff118bff),
                                        Color(0xff1c59a4),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter
                                  ),
                                shape: BoxShape.circle
                              ),
                              padding: EdgeInsets.symmetric(
                                vertical: 7,
                                horizontal: 10
                              ),
                              height: 47,
                              width: 47,
                              child: FittedBox(
                                child: Icon(
                                  CupertinoIcons.fullscreen,
                                  color: Colors.white,
                                  size: 30,

                                ),
                              ),
                            )),
                        onTap: (){
                          if(!isWebMobile){
                            html.document.documentElement!.requestFullscreen();
                          }
                        },
                      ),
                      InkWell(
                        onTap: (){
                          tapFunctions(context);
                          Provider.of<OnOff>(context, listen: false)
                              .maxCalendar();
                          Provider.of<Apps>(context, listen: false).openApp(
                              Calendar(
                                key: ObjectKey("calendar"),
                                  initPos: Offset(
                                      screenWidth(context, mulBy: 0.24),
                                      screenHeight(context, mulBy: 0.15))
                              ),
                              Provider.of<OnOff>(context, listen: false)
                                  .maxCalendar()
                          );
                        },
                        child: Column(
                          children: [
                            Expanded(
                              child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 80),
                                  transform: Matrix4.identity()
                                    ..scale((.6*_getPath(screenWidth(context, mulBy: 0.4116), _getCursor(), ))+1,(.6*_getPath(screenWidth(context, mulBy: 0.4116), _getCursor(), ))+1)
                                    ..translate(-_getPath(screenWidth(context, mulBy: 0.4116), _getCursor(), )*8, -(_getPath(screenWidth(context, mulBy: 0.4116), _getCursor(), )*18), 0,
                                    ),
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      Image.asset(
                                        "assets/apps/calendar.png",
                                      ),
                                      Positioned(
                                        top: screenHeight(context, mulBy: 0.006),
                                        child: Container(
                                          height:
                                          screenHeight(context, mulBy: 0.014),
                                          width:
                                          screenWidth(context, mulBy: 0.025),
                                          color: Colors.transparent,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "${DateFormat('LLL').format(now).toUpperCase()}",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'SF',
                                                fontWeight: FontWeight.w400,
                                                fontSize: 11,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: screenHeight(context, mulBy: 0.017),
                                        child: Container(
                                          height:
                                          screenHeight(context, mulBy: 0.031),
                                          width:
                                          screenWidth(context, mulBy: 0.025),
                                          color: Colors.transparent,
                                          child: FittedBox(
                                            fit: BoxFit.fitHeight,
                                            child: Text(
                                              "${DateFormat('d').format(now).toUpperCase()}",
                                              style: TextStyle(
                                                  color: Colors.black87
                                                      .withOpacity(0.8),
                                                  fontFamily: 'SF',
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 28),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                            ),
                            Container(
                              height: 4,
                              width: 4,
                              decoration: BoxDecoration(
                                color: calendarOpen!
                                    ? Theme.of(context)
                                    .cardColor
                                    .withOpacity(1)
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DockerItem(
                        iName: "Notes",
                        on: false,
                        dx: _getPath(screenWidth(context, mulBy: 0.4508), _getCursor(), ),
                        onTap: (){
                          Provider.of<DataBus>(context, listen: false).setNotification(
                              "App has not been installed. Create the app on GitHub.",
                              "https://github.com/liabafi",
                              "notes",
                              "Not installed"
                          );
                          Provider.of<OnOff>(context, listen: false).onNotifications();
                        },
                      ),
                      DockerItem(
                        iName: "Feedback",
                        on: fbOpen,
                        dx: _getPath(screenWidth(context, mulBy: 0.49), _getCursor(), ),
                        onTap: () {
                          tapFunctions(context);

                          Provider.of<OnOff>(context, listen: false)
                              .maxFeedBack();
                          Provider.of<Apps>(context, listen: false).openApp(
                              FeedBack(
                                  key: ObjectKey("feedback"),
                                  initPos: Offset(
                                      screenWidth(context, mulBy: 0.2),
                                      screenHeight(context, mulBy: 0.12))),
                              Provider.of<OnOff>(context, listen: false)
                                  .maxFeedBack()
                          );
                        },
                      ),
                      DockerItem(
                        iName: "System Preferences",
                        on: Provider.of<Apps>(context).isOpen(ObjectKey("systemPreferences")),
                        dx: _getPath(screenWidth(context, mulBy: 0.5292), _getCursor(), ),
                        onTap: () {
                          tapFunctions(context);
                          Future.delayed(const Duration(milliseconds: 200), () {
                            Provider.of<OnOff>(context, listen: false)
                                .maxSysPref();
                            Provider.of<Apps>(context, listen: false).openApp(
                                SystemPreferences(
                                    key: ObjectKey("systemPreferences"),
                                    initPos: Offset(
                                        screenWidth(context, mulBy: 0.27),
                                        screenHeight(context, mulBy: 0.13))),
                                Provider.of<OnOff>(context, listen: false)
                                    .maxSysPref()
                            );
                          });

                        },
                      ),
                    ]
                ),
              ),
              MouseRegion(
                opaque: false,
                onHover: (event) {
                  setState(() {
                    _offsetX = event.localPosition.dx;
                    _offsetY= event.localPosition.dy;
                  });
                },
                onExit: (event) {
                  setState(() {
                    _offsetX = 0;
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(bottom: 2),
                  width: screenWidth(context, mulBy: 0.55),
                  height: screenHeight(context, mulBy: 0.135),
                ),
              ),
            ],
          ),
          SizedBox(
            height: screenHeight(context, mulBy: 0.005),
          )
        ],
      ),
    );
  }
}

class DockerItem extends StatefulWidget {
  final String iName;
  final bool? on;
  ///change to be applied
  double dx;
  VoidCallback? onTap=(){};
  DockerItem({
    Key? key,
    required this.iName,
    required this.dx,
    this.on = false,
    this.onTap
  }) : super(key: key);

  @override
  _DockerItemState createState() => _DockerItemState();
}

class _DockerItemState extends State<DockerItem> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      mouseCursor: MouseCursor.defer,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: AnimatedContainer(
                  duration: const Duration(milliseconds: 80),
                  transform: Matrix4.identity()
                    ..scale((.5*widget.dx)+1,(.5*widget.dx)+1)
                    ..translate(-widget.dx*8, -(widget.dx*16), 0,
                    ),
                  child: Image.asset(
                      widget.iName.contains("/")?widget.iName:"assets/apps/${widget.iName.toLowerCase()}.png",
                  ))),
          Container(
            height: 4,
            width: 4,
            decoration: BoxDecoration(
              color: widget.on!
                  ? Theme.of(context).cardColor.withOpacity(1)
                  : Colors.transparent,
              shape: BoxShape.circle,
            ),
          )
        ],
      ),
    );
  }
}
