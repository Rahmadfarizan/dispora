import 'package:cached_network_image/cached_network_image.dart';
import 'package:dispora/views/sarpras_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';

class Detail extends StatefulWidget {
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
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  ScrollController _scrollController = ScrollController();
  bool _showTitle = false;
  double opacity = 0.0;
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset <= 0) {
        setState(() {
          _showTitle = false;
          opacity = 0.0;
        });
      } else {
        setState(() {
          _showTitle = true;
          opacity = 0.6;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String modifiedHtmlString = widget.content!.replaceAll('data-src', 'src');

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xff29366A),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // Add the app bar to the CustomScrollView.
          SliverAppBar(
            automaticallyImplyLeading: false,
            elevation: 2,
            shadowColor: Colors.grey.shade300,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff29366A).withOpacity(0.8),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
            ),
            // Provide a standard title.

            // Allows the user to reveal the app bar if they begin scrolling
            // back up the list of items.

            title: _showTitle
                ? Text(
                    "Poradi Pekanbaru",
                    style: GoogleFonts.arimo(
                        fontWeight: FontWeight.bold,
                        color:
                            widget.image != "" ? Colors.white : Colors.black),
                  )
                : null,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            // Display a placeholder widget to visualize the shrinking size.
            flexibleSpace: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                /// untuk pages dan posts
                if (widget.image != "")
                  CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.33,
                    imageUrl: widget.image!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
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
                          "assets/logodispora.png",
                          color: Colors.white,
                        ),
                      ); // Ganti dengan placeholder yang sesuai.
                    },
                  ),
                if (widget.image != "")
                  AnimatedContainer(
                    duration: Duration(seconds: 2), // Durasi animasi
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.33,
                    color: _showTitle
                        ? Colors.black.withOpacity(opacity)
                        : Colors.transparent,
                  ),
              ],
            ),

            // Make the initial height of the SliverAppBar larger than normal.
            expandedHeight:
                widget.image != "" ? MediaQuery.of(context).size.height / 3 : 0,
          ),
          // Next, create a SliverList
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
              (context, index) => Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, //semua konten dimulai dari sebelah kiri
                  children: [
                    Text(
                      widget.title!, //menampilkan judul
                      style: GoogleFonts.arimo(
                        fontSize: 22, //ukuran huruf
                        fontWeight: FontWeight.w600, //ketebalan huruf
                      ),
                    ),
                    const SizedBox(
                      height: 20, //jarak antara judul dan konten
                    ),
                    (modifiedHtmlString.contains("www.google.com/maps"))
                        ? SingleChildScrollView(
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                              child: SarprasWidget(
                                link:
                                    "https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d4919.56786220599!2d101.38476387582705!3d0.4749816637614036!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x31d5a855ec651789%3A0x222d619462f3b35b!2sStadion%20Mini%20Universitas%20Riau!5e1!3m2!1sid!2sid!4v1697657709947!5m2!1sid!2sid",
                              ),
                            ),
                          )
                        : HtmlWidget(
                            modifiedHtmlString,
                            textStyle: GoogleFonts.arimo(
                              fontSize: 16,
                            ), //teks html diubah menjadi teks yang bisa dibaca
                          ),
                  ],
                ),
              ),
              // Builds 1000 ListTiles
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
