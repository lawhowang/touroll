import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
//import 'package:location/location.dart';
import 'package:sprung/sprung.dart';
import 'package:touroll/components/route/fade.dart';
import 'package:touroll/components/route/slide.dart';
import 'package:touroll/models/place.dart';
import 'package:touroll/models/tour.dart';
import 'package:touroll/screens/filter.dart';
import 'package:touroll/screens/tour.dart';
import 'package:touroll/services/tour.dart';
import 'package:touroll/utils/image.dart';
import 'package:touroll/utils/pagination.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final double ORIGINAL_SIZE = 400;
final double ANIMATED_SIZE = 100;

class ResultScreen extends StatefulWidget {
  // Function callback;
  Position locationData;
  Place place;
  bool userLocation;
  ResultScreen(
      {Key key, @required this.userLocation, this.locationData, this.place})
      : super(key: key);
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
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

  final Widget filterSvg = SvgPicture.asset(
    'assets/svg/outline/filter.svg',
    semanticsLabel: 'filter',
    color: Colors.black,
    width: 26,
    height: 26,
  );

  final Widget closeSvg = SvgPicture.asset(
    'assets/svg/outline/close.svg',
    semanticsLabel: 'close',
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
  }

  final tourService = TourService();
  final pagination = Pagination();
  final PagingController<int, Tour> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    super.initState();

    _pagingController.addPageRequestListener((pageKey) {
      if (widget.userLocation) {
        pagination.fetchPage(
            tourService.getNearbyTours(
                widget.locationData.latitude, widget.locationData.longitude),
            _pagingController,
            pageKey);
      } else {
        pagination.fetchPage(
            tourService.getNearbyTours(widget.place.geometry.location.lat,
                widget.place.geometry.location.lng),
            _pagingController,
            pageKey);
      }
    });

    _fadeController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_fadeController);

    _kGooglePlex = CameraPosition(
      target: LatLng(
        widget.userLocation
            ? widget.locationData.latitude
            : widget.place.geometry.location.lat,
        widget.userLocation
            ? widget.locationData.longitude
            : widget.place.geometry.location.lng,
      ),
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
      } else if (_scrollController.offset < -50 &&
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
      resizeToAvoidBottomInset: false,
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
                                  markers: Set<Marker>.of([
                                    Marker(
                                        position: widget.userLocation
                                            ? LatLng(
                                                widget.locationData.latitude,
                                                widget.locationData.longitude)
                                            : LatLng(
                                                widget.place.geometry.location
                                                    .lat,
                                                widget.place.geometry.location
                                                    .lng,
                                              ),
                                        infoWindow: InfoWindow(
                                            title: widget.userLocation
                                                ? 'Your current location'
                                                : widget.place.formatted_address
                                                    .toString(),
                                            snippet: '*'),
                                        markerId: widget.userLocation
                                            ? MarkerId(widget
                                                    .locationData.latitude
                                                    .toString() +
                                                widget.locationData.longitude
                                                    .toString())
                                            : MarkerId(widget
                                                    .place.geometry.location.lat
                                                    .toString() +
                                                widget
                                                    .place.geometry.location.lng
                                                    .toString()))
                                  ]),
                                  mapType: MapType.normal,
                                  initialCameraPosition: _kGooglePlex,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    _controller.complete(controller);
                                  },
                                ),
                              ),
                              Positioned(
                                  left: 0,
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
                    Expanded(
                      child: Opacity(
                        opacity: _fadeAnimation.value,
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 16,
                            right: 24,
                            left: 24,
                          ),
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  // Row(
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.center,
                                  //   children: [
                                  //     Padding(  padding: EdgeInsets.only(top: 4),
                                  //       child: IconButton(
                                  //         icon: Icon(
                                  //             Icons.arrow_back_ios_rounded),
                                  //         onPressed: () {
                                  //           Navigator.popUntil(
                                  //               context,
                                  //               ModalRoute.withName(Navigator
                                  //                   .defaultRouteName));
                                  //         },
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  Row(
                                    children: [
                                      // Container(
                                      //   width: 50,
                                      // ),
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
                                                      vertical: 16),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18),
                                                    color: Color(0xfff6f6f6),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                        widget.userLocation
                                                            ? 'Current Location'
                                                            : widget.place.name,
                                                        overflow: TextOverflow
                                                            .ellipsis,
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
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.of(context)
                                                .push(SlideRoute(
                                                    slideUp: true,
                                                    widget: FilterScreen(
                                                      callback:
                                                          (activities, sortBy) {
                                                        print(
                                                            'callback from filter screen');
                                                      },
                                                    )));
                                          },
                                          child: Hero(
                                              tag: 'filter-icon',
                                              child: Material(
                                                  type:
                                                      MaterialType.transparency,
                                                  child: filterSvg)))
                                    ],
                                  ),
                                ],
                              ),
                              Container(
                                height: 12,
                              ),
                              Expanded(
                                  child: PagedListView<int, Tour>(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 6),
                                      pagingController: _pagingController,
                                      scrollController: _scrollController,
                                      physics: AlwaysScrollableScrollPhysics(
                                          parent: BouncingScrollPhysics()),
                                      builderDelegate:
                                          PagedChildBuilderDelegate<Tour>(
                                              itemBuilder:
                                                  (context, item, index) =>
                                                      GestureDetector(
                                                        onTap: () => {
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .push(SlideRoute(
                                                                  widget:
                                                                      TourScreen(
                                                            id: item.id,
                                                            coverImageTag:
                                                                'map-tour-$index',
                                                            coverImage:
                                                                item.coverImage,
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
                                                                        index
                                                                            .toString(),
                                                                    child:
                                                                        Material(
                                                                      type: MaterialType
                                                                          .transparency,
                                                                      child:
                                                                          ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                        child:
                                                                            CachedNetworkImage(
                                                                          imageUrl: ImageUtil.getImageUrlByIdentifier(
                                                                              ImageType.TOUR_COVER,
                                                                              item.coverImage),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                          height:
                                                                              screenHeight * 0.25,
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
                                                                  child: Text(
                                                                      item
                                                                          .title,
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            18,
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
                                                                  child: Text(item.description,
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          fontWeight: FontWeight
                                                                              .w200,
                                                                          color:
                                                                              Color(0xff6e6e6e))),
                                                                )
                                                              ],
                                                            ),
                                                            Container(
                                                              height: 9,
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                Expanded(
                                                                  child: Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .centerRight,
                                                                    child: Text(
                                                                        '\$ ${item.price}',
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow
                                                                                .ellipsis,
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              18,
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
                                                      )))
                                  //           ListTile(
                                  //               title:
                                  //                   Text(item.title.toString()),
                                  //               subtitle: Text(item.startDate
                                  //                       .toString()
                                  //                       .substring(0, 10) +
                                  //                   ' - ' +
                                  //                   item.endDate
                                  //                       .toString()
                                  //                       .substring(0, 10)),
                                  //               leading: AspectRatio(
                                  //                 aspectRatio: 1,
                                  //                 child: CachedNetworkImage(
                                  //                   imageUrl: ImageUtil
                                  //                       .getImageUrlByIdentifier(
                                  //                           ImageType.TOUR_COVER,
                                  //                           item.coverImage),
                                  //                   fit: BoxFit.cover,
                                  //                 ),
                                  //               ))),
                                  // ),
                                  // ListView.builder(
                                  //     controller: _scrollController,
                                  //     padding: EdgeInsets.only(
                                  //       top: 12,
                                  //     ),
                                  //     itemCount: 20,
                                  //     itemBuilder: (context, index) {
                                  //       return
                                  //
                                  //     }),
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
