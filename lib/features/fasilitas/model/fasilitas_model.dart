class Fasilitas {
  final String slug;
  final String date;
  final String image;

  Fasilitas({
    required this.slug,
    required this.date,
    required this.image,
  });
  factory Fasilitas.fromJson(Map<String, dynamic> json) {
    return Fasilitas(
      slug: json['slug'],
      date: json['date'],
      image: json['guid']['rendered'],
    );
  }
}

class FasilitasDetail {
  final String slug;
  final String title;
  final String content;

  FasilitasDetail({
    required this.slug,
    required this.title,
    required this.content,
  });
  factory FasilitasDetail.fromJson(Map<String, dynamic> json) {
    return FasilitasDetail(
      slug: json['slug'],
      title: json["title"]["rendered"],
      content: json["content"]["rendered"],
    );
  }
}

class FasilitasList {
  final String title;
  final String linkImage;
  final String content;

  FasilitasList({
    required this.title,
    required this.linkImage,
    required this.content,
  });
  factory FasilitasList.fromJson(Map<String, dynamic> json) {
    return FasilitasList(
      title: json['title']["rendered"],
      linkImage: json["_links"]["wp:attachment"][0]["href"],
      content: json["_links"]["self"][0]["href"],
    );
  }
}
