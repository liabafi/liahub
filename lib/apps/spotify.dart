import 'package:flutter/material.dart';
import 'package:mac_dt/system/componentsOnOff.dart';
import 'package:provider/provider.dart';
import '../data/analytics.dart';
import '../system/openApps.dart';
import '../sizes.dart';
import '../widgets.dart';
import 'dart:html' as html;
import 'dart:ui' as ui;

class Spotify extends StatefulWidget {
  final Offset? initPos;
  const Spotify({this.initPos, Key? key}) : super(key: key);

  @override
  _SpotifyState createState() => _SpotifyState();
}

class _SpotifyState extends State<Spotify> {
  Offset? position = Offset(0.0, 0.0);
  late bool spotifyFS;
  late bool spotifyPan;
  final html.IFrameElement _iframeElementURL = html.IFrameElement();


  @override
  void initState() {
    position = widget.initPos;
    super.initState();
    _iframeElementURL.src = 'https://open.spotify.com/embed/playlist/6x90MMPI80sHj0unj3aT8o';
    _iframeElementURL.style.border = 'none';
    _iframeElementURL.allow = "autoplay; encrypted-media;";
    _iframeElementURL.allowFullscreen = true;
    ui.platformViewRegistry.registerViewFactory(
      'spotifyIframe',
          (int viewId) => _iframeElementURL,
    );

    Provider.of<AnalyticsService>(context, listen: false)
        .logCurrentScreen("Spotify");
  }

  @override
  Widget build(BuildContext context) {
    var spotifyOpen = Provider.of<OnOff>(context).getSpotify;
    spotifyFS = Provider.of<OnOff>(context).getSpotifyFS;
    spotifyPan = Provider.of<OnOff>(context).getSpotifyPan;
    return spotifyOpen
        ? AnimatedPositioned(
      duration: Duration(milliseconds: spotifyPan ? 0 : 200),
      top: spotifyFS ? 25 : position!.dy,
      left: spotifyFS ? 0 : position!.dx,
      child: spotifyWindow(context),
    )
        : Nothing();
  }

  AnimatedContainer spotifyWindow(BuildContext context) {
    String topApp = Provider.of<Apps>(context).getTop;
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      width: spotifyFS
          ? screenWidth(context, mulBy: 1)
          : screenWidth(context, mulBy: 0.5),
      height: spotifyFS
          ?screenHeight(context, mulBy: 0.975)
          : screenHeight(context, mulBy: 0.7),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 10,
            blurRadius: 15,
            offset: Offset(0, 8), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    height: spotifyFS
                        ? screenHeight(context, mulBy: 0.056)
                        : screenHeight(context, mulBy: 0.053),
                    decoration: BoxDecoration(
                        color: Color(0xff3a383e),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(10),
                            topLeft: Radius.circular(10))),
                  ),
                  GestureDetector(
                    onPanUpdate: (tapInfo) {
                      if (!spotifyFS) {
                        setState(() {
                          position = Offset(position!.dx + tapInfo.delta.dx,
                              position!.dy + tapInfo.delta.dy);
                        });
                      }
                    },
                    onPanStart: (details) {
                      Provider.of<OnOff>(context, listen: false).onSpotifyPan();
                    },
                    onPanEnd: (details) {
                      Provider.of<OnOff>(context, listen: false).offSpotifyPan();
                    },
                    onDoubleTap: () {
                      Provider.of<OnOff>(context, listen: false).toggleSpotifyFS();
                    },
                    child: Container(
                      alignment: Alignment.topRight,
                      width: spotifyFS
                          ? screenWidth(context, mulBy: 0.95)
                          : screenWidth(context, mulBy: 0.6),
                      height: spotifyFS
                          ? screenHeight(context, mulBy: 0.056)
                          : screenHeight(context, mulBy: 0.053),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          border: Border(
                              bottom: BorderSide(
                                  color: Colors.black.withOpacity(0.5),
                                  width: 0.8))),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth(context, mulBy: 0.013),
                        vertical: screenHeight(context, mulBy: 0.01)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              child: Container(
                                height: 11.5,
                                width: 11.5,
                                decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Provider.of<OnOff>(context, listen: false)
                                    .offSpotifyFS();
                                Provider.of<Apps>(context, listen: false).closeApp("spotify");
                                Provider.of<OnOff>(context, listen: false).toggleSpotify();


                              },
                            ),
                            SizedBox(
                              width: screenWidth(context, mulBy: 0.005),
                            ),
                            InkWell(
                              onTap: (){
                                Provider.of<OnOff>(context, listen: false).toggleSpotify();
                                Provider.of<OnOff>(context, listen: false).offSpotifyFS();
                              },
                              child: Container(
                                height: 11.5,
                                width: 11.5,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth(context, mulBy: 0.005),
                            ),
                            InkWell(
                              child: Container(
                                height: 11.5,
                                width: 11.5,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Provider.of<OnOff>(context, listen: false)
                                    .toggleSpotifyFS();
                              },
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      bottomLeft: Radius.circular(10)),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(sigmaX: 30.0, sigmaY: 30.0),
                    child: Container(
                      height: screenHeight(context, mulBy: 0.14),
                      width: screenWidth(
                        context,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xff3a383e).withOpacity(0.8),
                      ),
                      child: HtmlElementView(
                        viewType: 'spotifyIframe',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),


    Visibility(
      visible: topApp != "Spotify",
      child: InkWell(
        onTap: (){
          Provider.of<Apps>(context, listen: false)
              .bringToTop(ObjectKey("spotify"));
        },
        child: Container(
          width: screenWidth(context,),
          height: screenHeight(context,),
          color: Colors.transparent,
        ),
      ),
    ),
        ],
      ),
    );
  }
}

