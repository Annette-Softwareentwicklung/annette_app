enum Weekdays {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
  error
}

extension WeekdaysExt on Weekdays {
  static int toNumber(Weekdays day) {
    switch (day) {
      case Weekdays.monday:
        return 1;
      case Weekdays.tuesday:
        return 2;
      case Weekdays.wednesday:
        return 3;
      case Weekdays.thursday:
        return 4;
      case Weekdays.friday:
        return 5;
      case Weekdays.saturday:
        return 6;
      case Weekdays.sunday:
        return 7;
      default:
        return -1;
    }
  }
}
