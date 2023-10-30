class Sosial {
  final String slug;
  final String title;
  final String content;
  final String image;

  Sosial(
      {required this.slug,
      required this.title,
      required this.image,
      required this.content});
  factory Sosial.fromJson(Map<String, dynamic> json) {
    return Sosial(
      slug: json['slug'],
      title: json['title']['rendered'],
      content: json['content']['rendered'],
      image: json["_links"]["wp:attachment"][0]["href"],
    );
  }
}

class SosialDetail {
  final String image;

  SosialDetail({
    required this.image,
  });
  factory SosialDetail.fromJson(Map<String, dynamic> json) {
    return SosialDetail(
      image: json['guid']['rendered'],
    );
  }
}
