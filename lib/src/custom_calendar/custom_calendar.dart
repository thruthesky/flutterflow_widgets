import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:table_calendar/table_calendar.dart';

/// CustomCalendar
///
/// Displays a calendar with events.
class CustomCalendar extends StatefulWidget {
  const CustomCalendar({
    Key? key,
    this.locale = 'en_US',
    this.events = const {},
    required this.onDaySelected,
  }) : super(key: key);

  final String locale;
  final Map<DateTime, List<String>> events;

  final Function(List<String>?) onDaySelected;
  @override
  createState() => _CustomCalendarState();
}

class _CustomCalendarState extends State<CustomCalendar> {
  DateTime? _selectedDay;

  DateTime? _focusedDay;

  CalendarFormat _calendarFormat = CalendarFormat.month;

  late final LinkedHashMap kEvents;

  @override
  void initState() {
    super.initState();
    kEvents = LinkedHashMap<DateTime, List<String>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(widget.events);
  }

  /// 날짜 hashcode
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: widget.locale,
      firstDay: DateTime.utc(2022, 01, 01),
      lastDay: DateTime.utc(DateTime.now().year + 2),
      focusedDay: _focusedDay ?? DateTime.now(),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
        widget.onDaySelected(kEvents[selectedDay]);
      },
      calendarFormat: _calendarFormat,
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },
      eventLoader: (dt) => kEvents[dt] ?? [],
      calendarStyle: const CalendarStyle(
        markersAlignment: Alignment(.6, .9),
      ),
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          if (day.weekday == DateTime.sunday) {
            final text = DateFormat.E().format(day);

            return Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
          return null;
        },
        markerBuilder: (context, date, List<dynamic> event) {
          if (event.isEmpty) {
            return null;
          }
          return Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              color: Colors.red.shade500,
              shape: BoxShape.circle,
            ),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                event.length.toString(),
                style: const TextStyle(fontSize: 8, color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
