class Sosial {
  final String slug;
  final String title;

  Sosial({
    required this.slug,
    required this.title,
  });
  factory Sosial.fromJson(Map<String, dynamic> json) {
    return Sosial(
      slug: json['slug'],
      title: json['title'],
    );
  }
}
