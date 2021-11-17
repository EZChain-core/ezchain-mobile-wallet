import 'package:flutter/material.dart';

class CrossScreen extends StatefulWidget {
  const CrossScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CrossScreenState();
}

class _CrossScreenState extends State<CrossScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('CrossScreen'),
      ),
    );
  }
}
