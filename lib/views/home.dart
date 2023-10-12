import 'package:flutter/material.dart';
import 'package:flutter_wordpress_example/wp_api.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'dart:developer' as logger show log;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child:
            // FutureBuilder(
            //     future: fetchWpPosts(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return ListView.builder(
            //           itemCount: snapshot.data!.length,
            //           itemBuilder: (context, index) {
            //             Map wpPost = snapshot.data![index];

            //             return PostTile(
            //                 wpPost["_links"]["wp:featuredmedia"][0]["href"],
            //                 wpPost["title"]["rendered"],
            //                 wpPost["excerpt"]["rendered"],
            //                 wpPost["content"]["rendered"]);
            //           },
            //         );
            //       }

            //       return CircularProgressIndicator();
            //     }),
            // FutureBuilder(
            //     future: fetchWpVenue(),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return ListView.builder(
            //           itemCount: snapshot.data!.length,
            //           itemBuilder: (context, index) {
            //             Map wpPost = snapshot.data![index];

            //             return FasilitasWidget(
            //                 wpPost["_links"]["wp:attachment"][0]["href"],
            //                 wpPost["title"]["rendered"],
            //                 wpPost["excerpt"]["rendered"],
            //                 wpPost["content"]["rendered"]);
            //           },
            //         );
            //       }

            //       return const CircularProgressIndicator();
            //     }),
            FutureBuilder(
                future: fetchWpMedia(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Map wpPost = snapshot.data![index];

                        return MediaWidget(
                            wpPost["guid"]["rendered"],
                            wpPost["title"]["rendered"],
                            wpPost["description"]["rendered"],
                            wpPost["caption"]["rendered"]);
                      },
                    );
                  }

                  return const CircularProgressIndicator();
                }),
      ),
    );
  }
}

class PostTile extends StatefulWidget {
  final String href, title, desc, content;
  PostTile(this.href, this.title, this.desc, this.content);

  @override
  State<PostTile> createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FutureBuilder(
          future: fetchWpPostImage(widget.href),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data;

              if (data != null &&
                  data["guid"] != null &&
                  data["guid"]["rendered"] != null) {
                return Image.network(data["guid"]["rendered"]);
              } else {
                return const SizedBox.shrink();
              }
            } else if (snapshot.hasError) {
              logger.log("Error: ${snapshot.error}");
              return Text("Gambar Tidak Ditemukan");
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          widget.title,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 5,
        ),
        HtmlWidget(widget.desc),
      ]),
    );
  }
}

class FasilitasWidget extends StatefulWidget {
  final String href, title, desc, content;
  FasilitasWidget(this.href, this.title, this.desc, this.content);

  @override
  State<FasilitasWidget> createState() => _FasilitasWidgetState();
}

class _FasilitasWidgetState extends State<FasilitasWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FutureBuilder(
          future: fetchWpPostImage(widget.href),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final data = snapshot.data;

                if (data != null &&
                    data is Map<String, dynamic> &&
                    data.containsKey("guid")) {
                  final guid = data["guid"];
                  if (guid != null &&
                      guid is Map<String, dynamic> &&
                      guid.containsKey("rendered")) {
                    final imageUrl = guid["rendered"];
                    return Image.network(imageUrl);
                  }
                }

                // Handle cases where the data structure is not as expected.
                return const SizedBox.shrink();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              }
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          widget.title,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 5,
        ),
        HtmlWidget(widget.desc),
      ]),
    );
  }
}

class MediaWidget extends StatefulWidget {
  final String href, title, desc, content;
  MediaWidget(this.href, this.title, this.desc, this.content);

  @override
  State<MediaWidget> createState() => _MediaWidgetState();
}

class _MediaWidgetState extends State<MediaWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        FutureBuilder(
          future: fetchWpPostImage(widget.href),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                return Image.network(data);
              } else if (snapshot.hasError) {
                logger.log("Error: ${snapshot.error}");
                return Text("Gambar Tidak Ditemukan");
              }
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
        const SizedBox(
          height: 8,
        ),
        HtmlWidget(
          "Title ${widget.title}",
          textStyle: const TextStyle(fontSize: 18),
        ),
        const SizedBox(
          height: 5,
        ),
        HtmlWidget("Desc ${widget.desc}"),
        HtmlWidget("Content ${widget.content}"),
      ]),
    );
  }
}
