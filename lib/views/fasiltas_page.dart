import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: FutureBuilder(
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
      ),
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
          child: Image.asset("assets/dispora.png"),
        ),
      ),
    );
  }

  Widget _buildLoadingListWidget() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: Container(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
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
                    margin: const EdgeInsets.only(left: 10, bottom: 10),
                    height: 20,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, bottom: 10),
                    height: 20,
                    width: 120,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10),
                    height: 16,
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
          ],
        ),
      ),
    );
  }

  Widget _buildVenueList(List list) {
    return ListView.builder(
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
                list[index]['date'],
              );
            } else if (snapshot.hasError) {
              return const Text("Tidak Ditemukan");
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
    return Column(
      children: [
        InkWell(
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
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (imageUrl != null)
                  Container(
                    height: MediaQuery.of(context).size.width / 4,
                    width: MediaQuery.of(context).size.width / 4,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
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
                      "assets/dispora.png",
                      color: Colors.white54,
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
                        padding: const EdgeInsets.only(left: 10, bottom: 10),
                        child: Text(
                          venueInfo['title'] ?? "",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          date,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
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
      ],
    );
  }
}
