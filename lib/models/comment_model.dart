import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String author;
  final String authorName;
  final String comment;
  final DateTime? createdDate;

  const Comment({
    required this.author,
    required this.authorName,
    required this.comment,
    this.createdDate,
  });

  factory Comment.fromMap(Map<String, dynamic> map) {
    final rawDate = map['createdDate'];

    DateTime? parsedDate;
    if (rawDate is Timestamp) {
      parsedDate = rawDate.toDate();
    } else if (rawDate is String) {
      parsedDate = DateTime.tryParse(rawDate);
    }

    return Comment(
      author: map['author'] ?? '',
      authorName: map['author'] ?? '',
      comment: map['comment'] ?? '',
      createdDate: parsedDate,
    );
  }

  /// Optional: for saving to Firestore
  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'authorName': authorName,
      'comment': comment,
      'createdAt': createdDate != null
          ? Timestamp.fromDate(createdDate!)
          : null,
    };
  }
}
