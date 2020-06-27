import 'package:flutter/material.dart';
import 'package:memo/HomeScreen.dart';

class StackPage extends StatefulWidget {
  @override
  _StackPageState createState() => _StackPageState();
}

class _StackPageState extends State<StackPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 20,
              ),
              Container(
                // width: 200,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "THE ANONYMOUS VOICE OF THE CYBER SPACE",
                    style: TextStyle(
                        fontFamily: "google",
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 3),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              // Text(
              //   "සටහන්",
              //   style: TextStyle(
              //       // fontFamily: "NYH",
              //       fontSize: 50),
              // ),
              Image(
                width: 100,
                height: 100,
                image: AssetImage('assets/memo.png'),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );
                },
                // color: Colors.green[500],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "start memo",
                      style: TextStyle(
                          fontFamily: "google",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 3),
                    ),
                    Icon(Icons.arrow_forward)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "THIS IS A SOCIAL PLATFORM  THAT ALLOWS YOU TO SHARE YOUR FEELINGS WITH THE WORLD ANONYMOUSLY." +
                        " PLEASE DON'T REVEAL YOURS OR OTHERS IDENTIFY." +
                        " PLEASE DON'T SHARE ANYTHING THAT HARMS YOURS OR OTHERS PRIVACY. THANK YOU!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      // letterSpacing: 2,
                      fontFamily: "google",
                      fontSize: 10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
