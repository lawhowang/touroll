import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:table_calendar/table_calendar.dart';

CalendarStyle customCalendarStyle(BuildContext context) {
  return CalendarStyle(
      selectedDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
          borderRadius: null),
      rangeStartDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
          borderRadius: null),
      rangeEndDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).primaryColor,
          borderRadius: null),
      rangeHighlightColor: Theme.of(context).primaryColor.withAlpha(128),
      todayDecoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).buttonColor,
          borderRadius: null));
}
