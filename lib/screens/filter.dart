import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

final ALL_ACTIVITIES = [
  {
    'name': 'Camping',
    'path': 'assets/svg/bonfire.svg',
  },
  {
    'name': 'Biking',
    'path': 'assets/svg/bonfire.svg',
  },
  {
    'name': 'Fishing',
    'path': 'assets/svg/bonfire.svg',
  },
  {
    'name': 'Sport',
    'path': 'assets/svg/bonfire.svg',
  },
  {
    'name': 'Party',
    'path': 'assets/svg/bonfire.svg',
  },
];

class Feature extends StatefulWidget {
  final List<String> activities;
  final String path;
  final Function onTap;
  final String title;
  const Feature({Key key, this.path, this.onTap, this.title, this.activities})
      : super(key: key);

  @override
  _FeatureState createState() => _FeatureState();
}

class _FeatureState extends State<Feature> {
  bool selected = false;

  @override
  void initState() {
    super.initState();

    if (widget.activities.contains(widget.title)) {
      setState(() {
        selected = true;
      });
    } else {
      setState(() {
        selected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Theme.of(context).accentColor : Color(0xfff6f6f6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          setState(() {
            selected = !selected;
          });
          widget.onTap();
        },
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: 0,
                    bottom: 12,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xb1C8B67E)),
                    ),
                  ),
                  SvgPicture.asset(
                    widget.path,
                    semanticsLabel: widget.title,
                    color: selected ? Colors.white : Colors.black,
                    width: 32,
                    height: 32,
                  ),
                ],
              ),
              Container(
                height: 12,
              ),
              Text(
                widget.title,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.black,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FilterScreen extends StatefulWidget {
  final Function callback;
  final String sortBy;
  final List<String> activities;
  FilterScreen({Key key, @required this.callback, this.activities, this.sortBy})
      : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String sortBy = 'startDate';
  List<String> activities = [];
  final Widget closeSvg = SvgPicture.asset(
    'assets/svg/outline/close.svg',
    semanticsLabel: 'close',
    color: Colors.black,
    width: 26,
    height: 26,
  );

  // **** INIT SET activities = widget.activities ****

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            widget.callback(activities, sortBy);
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.arrow_back_ios_rounded),
        ),
        title: Text('Filter'),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              Container(
                // margin: EdgeInsets.symmetric(horizontal: 24),
                padding: EdgeInsets.symmetric(vertical: 12),
                // decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: Color(0xffe3e3e3)))),
                child: Row(
                  children: [
                    Text('Sort by',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18))
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Material(
                      color: sortBy == 'startDate'
                          ? Theme.of(context).accentColor
                          : Color(0xfff6f6f6),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          setState(() {
                            sortBy = 'startDate';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                          child: Center(
                              child: Text('Date',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: sortBy == 'startDate'
                                          ? Colors.white
                                          : Color(0xfff1a1a1a)))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 12,
                  ),
                  Expanded(
                    child: Material(
                      color: sortBy == 'price'
                          ? Theme.of(context).accentColor
                          : Color(0xfff6f6f6),
                      borderRadius: BorderRadius.circular(14),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () {
                          setState(() {
                            sortBy = 'price';
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                          child: Center(
                              child: Text('Price',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: sortBy == 'price'
                                          ? Colors.white
                                          : Color(0xfff1a1a1a)))),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                height: 24,
              ),
              // Text(activities.toString()),
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                // decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: Color(0xffe3e3e3)))),
                child: Row(
                  children: [
                    Text('Activities',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18))
                  ],
                ),
              ),
              GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: ALL_ACTIVITIES.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: (1 / 1),
                ),
                itemBuilder: (
                  context,
                  index,
                ) {
                  return Feature(
                    path: 'assets/svg/bonfire.svg',
                    title: ALL_ACTIVITIES[index]['name'],
                    activities: activities,
                    onTap: () {
                      setState(() {
                        if (activities
                                .contains(ALL_ACTIVITIES[index]['name']) ==
                            false)
                          activities.add(ALL_ACTIVITIES[index]['name']);
                        else
                          activities.remove(ALL_ACTIVITIES[index]['name']);
                      });
                    },
                  );
                },
              ),
              // GridView.count(
              //   physics: NeverScrollableScrollPhysics(),
              //   shrinkWrap: true,
              //   crossAxisCount: 2,
              //   children: List.generate(ALL_ACTIVITIES.length, (index) {
              //     return Feature(
              //       path: 'assets/svg/bonfire.svg',
              //       title: ALL_ACTIVITIES[index]['name'],
              //       activities: activities,
              //       onTap: () {
              //         setState(() {
              //           if (activities
              //                   .contains(ALL_ACTIVITIES[index]['name']) ==
              //               false)
              //             activities.add(ALL_ACTIVITIES[index]['name']);
              //           else
              //             activities.remove(ALL_ACTIVITIES[index]['name']);
              //         });
              //       },
              //     );
              //   }),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
