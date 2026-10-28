import 'dart:async';
import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/firestore_service.dart';
import 'view_state.dart';

class BookProvider extends ChangeNotifier {
  final FirestoreService _service = FirestoreService();

  ViewState _state = ViewState.loading;
  List<BookModel> _books = [];
  String? _errorMessage;
  StreamSubscription<List<BookModel>>? _subscription;

  ViewState get state => _state;
  List<BookModel> get books => _books;
  String? get errorMessage => _errorMessage;

  BookProvider() {
    listenToBooks();
  }

  void listenToBooks() {
    _state = ViewState.loading;
    notifyListeners();

    _subscription?.cancel();
    _subscription = _service.streamBooks().listen(
      (data) {
        // Sort di sisi client (Dart) tanpa menggunakan orderBy di Firestore (Sesuai Syarat UTS)
        data.sort((a, b) => b.borrowedAt.compareTo(a.borrowedAt));

        _books = data;
        if (_books.isEmpty) {
          _state = ViewState.empty;
        } else {
          _state = ViewState.loaded;
        }
        notifyListeners();
      },
      onError: (error) {
        _state = ViewState.error;
        _errorMessage = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> addBook(String title, String author) async {
    await _service.addBook(title, author);
  }

  Future<void> updateBook(String id, String title, String author, String status,
      String borrower) async {
    await _service.updateBook(id, title, author, status, borrower);
  }

  Future<void> deleteBook(String id) async {
    await _service.deleteBook(id);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
