import '../widgets/detail_fasilitas_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../model/fasilitas_model.dart';
import 'dart:developer' as logger show log;

class FasilitasPage extends StatefulWidget {
  const FasilitasPage({super.key});

  @override
  State<FasilitasPage> createState() => _FasilitasPageState();
}

class _FasilitasPageState extends State<FasilitasPage> {
  List<String> listKecamatan = [
    "Bina widya",
    "Sail",
    "Bukit Raya",
    "Marpoyan Damai",
    "Kulim",
    "Pekanbaru Kota",
    "Rumbai",
    "Payung Sekaki",
    "Rumbai Barat",
    "Tenayan Raya",
    "Tuah Madani",
    "Sukajadi",
    "Senapelan",
    "Lima Puluh"
  ];

  @override
  void initState() {
    super.initState();
  }

  String modifyDateTime(String originalDateTime) {
    DateTime parsedDateTime = DateTime.parse(originalDateTime);

    Duration difference = DateTime.now().difference(parsedDateTime);

    if (difference.inDays >= 7) {
      int weeks = (difference.inDays / 7).floor();
      return "$weeks minggu yang lalu";
    } else if (difference.inDays >= 1) {
      return "${difference.inDays} hari yang lalu";
    } else if (difference.inHours >= 1) {
      return "${difference.inHours} jam yang lalu";
    } else if (difference.inMinutes >= 1) {
      return "${difference.inMinutes} menit yang lalu";
    } else {
      return "A few seconds ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listKecamatan.length,
      itemBuilder: (context, index) {
        // Use a Column to add a Divider below each item except the last one.
        return Column(
          children: <Widget>[
            if (index == 0)
              const SizedBox(
                height: 10,
              ), // A
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailFasilitasWidget(
                      kecamatan: listKecamatan[index],
                    ),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.only(
                    left: 16, right: 16, top: 8, bottom: 8),
                child: Text(
                  "Kecamatan ${listKecamatan[index]}",
                  style: GoogleFonts.arimo(
                      fontSize: 16, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            if (index < listKecamatan.length - 1)
              const Divider(), // Add a Divider unless it's the last item
          ],
        );
      },
    );
  }
}
