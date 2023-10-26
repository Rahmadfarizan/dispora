import 'dart:developer' as logger show log;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../home/presentation/widgets/detail_widget.dart';
import '../../model/fasilitas_model.dart';
import '../provider/fasilitas_provider.dart';

class ListFasilitasWidget extends StatefulWidget {
  final String linkImage;
  final String linkContent;
  final String title;
  const ListFasilitasWidget({
    super.key,
    required this.linkImage,
    required this.linkContent,
    required this.title,
  });

  @override
  State<ListFasilitasWidget> createState() => _ListFasilitasWidgetState();
}

class _ListFasilitasWidgetState extends State<ListFasilitasWidget> {
  Future<List<Fasilitas>>? futureLoadFasilitas;
  Future<List<FasilitasDetail>>? futureLoadFasilitasDetail;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    Future.wait([
      context.read<FasilitasProvider>().loadFasilitas(widget.linkImage),
      context.read<FasilitasProvider>().loadDetailFasilitas(widget.linkContent),
    ]).then((results) {
      futureLoadFasilitas = results[0] as Future<List<Fasilitas>>?;
      futureLoadFasilitasDetail = results[1] as Future<List<FasilitasDetail>>?;
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

  String modifyDateTime(String originalDateTime) {
    // Parse the original date from the string
    DateTime parsedDateTime = DateTime.parse(originalDateTime);

    // Calculate the time difference between the current time and the original time
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade100,
        title: Text(
          widget.title,
          style: GoogleFonts.arimo(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: (_isLoading)
          ? ListView(
              padding: const EdgeInsets.only(top: 16),
              children: [for (int i = 0; i < 3; i++) _buildLoadingListWidget()],
            )
          : Consumer<FasilitasProvider>(
              builder: (context, fasilitas, _) =>
                  _buildVenueList(fasilitas.venues)),
    );
  }

  Widget _buildLoadingListWidget() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(width: 1, color: Colors.grey.shade300),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        enabled: true,
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
                    margin:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 10),
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
    );
  }

  Widget _buildVenueList(List<Fasilitas> list) {
    return Consumer<FasilitasProvider>(builder: (context, fasilitasDetail, _) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 16),
        itemCount: list.length, // Use the length of 'list' here
        itemBuilder: (BuildContext context, int index) {
          if (index < fasilitasDetail.venuesDetail.length) {
            // Check the bounds
            final data = fasilitasDetail.venuesDetail;
            final venueInfo = _extractVenueInfo(data, list[index].slug);
            return (_isLoading)
                ? _buildLoadingListWidget()
                : _buildVenueItem(
                    venueInfo,
                    list[index].image,
                    modifyDateTime(list[index].date),
                  );
          } else {
            // Handle the case when the index is out of bounds (optional)
            return const SizedBox(); // Replace with an appropriate widget or leave it empty
          }
        },
      );
    });
  }

  Map<String, String> _extractVenueInfo(
      List<FasilitasDetail> data, String slug) {
    String title = "";
    String content = "";
    for (int i = 0; i < data.length; i++) {
      if (data[i].slug == slug) {
        title = data[i].title;
        content = data[i].content;
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
