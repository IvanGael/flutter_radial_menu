
import 'package:flutter/material.dart';
import 'dart:math' as math;

class RadialMenu extends StatefulWidget {
  const RadialMenu({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RadialMenuState createState() => _RadialMenuState();
}

class _RadialMenuState extends State<RadialMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: RadialAnimation(controller: controller),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (controller.isDismissed) {
            controller.forward();
          } else {
            controller.reverse();
          }
        },
        child: const Icon(Icons.menu),
      ),
    );
  }
}

class RadialAnimation extends StatelessWidget {
  RadialAnimation({super.key, required this.controller})
      : translation = Tween<double>(
          begin: 0.0,
          end: 100.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.linear,
          ),
        ),
        scale = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: controller,
            curve: Curves.bounceInOut,
          ),
        );

  final AnimationController controller;
  final Animation<double> translation;
  final Animation<double> scale;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: scale.value,
          child: Transform.translate(
            offset: Offset(0.0, translation.value),
            child: Center(
              child: Container(
                width: 200.0,
                height: 200.0,
                child: RadialMenuItems(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class RadialMenuItems extends StatelessWidget {
  final List<Widget> menuItems = [
    RadialMenuItem(icon: Icons.home, text: 'Home'),
    RadialMenuItem(icon: Icons.search, text: 'Search'),
    RadialMenuItem(icon: Icons.notifications, text: 'Notifications'),
    RadialMenuItem(icon: Icons.settings, text: 'Settings'),
  ];

  RadialMenuItems({super.key});

  @override
  Widget build(BuildContext context) {
    return RadialMenuStack(items: menuItems);
  }
}

class RadialMenuStack extends StatelessWidget {
  final List<Widget> items;

  RadialMenuStack({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: items.asMap().entries.map((entry) {
        final index = entry.key;
        final angle = -(math.pi / 2) + (math.pi / 2 / (items.length - 1) * index);

        return Positioned(
          right: math.cos(angle) * 80.0,
          bottom: math.sin(angle) * 80.0,
          child: items[index],
        );
      }).toList(),
    );
  }
}


class RadialMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;

  RadialMenuItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(height: 5.0),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

