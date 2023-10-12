// import 'package:flutter/material.dart';
// import 'package:flutter_wordpress_example/views/home.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           primarySwatch: Colors.blue,
//         ),
//         home: const Home());
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_wordpress_example/views/home2.dart';
import 'package:flutter_wordpress_example/wp_api.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Api api = Api();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter News'),
        ),
        body: FutureBuilder(
          future: api.fetchData(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var list = snapshot.data as List;

              return GridView.builder(
                itemCount: list.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // banyak grid yang ditampilkan dalam satu baris
                  crossAxisCount: 2,
                ),
                itemBuilder: (_, index) {
                  return Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          // DetailPage adalah halaman yang dituju
                          // MaterialPageRoute(
                          //   builder: (context) => Detail(
                          //     title: list[index]['title']['rendered'],
                          //     content: list[index]['content']['rendered'],
                          //     image: (list[index]['_embedded']
                          //                     ['wp:featuredmedia'][0]
                          //                 ['source_url'] !=
                          //             null)
                          //         ? list[index]['_embedded']
                          //             ['wp:featuredmedia'][0]['source_url']
                          //         : "",
                          //   ),
                          // ),
                          /// untuk Pages
                          // MaterialPageRoute(
                          //   builder: (context) => Detail(
                          //     title: list[index]['title']['rendered'] ?? "",
                          //     content: list[index]['content']['rendered'] ?? "",
                          //     image: "",
                          //   ),
                          // ),
                          //untuk categori
                          // MaterialPageRoute(
                          //   builder: (context) => Detail(
                          //     title: list[index]['name'] ?? "",
                          //     content: list[index]['_links']['wp:post_type'][0]
                          //             ["href"] ??
                          //         "",
                          //     image: "",
                          //   ),
                          // ),
                          /// Untuk media
                          MaterialPageRoute(
                            builder: (context) => Detail(
                              title: list[index]['title']['rendered'] ?? "",
                              content: list[index]['date'] ?? "",
                              image: list[index]['source_url'] ?? "",
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          // if (list[index]['_embedded']['wp:featuredmedia'][0]
                          //         ['source_url'] !=
                          //     null)
                          //   Flexible(
                          //     child: Image.network(
                          //       list[index]['_embedded']['wp:featuredmedia']
                          //           [0]['source_url'],
                          //       height:
                          //           100, // Sesuaikan ukuran gambar sesuai kebutuhan.
                          //       fit: BoxFit.cover,
                          //       width: MediaQuery.of(context).size.width,
                          //     ),
                          //   ),

                          /// untuk pages

                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     left: 5,
                          //     right: 5,
                          //     top: 5,
                          //     bottom: 5,
                          //   ),
                          //   child: Text(
                          //     list[index]['title']["rendered"] ??
                          //         "", //sesuaikan dengan data api
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //     ),
                          //     maxLines: 3,
                          //   ),
                          // ),

                          /// untuk Category
                          // if (list[index]['guid']['rendered'] != null)
                          //   Flexible(
                          //     child: Image.network(
                          //       list[index]['guid']['rendered'] ?? "",
                          //       height:
                          //           100, // Sesuaikan ukuran gambar sesuai kebutuhan.
                          //       fit: BoxFit.cover,
                          //       width: MediaQuery.of(context).size.width,
                          //     ),
                          //   ),
                          // Padding(
                          //   padding: const EdgeInsets.only(
                          //     left: 5,
                          //     right: 5,
                          //     top: 5,
                          //     bottom: 5,
                          //   ),
                          //   child: Text(
                          //     list[index]['name'] ??
                          //         "", //sesuaikan dengan data api
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //     ),
                          //     maxLines: 3,
                          //   ),
                          // ),

                          /// untuk Media
                          if (list[index]['guid']['rendered'] != null)
                            Flexible(
                              child: Image.network(
                                list[index]['source_url'] ?? "",
                                height:
                                    100, // Sesuaikan ukuran gambar sesuai kebutuhan.
                                fit: BoxFit.cover,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 5,
                              right: 5,
                              top: 5,
                              bottom: 5,
                            ),
                            child: Text(
                              list[index]['title']['rendered'] ??
                                  "", //sesuaikan dengan data api
                              style: TextStyle(
                                fontSize: 16,
                              ),
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }
}
