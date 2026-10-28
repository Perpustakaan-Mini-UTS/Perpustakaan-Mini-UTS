import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book_model.dart';

class FirestoreService {
  final CollectionReference _books =
      FirebaseFirestore.instance.collection('books');

  Stream<List<BookModel>> streamBooks() {
    return _books.snapshots().map(
          (snapshot) =>
              snapshot.docs.map((doc) => BookModel.fromFirestore(doc)).toList(),
        );
  }

  Future<List<BookModel>> getBooksOnce() async {
    final snapshot = await _books.get();
    return snapshot.docs.map((doc) => BookModel.fromFirestore(doc)).toList();
  }

  Future<void> addBook(String title, String author) {
    return _books.add({
      'title': title,
      'author': author,
      'status': 'Tersedia',
      'borrower': '-',
      'borrowedAt': Timestamp.now(),
    });
  }

  Future<void> updateBook(
      String id, String title, String author, String status, String borrower) {
    return _books.doc(id).update({
      'title': title,
      'author': author,
      'status': status,
      'borrower': borrower,
      'borrowedAt': Timestamp.now(),
    });
  }

  Future<void> deleteBook(String id) {
    return _books.doc(id).delete();
  }
}
