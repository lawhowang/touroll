import 'package:flutter/material.dart';
import 'package:touroll/components/button.dart';
import 'package:touroll/components/route/fade.dart';
import 'package:touroll/components/route/slide.dart';
import 'package:touroll/models/reservation.dart';
import 'package:touroll/components/loading.dart';
import 'package:touroll/models/tour.dart';
import 'package:touroll/screens/details.dart';
import 'package:touroll/screens/success.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:touroll/screens/tour.dart';
import 'package:touroll/services/reservation.dart';
import 'package:touroll/services/tour.dart';
import 'package:touroll/styles/calendar.dart';

class ReserveScreen extends StatefulWidget {
  final int tourId;
  final int days;
  final DateTime firstDay;
  final DateTime lastDay;
  final Tour tour;
  ReserveScreen(
      {Key key, this.tour, this.tourId, this.days, this.firstDay, this.lastDay})
      : super(key: key);

  @override
  _ReserveScreenState createState() => _ReserveScreenState();
}

class _ReserveScreenState extends State<ReserveScreen> {
  final tourService = TourService();
  final reservationService = ReservationService();
  Future<List<Reservation>> reservations;
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime firstDay;
  DateTime selectedDate;
  DateTime focusedDate;
  DateTime rangeStart, rangeEnd;
  RangeSelectionMode rangeSelectionMode = RangeSelectionMode.toggledOn;
  //List<Reservation> reservations = [];
  bool reserving = false;

  @override
  void initState() {
    reservations = tourService.getTourReservations(widget.tourId);
    firstDay = DateTime.now().isAfter(widget.firstDay)
        ? DateTime.now()
        : widget.firstDay;
    firstDay = DateTime(firstDay.year, firstDay.month, firstDay.day);
    focusedDate = firstDay;
    super.initState();
  }

  bool reserved(List<Reservation> reservations, DateTime date) {
    date = DateTime(date.year, date.month, date.day);
    for (final reservation in reservations) {
      if ((date.isAtSameMomentAs(reservation.startDate) ||
              date.isAfter(reservation.startDate)) &&
          (date.isBefore(reservation.endDate) ||
              date.isAtSameMomentAs(reservation.endDate))) {
        return true;
      }
    }
    return false;
  }

  bool overlapped(
      List<Reservation> reservations, DateTime rangeStart, DateTime rangeEnd) {
    // rangeStart 15 16
    // 16 17
    rangeStart = DateTime(rangeStart.year, rangeStart.month, rangeStart.day);
    rangeEnd = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);
    if (rangeEnd.isAfter(widget.lastDay) || rangeStart.isBefore(firstDay)) {
      return true;
    }
    for (final reservation in reservations) {
      if ((reservation.startDate.isBefore(rangeEnd) ||
              reservation.startDate.isAtSameMomentAs(rangeEnd)) &&
          (reservation.endDate.isAfter(rangeStart) ||
              reservation.endDate.isAtSameMomentAs(rangeStart))) {
                print(reservation.toJson());
        return true;
      }
    }
    return false;
  }

  void dateError(String message) {
    AlertDialog alert = AlertDialog(
      title: Text("Sorry..."),
      content: Text("$message"),
      actions: [
        Button(label: "OK", onPressed: () => Navigator.of(context).pop())
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Reserve',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: FutureBuilder(
          future: reservations,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TableCalendar(
                      availableGestures: AvailableGestures.horizontalSwipe,
                      calendarStyle: customCalendarStyle(context),
                      headerStyle: HeaderStyle(titleCentered: true),
                      calendarFormat: calendarFormat,
                      firstDay: firstDay,
                      lastDay: widget.lastDay,
                      rangeStartDay: rangeStart,
                      rangeEndDay: rangeEnd,
                      focusedDay: focusedDate,
                      rangeSelectionMode: rangeSelectionMode,
                      selectedDayPredicate: (day) {
                        return isSameDay(selectedDate, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        if (isSameDay(selectedDate, selectedDay)) return;
                        // remove offset
                        selectedDay = DateTime(selectedDay.year,
                            selectedDay.month, selectedDay.day);
                        DateTime start = selectedDay;
                        DateTime end =
                            selectedDay.add(Duration(days: widget.days - 1));
                            print(start);
                            print(end);
                        List<Reservation> reservations = snapshot.data;
                        if (overlapped(reservations, selectedDay, end)) {
                          bool found = false;
                          for (int i = 1; i < widget.days; i++) {
                            DateTime lstart =
                                selectedDay.subtract(Duration(days: i));
                            DateTime lend =
                                lstart.add(Duration(days: widget.days - 1));
                            if (!overlapped(reservations, lstart, lend)) {
                              start = lstart;
                              end = lend;
                              found = true;
                            }
                          }
                          if (!found) {
                            dateError(
                                'This day is not selectable because the days before/after are reserved already');
                            return;
                          }
                        }
                        setState(() {
                          selectedDate = selectedDay;
                          focusedDate = focusedDay;
                          rangeStart = start;
                          rangeEnd = end;
                          rangeSelectionMode = RangeSelectionMode.toggledOff;
                        });
                      },
                      availableCalendarFormats: {CalendarFormat.month: 'Month'},
                      onPageChanged: (focusedDay) {
                        focusedDate = focusedDay;
                      },
                      enabledDayPredicate: (day) {
                        List<Reservation> reservations = snapshot.data;
                        return !reserved(reservations, day);
                      },
                    ),
                    Button(
                      label: 'Reserve',
                      loading: reserving,
                      backgroundColor: Colors.amber,
                      onPressed: () async {
                        setState(() {
                          reserving = true;
                        });
                        try {
                          final reservation = await this
                              .reservationService
                              .createReservation(
                                  startDate: rangeStart,
                                  endDate: rangeEnd,
                                  tourId: widget.tourId);
                          Navigator.of(context, rootNavigator: true)
                              .push((FadeRoute(widget: SuccessScreen())));
                          // Navigator.of(context).replaceRouteBelow(
                          //     anchorRoute: FadeRoute(widget: TourScreen()),
                          //     newRoute: SlideRoute(
                          //         widget: DetailsScreen(
                          //       tour: widget.tour ?? widget.tour,
                          //     )));
                        } catch (ex) {}
                        setState(() {
                          reserving = false;
                        });
                      },
                    )
                  ],
                ),
              );
            }
            return Center(child: Loading());
          },
        ));
  }
}
