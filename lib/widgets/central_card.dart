import 'package:flutter/material.dart';

class CentralCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry margin;

  const CentralCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 5),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: margin,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: child,
      )
    );
  }
}