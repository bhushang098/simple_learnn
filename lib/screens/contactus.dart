import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactUs extends StatefulWidget {
  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  bool _isLoading = true;
  String url;

  @override
  Widget build(BuildContext context) {
    url = ModalRoute.of(context).settings.arguments.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(url.split('??').last),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Stack(
            children: <Widget>[
              WebView(
                initialUrl: url.split('??').first,
                javascriptMode: JavascriptMode.unrestricted,
                onPageFinished: pageFinishedLoading,
                onPageStarted: pageFinishedLoading,
              ),
              showprogress(_isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget showprogress(bool _isLoading) {
    if (_isLoading) {
      return Center(
        child: JumpingDotsProgressIndicator(
          fontSize: 50.0,
        ),
      );
    } else {
      return Text('');
    }
  }

  void pageFinishedLoading(String url) {
    setState(() {
      _isLoading = false;
    });
  }
}
