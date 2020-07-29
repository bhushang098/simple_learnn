import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple/screens/videoPlayer.dart';
import 'package:simple/services/firestoreService.dart';

class NewVidScreen extends StatefulWidget {
  @override
  _NewVidScreenState createState() => _NewVidScreenState();
}

class _NewVidScreenState extends State<NewVidScreen> {
  String downliadmesage = 'initializing...';
  bool isDownloading = false;
  double barpercentage = 0;
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
            onPressed: () async {
              setState(() {
                isDownloading = !isDownloading;
              });

              var dir = await getApplicationDocumentsDirectory();
              Dio dio = Dio();
              dio.download(vid.url, '${dir.path}/${vid.title}',
                  onReceiveProgress: (actualBytes, totalbytes) {
                setState(() {
                  var percentage = actualBytes / totalbytes * 100;
                  barpercentage = percentage / 100;
                  downliadmesage =
                      'Downloading .. ${percentage.floor().toString()} %';
                  if (percentage == 100) {
                    isDownloading = false;
                    Fluttertoast.showToast(
                        msg: 'File Downloaded',
                        backgroundColor: Colors.black54,
                        textColor: Colors.white);
                  }
                });
              });
              //Fluttertoast.showToast(msg: 'Feature Comming Soon');
              //TODO : implimenet Downoad functionality and getrive more data using vidClass
            },
          ),
        ),
        Center(
          child: Card(
            elevation: 3,
            child: messgeWrap(isDownloading),
          ),
        ),
      ],
    );
  }

  messgeWrap(bool isDownloading) {
    if (isDownloading)
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(downliadmesage),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: LinearProgressIndicator(
              backgroundColor: Colors.teal[100],
              value: barpercentage,
            ),
          )
        ],
      );
    else
      return Text('');
  }
}
