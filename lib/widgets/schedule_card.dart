import 'package:flutter/material.dart';
import '../models/class_schedule.dart';

class ScheduleCard extends StatelessWidget {
  final ClassSchedule item;
  final VoidCallback onTap;

  const ScheduleCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBatal = item.isCancelled;

    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: isBatal
            ? Colors.grey.shade200
            : (item.isMakeup ? Colors.orange.shade50 : Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    item.startTime,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isBatal ? Colors.grey : const Color(0xFF4A00E0),
                      decoration: isBatal ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const Text("|", style: TextStyle(color: Colors.grey)),
                  Text(
                    item.endTime,
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: isBatal ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.course,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isBatal ? Colors.grey : Colors.black,
                        decoration: isBatal ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: isBatal ? Colors.grey.shade400 : Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          item.room,
                          style: TextStyle(
                            color: isBatal ? Colors.grey.shade400 : Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    if (isBatal || item.isMakeup) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          if (isBatal)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "DIBATALKAN",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          if (isBatal && item.isMakeup)
                            const SizedBox(width: 5),
                          if (item.isMakeup)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "KELAS PENGGANTI",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
