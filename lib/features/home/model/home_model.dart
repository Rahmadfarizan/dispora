class Berita {
  final String title;
  final String content;
  final String image;

  Berita({
    required this.title,
    required this.content,
    required this.image,
  });
  factory Berita.fromJson(Map<String, dynamic> json) {
    return Berita(
      title: json['title']['rendered'] ?? "",
      content: json['content']['rendered'] ?? "",
      image: json['_embedded']['wp:featuredmedia'][0]['source_url'] ?? "",
    );
  }
}
