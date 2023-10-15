import 'package:carousel_slider/carousel_slider.dart';
import 'package:dispora/views/detail_widget.dart';
import 'package:dispora/service/service_api.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF9F7F7),
      child: FutureBuilder(
        future: fetchWpPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final list = snapshot.data as List;
            final listImages = list
                .where((post) =>
                    post['_embedded']['wp:featuredmedia'][0]['source_url'] !=
                    null)
                .map((post) =>
                    post['_embedded']['wp:featuredmedia'][0]['source_url'])
                .toList();

            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index == 0)
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: CarouselSlider(
                          items: [
                            for (final imageUrl in listImages)
                              Container(
                                width: MediaQuery.of(context).size.width - 32,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          ],
                          options: CarouselOptions(
                            height: MediaQuery.of(context).size.height / 3,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 10),
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
                              title: list[index]['title']['rendered'] ?? "",
                              content: list[index]['content']['rendered'] ?? "",
                              image: list[index]['_embedded']
                                      ['wp:featuredmedia'][0]['source_url'] ??
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
                            if (list[index]['_embedded']['wp:featuredmedia'][0]
                                    ['source_url'] !=
                                null)
                              Container(
                                height: MediaQuery.of(context).size.width / 4,
                                width: MediaQuery.of(context).size.width / 4,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  image: DecorationImage(
                                    image: NetworkImage(list[index]['_embedded']
                                                ['wp:featuredmedia'][0]
                                            ['source_url'] ??
                                        ""),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
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
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: Text(
                                      list[index]['title']['rendered'] ?? "",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text(
                                      list[index]['date'],
                                      style: const TextStyle(
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
        },
      ),
    );
  }
}
