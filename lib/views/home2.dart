import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:flutter_wordpress_example/wp_api.dart';

class Detail extends StatelessWidget {
  final String? title;
  final String? content;
  final String? image;

  Detail({
    this.title = "",
    this.content = "",
    this.image = "",
  });

  @override
  Widget build(BuildContext context) {
    //menghilangkan text 'data' pada 'data-src' ini biasa terdapat pada
    String modifiedHtmlString = this.content!.replaceAll('data-src', 'src');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          /// untuk pages dan posts
          if (this.image != "")
            Container(
              //ukuran gambar selebar perangkat
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.33,

              //anda dapat mengisi container dengan gambar menggunakan properti ini
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(this.image!), // menampilkan gambar
                  fit: BoxFit.cover,
                ),
              ),
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
                  this.title!, //menampilkan judul
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

          /// untuk kategori
          // FutureBuilder(
          //   future: fetchWpPostCategory(this.content!),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.done) {
          //       if (snapshot.hasData) {
          //         final data = snapshot.data;
          //         // return Text(data[0]["_links"]["wp:featuredmedia"][0]["href"]);
          //         return Column(
          //           children: [
          //             for (int i = 0; i < data.length; i++)
          //               FutureBuilder(
          //                 future: fetchWpPostImage(
          //                     data[i]["_links"]["wp:featuredmedia"][0]["href"]),
          //                 builder: (context, snapshot) {
          //                   if (snapshot.hasData) {
          //                     final data = snapshot.data;

          //                     if (data != null &&
          //                         data["guid"] != null &&
          //                         data["guid"]["rendered"] != null) {
          //                       return Image.network(data["guid"]["rendered"]);
          //                     } else {
          //                       return const SizedBox.shrink();
          //                     }
          //                   } else if (snapshot.hasError) {
          //                     return Text("Gambar Tidak Ditemukan");
          //                   } else {
          //                     return const Center(
          //                         child: CircularProgressIndicator());
          //                   }
          //                 },
          //               ),
          //           ],
          //         );
          //       } else if (snapshot.hasError) {
          //         return Text("Gambar Tidak Ditemukan");
          //       }
          //     }

          //     return const Center(child: CircularProgressIndicator());
          //   },
          // ),
        ],
      ),
    );
  }
}
