import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';

class AddDateTaskBar extends StatelessWidget {
  const AddDateTaskBar({Key? key, this.dateTime}) : super(key: key);
  final Function(DateTime)? dateTime;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: Colors.blue,
        selectedTextColor: Colors.white,
        dateTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        monthTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        onDateChange: (date) {
          dateTime!(date);
        },
      ),
    );
  }
}
