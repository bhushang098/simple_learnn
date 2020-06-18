import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firestoreService.dart';

class DeligateLectures extends SearchDelegate<VideoClass> {
  List<VideoClass> list = [];

  DeligateLectures(this.list);

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  void navtoVidScreen(VideoClass vid, BuildContext context) {
    Navigator.pushNamed(context, '/vidScreen', arguments: vid);
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<VideoClass> anslist = [];

    for (int i = 0; i < list.length; i++) {
      if (list[i].title.toLowerCase().contains(query.toLowerCase()) ||
          list[i].author.toLowerCase().contains(query.toLowerCase())) {
        anslist.add(list[i]);
      }
    }

    return ListView.builder(
        itemCount: anslist.length,
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
                      navtoVidScreen(anslist[index], context);
                      print("Tapped>>>>" + anslist[index].author.toString());
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.video_library,
                        size: 50,
                        color: Colors.green,
                      ),
                      title: Text(anslist[index].title.toString()),
                      subtitle: Text(anslist[index].author.toString()),
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
}

class DeligatePaidLectures extends SearchDelegate<paidVidClass> {
  List<paidVidClass> list = [];

  DeligatePaidLectures(this.list);

  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    List<paidVidClass> anslist = [];
    final user = Provider.of<FirebaseUser>(context);
    print('Stream user is' + user.toString());

    for (int i = 0; i < list.length; i++) {
      if (list[i].title.toLowerCase().contains(query.toLowerCase()) ||
          list[i].author.toLowerCase().contains(query.toLowerCase())) {
        anslist.add(list[i]);
      }
    }
    return ListView.builder(
        itemCount: anslist.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: <Widget>[
              SizedBox(
                height: 3,
              ),
//              ListTile(
//                leading: Icon(Icons.video_library, size: 50),
//                title: Text(_vidList[index].url.toString()),
//                subtitle: Text(_vidList[index].title.toString()),
//              ),

              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: InkWell(
                    splashColor: Colors.teal[100],
                    onTap: () {
                      if (user.isAnonymous) {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              // Retrieve the text the that user has entered by using the
                              // TextEditingController.
                              content: Text(
                                  'Guests Can not Purchase courses LogOut and then LogIn With your Email'),
                            );
                          },
                        );
                      } else {
                        navToPurchasePage(context, anslist[index]);
                      }
                      print("Tapped>>>>" + anslist[index].title.toString());
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.video_library,
                        size: 50,
                        color: Colors.redAccent,
                      ),
                      title: Text(anslist[index].title.toString()),
                      subtitle: Text(anslist[index].author.toString()),
                      trailing: Text('price' + anslist[index].price.toString()),
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

  void navToPurchasePage(BuildContext context, paidVidClass vid) {
    Navigator.pushNamed(context, '/PurchasePage', arguments: vid);
  }
}
