import 'package:dispora/views/detail_fasilitas_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../models/venue_model.dart';
import '../service/service_api.dart';
import 'detail_widget.dart';
import 'dart:developer' as logger show log;

class FasilitasPage extends StatefulWidget {
  const FasilitasPage({super.key});

  @override
  State<FasilitasPage> createState() => _FasilitasPageState();
}

class _FasilitasPageState extends State<FasilitasPage> {
  final model = VenueModel();

  List<String> listKecamatan = [
    "Bina widya",
    "Sail",
    "Bukit Raya",
    "Marpoyan Damai",
    "Kulim",
    "Pekanbaru Kota",
    "Rumbai",
    "Payung Sekaki",
    "Rumbai Barat",
    "Tenayan Raya",
    "Tuah Madani",
    "Sukajadi",
    "Senapelan",
    "Lima Puluh"
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      await model.fetchVenueData();
      await model.fetchDetailVenueData();
    } catch (e) {
      logger.log('Error: $e');
    }
  }

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
    return ListView.builder(
        itemCount: listKecamatan.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailFasilitasWidget(
                    kecamatan: listKecamatan[index],
                  ),
                ),
              );
            },
            child: Container(
                padding:
                    EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
                child: Text(listKecamatan[index])),
          );
        });
  }

  Widget _buildListKecamatan(List list) {
    // Create a list of unique Kecamatan names
    List<String> uniqueKecamatanNames = [];

    for (int index = 0; index < listKecamatan.length; index++) {
      String kecamatanName = listKecamatan[index].toLowerCase();

      if (!uniqueKecamatanNames.contains(kecamatanName)) {
        uniqueKecamatanNames.add(kecamatanName);
      }
    }

    return ListView(
      children: uniqueKecamatanNames.map((kecamatanName) {
        return _buildKecamatanItem(kecamatanName, list);
      }).toList(),
    );
  }

  Widget _buildKecamatanItem(String kecamatanName, List list) {
    List<Widget> kecamatanWidgets = [];

    for (int i = 0; i < list.length; i++) {
      String title = "";
      String content = "";
      String image = "";
      String lowerA = list[i]["title"]["rendered"].toLowerCase();
      String lowerB = kecamatanName.toLowerCase();

      // Check if string A contains string B
      bool containsStringB = lowerA.contains(lowerB);

      if (containsStringB) {
        title = list[i]["title"]["rendered"];
        content = list[i]["content"]["rendered"];
        if (list[i]["_links"]["wp:attachment"] != null &&
            list[i]["_links"]["wp:attachment"].isNotEmpty) {
          image = list[i]["_links"]["wp:attachment"][0]["href"];
        }
      }

      kecamatanWidgets.add(_buildKecamatanDetail(title, content, image));
    }

    return Column(
      children: <Widget>[
        Text("Kecamatan $kecamatanName",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Column(children: kecamatanWidgets),
      ],
    );
  }

  Widget _buildKecamatanDetail(String title, String content, String image) {
    // Check the image data and handle it here
    if (image != null && image.isNotEmpty) {
      return FutureBuilder(
        future: fetchFasilitasImage(image),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingListWidget();
          } else if (snapshot.hasData) {
            final data = snapshot.data;
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Detail(
                      title: title,
                      content: content,
                      image: data["source_url"] ?? "",
                    ),
                  ),
                );
              },
              child: ListTile(
                title: Text(title),
                // You can add other widgets here as needed.
              ),
            );
          } else if (snapshot.hasError) {
            return Text(
              "Tidak Ditemukan",
              style: GoogleFonts.arimo(),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      );
    } else {
      return ListTile(
        title: Text(title),
        // You can add other widgets here as needed for items without images.
      );
    }
  }

  Widget _buildLoadingWidget() {
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

  Widget _buildLoadingListWidget() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: Colors.grey.shade300),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  color: Colors.white,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10),
                      height: 16,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      height: 12,
                      width: 150,
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
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVenueList(List list) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return FutureBuilder(
          future: model.fetchDetailVenueData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoadingListWidget();
            } else if (snapshot.hasData) {
              final data = snapshot.data;
              final venueInfo = _extractVenueInfo(data, list[index]['id']);
              return _buildVenueItem(
                venueInfo,
                list[index]['guid']['rendered'],
                modifyDateTime(list[index]['date']),
              );
            } else if (snapshot.hasError) {
              return Text(
                "Tidak Ditemukan",
                style: GoogleFonts.arimo(),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }

  Map<String, String> _extractVenueInfo(dynamic data, int id) {
    String title = "";
    String content = "";
    for (int i = 0; i < data!.length; i++) {
      if (data[i]["featured_media"] == id) {
        title = data[i]["title"]["rendered"];
        content = data[i]["content"]["rendered"];
      }
    }
    return {'title': title, 'content': content};
  }

  Widget _buildVenueItem(
      Map<String, String> venueInfo, String imageUrl, String date) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Detail(
              title: venueInfo['title'],
              content: venueInfo['content'],
              image: imageUrl ?? "",
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey.shade300),
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              Container(
                height: MediaQuery.of(context).size.height / 4,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            else
              Container(
                height: MediaQuery.of(context).size.width / 4,
                width: MediaQuery.of(context).size.width / 4,
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.grey,
                ),
                child: Image.asset(
                  "assets/logodispora.png",
                  color: Colors.white54,
                ),
              ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(top: 10, left: 10, bottom: 10),
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    venueInfo['title'] ?? "",
                    style: GoogleFonts.arimo(
                        fontSize: 16, fontWeight: FontWeight.w700),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    date,
                    style: GoogleFonts.arimo(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
