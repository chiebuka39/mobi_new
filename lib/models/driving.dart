import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'driving.g.dart';

@HiveType(typeId: 3)
enum DrivingState {
  @HiveField(0)
  Does_Not_Drive,
  @HiveField(1)
  Drives,
  @HiveField(2)
  Drives_Once_A_While
}

const drivingStateInt = <DrivingState, int>{
  DrivingState.Does_Not_Drive: 0,
  DrivingState.Drives: 1,
  DrivingState.Drives_Once_A_While: 3,
};

@HiveType(typeId: 20)
class TimeOfDayCustom {
  /// Creates a time of day.
  ///
  /// The [hour] argument must be between 0 and 23, inclusive. The [minute]
  /// argument must be between 0 and 59, inclusive.
  const TimeOfDayCustom({ @required this.hour, @required this.minute });

  /// Creates a time of day based on the given time.
  ///
  /// The [hour] is set to the time's hour and the [minute] is set to the time's
  /// minute in the timezone of the given [DateTime].
  TimeOfDayCustom.fromDateTime(DateTime time)
      : hour = time.hour,
        minute = time.minute;

  /// Creates a time of day based on the current time.
  ///
  /// The [hour] is set to the current hour and the [minute] is set to the
  /// current minute in the local time zone.
  factory TimeOfDayCustom.now() { return TimeOfDayCustom.fromDateTime(DateTime.now()); }

  /// The number of hours in one day, i.e. 24.
  static const int hoursPerDay = 24;

  /// The number of hours in one day period (see also [DayPeriod]), i.e. 12.
  static const int hoursPerPeriod = 12;

  /// The number of minutes in one hour, i.e. 60.
  static const int minutesPerHour = 60;

  /// Returns a new TimeOfDay with the hour and/or minute replaced.
  TimeOfDay replacing({ int hour, int minute }) {
    assert(hour == null || (hour >= 0 && hour < hoursPerDay));
    assert(minute == null || (minute >= 0 && minute < minutesPerHour));
    return TimeOfDay(hour: hour ?? this.hour, minute: minute ?? this.minute);
  }

  /// The selected hour, in 24 hour time from 0..23.
  @HiveField(0)
  final int hour;

  /// The selected minute.
  @HiveField(1)
  final int minute;

  /// Whether this time of day is before or after noon.
  DayPeriod get period => hour < hoursPerPeriod ? DayPeriod.am : DayPeriod.pm;

  /// Which hour of the current period (e.g., am or pm) this time is.
  int get hourOfPeriod => hour - periodOffset;

  /// The hour at which the current period starts.
  int get periodOffset => period == DayPeriod.am ? 0 : hoursPerPeriod;



  @override
  bool operator ==(Object other) {
    return other is TimeOfDay
        && other.hour == hour
        && other.minute == minute;
  }

  @override
  int get hashCode => hashValues(hour, minute);
  TimeOfDay toTimeOfDay(){
    return TimeOfDay(hour: hour,minute: minute);
  }

  static TimeOfDayCustom fromTimeOfDay(TimeOfDay timeOfDay){
    return TimeOfDayCustom(hour: timeOfDay.hour,minute: timeOfDay.minute);
  }

  @override
  String toString() {
    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10)
        return '0$value';
      return value.toString();
    }

    final String hourLabel = _addLeadingZeroIfNeeded(hour);
    final String minuteLabel = _addLeadingZeroIfNeeded(minute);

    return '$TimeOfDay($hourLabel:$minuteLabel)';
  }
}
