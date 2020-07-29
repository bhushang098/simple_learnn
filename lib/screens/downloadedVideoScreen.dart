import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple/screens/doenloadedVidPlayer.dart';

class DownloadvidScreen extends StatefulWidget {
  @override
  _DownloadvidScreenState createState() => _DownloadvidScreenState();
}

class _DownloadvidScreenState extends State<DownloadvidScreen> {
  File Vid;
  @override
  Widget build(BuildContext context) {
    Vid = ModalRoute.of(context).settings.arguments;
    return Stack(
      children: <Widget>[
        DownloadedVidPalyer(Vid),
      ],
    );
  }
}
