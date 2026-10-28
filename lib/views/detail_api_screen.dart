import 'package:flutter/material.dart';
import '../models/catalog_model.dart';

class DetailApiScreen extends StatelessWidget {
  final CatalogModel catalog;
  const DetailApiScreen({super.key, required this.catalog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Catalog #${catalog.id}')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(catalog.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(catalog.body, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
