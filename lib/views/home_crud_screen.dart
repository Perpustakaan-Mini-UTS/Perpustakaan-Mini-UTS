import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/book_provider.dart';
import '../providers/view_state.dart';
import 'list_api_screen.dart';

class HomeCrudScreen extends StatelessWidget {
  const HomeCrudScreen({super.key});

  void _showForm(BuildContext context,
      [String? id,
      String? currentTitle,
      String? currentAuthor,
      String? currentStatus,
      String? currentBorrower]) {
    final titleController = TextEditingController(text: currentTitle ?? '');
    final authorController = TextEditingController(text: currentAuthor ?? '');
    final borrowerController =
        TextEditingController(text: currentBorrower ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        // Inisialisasi status terpilih dari parameter currentStatus
        String selectedStatus = currentStatus ?? 'Tersedia';

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    id == null ? 'Tambah Buku' : 'Edit Buku',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Judul Buku'),
                  ),
                  TextField(
                    controller: authorController,
                    decoration: const InputDecoration(labelText: 'Penulis'),
                  ),
                  if (id != null) ...[
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: ['Tersedia', 'Dipinjam']
                          .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)))
                          .toList(),
                      onChanged: (val) {
                        setModalState(() {
                          selectedStatus = val ?? 'Tersedia';
                        });
                      },
                      decoration: const InputDecoration(labelText: 'Status'),
                    ),
                    // Field Nama Peminjam hanya tampil jika status "Dipinjam"
                    if (selectedStatus == 'Dipinjam')
                      TextField(
                        controller: borrowerController,
                        decoration:
                            const InputDecoration(labelText: 'Nama Peminjam'),
                      ),
                  ],
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final provider =
                          Provider.of<BookProvider>(context, listen: false);
                      final title = titleController.text.trim();
                      final author = authorController.text.trim();

                      if (title.isEmpty || author.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Judul dan Penulis wajib diisi!')),
                        );
                        return;
                      }

                      if (id == null) {
                        provider.addBook(title, author);
                      } else {
                        // Jika Tersedia, Nama Peminjam otomatis reset jadi '-'
                        final finalBorrower = (selectedStatus == 'Tersedia')
                            ? '-'
                            : (borrowerController.text.trim().isEmpty
                                ? '-'
                                : borrowerController.text.trim());

                        provider.updateBook(
                            id, title, author, selectedStatus, finalBorrower);
                      }
                      Navigator.pop(ctx);
                    },
                    child: Text(id == null ? 'Simpan' : 'Update'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perpustakaan Mini (Firestore)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu_book),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const ListApiScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () =>
                Provider.of<AuthProvider>(context, listen: false).logout(),
          )
        ],
      ),
      body: _buildBody(context, bookProvider),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, BookProvider provider) {
    if (provider.state == ViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.state == ViewState.error) {
      return Center(child: Text('Error: ${provider.errorMessage}'));
    }
    if (provider.state == ViewState.empty) {
      return const Center(child: Text('Belum ada koleksi buku.'));
    }

    return ListView.builder(
      itemCount: provider.books.length,
      itemBuilder: (ctx, i) {
        final book = provider.books[i];
        return ListTile(
          title: Text(book.title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(
              'Penulis: ${book.author} | Status: ${book.status} ${book.status == 'Dipinjam' ? '(${book.borrower})' : ''}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showForm(context, book.id, book.title,
                    book.author, book.status, book.borrower),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => provider.deleteBook(book.id),
              ),
            ],
          ),
        );
      },
    );
  }
}
