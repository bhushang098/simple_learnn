import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:simple/screens/videoPlayer.dart';
import 'package:simple/services/firestoreService.dart';

class NewVidScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    VideoClass vid = ModalRoute.of(context).settings.arguments;
    return Stack(
      children: <Widget>[
        DefaultPlayer(vid.url),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            child: Icon(
              Icons.file_download,
            ),
            tooltip: 'Download Video',
            onPressed: () {
              Fluttertoast.showToast(msg: 'Feature Comming Soon');
              //TODO : implimenet Downoad functionality and getrive more data using vidClass
            },
          ),
        ),
      ],
    );
  }
}
