import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventDialog extends StatelessWidget {
  final GameEvent event;
  final Function(EventOption) onOptionSelected;

  const EventDialog({
    super.key,
    required this.event,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: 340,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2D1B2E), // Dark purple/brown theme
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black38,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
              ),
              child: Text(
                event.icon,
                style: const TextStyle(fontSize: 48),
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              event.title,
              style: const TextStyle(
                color: Colors.purpleAccent,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Serif', // Use default serif for "ancient" feel
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            
            // Description
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                event.description,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            
            // Options
            ...event.options.map((option) => _buildOptionButton(context, option)),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, EventOption option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onOptionSelected(option),
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.purple.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  option.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (option.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    option.description,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
