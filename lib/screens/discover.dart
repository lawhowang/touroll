import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:touroll/components/button.dart';
import 'package:touroll/components/cards.dart';
import 'package:touroll/components/loading.dart';
import 'package:touroll/components/route/fade.dart';
import 'package:touroll/components/route/slide.dart';
import 'package:touroll/models/card.dart';
import 'package:touroll/models/tour.dart';
import 'package:touroll/screens/map.dart';
import 'package:touroll/screens/search/result.dart';
import 'package:touroll/screens/search/search.dart';
import 'package:touroll/screens/tour.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touroll/services/tour.dart';
import 'package:touroll/utils/image.dart';

final Widget bonfireSvg = SvgPicture.asset(
  'assets/svg/bonfire.svg',
  semanticsLabel: 'Bonfire',
  color: Colors.black,
  width: 26,
  height: 26,
);

final Widget boatSvg = SvgPicture.asset(
  'assets/svg/boat.svg',
  semanticsLabel: 'Boat',
  color: Colors.black,
  width: 26,
  height: 26,
);

final Widget pizzaSvg = SvgPicture.asset(
  'assets/svg/pizza.svg',
  semanticsLabel: 'Pizza',
  color: Colors.black,
  width: 26,
  height: 26,
);

final testItems = [
  {
    'id': 1,
    'name': 'card name',
    'description': 'card descriotion ...',
    'image':
        'https://images.unsplash.com/photo-1509023464722-18d996393ca8?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTJ8fGphcGFufGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60',
  },
  {
    'id': 2,
    'name': 'card name',
    'description': 'card descriotion ...',
    'image':
        'https://images.unsplash.com/photo-1510798831971-661eb04b3739?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80',
  },
  {
    'id': 3,
    'name': 'card name',
    'description': 'card descriotion ...',
    'image':
        'https://images.unsplash.com/photo-1510798831971-661eb04b3739?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80',
  },
  {
    'id': 4,
    'name': 'card name',
    'description': 'card descriotion ...',
    'image':
        'https://images.unsplash.com/photo-1510798831971-661eb04b3739?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=668&q=80',
  }
];

class Feature extends StatelessWidget {
  final SvgPicture icon;
  final Function onPressed;
  final String title;
  const Feature({Key key, this.icon, this.onPressed, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        margin: EdgeInsets.fromLTRB(24, 0, 24, 12),
        child: Material(
          borderRadius: BorderRadius.circular(8),
          color: Color(0xfff3f3f3),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () => {onPressed},
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 21),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(24, 0, 16, 0),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Positioned(
                          right: -3,
                          bottom: 5,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Color(0xb1C8B67E)),
                          ),
                        ),
                        icon,
                      ],
                    ),
                  ),
                  // Container(width: 24,),
                  Expanded(
                      flex: 1,
                      child: Center(
                          child: Text(title, style: TextStyle(fontSize: 16))))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Discover extends StatefulWidget {
  // Function rootPush;
  Discover({
    Key key,
    // @required this.rootPush,
  }) : super(key: key);

  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {
  final tourService = TourService();
  Future<List<Tour>> _mostViewedTours;

  @override
  void initState() {
    super.initState();
    _mostViewedTours = tourService.getMostViewedTours();
  }

  @override
  Widget build(BuildContext context) {
    // tourService.searchTours('first');
    final ContainerTransitionType _containerTransitionType =
        ContainerTransitionType.fadeThrough;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            stretch: true,
            expandedHeight: screenHeight * 0.3,
            backgroundColor: Colors.white,
            // pinned: true,
            shadowColor: Color(0xffbebebe),
            elevation: 1,
            title: Container(
              // height: screenHeight * 0.3,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => {
                        Navigator.of(context, rootNavigator: true).push(
                            SlideRoute(
                                widget: Search(callback: (Position location) {
                          Navigator.of(context, rootNavigator: false)
                              .push(FadeRoute(
                                  widget: MapScreen(
                            locationData: location,
                          )));
                        })))
                        // Navigator.push(context,)
                        // widget.rootPush()
                      },
                      child: Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: 24, right: 24),
                            child: Hero(
                              tag: 'find-a-place',
                              child: Material(
                                type: MaterialType.transparency,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    color: Colors.white,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  child: Center(
                                    child: Text('Embark on a journey',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Container(
                          //   decoration: BoxDecoration(
                          //     borderRadius: BorderRadius.circular(16),
                          //     color: Colors.white,
                          //   ),
                          //   padding: EdgeInsets.symmetric(
                          //     vertical: 16,
                          //   ),
                          //   child: Center(
                          //     child: Text('Find a place',
                          //         style: TextStyle(
                          //             color: Colors.black, fontSize: 16)),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    // OpenContainer(
                    //   transitionType: _containerTransitionType,
                    //   transitionDuration: Duration(milliseconds: 500),
                    //   openBuilder: (context, _) => Search(),
                    //   closedElevation: 0,
                    //   closedShape: RoundedRectangleBorder(
                    //       borderRadius: BorderRadius.circular(16),
                    //       side: BorderSide(color: Colors.white, width: 1)),
                    //   closedBuilder: (context, _) =>
                    // ),
                  )
                ],
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: [StretchMode.zoomBackground],
              background: Stack(fit: StackFit.expand, children: [
                Positioned(
                  top: -100,
                  child: Hero(
                      tag: 'map',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Opacity(
                          opacity: 0,
                          child: Container(
                            height: 400,
                            width: screenWidth,
                          ),
                        ),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(left: 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40)),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1493780474015-ba834fd0ce2f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1626&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ]),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 24),
                          child: Text('Featured trips',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 21)),
                        )
                      ],
                    ),
                    Container(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                              padding: EdgeInsets.only(top: 12),
                              height: screenWidth * 0.6,
                              child: FutureBuilder(
                                future: _mostViewedTours,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState !=
                                      ConnectionState.done) {
                                    return Center(child: Loading());
                                  }
                                  List<Tour> items = snapshot.data;
                                  return ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: items.length,
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () => {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .push(SlideRoute(
                                                        widget: TourScreen(
                                                  id: items[index].id,
                                                  coverImage:
                                                      items[index].coverImage,
                                                )))
                                              },
                                              child: Container(
                                                margin: EdgeInsets.fromLTRB(
                                                    index == 0 ? 24 : 0,
                                                    0,
                                                    12,
                                                    0),
                                                width: screenWidth * 0.5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Expanded(
                                                        child: Hero(
                                                      tag: items[index]
                                                              .id
                                                              .toString() +
                                                          '-image',
                                                      child: Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      16.0),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: ImageUtil
                                                                .getImageUrlByIdentifier(
                                                                    ImageType
                                                                        .TOUR_COVER,
                                                                    items[index]
                                                                        .coverImage),
                                                            fit: BoxFit.cover,
                                                            width: screenWidth *
                                                                0.5,
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                                    Container(
                                                      height: 9,
                                                    ),
                                                    Text(
                                                      items[index].title,
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        );
                                      });
                                },
                              )),
                        )
                      ],
                    ),
                    Container(
                      height: 24,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          children: [
                            Feature(
                              icon: bonfireSvg,
                              onPressed: () => {},
                              title: 'Experience Nature',
                            ),
                            Feature(
                              icon: boatSvg,
                              onPressed: () => {},
                              title: 'Oceanic Activities',
                            ),
                            Feature(
                              icon: pizzaSvg,
                              onPressed: () => {},
                              title: 'Culinary Journey  ',
                            ),
                          ],
                        ))
                      ],
                    ),
                    Container(
                      height: 24,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      height: (screenWidth * 0.7),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                'https://i.imgur.com/N4LJLIk.jpg',
                                fit: BoxFit.cover,
                              )),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 48,
                                ),
                                Text(
                                  'Trip name',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                Container(
                                  height: 3,
                                ),
                                Text(
                                  'Host a special and unique trip to the world',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                Container(
                                  height: 24,
                                ),
                                // ConstrainedBox(
                                //   constraints: BoxConstraints(maxWidth: 180),
                                //   child: Button(
                                //       input: ButtonInput(
                                //           label: 'Apply now',
                                //           onPressed: () => {},
                                //           backgroundColor: Color(0xff8C456F),
                                //           color: Colors.white)),
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      height: (screenWidth * 0.7),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.network(
                                'https://i.imgur.com/N4LJLIk.jpg',
                                fit: BoxFit.cover,
                              )),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 48,
                                ),
                                Text(
                                  'Trip name',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24),
                                ),
                                Container(
                                  height: 3,
                                ),
                                Text(
                                  'Host a special and unique trip to the world',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 14),
                                ),
                                Container(
                                  height: 24,
                                ),
                                // ConstrainedBox(
                                //   constraints: BoxConstraints(maxWidth: 180),
                                //   child: Button(
                                //       input: ButtonInput(
                                //           label: 'Apply now',
                                //           onPressed: () => {},
                                //           backgroundColor: Color(0xff8C456F),
                                //           color: Colors.white)),
                                // )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
