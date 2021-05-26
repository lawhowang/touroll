import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:touroll/components/activity_block.dart';
import 'package:touroll/components/button.dart';
import 'package:touroll/models/activity.dart';
import 'package:touroll/models/tour.dart';
import 'package:touroll/components/loading.dart';
import 'package:touroll/screens/channel.dart';
import 'package:touroll/screens/me/new_tour.dart';
import 'package:touroll/screens/new_activity.dart';
import 'package:touroll/screens/reserve.dart';
import 'package:touroll/services/activity.dart';
import 'package:touroll/services/chat.dart';
import 'package:touroll/services/tour.dart';
import 'package:touroll/services/upload.dart';
import 'package:touroll/stream/client.dart';
import 'package:touroll/utils/time_converter.dart';
import 'package:touroll/utils/image.dart';

final List<String> imgList = [
  'https://images.unsplash.com/photo-1509023464722-18d996393ca8?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MTJ8fGphcGFufGVufDB8fDB8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=60',
  'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
  'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
  'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
  'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80'
];

final List<Widget> imageSliders = imgList
    .map(
      (item) => Image.network(
        item,
        fit: BoxFit.cover,
        height: 1000,
      ),
    )
    .toList();

class ReviewInput {
  String author;
  double rating;
  String comment;
  ReviewInput({this.author, this.comment, this.rating});
}

class Review extends StatelessWidget {
  final ReviewInput input;
  const Review({Key key, @required this.input}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
        // decoration: BoxDecoration(
        //   border: Border(bottom: BorderSide(width: 1, color: Colors.black26)),
        // ),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              padding: EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffe3e3e3))),
              ),
              child: Row(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Text(
                          '8/10',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Container(
                          height: 9,
                        ),
                        Text(
                          'Author',
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 60,
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      // padding: EdgeInsets.only(right: 24),
                      child: Column(
                        children: [
                          Text(
                            'lorem ipsum dolor sit ameonsectetur adipiscing elit lorem ipsum dolor sit amet consectetur adipiscing elit lorem ipsum dolor sit amet consectetur adipiscing elit lorem ipsum dolor sit amet consectetur adipiscing elit',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: Color(0xff8e8e8e)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class TourScreen extends StatefulWidget {
  final int id;
  final String coverImage;
  final String coverImageTag;
  TourScreen({Key key, this.id, this.coverImage, this.coverImageTag})
      : super(key: key);

  @override
  _TourScreenState createState() => _TourScreenState();
}

class _TourScreenState extends State<TourScreen> {
  // final TourInput tour;
  final tourService = TourService();
  final chatService = ChatService();
  final activityService = ActivityService();
  final uploadService = UploadService();
  final picker = ImagePicker();

  Future<Tour> tour;

  @override
  void initState() {
    super.initState();
    getTour();
  }

  void getTour() {
    tour = tourService.getTour(widget.id, ['activities', 'organizer']);
  }

  void openConversation(String userId) async {
    Channel channel = await chatService.newChat(userId);
    //print(channelId);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ChannelPage(
                  channel: channel,
                )));
  }

  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder(
          future: tour,
          builder: (context, snapshot) {
            Tour tour = snapshot.connectionState == ConnectionState.done
                ? snapshot.data
                : null;
            List<ActivityBlock> activityBlocks = [];
            List<Widget> additionalImages = [];
            if (tour != null) {
              tour.activities.asMap().forEach((index, activity) {
                int day = TimeConverter.timeToDay(activity.time);
                bool showDay =
                    index == 0 ? true : activityBlocks[index - 1].day != day;
                bool hasNext = index != tour.activities.length - 1 &&
                    TimeConverter.timeToDay(tour.activities[index + 1].time) ==
                        day;
                if (activity.image != null)
                  additionalImages.add(
                    CachedNetworkImage(
                        imageUrl: ImageUtil.getImageUrlByIdentifier(
                            ImageType.ACTIVITY_IMAGE, activity.image),
                        fit: BoxFit.cover),
                  );
                activityBlocks.add(ActivityBlock(
                  activity: activity,
                  day: day,
                  showDay: showDay,
                  hasNext: hasNext,
                  onDelete: tour.organizer.firebaseUid ==
                          FirebaseAuth.instance.currentUser?.uid
                      ? () async {
                          await activityService.deleteActivity(activity.id);
                          this.setState(() {
                            getTour();
                          });
                        }
                      : null,
                ));
              });
            }
            return Stack(children: [
              CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      stretch: true,
                      expandedHeight: screenHeight * 0.5,
                      backgroundColor: Colors.white,
                      pinned: true,
                      shadowColor: Color(0xffbebebe),
                      elevation: 1,
                      actions: [
                        PopupMenuButton<String>(
                          onSelected: (s) {
                            if (s == 'Edit tour') {
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              NewTourScreen(id: widget.id)))
                                  .then((value) {
                                setState(() {
                                  getTour();
                                });
                              });
                            }
                            if (s == 'Add activity') {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => NewActivityScreen(
                                          tourId: tour.id,
                                          days: tour.days))).then((value) {
                                setState(() {
                                  getTour();
                                });
                              });
                            }
                            if (s == 'Report') {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('Report'),
                                      content: Text('Reported successfully.'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text('OK'))
                                      ],
                                    );
                                  });
                            }
                          },
                          icon: Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) {
                            List<String> op = [];
                            if (tour.organizer.firebaseUid ==
                                FirebaseAuth.instance.currentUser?.uid) {
                              op.add('Edit tour');
                              op.add('Add activity');
                            }
                            return {...op, 'Report'}.map((String choice) {
                              return PopupMenuItem<String>(
                                value: choice,
                                child: Text(choice),
                              );
                            }).toList();
                          },
                        ),
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        stretchModes: [StretchMode.zoomBackground],
                        background: Stack(
                          fit: StackFit.expand,
                          children: [
                            CarouselSlider(
                              items: [
                                Hero(
                                  tag: widget.coverImageTag ??
                                      widget.id.toString() + '-image',
                                  child: Material(
                                    type: MaterialType.transparency,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          ImageUtil.getImageUrlByIdentifier(
                                              ImageType.TOUR_COVER,
                                              widget.coverImage ??
                                                  tour?.coverImage ??
                                                  null),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                ...additionalImages
                              ],
                              options: CarouselOptions(
                                viewportFraction: 1,
                                height: screenHeight * 0.6,
                                enlargeCenterPage: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (tour != null)
                      SliverList(
                          delegate: SliverChildListDelegate([
                        Stack(
                          children: [
                            // Positioned(
                            //   top: -200,
                            //   child: Hero(
                            //     tag: 'map',
                            //     child: Material(
                            //       type: MaterialType.transparency,
                            //       child: Opacity(
                            //         opacity: 0,
                            //         child: Container(
                            //           height: 400,
                            //           color: Colors.white,
                            //           width: screenWidth,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),

                            // Positioned(
                            //   top: 0,
                            //   child: Hero(
                            //     tag: 'search-bar',
                            //     child: Material(
                            //       type: MaterialType.transparency,
                            //       child: Opacity(
                            //         opacity: 0,
                            //         child: Container(
                            //           height: 0,
                            //           width: screenWidth,
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ),
                            Container(
                              color: Colors.white,
                              padding: EdgeInsets.all(24),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              tour.title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            )
                                          ],
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 12)),
                                        Row(
                                          children: [
                                            Text(
                                              tour.description,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  fontSize: 12,
                                                  color: Color(0xFF7e7e7e)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                    Button(
                                      label: 'Join' +
                                          ' (\$' +
                                          tour.price.toString() +
                                          ')',
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => ReserveScreen(
                                                    tour: tour,
                                                    tourId: tour.id,
                                                    days: tour.days,
                                                    firstDay: tour.startDate,
                                                    lastDay: tour.endDate)));
                                      },
                                    )
                                  ]),
                            ),
                          ],
                        ),
                        Container(
                          height: 1,
                          color: Color(0xFFF2F2F2),
                        ),
                        IntrinsicHeight(
                            child: Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(top: 24),
                          child: Column(
                            children: [
                              IntrinsicHeight(
                                child: Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(left: 24, right: 24),
                                  child: Column(
                                    children: activityBlocks,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                  ),
                                ),
                              ),
                              IntrinsicHeight(
                                child: Container(
                                  color: Colors.white,
                                  margin: EdgeInsets.only(bottom: 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(24),
                                          child: Column(
                                            children: [
                                              Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100),
                                                    color: Colors.black12,
                                                  ),
                                                  width: 80,
                                                  height: 80,
                                                  child:
                                                      tour.organizer.icon ==
                                                              null
                                                          ? null
                                                          : ClipOval(
                                                              child:
                                                                  CachedNetworkImage(
                                                                imageUrl: ImageUtil.getImageUrlByIdentifier(
                                                                    ImageType
                                                                        .USER_ICON,
                                                                    tour.organizer
                                                                        .icon),
                                                              ),
                                                            )),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 12)),
                                              Text(
                                                tour.organizer.name,
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 2,
                                        color: Color(0xfff6f6f6),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          padding: EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                tour.organizer.about,
                                                style: TextStyle(
                                                    color: Color(0xff8e8e8e),
                                                    fontSize: 12),
                                              ),
                                              if (tour.organizer.firebaseUid !=
                                                  FirebaseAuth
                                                      .instance.currentUser.uid)
                                                Button(
                                                    label: 'Message',
                                                    onPressed: () {
                                                      openConversation(tour
                                                          .organizer
                                                          .firebaseUid);
                                                    })
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // IntrinsicHeight(
                              //   child: Container(
                              //       margin: EdgeInsets.only(top: 2),
                              //       padding: EdgeInsets.symmetric(vertical: 24),
                              //       color: Colors.white,
                              //       child: Column(
                              //         children: [
                              //           Text(
                              //             'Reviews',
                              //             style: TextStyle(
                              //               fontWeight: FontWeight.w500,
                              //               fontSize: 16,
                              //             ),
                              //           ),
                              //           Container(
                              //             height: 18,
                              //           ),
                              //           Review(
                              //             input: ReviewInput(
                              //               author: 'Author',
                              //               comment: 'comments',
                              //               rating: 8.0,
                              //             ),
                              //           ),
                              //           Review(
                              //             input: ReviewInput(
                              //               author: 'Author',
                              //               comment: 'comments',
                              //               rating: 8.0,
                              //             ),
                              //           ),
                              //           Review(
                              //             input: ReviewInput(
                              //               author: 'Author',
                              //               comment: 'comments',
                              //               rating: 8.0,
                              //             ),
                              //           )
                              //         ],
                              //       )),
                              // ),
                              // IntrinsicHeight(
                              //   child: Container(
                              //     margin: EdgeInsets.only(top: 2),
                              //     color: Colors.white,
                              //     child: Column(children: [

                              //     ],),
                              //   ),
                              // )
                            ],
                          ),
                        )),
                      ]))
                    else
                      SliverFillRemaining(
                        child: Center(
                          child: Loading(),
                        ),
                      )
                  ]),
              Positioned(
                bottom: -100,
                child: Hero(
                  tag: 'navigation-bar',
                  child: Material(
                    type: MaterialType.transparency,
                    child: Opacity(
                      opacity: 0,
                      child: Container(
                        height: 100,
                        color: Colors.transparent,
                        width: screenWidth,
                      ),
                    ),
                  ),
                ),
              ),
            ]);
          },
        ));
  }
}
