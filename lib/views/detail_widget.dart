import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class Detail extends StatelessWidget {
  final String? title;
  final String? content;
  final String? image;

  const Detail({
    super.key,
    this.title = "",
    this.content = "",
    this.image = "",
  });

  @override
  Widget build(BuildContext context) {
    String modifiedHtmlString = content!.replaceAll('data-src', 'src');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xff29366A),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              /// untuk pages dan posts
              // if (image != "")
              CachedNetworkImage(
                imageUrl: image!,
                placeholder: (context, url) {
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.33,
                    decoration: BoxDecoration(color: Colors.grey.shade300),
                  );
                },
                errorWidget: (context, url, error) {
                  // Menampilkan gambar pengganti jika URL mengembalikan kode status 404.
                  return Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.33,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                    ),
                    child: Image.asset(
                      "assets/dispora.png",
                      color: Colors.white,
                    ),
                  ); // Ganti dengan placeholder yang sesuai.
                },
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xff29366A),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 10, //jarak antara gambar dan konten
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment
                  .start, //semua konten dimulai dari sebelah kiri
              children: [
                Text(
                  title!, //menampilkan judul
                  style: const TextStyle(
                    fontSize: 22, //ukuran huruf
                    fontWeight: FontWeight.w400, //ketebalan huruf
                  ),
                ),
                const SizedBox(
                  height: 20, //jarak antara judul dan konten
                ),
                HtmlWidget(
                  modifiedHtmlString, //teks html diubah menjadi teks yang bisa dibaca
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
