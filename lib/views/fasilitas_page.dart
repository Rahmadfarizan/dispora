import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../models/venue_model.dart';
import 'detail_widget.dart';
import 'dart:developer' as logger show log;

class FasilitasPage extends StatefulWidget {
  const FasilitasPage({super.key});

  @override
  State<FasilitasPage> createState() => _FasilitasPageState();
}

class _FasilitasPageState extends State<FasilitasPage> {
  final model = VenueModel();

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
    return FutureBuilder(
      future: model.fetchVenueData(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        } else if (snapshot.hasError) {
          return const Center(child: Text("Error: Tidak Ditemukan"));
        } else {
          final list = snapshot.data as List;
          return _buildVenueList(list);
        }
      },
    );
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
