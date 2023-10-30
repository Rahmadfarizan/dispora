import 'package:dispora/features/home/model/home_model.dart';
import 'package:dispora/features/home/presentation/provider/home_provider.dart';
import 'package:dispora/features/sosial/presentation/provider/sosial_provider.dart';

import 'features/fasilitas/presentation/provider/fasilitas_provider.dart';
import 'package:provider/provider.dart';

import 'features/home/service/home_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:developer' as logger show log;
import 'features/home/presentation/screen/home_screen.dart';
import 'features/sosial/presentation/screen/sosial_page.dart';
import 'features/video/presentation/screen/video_page.dart';
import 'features/fasilitas/presentation/screen/fasilitas_screen.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   SystemChrome.setPreferredOrientations(
//       [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
//   runApp(
//     MyApp(),
//   );
// }

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   State<MyApp> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   int _selectedIndex = 0;
//   int? _categorySelected;
//   String? _categoryTitle;
//   List<dynamic>? _categories;
//   bool _isLoading = true;
//   late List<Widget> pages;
//   final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//       GlobalKey<RefreshIndicatorState>();
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     HomeServiceApi().fetchWpCategory().then((snapshot) {
//       if (snapshot.isNotEmpty) {
//         setState(() {
//           _categories = snapshot;
//           _categorySelected = snapshot[0]["id"];
//           _categoryTitle = snapshot[0]["name"];
//           _isLoading = false;
//         });
//       }
//     });
//   }

//   Future<void> _refreshData() async {
//     // You can fetch new data or perform any necessary actions to refresh the content.
//     // Example: Call your API to fetch new data
//     // Update the UI with new data
//     setState(() {
//       _categorySelected;
//       _categoryTitle;

//       pages = [
//         HomePage(
//           categoryPost: _categorySelected ?? 0,
//           categoryTitle: _categoryTitle ?? "",
//         ),
//         const FasilitasPage(),
//         const SosialPage(),
//         const VideoPage(),
//       ];
//     });
//     await Future.delayed(Duration(seconds: 2));
//   }

//   void _onCategorySelected(int categoryId, String categoryTitle) {
//     setState(() {
//       _categorySelected = categoryId;
//       _categoryTitle = categoryTitle;
//     });
//     // Trigger the refresh action
//     _refreshIndicatorKey.currentState?.show();
//   }

//   @override
//   Widget build(BuildContext context) {
//     pages = [
//       HomePage(
//         categoryPost: _categorySelected ?? 0,
//         categoryTitle: _categoryTitle ?? "",
//       ),
//       const FasilitasPage(),
//       const SosialPage(),
//       const VideoPage(),
//     ];
//     return MultiProvider(
//       providers: [
//         ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
//         ChangeNotifierProvider<FasilitasProvider>(
//             create: (_) => FasilitasProvider()),
//         ChangeNotifierProvider<SosialProvider>(create: (_) => SosialProvider()),
//       ],
//       child: MaterialApp(
//         debugShowCheckedModeBanner: false,
//         home: Scaffold(
//           appBar: buildAppBar(),
//           body: RefreshIndicator(
//               key: _refreshIndicatorKey,
//               onRefresh: () async {
//                 // Handle the refresh action here, for example, fetch new data
//                 await _refreshData();
//                 setState(() {});
//               },
//               child: pages[_selectedIndex]),
//           bottomNavigationBar: buildBottomBar(),
//         ),
//       ),
//     );
//   }

//   AppBar buildAppBar() {
//     return AppBar(
//       titleSpacing: (_selectedIndex == 0) ? 0 : null,
//       toolbarHeight: (_selectedIndex == 0) ? 100 : null,
//       backgroundColor: Colors.white,
//       elevation: 1,
//       shadowColor: Colors.grey.shade100,
//       title: (_selectedIndex == 0)
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16),
//                   child: Row(
//                     children: [
//                       Container(
//                         height: 50,
//                         width: MediaQuery.of(context).size.width / 4,
//                         alignment: Alignment.topLeft,
//                         decoration: const BoxDecoration(
//                           image: DecorationImage(
//                             image: AssetImage("assets/logodispora.png"),
//                             fit: BoxFit.contain,
//                           ),
//                         ),
//                       ),
//                       const Spacer(),
//                       const Icon(
//                         Icons.search_rounded,
//                         color: Colors.black,
//                       )
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 FutureBuilder(
//                   future: HomeServiceApi().fetchWpCategory(),
//                   builder: (context, snapshot) {
//                     if (_isLoading) {
//                       // Menampilkan loading indicator
//                       return Shimmer.fromColors(
//                         baseColor: Colors.grey.shade300,
//                         highlightColor: Colors.grey.shade100,
//                         enabled: true,
//                         child: SingleChildScrollView(
//                           scrollDirection: Axis.horizontal,
//                           physics: const NeverScrollableScrollPhysics(),
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 16),
//                             child: Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               mainAxisSize: MainAxisSize.max,
//                               children: [
//                                 for (int i = 0; i < 5; i++)
//                                   const CategoryPlaceholder(width: 80),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }

//                     if (_categories != null) {
//                       return SizedBox(
//                         height: 20,
//                         width: MediaQuery.of(context).size.width,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemCount: _categories!.length,
//                           itemBuilder: (context, index) {
//                             Map wpPost = _categories![index];
//                             return InkWell(
//                               onTap: () {
//                                 _onCategorySelected(
//                                     wpPost["id"], wpPost["name"]);
//                                 // setState(() {
//                                 //   _categorySelected = wpPost["id"];
//                                 //   _categoryTitle = wpPost["name"];
//                                 // });

//                                 logger.log(
//                                     "_categorySelected => $_categorySelected");
//                                 logger.log("_categoryTitle => $_categoryTitle");
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 16,
//                                 ),
//                                 child: Text(
//                                   wpPost["name"],
//                                   style: GoogleFonts.arimo(
//                                     color: (_categoryTitle == wpPost["name"])
//                                         ? Colors.black
//                                         : Colors.grey,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     } else {
//                       logger.log("Data Tidak Ditemukan");
//                       return SizedBox.shrink();
//                     }
//                   },
//                 ),
//               ],
//             )
//           : Text(
//               (_selectedIndex == 1)
//                   ? "Fasilitas"
//                   : (_selectedIndex == 2)
//                       ? "Sosial"
//                       : "Video",
//               style: GoogleFonts.arimo(
//                 fontSize: 20,
//                 color: Colors.black,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//     );
//   }

//   Container buildBottomBar() {
//     return Container(
//       decoration: BoxDecoration(
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.shade100,
//             blurRadius: 1,
//             offset: const Offset(0, -1),
//           ),
//         ],
//       ),
//       child: BottomNavigationBar(
//         backgroundColor: Colors.white,
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.dashboard_rounded),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.business_rounded),
//             label: 'Fasilitas',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.group_rounded),
//             label: 'Sosial',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.play_arrow),
//             label: 'Video',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: const Color(0xff29366A),
//         type: BottomNavigationBarType.fixed,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

// class CategoryPlaceholder extends StatelessWidget {
//   final double width;

//   const CategoryPlaceholder({
//     Key? key,
//     required this.width,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(right: 10),
//       width: width,
//       height: 24,
//       decoration: const BoxDecoration(
//         borderRadius: BorderRadius.all(
//           Radius.circular(10),
//         ),
//         color: Colors.white,
//       ),
//     );
//   }
// }

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  int? _categorySelected;
  String? _categoryTitle;
  List<dynamic>? _categories;
  bool _isLoading = true;
  bool _isLoadingBerita = true;
  List<Widget>? pages;
  Future<List<Berita>>? futureLoadBerita;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

// Create a separate method to load categories and handle async operations.
  void _loadCategories() async {
    try {
      _isLoadingBerita = true;
      await HomeServiceApi().fetchWpCategory().then((snapshot) {
        setState(() {
          if (snapshot.isNotEmpty) {
            final selectedCategory = snapshot[0];
            setState(() {
              _categories = snapshot;
              _categorySelected = selectedCategory["id"];
              _categoryTitle = selectedCategory["name"];
              _isLoading = false;
              _isLoadingBerita = false;

              logger.log("_categorySelected =>$_categorySelected init");
            });
          }
        });
      });
    } catch (e) {
      // Handle any potential errors here.
      print('Error loading categories: $e');
    }
  }

  void _onCategorySelected(int categoryId, String categoryTitle) {
    setState(() {
      _categorySelected = categoryId;
      _categoryTitle = categoryTitle;

      logger.log("_onCategorySelected =>$_categorySelected");
    });
  }

  @override
  Widget build(BuildContext context) {
    pages = [
      HomePage(
        categoryPost: _categorySelected!,
        categoryTitle: _categoryTitle ?? "",
        isLoading: (_categorySelected == null) ? true : _isLoadingBerita,
      ),
      const FasilitasPage(),
      const SosialPage(),
      const VideoPage(),
    ];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<HomeProvider>(create: (_) => HomeProvider()),
        ChangeNotifierProvider<FasilitasProvider>(
            create: (_) => FasilitasProvider()),
        ChangeNotifierProvider<SosialProvider>(create: (_) => SosialProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: buildAppBar(),
          body:
              (pages == null) ? _buildLoadingWidget() : pages![_selectedIndex],
          bottomNavigationBar: buildBottomBar(),
        ),
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
          child: Image.asset("assets/logodispora.png"),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      titleSpacing: (_selectedIndex == 0) ? 0 : null,
      toolbarHeight: (_selectedIndex == 0) ? 100 : null,
      backgroundColor: Colors.white,
      elevation: 1,
      shadowColor: Colors.grey.shade100,
      title: (_selectedIndex == 0)
          ? Column(
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
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/logodispora.png"),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.search_rounded,
                        color: Colors.black,
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: HomeServiceApi().fetchWpCategory(),
                  builder: (context, snapshot) {
                    if (_isLoading) {
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                for (int i = 0; i < 5; i++)
                                  const CategoryPlaceholder(width: 80),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    if (_categories != null) {
                      return SizedBox(
                        height: 20,
                        width: MediaQuery.of(context).size.width,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _categories!.length,
                          itemBuilder: (context, index) {
                            Map wpPost = _categories![index];
                            return InkWell(
                              onTap: () async {
                                setState(() {
                                  _isLoadingBerita = true;
                                });

                                _onCategorySelected(
                                    wpPost["id"], wpPost["name"]);
                                await context
                                    .read<HomeProvider>()
                                    .loadBerita(wpPost["id"])
                                    .then((value) => setState(() {
                                          _isLoadingBerita = false;
                                        }));
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  wpPost["name"],
                                  style: GoogleFonts.arimo(
                                    color: (_categoryTitle == wpPost["name"])
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else {
                      logger.log("Data Tidak Ditemukan");
                      return SizedBox.shrink();
                    }
                  },
                ),
              ],
            )
          : Text(
              (_selectedIndex == 1)
                  ? "Fasilitas"
                  : (_selectedIndex == 2)
                      ? "Sosial"
                      : "Video",
              style: GoogleFonts.arimo(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
    );
  }

  Container buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 1,
            offset: const Offset(0, -1),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: 'Video',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff29366A),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CategoryPlaceholder extends StatelessWidget {
  final double width;

  const CategoryPlaceholder({
    Key? key,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: width,
      height: 24,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: Colors.white,
      ),
    );
  }
}
