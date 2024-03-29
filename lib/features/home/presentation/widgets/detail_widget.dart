import 'dart:developer' as logger show log;
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class Detail extends StatefulWidget {
  final String? title;
  final String? content;
  final String? image;
  final String? date;
  final String? category;

  const Detail({
    super.key,
    this.title = "",
    this.content = "",
    this.image = "",
    this.date = "",
    this.category = "",
  });

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final ScrollController _scrollController = ScrollController();
  bool _showTitle = false;
  double opacity = 0.0;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();

    _scrollController.addListener(() {
      if (_scrollController.offset <= 0) {
        setState(() {
          _showTitle = false;
          opacity = 0.0;
        });
      } else {
        setState(() {
          _showTitle = true;
          opacity = 0.6;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const double pointSize = 65;

  final mapController = MapController();

  LatLng? tappedCoords;
  Point<double>? tappedPoint;

  RegExp regex = RegExp(r'src="([^"]+)"');

  @override
  Widget build(BuildContext context) {
    String modifiedHtmlString = widget.content!.replaceAll('data-src', 'src');
    Intl.defaultLocale = 'id';
    var formatter = DateFormat("EEEE, dd MMMM y HH:mm 'WIB'", "id_ID");
    RegExp regex = RegExp(r"!2d(-?\d+\.\d+)!3d(-?\d+\.\d+)");
    RegExpMatch? match = regex.firstMatch(modifiedHtmlString);
    double? latitude;
    double? longitude;
    if (match != null) {
      String? long = match.group(1);
      String? lat = match.group(2);

      latitude = double.parse(lat!);
      longitude = double.parse(long!);

      logger.log("Latitude: $latitude");
      logger.log("Longitude: $longitude");
    } else {
      logger.log("No matching latitude and longitude in iframeCode.");
    }

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: const Color(0xff29366A),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            elevation: 2,
            shadowColor: Colors.grey.shade300,
            leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff29366A).withOpacity(0.8),
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
            title: _showTitle
                ? Text(
                    "Poradi Pekanbaru",
                    style: GoogleFonts.arimo(
                        fontWeight: FontWeight.bold,
                        color:
                            widget.image != "" ? Colors.white : Colors.black),
                  )
                : null,
            floating: false,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                if (widget.image != "")
                  CachedNetworkImage(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.33,
                    imageUrl: widget.image!,
                    fit: BoxFit.cover,
                    placeholder: (context, url) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.33,
                        decoration: BoxDecoration(color: Colors.grey.shade300),
                      );
                    },
                    errorWidget: (context, url, error) {
                      return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.33,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                        ),
                        child: Image.asset(
                          "assets/logodispora.png",
                          color: Colors.white,
                        ),
                      );
                    },
                  ),
                if (widget.image != "")
                  AnimatedContainer(
                    duration: const Duration(seconds: 2),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.33,
                    color: _showTitle
                        ? Colors.black.withOpacity(opacity)
                        : Colors.transparent,
                  ),
              ],
            ),
            expandedHeight:
                widget.image != "" ? MediaQuery.of(context).size.height / 3 : 0,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.category!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          widget.category!,
                          style: GoogleFonts.arimo(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    Text(
                      widget.title!,
                      style: GoogleFonts.arimo(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Divider(),
                    if (widget.date!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          formatter.format(DateTime.parse(widget.date!)),
                          style: GoogleFonts.arimo(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    (modifiedHtmlString.contains("www.google.com/maps"))
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height / 2,
                              width: MediaQuery.of(context).size.width,
                              child: FlutterMap(
                                mapController: mapController,
                                options: MapOptions(
                                  initialCenter: LatLng(latitude ?? -6.8995722,
                                      longitude ?? 107.6097063),
                                  initialZoom: 16,
                                  interactionOptions: const InteractionOptions(
                                    flags: ~InteractiveFlag.doubleTapZoom,
                                  ),
                                  onTap: (_, latLng) {
                                    final point = mapController.camera
                                        .latLngToScreenPoint(
                                            tappedCoords = latLng);
                                    setState(() =>
                                        tappedPoint = Point(point.x, point.y));
                                  },
                                ),
                                children: [
                                  TileLayer(
                                    urlTemplate:
                                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    userAgentPackageName:
                                        'dev.fleaflet.flutter_map.example',
                                  ),
                                  MarkerLayer(
                                    markers: [
                                      Marker(
                                        width: pointSize,
                                        height: pointSize,
                                        point: LatLng(latitude ?? -6.8995722,
                                            longitude ?? 107.6097063),
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Colors.red,
                                          size: 60,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        : HtmlWidget(
                            modifiedHtmlString,
                            textStyle: GoogleFonts.arimo(
                              fontSize: 18,
                              height: 1.5,
                            ),
                          ),
                  ],
                ),
              ),
              childCount: 1,
            ),
          ),
        ],
      ),
    );
  }
}
