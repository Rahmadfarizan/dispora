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

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wordpress_example/views/home2.dart';
import 'package:flutter_wordpress_example/wp_api.dart';

/// warna
/// 29366A biru
/// F9322E merah
/// F05C39 oren
/// 458E32 hijau
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
  int _selectedIndex = 0; // Index of the selected tab

  List<Widget> _pages = [
    const FirstPage(),
    const SecondPage(),
    const ThirdPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (_selectedIndex == 0)
          ? buildAppBar(context)
          : AppBar(
              toolbarHeight: 0,
              backgroundColor: Color(0xff29366A),
            ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: buildBottomBar(),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      toolbarHeight: 100,
      backgroundColor: Colors.white,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width / 4,
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/dispora.png"),
                      fit: BoxFit.contain, // Adjust this to your needs
                    ),
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          FutureBuilder(
            future: fetchWpCategory(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 20,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Map wpPost = snapshot.data![index];
                        return Container(
                          padding: EdgeInsets.only(
                            left: 16,
                            right:
                                (index == snapshot.data!.length - 1) ? 16 : 0,
                          ),
                          child: Text(
                            wpPost["name"],
                            style: TextStyle(
                              color: (index == 0) ? Colors.black : Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              }
              return const CircularProgressIndicator();
            },
          ),
        ],
      ),
    );
  }

  Container buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1), // Shadow color
            spreadRadius: 5, // Spread radius
            blurRadius: 5, // Blur radius
            offset: const Offset(0, -3), // Offset the shadow upwards
          ),
        ],
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_rounded),
            label: 'Fasilitas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group_rounded),
            label: 'Sosial',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff29366A),
        onTap: _onItemTapped,
      ),
    );
  }
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  Api api = Api();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffF9F7F7),
      child: FutureBuilder(
        future: fetchWpPosts(),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            var list = snapshot.data as List;
            var listImages = [];
            for (int i = 0; i < list.length; i++) {
              if (list[i]['_embedded']['wp:featuredmedia'][0]['source_url'] !=
                  null)
                listImages.add(
                    list[i]['_embedded']['wp:featuredmedia'][0]['source_url']);
            }
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
                            for (int i = 0; i < listImages.length; i++)
                              Container(
                                width: MediaQuery.of(context).size.width - 32,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      listImages[i],
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            // Add more images as needed
                          ],
                          options: CarouselOptions(
                              height: MediaQuery.of(context).size.height /
                                  3, // Set the height of the carousel
                              autoPlay: true, // Set auto-play to true or false
                              autoPlayInterval: const Duration(
                                  seconds: 10), // Set the auto-play interval
                              autoPlayAnimationDuration: const Duration(
                                  milliseconds:
                                      800), // Set the animation duration
                              autoPlayCurve: Curves
                                  .fastOutSlowIn, // Set the animation curve
                              enlargeCenterPage: true,
                              viewportFraction: 1),
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
                            (list[index]['_embedded']['wp:featuredmedia'][0]
                                        ['source_url'] !=
                                    null)
                                ? Container(
                                    height:
                                        MediaQuery.of(context).size.width / 4,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          list[index]['_embedded']
                                                      ['wp:featuredmedia'][0]
                                                  ['source_url'] ??
                                              "",
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : Container(
                                    height:
                                        MediaQuery.of(context).size.width / 4,
                                    width:
                                        MediaQuery.of(context).size.width / 4,
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.grey),
                                  ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding:
                                        EdgeInsets.only(left: 10, bottom: 10),
                                    child: Text(
                                      list[index]['title']['rendered'] ?? "",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Text(
                                      list[index]['date'],
                                      style: const TextStyle(
                                          fontSize: 12, color: Colors.grey),
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search Page'),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Profile Page'),
    );
  }
}










  // Expanded(
                //   child: GridView.builder(
                //     itemCount: list.length,
                //     gridDelegate:
                //         const SliverGridDelegateWithFixedCrossAxisCount(
                //       // banyak grid yang ditampilkan dalam satu baris
                //       crossAxisCount: 2,
                //     ),
                //     itemBuilder: (_, index) {
                //       return Container(
                //         margin: const EdgeInsets.all(8.0),
                //         decoration: BoxDecoration(
                //           border: Border.all(
                //             color: Colors.grey,
                //             width: 1.0,
                //           ),
                //         ),
                //         child: InkWell(
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               // DetailPage adalah halaman yang dituju
                //               // MaterialPageRoute(
                //               //   builder: (context) => Detail(
                //               //     title: list[index]['title']['rendered'],
                //               //     content: list[index]['content']['rendered'],
                //               //     image: (list[index]['_embedded']
                //               //                     ['wp:featuredmedia'][0]
                //               //                 ['source_url'] !=
                //               //             null)
                //               //         ? list[index]['_embedded']
                //               //             ['wp:featuredmedia'][0]['source_url']
                //               //         : "",
                //               //   ),
                //               // ),
                //               /// untuk Pages
                //               // MaterialPageRoute(
                //               //   builder: (context) => Detail(
                //               //     title: list[index]['title']['rendered'] ?? "",
                //               //     content: list[index]['content']['rendered'] ?? "",
                //               //     image: "",
                //               //   ),
                //               // ),
                //               //untuk categori
                //               // MaterialPageRoute(
                //               //   builder: (context) => Detail(
                //               //     title: list[index]['name'] ?? "",
                //               //     content: list[index]['_links']['wp:post_type'][0]
                //               //             ["href"] ??
                //               //         "",
                //               //     image: "",
                //               //   ),
                //               // ),
                //               /// Untuk media
                //               MaterialPageRoute(
                //                 builder: (context) => Detail(
                //                   title:
                //                       list[index]['title']['rendered'] ?? "",
                //                   content: list[index]['date'] ?? "",
                //                   image: list[index]['source_url'] ?? "",
                //                 ),
                //               ),
                //             );
                //           },
                //           child: Column(
                //             children: [
                //               // if (list[index]['_embedded']['wp:featuredmedia'][0]
                //               //         ['source_url'] !=
                //               //     null)
                //               //   Flexible(
                //               //     child: Image.network(
                //               //       list[index]['_embedded']['wp:featuredmedia']
                //               //           [0]['source_url'],
                //               //       height:
                //               //           100, // Sesuaikan ukuran gambar sesuai kebutuhan.
                //               //       fit: BoxFit.cover,
                //               //       width: MediaQuery.of(context).size.width,
                //               //     ),
                //               //   ),

                //               /// untuk pages

                //               // Padding(
                //               //   padding: const EdgeInsets.only(
                //               //     left: 5,
                //               //     right: 5,
                //               //     top: 5,
                //               //     bottom: 5,
                //               //   ),
                //               //   child: Text(
                //               //     list[index]['title']["rendered"] ??
                //               //         "", //sesuaikan dengan data api
                //               //     style: TextStyle(
                //               //       fontSize: 16,
                //               //     ),
                //               //     maxLines: 3,
                //               //   ),
                //               // ),

                //               /// untuk Category
                //               // if (list[index]['guid']['rendered'] != null)
                //               //   Flexible(
                //               //     child: Image.network(
                //               //       list[index]['guid']['rendered'] ?? "",
                //               //       height:
                //               //           100, // Sesuaikan ukuran gambar sesuai kebutuhan.
                //               //       fit: BoxFit.cover,
                //               //       width: MediaQuery.of(context).size.width,
                //               //     ),
                //               //   ),
                //               // Padding(
                //               //   padding: const EdgeInsets.only(
                //               //     left: 5,
                //               //     right: 5,
                //               //     top: 5,
                //               //     bottom: 5,
                //               //   ),
                //               //   child: Text(
                //               //     list[index]['name'] ??
                //               //         "", //sesuaikan dengan data api
                //               //     style: TextStyle(
                //               //       fontSize: 16,
                //               //     ),
                //               //     maxLines: 3,
                //               //   ),
                //               // ),

                //               /// untuk Media
                //               if (list[index]['guid']['rendered'] != null)
                //                 Flexible(
                //                   child: Image.network(
                //                     list[index]['source_url'] ?? "",
                //                     height:
                //                         100, // Sesuaikan ukuran gambar sesuai kebutuhan.
                //                     fit: BoxFit.cover,
                //                     width: MediaQuery.of(context).size.width,
                //                   ),
                //                 ),
                //               Padding(
                //                 padding: const EdgeInsets.only(
                //                   left: 5,
                //                   right: 5,
                //                   top: 5,
                //                   bottom: 5,
                //                 ),
                //                 child: Text(
                //                   list[index]['title']['rendered'] ??
                //                       "", //sesuaikan dengan data api
                //                   style: const TextStyle(
                //                     fontSize: 16,
                //                   ),
                //                   maxLines: 3,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         ),
                //       );
                //     },
                // ),
                // ),