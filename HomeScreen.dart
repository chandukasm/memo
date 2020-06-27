import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'FireGoogLogin.dart';
import 'models/SatahanBox1.dart';
import 'models/Satahana.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

///adds/////////////////
class _HomeScreenState extends State<HomeScreen> {
  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['flutterio', 'beautiful apps'],
    contentUrl: 'https://flutter.io',
    childDirected: false,
    testDevices: <String>[], // Android emulators are considered test devices
  );

//////////////////adds////////////////////////////////////////
  BannerAd _bannerAd;

  FirebaseUser user;
  FirebaseAuth auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  // List<Satahana> satahan = [];
  List<ListItem> satahan = [];
  String satahanText;
  String displayName = "displayName";
  String email = "email";
  String photoUrl;
  bool isLoaded = false;
  bool isLight = false;
  int times = 0;

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.fullBanner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  getCurrentUser() async {
    user = await auth.currentUser();
    displayName = user.displayName;
    email = user.email;
    photoUrl = user.photoUrl;
    print("from getCurrentUser ${++times}");
  }

  Future<void> getSatahan() async {
    print("called");
    QuerySnapshot current = await _firestore.collection('count').getDocuments();
    int max = current.documents[0].data['id'];
    int start = Random().nextInt(max);
    int end = start + 30;
    satahan = [];
    int i = 0;
    QuerySnapshot x;
    try {
      x = await _firestore
          .collection('satahan')
          .where('id', isGreaterThanOrEqualTo: start)
          .where('id', isLessThanOrEqualTo: end)
          .orderBy('id', descending: true)
          .getDocuments();
    } catch (e) {
      print(
          "=======================================================================");
      print(e);
      print(
          "=======================================================================");
    }

    for (var item in x.documents) {
      Satahana n = new Satahana(
        id: i,
        content: item.data['content'] ?? "",
        hearts: item.data['hearts'],
        ref: item.documentID,
        liked: false,
        docId: item.data['id'],
        time: item.data['time'] ?? "last sunday",
        commentCount: item.data['comments'].length,
      );
      // print(n.commentCount);
      i++;
      satahan.add(n);
    }
    satahan.add(
      NativeAdvanced(), //the sized box
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(appId: "app_id");

    _bannerAd = createBannerAd()
      ..load()
      ..show();

    getCurrentUser();
    getSatahan();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: SafeArea(
          child: Container(
            width: 50,
            child: Image.asset('assets/memo.png'),
          ),
        ),
        actions: [
          Switch(
              activeColor: Colors.redAccent,
              value: isLight,
              onChanged: (value) {
                setState(() {
                  isLight = value;
                });
              })
        ],
      ),
      drawer: FutureBuilder<FirebaseUser>(
        future: auth.currentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          return Drawer(
            child: Container(
              decoration: BoxDecoration(color: Colors.black),
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                        // image: DecorationImage(
                        //   colorFilter: ColorFilter.mode(
                        //     Colors.black12,
                        //     BlendMode.darken,
                        //   ),
                        //   image: AssetImage('assets/newone.jpg'),
                        //   fit: BoxFit.cover,
                        // ),
                        color: Colors.black),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                    accountEmail: Text(
                      email,
                      style: TextStyle(
                          fontFamily: 'google',
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 1),
                    ),
                    accountName: Text(
                      displayName,
                      style: TextStyle(
                          fontFamily: 'google',
                          color: Colors.white,
                          fontSize: 15,
                          letterSpacing: 1),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RaisedButton(
                      onPressed: () async {
                        try {
                          await auth.signOut();
                          await _googleSignIn.signOut();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FireGoogLogin(),
                              ));
                        } catch (e) {
                          print(e);
                        }
                      },
                      color: Colors.redAccent,
                      child: Text(
                        "sign out",
                        style: TextStyle(
                            fontFamily: 'google',
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //       image: AssetImage('assets/newone.jpg'), fit: BoxFit.cover),
        // ),
        color: isLight ? Colors.white : null,
        child: RefreshIndicator(
          color: Colors.redAccent,
          onRefresh: getSatahan,
          child: ListView.builder(
            itemCount: satahan.length,
            itemBuilder: (context, index) {
              final item = satahan[index];

              if (item is Satahana) {
                return SatahanBox1(
                  // hasComments: ,
                  satahana: satahan[index],
                  handleLike: () {
                    print(item.id);
                    setState(() {
                      if (item.liked == false) {
                        item.liked = true;
                        item.hearts += 1;
                        _firestore
                            .collection('satahan')
                            .document(item.ref)
                            .updateData(
                          {
                            'hearts': FieldValue.increment(1),
                          },
                        );
                      } else {
                        item.liked = false;
                        item.hearts -= 1;
                        _firestore
                            .collection('satahan')
                            .document(item.ref)
                            .updateData({
                          'hearts': FieldValue.increment(-1),
                        });
                      }
                    });
                  },
                );
              }

              if (item is NativeAdvanced) {
                return Container(
                  height: 330,
                );
              }
            },
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.redAccent.withOpacity(0.8),
            onPressed: () async {
              return showDialog<void>(
                context: context,
                barrierDismissible: true, // user must tap button!
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.black,
                    title: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'M',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontFamily: 'google',
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'em',
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'google',
                                fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'O',
                            style: TextStyle(
                                color: Colors.redAccent,
                                fontFamily: 'google',
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          TextField(
                            decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            cursorColor: Colors.redAccent,
                            maxLength: 400,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            onChanged: (value) {
                              satahanText = value;
                            },
                          ),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Colors.redAccent,
                        ),
                        onPressed: () async {
                          if (satahanText == null) {
                            print("satahan in returned");
                            return;
                          }
                          var id = _firestore
                              .collection('count')
                              .document('7GaZ2tAoaBvgBZZ5MdpZ')
                              .get();
                          id.then((value) {
                            print(value.data['id']);
                            _firestore.collection('satahan').add({
                              'id': value.data['id'],
                              'content': satahanText,
                              'hearts': 1,
                              'email': user.email,
                              'comments': [],
                              'time': DateTime.now().toString()
                            });
                            _firestore
                                .collection('count')
                                .document('7GaZ2tAoaBvgBZZ5MdpZ')
                                .updateData({'id': FieldValue.increment(1)});
                          });

                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: 'M',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'google',
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'em',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'google',
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: 'O',
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'google',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 70,
          ),
        ],
      ),
    );
  }
}
//  Text(
//               'MemO',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                   fontFamily: "google",
//                   fontSize: 15,
//                   fontWeight: FontWeight.w800,
//                   color: Colors.black),
//             ),

// https://stackoverflow.com/questions/46798981/firestore-how-to-get-random-documents-in-a-collection
class NativeAdvanced implements ListItem {
  Widget adwidget;
  NativeAdvanced({this.adwidget});
}
