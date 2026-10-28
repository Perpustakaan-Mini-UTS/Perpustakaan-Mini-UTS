import 'package:cloud_firestore/cloud_firestore.dart';

class BookModel {
  final String id;
  final String title;
  final String author;
  final String status; // 'Tersedia' atau 'Dipinjam'
  final String borrower;
  final Timestamp borrowedAt;

  BookModel({
    required this.id,
    required this.title,
    required this.author,
    required this.status,
    required this.borrower,
    required this.borrowedAt,
  });

  factory BookModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    return BookModel(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      status: data['status'] ?? 'Tersedia',
      borrower: data['borrower'] ?? '',
      borrowedAt: data['borrowedAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'status': status,
      'borrower': borrower,
      'borrowedAt': borrowedAt,
    };
  }
}
