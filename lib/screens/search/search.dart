import 'dart:io';

import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:touroll/components/route/fade.dart';
import 'package:touroll/components/route/slide.dart';
import 'package:touroll/curves/spring.dart';
import 'package:sprung/sprung.dart';
import 'package:touroll/models/geometry.dart';
import 'package:touroll/models/location.dart';
import 'package:touroll/models/place.dart';
import 'package:touroll/models/tour.dart';
import 'package:touroll/screens/map.dart';
import 'package:touroll/screens/search/result.dart';
import 'package:touroll/screens/tour.dart';
// import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:touroll/services/place.dart';
import 'package:touroll/services/tour.dart';
import 'package:touroll/utils/pagination.dart';

class SuggestionItem extends StatefulWidget {
  final Place place;
  final Color color;
  SuggestionItem({Key key, @required this.place, this.color}) : super(key: key);

  @override
  _SuggestionItemState createState() => _SuggestionItemState();
}

class _SuggestionItemState extends State<SuggestionItem>
    with TickerProviderStateMixin {
  final Widget locationSvg = SvgPicture.asset(
    'assets/svg/outline/location.svg',
    semanticsLabel: 'location',
    color: Colors.white,
    width: 26,
    height: 26,
  );

  Animation _fadeAnimation;
  AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);
    _fadeController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (_, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(SlideRoute(
                    widget: ResultScreen(
                  userLocation: false,
                  place: widget.place,
                )));
              },
              child: Container(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 14),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(14),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: widget.color ?? widget.color),
                          child: locationSvg,
                        ),
                        Container(
                          width: 32,
                        ),
                        Expanded(
                            child: Text(widget.place.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontSize: 14)))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class Search extends StatefulWidget {
  Function callback;
  Search({Key key, @required this.callback}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with TickerProviderStateMixin {
  FocusNode _textFieldFocus = FocusNode();
  Color _color = Color(0xfff6f6f6);

  Animation _animation;
  AnimationController _controller;
  Animation<double> _curvedAnimation;

  Animation _fadeAnimation;
  AnimationController _fadeController;

  // Location location = new Location();
  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;
  // LocationData _locationData;

  Position position;

  void _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    //
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      // widget.callback(position);
      // Navigator.of(context, rootNavigator: true).pop();
      Navigator.of(context, rootNavigator: true).push(FadeRoute(
          widget: ResultScreen(
        userLocation: true,
        locationData: position,
      )));
    } catch (err) {
      print(err);
    }
  }

  void showAfter() async {
    await Future.delayed(Duration(milliseconds: 100), () {});
    _fadeController.forward();
  }

  // final tourService = TourService();
  // final pagination = Pagination();
  // final PagingController<int, Tour> _pagingController =
  //     PagingController(firstPageKey: null);
  String query = '';
  List<Place> suggestions = [
    Place(
        formatted_address: '',
        name: 'Discover nearby tours',
        geometry: Geometry(location: Location(lat: 0.0, lng: 0.0))),
  ];
  final placeService = PlaceService();
  @override
  void initState() {
    super.initState();
    // placeService.getPlaces('');
    // _pagingController.addPageRequestListener((pageKey) {
    //   pagination.fetchPage(
    //       tourService.searchTours(query), _pagingController, pageKey);
    // });
    // _textFieldFocus.addListener(() {
    //   if (_textFieldFocus.hasFocus) {
    //     setState(() {
    //       _color = Color(0xfff6f6f6);
    //     });
    //   } else {
    //     setState(() {
    //       _color = Color(0xfff6f6f6);
    //     });
    //   }
    // });

    _controller = AnimationController(
        duration: Duration(milliseconds: 1200), vsync: this);
    _curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Sprung.criticallyDamped);
    _animation = Tween<double>(
      begin: -100,
      end: 0,
    ).animate(_curvedAnimation);

    _fadeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);

    // showAfter();
    // _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final Widget compassSvg = SvgPicture.asset(
      'assets/svg/outline/compass.svg',
      semanticsLabel: 'compass',
      color: Colors.white,
      width: 26,
      height: 26,
    );

    return Scaffold(
        body: AnimatedBuilder(
            animation: _fadeController,
            builder: (_, child) {
              return (Stack(children: [
                Hero(
                  tag: 'map',
                  child: Material(
                      type: MaterialType.transparency,
                      child: Container(
                        height: screenHeight * 0.4,
                        width: screenWidth,
                        color: Colors.transparent,
                      )),
                ),
                Hero(
                  tag: 'search-bar',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Container(
                      height: screenHeight,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(40),
                            topLeft: Radius.circular(40)),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: SafeArea(
                    bottom: false,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                              icon: Icon(Icons.arrow_back_ios_outlined),
                              onPressed: () => {Navigator.of(context).pop()}),
                          // IconButton(
                          //     icon: Icon(Icons.arrow_back_ios_outlined),
                          //     onPressed: () => {Navigator.of(context).pop()}),
                          Container(
                            height: 24,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                            ),
                            child: Text(
                              'Choose a location',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 24),
                            ),
                          ),
                          Container(
                            height: 16,
                          ),
                          Hero(
                            tag: 'find-a-place',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: TextField(
                                    onChanged: (text) async {
                                      final places =
                                          await placeService.getPlaces(text);
                                      places.forEach((element) {
                                        print(element.name);
                                      });
                                      setState(() {
                                        suggestions = places;
                                        suggestions.insert(
                                            0,
                                            Place(
                                                formatted_address: '',
                                                name: 'Discover nearby tours',
                                                geometry: Geometry(
                                                    location: Location(
                                                        lat: 0.0, lng: 0.0))));
                                      });
                                    },
                                    autofocus: true,
                                    // focusNode: _textFieldFocus,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            bottom: 16, left: 18),
                                        filled: true,
                                        fillColor: _color,
                                        border: InputBorder.none,
                                        labelText: 'Find a place',
                                        hintText: 'Find a place',
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.never),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 12,
                          ),
                          Expanded(
                            child: Container(
                              child: ListView.builder(
                                  padding: EdgeInsets.only(top: 12, bottom: 60),
                                  itemCount: suggestions.length,
                                  itemBuilder: (context, index) {
                                    return (index == 0
                                        ? GestureDetector(
                                            onTap: () {
                                              _determinePosition();
                                            },
                                            child: Container(
                                              color: Colors.white,
                                              // margin:
                                              //     EdgeInsets.only(bottom: 24),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          EdgeInsets.all(14),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                          color: Color(
                                                              0xff50A5D5)),
                                                      child: compassSvg,
                                                    ),
                                                    Container(
                                                      width: 32,
                                                    ),
                                                    Expanded(
                                                        child: Text(
                                                            suggestions[index]
                                                                .name,
                                                            style: TextStyle(
                                                                fontSize: 14)))
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : SuggestionItem(
                                            color:
                                                Theme.of(context).accentColor,
                                            place: suggestions[index],
                                          ));
                                  }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ]));
            }));
  }
}
