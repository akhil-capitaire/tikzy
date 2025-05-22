import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<DateTime?> showCustomCupertinoDatePicker(
  BuildContext context, {
  required DateTime initialDate,
  required DateTime minimumDate,
  required DateTime maximumDate,
}) {
  DateTime selectedDate = initialDate;

  return showModalBottomSheet<DateTime>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        height: 300,
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Text(
                    'Select Date',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Text('Done'),
                    onPressed: () => Navigator.of(context).pop(selectedDate),
                  ),
                ],
              ),
            ),

            // Divider
            const Divider(height: 1),

            // CupertinoDatePicker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
                initialDateTime: initialDate,
                onDateTimeChanged: (date) => selectedDate = date,
              ),
            ),
          ],
        ),
      );
    },
  );
}
