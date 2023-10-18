import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dispora/views/detail_widget.dart';
import 'package:dispora/service/service_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'dart:developer' as logger show log;

class HomePage extends StatefulWidget {
  int categoryPost;
  HomePage({super.key, required this.categoryPost});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String modifyDateTime(String originalDateTime) {
    // Parse the original date from the string
    DateTime parsedDateTime = DateTime.parse(originalDateTime);

    // Calculate the time difference between the current time and the original time
    Duration difference = DateTime.now().difference(parsedDateTime);

    if (difference.inDays >= 7) {
      int weeks = (difference.inDays / 7).floor();
      return "${weeks} minggu yang lalu";
    } else if (difference.inDays >= 1) {
      return "${difference.inDays} hari yang lalu";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours} jam yang lalu";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes} menit yang lalu";
    } else {
      return "A few seconds ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.log("cek Category =>${widget.categoryPost}");
    return Container(
      color: const Color(0xffF9F7F7),
      child: FutureBuilder(
        future: fetchWpPosts(widget.categoryPost),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              // Check if the data is not null
              final list = snapshot.data as List;
              // final listImages = list
              //     .where((post) =>
              //         post['_embedded']['wp:featuredmedia'][0]['source_url'] !=
              //         null)
              //     .map((post) =>
              //         post['_embedded']['wp:featuredmedia'][0]['source_url'])
              //     .toList();

              final listImages = [
                "https://dispora.di-mep.com/wp-content/uploads/2023/08/98Kantor-Tenayan-scaled.jpg",
                "https://dispora.di-mep.com/wp-content/uploads/2023/10/Slider01.jpg",
                "https://dispora.di-mep.com/wp-content/uploads/2023/09/dispora-OPD-18-58552.jpeg"
              ];

              return (snapshot.data!.isEmpty)
                  ? const Center(
                      child: Text("Belum ada Postingan"),
                    )
                  : ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            if (index == 0)
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: CarouselSlider(
                                  items: [
                                    for (final imageUrl in listImages)
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: CachedNetworkImage(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              32,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              4,
                                          imageUrl: imageUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) {
                                            return Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  32,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  4,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  color: Colors.grey.shade300),
                                            );
                                          },
                                          errorWidget: (context, url, error) {
                                            // Menampilkan gambar pengganti jika URL mengembalikan kode status 404.
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              padding: const EdgeInsets.all(16),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: Colors.grey.shade300,
                                              ),
                                              child: Image.asset(
                                                "assets/logodispora.png",
                                                color: Colors.white,
                                              ),
                                            ); // Ganti dengan placeholder yang sesuai.
                                          },
                                        ),
                                      ),
                                  ],
                                  options: CarouselOptions(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 10),
                                    autoPlayAnimationDuration:
                                        const Duration(milliseconds: 800),
                                    autoPlayCurve: Curves.fastOutSlowIn,
                                    enlargeCenterPage: true,
                                    viewportFraction: 1,
                                  ),
                                ),
                              ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Detail(
                                      title: list[index]['title']['rendered'] ??
                                          "",
                                      content: list[index]['content']
                                              ['rendered'] ??
                                          "",
                                      image: list[index]['_embedded']
                                                  ['wp:featuredmedia'][0]
                                              ['source_url'] ??
                                          "",
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 16, right: 16, bottom: 16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (list[index]['_embedded']
                                                ['wp:featuredmedia'][0]
                                            ['source_url'] !=
                                        null)
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: CachedNetworkImage(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              4,
                                          fit: BoxFit.cover,
                                          imageUrl: list[index]['_embedded']
                                                      ['wp:featuredmedia'][0]
                                                  ['source_url'] ??
                                              "",
                                          placeholder: (context, url) {
                                            return Container(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      const BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                  color: Colors.grey.shade300),
                                            );
                                          },
                                          errorWidget: (context, url, error) {
                                            // Menampilkan gambar pengganti jika URL mengembalikan kode status 404.
                                            return Container(
                                              padding: const EdgeInsets.all(10),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  4,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(10)),
                                                color: Colors.grey.shade300,
                                              ),
                                              child: Image.asset(
                                                "assets/logodispora.png",
                                                color: Colors.white,
                                              ),
                                            ); // Ganti dengan placeholder yang sesuai.
                                          },
                                        ),
                                      )
                                    else
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                4,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(10)),
                                          color: Colors.grey.shade300,
                                        ),
                                        child: Image.asset(
                                          "assets/logodispora.png",
                                          color: Colors.white,
                                        ),
                                      ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.width / 4,
                                      width:
                                          (MediaQuery.of(context).size.width -
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      4) -
                                              (32),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 10, bottom: 10),
                                            child: Text(
                                              list[index]['title']
                                                      ['rendered'] ??
                                                  "",
                                              style: GoogleFonts.arimo(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              modifyDateTime(
                                                  list[index]['date']),
                                              style: GoogleFonts.arimo(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                              maxLines: 3,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (index == list.length - 1)
                              const SizedBox(
                                height: 50,
                              )
                          ],
                        );
                      },
                    );
            } else {
              // Handle the case where data is null
              return Center(
                child: Text(
                  "No data available",
                  style: GoogleFonts.arimo(),
                ),
              );
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingListWidget();
          } else {
            return Center(
              child: SizedBox(
                width: 200.0,
                height: 100.0,
                child: Shimmer.fromColors(
                  baseColor: const Color(0xff29366A),
                  highlightColor: const Color(0xffF05C39),
                  period: const Duration(milliseconds: 1200),
                  child: Image.asset("assets/logodispora.png"),
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildLoadingListWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 32,
                  height: MediaQuery.of(context).size.height / 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                for (int i = 0; i < 5; i++)
                  Container(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.width / 4,
                          width: MediaQuery.of(context).size.width / 4,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width / 4,
                          width: (MediaQuery.of(context).size.width -
                                  MediaQuery.of(context).size.width / 4) -
                              (32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, bottom: 8),
                                height: 16,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, bottom: 8),
                                height: 16,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(left: 10, bottom: 10),
                                height: 16,
                                width: MediaQuery.of(context).size.width / 2,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(left: 10),
                                height: 12,
                                width: 120,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
