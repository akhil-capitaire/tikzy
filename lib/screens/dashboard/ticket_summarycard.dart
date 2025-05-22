import 'package:flutter/material.dart';

import '../../utils/fontsizes.dart';
import '../../utils/screen_size.dart';

class TicketSummaryCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const TicketSummaryCard({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenSize.width(4),
        vertical: ScreenSize.height(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: baseFontSize - 2,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: ScreenSize.height(0.5)),
          Text(
            '$count',
            style: TextStyle(
              color: color,
              fontSize: baseFontSize + 6,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
