import 'package:flutter/material.dart';


class WeakTopicDashboardCard extends StatefulWidget {
  final String topicName;
  final int currentPoints;
  final VoidCallback onPlayPressed; 

  const WeakTopicDashboardCard({
    super.key,
    required this.topicName,
    required this.currentPoints,
    required this.onPlayPressed,
  });

  @override
  State<WeakTopicDashboardCard> createState() => _WeakTopicDashboardCardState();
}

class _WeakTopicDashboardCardState extends State<WeakTopicDashboardCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _bounceAnimation = Tween<double>(begin: 0.0, end: -12.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bounceAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF222244),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: Colors.orangeAccent, width: 2.5),
            boxShadow: [
              BoxShadow(
                color: Colors.orangeAccent.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            children: [
              
              Transform.translate(
                offset: Offset(0, _bounceAnimation.value),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2), 
                    shape: BoxShape.circle,
                  ),
                  child: const Text("🤖", style: TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "LEVEL UP MISSION 🎯",
                      style: TextStyle(
                        color: Colors.orangeAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.topicName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                   
                    Stack(
                      children: [
                        Container(
                          height: 12,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade800,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: (widget.currentPoints / 100).clamp(0.15, 1.0),
                          child: Container(
                            height: 12,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.orange, Colors.amber],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Energy: ${widget.currentPoints} XP ⚡",
                      style: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              
              
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  foregroundColor: Colors.black,
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(12),
                  elevation: 4,
                ),
                onPressed: widget.onPlayPressed, 
                child: const Icon(Icons.play_arrow_rounded, size: 26),
              ),
            ],
          ),
        );
      },
    );
  }
}