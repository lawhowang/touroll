import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';
import 'package:sprung/sprung.dart';
import 'package:touroll/components/route/fade.dart';
import 'package:touroll/components/route/slide.dart';
import 'package:touroll/screens/tour.dart';

final double ORIGINAL_SIZE = 400;
final double ANIMATED_SIZE = 100;

class MapScreen extends StatefulWidget {
  // Function callback;
  Position locationData;
  MapScreen({Key key, @required this.locationData}) : super(key: key);
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  Completer<GoogleMapController> _controller = Completer();
  CameraPosition _kGooglePlex;

  ScrollController _scrollController = ScrollController();

  final Widget locationSvg = SvgPicture.asset(
    'assets/svg/outline/location.svg',
    semanticsLabel: 'location',
    color: Colors.black,
    width: 26,
    height: 26,
  );

  Animation _fadeAnimation;
  AnimationController _fadeController;

  double animatedSize = ORIGINAL_SIZE;
  double contentSpacerSize = ORIGINAL_SIZE - 100;
  double heroSpacerSize = ORIGINAL_SIZE - 100;

  void showAfter() async {
    await Future.delayed(Duration(milliseconds: 300), () {
      print('delay completed');
    });
    _fadeController.forward();
    // print('kmaskd');
    // setState(() {
    // _fadeController.forward();
    // });
  }

  @override
  void initState() {
    super.initState();
    _fadeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);

    _kGooglePlex = CameraPosition(
      target:
          LatLng(widget.locationData.latitude, widget.locationData.longitude),
      zoom: 14.4746,
    );
    _scrollController.addListener(() {
      // print(_scrollController.offset);
      if (_scrollController.offset >= 50 && animatedSize != ANIMATED_SIZE) {
        setState(() {
          animatedSize = ANIMATED_SIZE;
          contentSpacerSize = ANIMATED_SIZE - 70;
          heroSpacerSize = ANIMATED_SIZE - 100;
        });
      } else if (_scrollController.offset < 50 &&
          animatedSize == ANIMATED_SIZE) {
        setState(() {
          animatedSize = ORIGINAL_SIZE;
          contentSpacerSize = animatedSize - 100;
          heroSpacerSize = animatedSize - 100;
        });
      }
    });

    // _fadeController.forward();

    showAfter();
    //end
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return new Scaffold(
      body: AnimatedBuilder(
          animation: _fadeController,
          builder: (_, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    Hero(
                      tag: 'map',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          height: ORIGINAL_SIZE,
                          color: Color(0xfff6f6f6),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Opacity(
                                opacity: _fadeAnimation.value,
                                child: GoogleMap(
                                  mapType: MapType.normal,
                                  initialCameraPosition: _kGooglePlex,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                ),
                              ),
                              Positioned(
                                  left: 12,
                                  child: SafeArea(
                                    child: IconButton(
                                      icon: Icon(Icons.arrow_back_ios_rounded),
                                      onPressed: () {
                                        Navigator.popUntil(
                                            context,
                                            ModalRoute.withName(
                                                Navigator.defaultRouteName));
                                      },
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      height: (heroSpacerSize),
                      curve:
                          Sprung.custom(damping: 35, stiffness: 200, mass: 1),
                    ),
                    Hero(
                      tag: 'search-bar',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Container(
                          height: ORIGINAL_SIZE,
                          width: screenWidth,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    AnimatedContainer(
                      duration: Duration(milliseconds: 1000),
                      curve:
                          Sprung.custom(damping: 35, stiffness: 200, mass: 1),
                      height: (contentSpacerSize),
                    ),
                    // Container(
                    //   height: animatedSize - 100,
                    // ),
                    Expanded(
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 16,
                            right: 24,
                            left: 24,
                          ),
                          // height: ,
                          // margin: EdgeInsets.only(top: screenHeight * 0.4),

                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .pop();
                                      },
                                      child: Hero(
                                        tag: 'find-a-place',
                                        child: Material(
                                          type: MaterialType.transparency,
                                          child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(18),
                                                color: Color(0xfff6f6f6),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 12,
                                                  ),
                                                  locationSvg,
                                                  Container(
                                                    width: 12,
                                                  ),
                                                  Expanded(
                                                      child: Text(
                                                    'Current Location || location name ',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                  )),
                                                  Container(
                                                    width: 12,
                                                  ),
                                                ],
                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 12,
                                  ),
                                  Text('icon')
                                ],
                              ),
                              Container(
                                height: 12,
                              ),
                              Expanded(
                                child: ListView.builder(
                                    controller: _scrollController,
                                    padding: EdgeInsets.only(
                                      top: 12,
                                    ),
                                    itemCount: 20,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () => {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .push(SlideRoute(
                                                  widget: TourScreen(
                                            id: index,
                                            coverImageTag: 'map-tour-$index',
                                          )))
                                        },
                                        child: Container(
                                            child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Hero(
                                                    tag: 'map-tour-' +
                                                        index.toString(),
                                                    child: Material(
                                                      type: MaterialType
                                                          .transparency,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(16),
                                                        child: Image.network(
                                                          'https://images.unsplash.com/photo-1510798831971-661eb04b3739?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80',
                                                          fit: BoxFit.cover,
                                                          height: screenHeight *
                                                              0.3,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Container(
                                              height: 9,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child:
                                                      Text('Tour name example',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                          )),
                                                )
                                              ],
                                            ),
                                            Container(
                                              height: 3,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                      'lorem ipsum dolor sit amet consectetuer adipiscing elit',
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w200,
                                                          color: Color(
                                                              0xff6e6e6e))),
                                                )
                                              ],
                                            ),
                                            Container(
                                              height: 9,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Expanded(
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    child: Text('HKD 2400+',
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                        )),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Container(
                                              height: 24,
                                            ),
                                          ],
                                        )),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            );
          }),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }

  // Future<void> _goToTheLake() async {
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  // }
}
