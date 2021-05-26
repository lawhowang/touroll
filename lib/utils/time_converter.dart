class TimeConverter {
  static int timeToDay(int time) {
    return (time / 1440).ceil();
  }

  static String formatTime(int time) {
    String s = '';
    int hour = ((time % (24 * 60)) / 60).floor();
    int minutes = time % 60;
    bool isPm = (time % 1440) >= (12 * 60);
    s += hour.toString();
    if (minutes != 0) {
      s += ':';
      if (minutes < 10) {
        s += '0';
      }
      s += minutes.toString();
    }
    s += (isPm ? 'pm' : 'am');
    return s;
  }
}
