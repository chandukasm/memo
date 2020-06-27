import 'package:flutter/material.dart';
import 'package:memo/HomeScreen.dart';
import 'package:memo/MIne.dart';

class TabPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: SafeArea(
            child: Container(
              width: 50,
              child: Image.asset('assets/memo.png'),
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
            ],
          ),
        ),
        body: TabBarView(children: [
          HomeScreen(),
          Mine(),
        ]),
      ),
    );
  }
}
