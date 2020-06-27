class Satahana implements ListItem {
  final int id;
  int hearts;
  String content;
  String ref;
  bool liked;
  int docId;
  int commentCount;
  var time;

  Satahana({
    this.id,
    this.hearts,
    this.content,
    this.ref,
    this.liked,
    this.docId,
    this.time,
    this.commentCount,
  });

  factory Satahana.fromJson(Map<String, dynamic> json) {
    return Satahana(
      id: json['id'],
      content: json['content'],
      hearts: json['hearts'],
    );
  }
}

abstract class ListItem {}
