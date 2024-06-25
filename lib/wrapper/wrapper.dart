import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile3_midterm/screens/homescreen.dart';

class homeWrapper extends StatefulWidget {
  final Widget? child;
  const homeWrapper({super.key, this.child});

  @override
  State<homeWrapper> createState() => _homeWrapperState();
}

class _homeWrapperState extends State<homeWrapper> {
  int index = 0;
  List<String> routes = [sentimentanalysis.route, "/logout"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child ?? const Placeholder(),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: index,
          onTap: (i) {
            setState(() {
              index = i;
              GoRouter.of(context).go(routes[index]);
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings")
          ]),
    );
  }
}
