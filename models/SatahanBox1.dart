import 'package:flutter/material.dart';
import 'package:memo/components/Devider.dart';
import 'package:memo/components/Heart.dart';

import '../Comments.dart';
import 'Satahana.dart';

class SatahanBox1 extends StatelessWidget {
  final Satahana satahana;
  final Function handleLike;
  final bool hasComments;

  SatahanBox1({this.satahana, this.handleLike, this.hasComments});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 50,
                ),
                // Text(
                //   '- memo - ',
                //   softWrap: true,
                //   style: TextStyle(
                //     fontSize: 10,
                //     fontWeight: FontWeight.w200,
                //     color: Colors.white,
                //     fontFamily: 'google',
                //   ),
                // ),
                Text(
                  '${satahana.time.substring(0, 11)} at ${satahana.time.substring(10, 16)} ',
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w200,
                    color: Colors.white,
                    fontFamily: 'google',
                  ),
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      child: IconButton(
                        icon: Icon(Icons.chat_bubble_outline,
                            color: Colors.redAccent),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Comments(
                                ref: satahana.ref,
                                id: satahana.id,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white.withOpacity(0.8),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text(
                              satahana.commentCount.toString(),
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.black,
                                  fontFamily: 'google',
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            CardDevider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                satahana.content,
                // .length > 300
                //     ? satahana.content.substring(0, 300) + "...."
                //     : satahana.content,
                textAlign: TextAlign.center,

                style: TextStyle(
                  fontSize: 15,
                  // fontWeight: FontWeight.w200,
                  fontFamily: 'google',
                  letterSpacing: 1,
                  color: Colors.white,
                ),
              ),
            ),
            // CardDevider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  child: Heart(isLiked: satahana.liked, handleTap: handleLike),
                ),
                Text(
                  satahana.hearts.toString(),
                  style: TextStyle(
                    // fontWeight: FontWeight.w300,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
