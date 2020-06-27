import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  Comments({this.ref, this.id, this.email});
  final String ref;
  final int id;
  final String email;
  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  FirebaseUser user;
  FirebaseAuth auth = FirebaseAuth.instance;
  Firestore _firestore = Firestore.instance;
  String comment = "";
  String email = "";
  String userEmail = "";
  bool isLight = false;

  final commentController = TextEditingController();

  getCurrentUser() async {
    user = await auth.currentUser();
    userEmail = user.email;
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Container(
          width: 50,
          child: Image.asset('assets/memo.png'),
        ),
        actions: [
          Switch(
              activeColor: Colors.redAccent,
              value: isLight, //default false
              onChanged: (value) {
                setState(() {
                  isLight = value;
                });
                print('fom the swithch : $isLight');
              })
        ],
      ),
      body: Container(
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage('assets/newone.jpg'),
        //     fit: BoxFit.cover,
        //   ),
        // ),
        color: isLight ? Colors.white : null,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: _firestore
                  .collection('satahan')
                  .document(widget.ref)
                  .snapshots(),
              builder: (context, snapshot) {
                var comments = [];
                List<Widget> commetsList = [];

                if (snapshot.data == null) {
                  Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // if (snapshot.connectionState != ConnectionState.done) {
                //   Center(
                //     child: CircularProgressIndicator(),
                //   );
                // }

                // print(comments);
                else {
                  comments = snapshot.data.data['comments'];
                }
                for (var i = 0; i < comments.length; i++) {
                  commetsList.add(
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: MessageBubble(
                        comment: comments[i]['comment'] ?? "satahan...",
                        email: comments[i]['sender'] ?? "satahan...",
                        isMe: comments[i]['sender'] == userEmail,
                        isLight: isLight,
                      ),
                    ),
                  );
                }
                commetsList = commetsList.reversed.toList();
                return Expanded(
                  child: ListView(
                    reverse: true, //list view bottom sticky
                    children: commetsList,
                  ),
                );
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      cursorColor: Colors.redAccent,
                      style: TextStyle(
                          color: isLight ? Colors.black : Colors.white),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        hintText: "type a comment..",
                        filled: true,
                      ),
                      maxLength: 400,
                      // keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: commentController,
                      onChanged: (value) {
                        comment = value;
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20, right: 5),
                  child: SizedBox(
                    height: 60,
                    child: FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      color: Colors.redAccent,
                      child: Text('send'),
                      onPressed: () {
                        commentController.clear();
                        print(comment);
                        if (comment == "" || comment == null) {
                          print('comment is null');
                          return;
                        }
                        _firestore
                            .collection('satahan')
                            .document(widget.ref)
                            .updateData({
                          'comments': FieldValue.arrayUnion([
                            {
                              'comment': comment,
                              'sender': userEmail,
                            }
                          ])
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String comment;
  final String email; //comes with the comment
  final bool isMe;
  final bool isLight; //current loggedin User.

  const MessageBubble(
      {Key key, this.comment, this.email, this.isMe, this.isLight})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Material(
          elevation: 5,
          shadowColor: Colors.black,
          borderRadius: isMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  bottomRight: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
          color: isMe
              ? isLight ? Colors.black : Color.fromRGBO(4, 71, 64, 1)
              : isLight ? Colors.lightBlue : Colors.blueGrey,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
            child: Text(
              "$comment",
              style: TextStyle(
                  color: isMe ? Colors.white : Colors.black, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }
}
