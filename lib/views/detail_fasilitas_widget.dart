import 'package:dispora/views/list_fasilitas_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../service/service_api.dart';
import 'dart:developer' as logger show log;

class DetailFasilitasWidget extends StatefulWidget {
  final String kecamatan;
  const DetailFasilitasWidget({super.key, required this.kecamatan});

  @override
  State<DetailFasilitasWidget> createState() => _DetailFasilitasWidgetState();
}

class _DetailFasilitasWidgetState extends State<DetailFasilitasWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade100,
        title: Text(
          widget.kecamatan,
          style: GoogleFonts.arimo(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: FutureBuilder(
        future: fetchFasilitas(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingWidget();
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error: Tidak Ditemukan"));
          } else {
            final list = snapshot.data as List;
            // return _buildVenueList(list);

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                String lowerA = list[index]["title"]["rendered"].toLowerCase();
                String lowerB = widget.kecamatan.toLowerCase();

                // Check if string A contains string B
                bool containsStringB = lowerA.contains(lowerB);
                String image = "";

                if (lowerA.toLowerCase().contains("sepak bola")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/stadion-150x150.png";
                } else if (lowerA.toLowerCase().contains("bulu tangkis")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/field-150x150.png";
                } else if (lowerA.toLowerCase().contains("basket")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/basketball-court-150x150.png";
                } else if (lowerA.toLowerCase().contains("futsal")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/futsal-150x150.png";
                } else if (lowerA.toLowerCase().contains("volly")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/volleyball-court-150x150.png";
                } else if (lowerA.toLowerCase().contains("takraw")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/sepak-takraw-1-150x150.png";
                } else if (lowerA.toLowerCase().contains("tenis di")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/court-150x150.png";
                } else if (lowerA.toLowerCase().contains("senam")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/on-fire-150x150.png";
                } else if (lowerA.toLowerCase().contains("fitnes") ||
                    lowerA.toLowerCase().contains("gym")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/gym-150x150.png";
                } else if (lowerA.toLowerCase().contains("tenis meja")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/table-tennis-1-150x150.png";
                } else if (lowerA.toLowerCase().contains("petanque")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/petanque-150x150.png";
                } else if (lowerA.toLowerCase().contains("muaythai")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/muay-thai-1-150x150.png";
                } else if (lowerA.toLowerCase().contains("panahan")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/shooting-range-1-150x150.png";
                } else if (lowerA.toLowerCase().contains("tembak")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/target-150x150.png";
                } else if (lowerA.toLowerCase().contains("renang")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/swimming-pool-150x150.png";
                } else if (lowerA.toLowerCase().contains("taekwondo")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/taekwondo-150x150.png";
                } else if (lowerA.toLowerCase().contains("golf")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/golf-150x150.png";
                } else if (lowerA.toLowerCase().contains("silat")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/pencak-silat-150x150.png";
                } else if (lowerA.toLowerCase().contains("softball")) {
                  image =
                      "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/10/baseball-150x150.png";
                }

                return (containsStringB &&
                        lowerA.toLowerCase().contains("lapangan"))
                    ? InkWell(
                        onTap: () {
                          logger.log(
                              "linkImage => ${list[index]["_links"]["wp:attachment"][0]["href"]}");
                          logger.log(
                              "linkContent => ${list[index]["_links"]["self"][0]["href"]}");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ListFasilitasWidget(
                                linkImage: list[index]["_links"]
                                    ["wp:attachment"][0]["href"],
                                linkContent: list[index]["_links"]["self"][0]
                                    ["href"],
                                title: list[index]["title"]["rendered"],
                              ),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            (image.isNotEmpty)
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      image,
                                      height:
                                          MediaQuery.of(context).size.width / 4,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                    ),
                                  )
                                : Container(
                                    padding: const EdgeInsets.all(10),
                                    height:
                                        MediaQuery.of(context).size.width / 4,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
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
                              width: 10,
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Text(
                                  list[index]["title"]["rendered"],
                                  style: GoogleFonts.arimo(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : SizedBox.shrink();
              },
            );
          }
        },
      ),
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
