import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          children: <Widget>[
            Text(
              'This Learning  App Offers Recorded Classes and Conceptual Videos For Unique Learning Experiences You Will Find Everything On app Through Recorded videos , Concepts are Broken Down inTo bite sized Movies To Maximize Retention Of Knowledge \n\n Localised Video Lesions are Used to Various Ages from School Studies to Higher Education Great Video Tutorials by Your  Favourite Teachers .... \n\n\n we help Teachers to Make their Educational Content Available to all \n\n\n\n Contact:- \n simple.learn.edu@gmail.com \n Developer:-\n gurnulebhushan2091999@gmail.com',
              style: TextStyle(fontSize: 16, color: Colors.teal),
            )
          ],
        ),
      ),
    );
  }
}
