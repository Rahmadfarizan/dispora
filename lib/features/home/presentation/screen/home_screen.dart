import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dispora/features/home/model/home_model.dart';
import 'package:dispora/features/home/presentation/provider/home_provider.dart';
import 'package:provider/provider.dart';
import '../widgets/detail_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import 'dart:developer' as logger show log;

import '../../service/home_service.dart';

class HomePage extends StatefulWidget {
  final int categoryPost;
  final String categoryTitle;
  final bool loadingCategory;
  const HomePage({
    super.key,
    required this.categoryPost,
    required this.categoryTitle,
    required this.loadingCategory,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String modifyDateTime(String originalDateTime) {
    DateTime parsedDateTime = DateTime.parse(originalDateTime);
    Duration difference = DateTime.now().difference(parsedDateTime);

    if (difference.inDays >= 7) {
      int weeks = (difference.inDays / 7).floor();
      return "$weeks minggu yang lalu";
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

  Future<List<Berita>>? futureLoadBerita;

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();

    Future.wait([
      context.read<HomeProvider>().loadBerita(widget.categoryPost),
    ]).then((results) {
      futureLoadBerita = results[0] as Future<List<Berita>>?;
      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {
      // Handle errors if any of the futures fail
      logger.log(error.toString());
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final listImages = [
      "https://dispora.di-mep.com/wp-content/uploads/2023/08/98Kantor-Tenayan-scaled.jpg",
      "https://dispora.di-mep.com/wp-content/uploads/2023/10/Slider01.jpg",
      "https://dispora.di-mep.com/wp-content/uploads/2023/09/dispora-OPD-18-58552.jpeg"
    ];

    return (_isLoading || widget.loadingCategory)
        ? _buildLoadingListWidget()
        : Consumer<HomeProvider>(
            builder: (context, home, _) => (home.berita.isEmpty)
                ? Center(
                    child: Text(
                      "${widget.categoryTitle} kosong",
                      style: TextStyle(color: Colors.black),
                    ),
                  )
                : Container(
                    color: const Color(0xffF9F7F7),
                    child: ListView.builder(
                      itemCount: home.berita.length,
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
                                      title: home.berita[index].title,
                                      content: home.berita[index].content,
                                      image: home.berita[index].image,
                                      date: home.berita[index].date,
                                      category: widget.categoryTitle,
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
                                    if (home.berita[index].image != null)
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
                                          imageUrl: home.berita[index].image,
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
                                              home.berita[index].title,
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
                                                  home.berita[index].date),
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
                            if (index == home.berita.length - 1)
                              const SizedBox(
                                height: 50,
                              )
                          ],
                        );
                      },
                    )),
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

// class HomePage extends StatefulWidget {
//   final int categoryPost;
//   final String categoryTitle;

//   const HomePage({
//     Key? key,
//     required this.categoryPost,
//     required this.categoryTitle,
//   });

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   String modifyDateTime(String originalDateTime) {
//     DateTime parsedDateTime = DateTime.parse(originalDateTime);
//     Duration difference = DateTime.now().difference(parsedDateTime);

//     if (difference.inDays >= 7) {
//       int weeks = (difference.inDays / 7).floor();
//       return "$weeks minggu yang lalu";
//     } else if (difference.inDays >= 1) {
//       return "${difference.inDays} hari yang lalu";
//     } else if (difference.inHours >= 1) {
//       return "${difference.inHours} jam yang lalu";
//     } else if (difference.inMinutes >= 1) {
//       return "${difference.inMinutes} menit yang lalu";
//     } else {
//       return "A few seconds ago";
//     }
//   }

//   bool _isLoading = false;
//   Future<List<Berita>>? futureLoadBerita;

//   @override
//   void initState() {
//     super.initState();
//     _isLoading = true;
//     futureLoadBerita =
//         context.read<HomeProvider>().loadBerita(widget.categoryPost);

//     futureLoadBerita?.then((result) {
//       setState(() {
//         _isLoading = false;
//       });
//     }).catchError((error) {
//       // Handle errors if the future fails
//       logger.log(error.toString());
//       setState(() {
//         _isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final listImages = [
//       "https://dispora.di-mep.com/wp-content/uploads/2023/08/98Kantor-Tenayan-scaled.jpg",
//       "https://dispora.di-mep.com/wp-content/uploads/2023/10/Slider01.jpg",
//       "https://dispora.di-mep.com/wp-content/uploads/2023/09/dispora-OPD-18-58552.jpeg",
//     ];

//     return _isLoading ? _buildLoadingListWidget() : _buildContent(listImages);
//   }

//   Widget _buildContent(List<String> listImages) {
//     return Consumer<HomeProvider>(
//       builder: (context, home, _) => Container(
//         color: const Color(0xffF9F7F7),
//         child: ListView.builder(
//           itemCount: home.berita.length,
//           itemBuilder: (context, index) {
//             if (index == 0) {
//               return _buildCarousel(listImages);
//             } else {
//               return _buildListItem(home, index);
//             }
//           },
//         ),
//       ),
//     );
//   }

//   Widget _buildCarousel(List<String> listImages) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: CarouselSlider(
//         items:
//             listImages.map((imageUrl) => _buildCarouselItem(imageUrl)).toList(),
//         options: CarouselOptions(
//           height: MediaQuery.of(context).size.height / 4,
//           autoPlay: true,
//           autoPlayInterval: const Duration(seconds: 10),
//           autoPlayAnimationDuration: const Duration(milliseconds: 800),
//           autoPlayCurve: Curves.fastOutSlowIn,
//           enlargeCenterPage: true,
//           viewportFraction: 1,
//         ),
//       ),
//     );
//   }

//   Widget _buildCarouselItem(String imageUrl) {
//     return ClipRRect(
//       borderRadius: const BorderRadius.all(Radius.circular(10)),
//       child: CachedNetworkImage(
//         width: MediaQuery.of(context).size.width - 32,
//         height: MediaQuery.of(context).size.height / 4,
//         imageUrl: imageUrl,
//         fit: BoxFit.cover,
//         placeholder: (context, url) {
//           return Container(
//             width: MediaQuery.of(context).size.width - 32,
//             height: MediaQuery.of(context).size.height / 4,
//             decoration: BoxDecoration(
//                 borderRadius: const BorderRadius.all(
//                   Radius.circular(10),
//                 ),
//                 color: Colors.grey.shade300),
//           );
//         },
//         errorWidget: (context, url, error) {
//           // Menampilkan gambar pengganti jika URL mengembalikan kode status 404.
//           return Container(
//             height: MediaQuery.of(context).size.width / 4,
//             width: MediaQuery.of(context).size.width / 4,
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: const BorderRadius.all(Radius.circular(10)),
//               color: Colors.grey.shade300,
//             ),
//             child: Image.asset(
//               "assets/logodispora.png",
//               color: Colors.white,
//             ),
//           ); // Ganti dengan placeholder yang sesuai.
//         },
//       ),
//     );
//   }

//   Widget _buildListItem(HomeProvider home, int index) {
//     return Consumer<HomeProvider>(
//       builder: (context, home, _) => Container(
//           color: const Color(0xffF9F7F7),
//           child: ListView.builder(
//             itemCount: home.berita.length,
//             itemBuilder: (context, index) {
//               return Column(
//                 children: [
//                   InkWell(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => Detail(
//                             title: home.berita[index].title,
//                             content: home.berita[index].content,
//                             image: home.berita[index].image,
//                             date: home.berita[index].date,
//                             category: widget.categoryTitle,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       padding: const EdgeInsets.only(
//                           left: 16, right: 16, bottom: 16),
//                       child: Row(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (home.berita[index].image != null)
//                             ClipRRect(
//                               borderRadius:
//                                   const BorderRadius.all(Radius.circular(10)),
//                               child: CachedNetworkImage(
//                                 height: MediaQuery.of(context).size.width / 4,
//                                 width: MediaQuery.of(context).size.width / 4,
//                                 fit: BoxFit.cover,
//                                 imageUrl: home.berita[index].image,
//                                 placeholder: (context, url) {
//                                   return Container(
//                                     height:
//                                         MediaQuery.of(context).size.width / 4,
//                                     width:
//                                         MediaQuery.of(context).size.width / 4,
//                                     decoration: BoxDecoration(
//                                         borderRadius: const BorderRadius.all(
//                                           Radius.circular(10),
//                                         ),
//                                         color: Colors.grey.shade300),
//                                   );
//                                 },
//                                 errorWidget: (context, url, error) {
//                                   // Menampilkan gambar pengganti jika URL mengembalikan kode status 404.
//                                   return Container(
//                                     padding: const EdgeInsets.all(10),
//                                     height:
//                                         MediaQuery.of(context).size.width / 4,
//                                     width:
//                                         MediaQuery.of(context).size.width / 4,
//                                     decoration: BoxDecoration(
//                                       borderRadius: const BorderRadius.all(
//                                           Radius.circular(10)),
//                                       color: Colors.grey.shade300,
//                                     ),
//                                     child: Image.asset(
//                                       "assets/logodispora.png",
//                                       color: Colors.white,
//                                     ),
//                                   ); // Ganti dengan placeholder yang sesuai.
//                                 },
//                               ),
//                             )
//                           else
//                             Container(
//                               height: MediaQuery.of(context).size.width / 4,
//                               width: MediaQuery.of(context).size.width / 4,
//                               padding: const EdgeInsets.all(10),
//                               decoration: BoxDecoration(
//                                 borderRadius:
//                                     const BorderRadius.all(Radius.circular(10)),
//                                 color: Colors.grey.shade300,
//                               ),
//                               child: Image.asset(
//                                 "assets/logodispora.png",
//                                 color: Colors.white,
//                               ),
//                             ),
//                           SizedBox(
//                             height: MediaQuery.of(context).size.width / 4,
//                             width: (MediaQuery.of(context).size.width -
//                                     MediaQuery.of(context).size.width / 4) -
//                                 (32),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.only(
//                                       left: 10, bottom: 10),
//                                   child: Text(
//                                     home.berita[index].title,
//                                     style: GoogleFonts.arimo(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w700,
//                                     ),
//                                     maxLines: 3,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.only(left: 10),
//                                   child: Text(
//                                     modifyDateTime(home.berita[index].date),
//                                     style: GoogleFonts.arimo(
//                                       fontSize: 12,
//                                       color: Colors.grey,
//                                     ),
//                                     maxLines: 3,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   if (index == home.berita.length - 1)
//                     const SizedBox(
//                       height: 50,
//                     )
//                 ],
//               );
//             },
//           )),
//     );
//   }

//   Widget _buildLoadingListWidget() {
//     return Shimmer.fromColors(
//       baseColor: Colors.grey.shade300,
//       highlightColor: Colors.grey.shade100,
//       enabled: true,
//       child: ListView(
//         children: [
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: Column(
//               children: [
//                 Container(
//                   width: MediaQuery.of(context).size.width - 32,
//                   height: MediaQuery.of(context).size.height / 4,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 16,
//                 ),
//                 for (int i = 0; i < 5; i++)
//                   Container(
//                     padding:
//                         const EdgeInsets.only(left: 16, right: 16, bottom: 16),
//                     child: Row(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(
//                           height: MediaQuery.of(context).size.width / 4,
//                           width: MediaQuery.of(context).size.width / 4,
//                           decoration: const BoxDecoration(
//                             borderRadius: BorderRadius.all(Radius.circular(10)),
//                             color: Colors.white,
//                           ),
//                         ),
//                         SizedBox(
//                           height: MediaQuery.of(context).size.width / 4,
//                           width: (MediaQuery.of(context).size.width -
//                                   MediaQuery.of(context).size.width / 4) -
//                               (32),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Container(
//                                 margin:
//                                     const EdgeInsets.only(left: 10, bottom: 8),
//                                 height: 16,
//                                 decoration: const BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(10),
//                                   ),
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Container(
//                                 margin:
//                                     const EdgeInsets.only(left: 10, bottom: 8),
//                                 height: 16,
//                                 decoration: const BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(10),
//                                   ),
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Container(
//                                 margin:
//                                     const EdgeInsets.only(left: 10, bottom: 10),
//                                 height: 16,
//                                 width: MediaQuery.of(context).size.width / 2,
//                                 decoration: const BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(10),
//                                   ),
//                                   color: Colors.white,
//                                 ),
//                               ),
//                               Container(
//                                 margin: const EdgeInsets.only(left: 10),
//                                 height: 12,
//                                 width: 120,
//                                 decoration: const BoxDecoration(
//                                   borderRadius: BorderRadius.all(
//                                     Radius.circular(10),
//                                   ),
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
