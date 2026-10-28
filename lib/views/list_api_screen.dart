import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/api_provider.dart';
import '../providers/view_state.dart';
import 'detail_api_screen.dart';

class ListApiScreen extends StatelessWidget {
  const ListApiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Katalog Referensi (Dio REST API)')),
      body: _buildBody(context, apiProvider),
    );
  }

  Widget _buildBody(BuildContext context, ApiProvider provider) {
    if (provider.state == ViewState.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.state == ViewState.error) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.errorMessage ?? 'Gagal memuat data'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => provider.fetchCatalogs(),
              child: const Text('Coba Lagi (Retry)'),
            )
          ],
        ),
      );
    }
    if (provider.state == ViewState.empty) {
      return const Center(child: Text('Katalog Referensi Kosong.'));
    }

    return ListView.builder(
      itemCount: provider.catalogs.length,
      itemBuilder: (ctx, i) {
        final item = provider.catalogs[i];
        return ListTile(
          leading: CircleAvatar(child: Text(item.id.toString())),
          title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle:
              Text(item.body, maxLines: 2, overflow: TextOverflow.ellipsis),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => DetailApiScreen(catalog: item)),
            );
          },
        );
      },
    );
  }
}
