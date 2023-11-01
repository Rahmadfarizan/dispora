import 'dart:developer' as logger show log;

import 'package:dispora/features/fasilitas/presentation/provider/fasilitas_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/fasilitas_model.dart';
import '../../service/fasilitas_service.dart';
import 'list_fasilitas_widget.dart';

class DetailFasilitasWidget extends StatefulWidget {
  final String kecamatan;
  const DetailFasilitasWidget({super.key, required this.kecamatan});

  @override
  State<DetailFasilitasWidget> createState() => _DetailFasilitasWidgetState();
}

class _DetailFasilitasWidgetState extends State<DetailFasilitasWidget> {
  bool isLoading = true;
  Future<List<FasilitasList>>? futureLoadListFasilitas;

  @override
  void initState() {
    super.initState();

    Future.wait([
      context.read<FasilitasProvider>().loadListFasilitas(widget.kecamatan),
    ]).then((results) {
      futureLoadListFasilitas = results[0] as Future<List<FasilitasList>>?;
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      // Handle errors if any of the futures fail
      logger.log(error.toString());
      setState(() {
        isLoading = false;
      });
    });
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
          widget.kecamatan,
          style: GoogleFonts.arimo(
            fontSize: 20,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // body: Text("testing"),
      body: (isLoading)
          ? _buildLoadingWidget()
          : Consumer<FasilitasProvider>(
              builder: (context, value, child) {
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    // mainAxisSpacing: 40,
                    // crossAxisSpacing: 24,
                    // width / height: fixed for *all* items

                    childAspectRatio: 0.95,
                  ),
                  itemCount: value.venuesList.length,
                  itemBuilder: (context, index) {
                    final list = value.venuesList;

                    String lowerA;
                    String image = "";

                    lowerA = list[index].title.toLowerCase();

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

                    return InkWell(
                      onTap: () {
                        logger.log("linkImage => ${list[index].linkImage}");
                        logger.log("linkContent => ${list[index].content}");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ListFasilitasWidget(
                              linkImage: list[index].linkImage,
                              linkContent: list[index].content,
                              title: list[index].title,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(2, 3),
                            )
                          ],
                        ),
                        child: (image.isNotEmpty)
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  children: [
                                    Image.network(
                                      image,
                                      height:
                                          MediaQuery.of(context).size.width / 4,
                                      width:
                                          MediaQuery.of(context).size.width / 4,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          list[index]
                                              .title
                                              .capitalizeEachWord(),
                                          style: GoogleFonts.arimo(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600),
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.all(16),
                                height: MediaQuery.of(context).size.width / 4,
                                width: MediaQuery.of(context).size.width / 4,
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
                      ),
                    );
                  },
                );
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

extension StringCapitalizationExtensions on String {
  // Capitalize the first letter of the string and make the rest lowercase.
  String capitalizeEachWord() {
    List<String> words = split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1);
      }
    }
    return words.join(' ');
  }
}
