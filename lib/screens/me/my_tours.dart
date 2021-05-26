import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:touroll/components/login_only.dart';
import 'package:touroll/components/route/slide.dart';
import 'package:touroll/models/tour.dart';
import 'package:touroll/screens/me/new_tour.dart';
import 'package:touroll/screens/tour.dart';
import 'package:touroll/services/user.dart';
import 'package:touroll/utils/image.dart';
import 'package:touroll/utils/pagination.dart';

class MyToursScreen extends StatefulWidget {
  MyToursScreen({Key key}) : super(key: key);

  @override
  _MyToursScreenState createState() => _MyToursScreenState();
}

class _MyToursScreenState extends State<MyToursScreen> {
  final userService = UserService();
  final pagination = Pagination();
  final PagingController<int, Tour> _pagingController =
      PagingController(firstPageKey: null);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      pagination.fetchPage(
          userService.getTours(after: pageKey), _pagingController, pageKey);
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
                title: Text('Tours'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) => NewTourScreen()));
                    },
                  )
                ],
              ),
              body: PagedListView<int, Tour>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<Tour>(
                    itemBuilder: (context, item, index) {
                  return GestureDetector(
                    onTap: () => {
                      Navigator.of(context, rootNavigator: true)
                          .push(SlideRoute(
                              widget: TourScreen(
                        id: item.id,
                        coverImageTag: 'tours-tour-$index',
                        coverImage: item.coverImage,
                      )))
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Hero(
                                    tag: 'tours-tour-' + index.toString(),
                                    child: Material(
                                      type: MaterialType.transparency,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              ImageUtil.getImageUrlByIdentifier(
                                                  ImageType.TOUR_COVER,
                                                  item.coverImage),
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
                                  child: Text(item.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                      )),
                                )
                              ],
                            ),
                          ],
                        )),
                  );
                }),
              ),
            ));
  }
}
