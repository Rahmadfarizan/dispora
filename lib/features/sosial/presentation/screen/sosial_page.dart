import 'package:dispora/features/sosial/presentation/provider/sosial_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as logger show log;

import '../../model/sosial_model.dart';
import '../../model/sosial_model.dart';
import '../widgets/sarpras_widget.dart';

class SosialPage extends StatefulWidget {
  const SosialPage({Key? key}) : super(key: key);

  @override
  State<SosialPage> createState() => _SosialPageState();
}

class _SosialPageState extends State<SosialPage> {
  Future<List<Sosial>>? futureLoadKomunitas;
  Future<List<SosialDetail>>? futureLoadKomunitasDetail;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    setState(() {
      _isLoading = true;
    });

    context.read<SosialProvider>().loadKomunitas().then((result) {
      setState(() {
        futureLoadKomunitas = result as Future<List<Sosial>>?;
        _isLoading = false;
      });
    }).catchError((error) {
      // Handle errors if loading komunitas fails
      logger.log(error.toString());
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_isLoading)
        ? CircularProgressIndicator()
        : Consumer<SosialProvider>(
            builder: (context, sosial, child) {
              return DefaultTabController(
                length: 1 + sosial.komunitas.length, // Number of tabs
                child: Scaffold(
                  appBar: AppBar(
                    toolbarHeight: 0,
                    backgroundColor: Colors.white,
                    shadowColor: Colors.grey.shade100,
                    elevation: 1,
                    bottom: TabBar(
                      labelColor: Colors.black,
                      indicatorColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      labelStyle: GoogleFonts.arimo(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: [
                        Tab(
                          text: 'E-Sarpras Bertuah',
                        ),
                        for (int i = 0; i < sosial.komunitas.length; i++)
                          Tab(
                            text: sosial.komunitas[i].title,
                          )
                      ],
                    ),
                  ),
                  body: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SarprasWidget(),
                      for (int i = 0; i < sosial.komunitas.length; i++)
                        TabContent(
                          link: sosial.komunitas[i].image,
                          content: sosial.komunitas[i].content,
                        )
                      // Consumer<SosialProvider>(
                      //   builder: (context, value, child) =>
                      //       _buildWidgetComingSoon(
                      //     value.komunitasDetail[i].image ??
                      //         "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/08/stadium-150x150.png",
                      //     value.komunitasDetail[i].image,
                      //     'Booking berbagai venue olahraga maupun non-olahraga di Kota Pekanbaru',
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  Center _buildWidgetComingSoon(image, title, description) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(image),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.arimo(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: GoogleFonts.arimo(
              color: Colors.grey,
              fontSize: 16,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xffF05C39),
            ),
            child: Text(
              "Coming Soon",
              style: GoogleFonts.arimo(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}

class TabContent extends StatefulWidget {
  final String link;
  final String content;
  const TabContent({super.key, required this.link, required this.content});

  @override
  State<TabContent> createState() => _TabContentState();
}

class _TabContentState extends State<TabContent> {
  Future<List<SosialDetail>>? futureLoadKomunitasDetail;
  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    setState(() {
      _isLoading = true;
    });

    context
        .read<SosialProvider>()
        .loadKomunitasImage(widget.link)
        .then((result) {
      setState(() {
        futureLoadKomunitasDetail = result as Future<List<SosialDetail>>?;
        _isLoading = false;
      });
    }).catchError((error) {
      // Handle errors if loading komunitas fails
      logger.log(error.toString());
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String modifiedHtmlString =
        widget.content!.replaceAllMapped(RegExp(r'width=\"(\d+)\"'), (match) {
      double newWidth = MediaQuery.of(context).size.width; // Halve the width
      return 'width="$newWidth" style="border-radius: 20px;';
    });
    return (_isLoading)
        ? CircularProgressIndicator()
        : Consumer<SosialProvider>(
            builder: (context, value, child) => ListView(
                  children: [
                    // for (int i = 0; i < value.komunitasDetail.length; i++)
                    //   Image.network(value.komunitasDetail[i].image),
                    HtmlWidget(
                      modifiedHtmlString,
                      textStyle: GoogleFonts.arimo(
                        fontSize: 16,
                      ),
                    )
                  ],
                ));
  }
}
