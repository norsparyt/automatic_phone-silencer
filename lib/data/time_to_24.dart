class TimeTo24 {
  Map convert(DateTime time) {
    Map t = {'hour': time.hour, 'timeOfDay': 'AM'};
    if (time.hour == 0) {
      t['hour'] = 12;
    }
    if (time.hour >= 12) {
      t['timeOfDay'] = 'PM';
      if (time.hour == 12)
        t['hour'] = 12;
      else
        t['hour'] = time.hour - 12;
    }
    return t;
  }
}
