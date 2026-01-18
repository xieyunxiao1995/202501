import 'package:flutter/material.dart';
import '../models/event_model.dart';

class EventScreen extends StatelessWidget {
  final GameEvent event;
  final Function(EventOption) onOptionSelected;

  const EventScreen({
    super.key,
    required this.event,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF2D1B2E),
              const Color(0xFF111827),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header/Icon Section
              Expanded(
                flex: isSmallScreen ? 2 : 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 20 : 32),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.purpleAccent.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.purpleAccent.withOpacity(0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Text(
                        event.icon,
                        style: TextStyle(fontSize: isSmallScreen ? 56 : 80),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),
                    Text(
                      event.title,
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: isSmallScreen ? 24 : 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              // Description Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 20 : 32),
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.purpleAccent.withOpacity(0.1)),
                  ),
                  child: Text(
                    event.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: isSmallScreen ? 14 : 16,
                      height: 1.6,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              SizedBox(height: isSmallScreen ? 24 : 40),

              // Options Section
              Padding(
                padding: EdgeInsets.only(
                  left: isSmallScreen ? 20 : 32,
                  right: isSmallScreen ? 20 : 32,
                  bottom: isSmallScreen ? 20 : 40,
                ),
                child: Column(
                  children: event.options.map((option) => _buildOptionButton(context, option, isSmallScreen)).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(BuildContext context, EventOption option, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onOptionSelected(option),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              vertical: isSmallScreen ? 12 : 16,
              horizontal: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purpleAccent.withOpacity(0.3)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isSmallScreen ? 16 : 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (option.description.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          option.description,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: isSmallScreen ? 12 : 13,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.purpleAccent.withOpacity(0.5),
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
