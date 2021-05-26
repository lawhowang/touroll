import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:touroll/components/login_only.dart';
import 'package:touroll/components/route/slide.dart';
import 'package:touroll/models/reservation.dart';
import 'package:touroll/screens/tour.dart';
import 'package:touroll/services/user.dart';
import 'package:touroll/utils/image.dart';
import 'package:touroll/utils/pagination.dart';

class MyReservationsScreen extends StatefulWidget {
  MyReservationsScreen({Key key}) : super(key: key);

  @override
  _MyReservationsScreenState createState() => _MyReservationsScreenState();
}

class _MyReservationsScreenState extends State<MyReservationsScreen> {
  final userService = UserService();
  final pagination = Pagination();
  final PagingController<int, Reservation> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      pagination.fetchPage(
          userService.getReservations(after: pageKey, expand: ['tour']),
          _pagingController,
          pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoginOnly(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Trips'),
        ),
        body: PagedListView<int, Reservation>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<Reservation>(
              itemBuilder: (context, item, index) {
            return GestureDetector(
              onTap: () => {
                Navigator.of(context, rootNavigator: true).push(SlideRoute(
                    widget: TourScreen(
                  id: item.tour.id,
                  coverImageTag: 'reservations-tour-$index',
                  coverImage: item.tour.coverImage,
                )))
              },
              child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Hero(
                              tag: 'reservations-tour-' + index.toString(),
                              child: Material(
                                type: MaterialType.transparency,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: CachedNetworkImage(
                                    imageUrl: ImageUtil.getImageUrlByIdentifier(
                                        ImageType.TOUR_COVER,
                                        item.tour.coverImage),
                                    fit: BoxFit.cover,
                                    height: 180,
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
                            child: Text(item.tour.title,
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
                                item.startDate.toString().substring(0, 10) +
                                    ' ~ ' +
                                    item.endDate.toString().substring(0, 10),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w200,
                                    color: Color(0xff6e6e6e))),
                          )
                        ],
                      ),
                    ],
                  )),
            );
          }),
        ),
      ),
    );
  }
}
