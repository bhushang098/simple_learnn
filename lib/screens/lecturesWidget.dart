import 'dart:core';

import 'package:flutter/material.dart';
import 'package:simple/services/firestoreService.dart';

class VideoWidget extends StatefulWidget {
  List<VideoClass> _vidList;
  VideoWidget(this._vidList);

  @override
  _VideoWidgetState createState() => _VideoWidgetState();
}

class _VideoWidgetState extends State<VideoWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: widget._vidList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 3,
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    splashColor: Colors.teal[100],
                    onTap: () {
                      navtoVidScreen(widget._vidList[index]);
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.video_library,
                        size: 50,
                        color: Colors.green,
                      ),
                      title: Text(widget._vidList[index].title.toString()),
                      subtitle: Text(widget._vidList[index].author.toString()),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 3,
              ),
            ],
          );
        });
  }

  void navtoVidScreen(VideoClass vid) {
    Navigator.pushNamed(context, '/vidScreen', arguments: vid);
  }
}
