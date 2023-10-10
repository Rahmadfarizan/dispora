import 'package:flutter/material.dart';
import 'package:flutter_wordpress_example/wp_api.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

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
        child: FutureBuilder(
            future: fetchWpPosts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    Map wpPost = snapshot.data![index];

                    return PostTile(
                        wpPost["_links"]["wp:featuredmedia"][0]["href"],
                        wpPost["title"]["rendered"],
                        wpPost["excerpt"]["rendered"],
                        wpPost["content"]["rendered"]);
                  },
                );
              }

              return CircularProgressIndicator();
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                return SizedBox.shrink();
              }
            } else if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
        SizedBox(
          height: 8,
        ),
        Text(
          widget.title,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(
          height: 5,
        ),
        HtmlWidget(widget.desc),
      ]),
    );
  }
}
