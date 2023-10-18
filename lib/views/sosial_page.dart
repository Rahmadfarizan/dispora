import 'package:dispora/views/sarpras_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SosialPage extends StatelessWidget {
  const SosialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
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
            tabs: const [
              Tab(
                text: 'E-Sarpras Bertuah',
              ),
              Tab(text: 'E-Booking'),
              Tab(text: 'Virtual Tour Fasilitas Olahraga'),
              Tab(text: 'E-Data'),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const SarprasWidget(),
            _buildWidgetComingSoon(
                "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/08/stadium-150x150.png",
                'E-Booking',
                'Booking berbagai venue olahraga maupun non-olahraga di Kota Pekanbaru'),
            _buildWidgetComingSoon(
                "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/08/virtual-tour-150x150.png",
                'Virtual Tour Fasilitas Olahraga',
                'Jelajahi Fasilitas Olahraga di Kota Pekanbaru'),
            _buildWidgetComingSoon(
                "https://dispora.pekanbaru.go.id/wp-content/uploads/2023/08/file-150x150.png",
                'E-Data',
                'Informasi publik seputar Database olahraga dan kepemudaan Provinsi Kota Pekanbaru'),
          ],
        ),
      ),
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
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          description,
          style: GoogleFonts.arimo(
              color: Colors.grey, fontSize: 16, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xffF05C39)),
          child: Text(
            "Coming Soon",
            style: GoogleFonts.arimo(
                color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        )
      ],
    ));
  }
}
