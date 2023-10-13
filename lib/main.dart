import 'package:dispora/views/home_page.dart';
import 'package:dispora/views/sosial_page.dart';
import 'package:flutter/material.dart';
import 'package:dispora/views/fasiltas_page.dart';
import 'package:dispora/service/service_api.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:developer' as logger show log;

/// warna
/// 29366A biru
/// F9322E merah
/// F05C39 oren
/// 458E32 hijau

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const FasilitasPage(),
    const SosialPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: buildBottomBar(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      titleSpacing: (_selectedIndex == 0) ? 0 : null,
      toolbarHeight: (_selectedIndex == 0)
          ? 100
          : (_selectedIndex == 1)
              ? null
              : 0,
      backgroundColor:
          (_selectedIndex != 2) ? Colors.white : const Color(0xff29366A),
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
                            image: AssetImage("assets/dispora.png"),
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
                                  right: (index == snapshot.data!.length - 1)
                                      ? 16
                                      : 0,
                                ),
                                child: Text(
                                  wpPost["name"],
                                  style: TextStyle(
                                    color: (index == 0)
                                        ? Colors.black
                                        : Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        logger.log("Data Tidak Dietmukan");
                        return SizedBox.shrink();
                      }
                    }
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
                  },
                ),
              ],
            )
          : (_selectedIndex == 1)
              ? const Text(
                  "Fasilitas",
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff29366A),
                    fontWeight: FontWeight.w600,
                  ),
                )
              : const SizedBox.shrink(),
    );
  }

  Container buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 5,
            offset: const Offset(0, -3),
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
        selectedItemColor: const Color(0xff29366A),
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
