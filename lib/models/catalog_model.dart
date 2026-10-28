class CatalogModel {
  final int id;
  final String title;
  final String body;

  CatalogModel({
    required this.id,
    required this.title,
    required this.body,
  });

  factory CatalogModel.fromJson(Map<String, dynamic> json) {
    return CatalogModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
    );
  }
}
