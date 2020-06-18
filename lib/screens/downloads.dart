import 'package:flutter/material.dart';

class Downloaded extends StatefulWidget {
  @override
  _DownloadedState createState() => _DownloadedState();
}

class _DownloadedState extends State<Downloaded> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Downloads'),
      ),
    );
  }
}
