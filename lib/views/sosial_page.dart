import 'package:dispora/views/sarpras_widget.dart';
import 'package:flutter/material.dart';

class SosialPage extends StatelessWidget {
  const SosialPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          backgroundColor: Colors.white,
          bottom: const TabBar(
            labelColor: Colors.black,
            physics: NeverScrollableScrollPhysics(),
            tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Center(child: Text('Tab 1 Content')),
            // Center(child: Text('Tab 1 Content')),
            SarprasWidget(),
          ],
        ),
      ),
    );
  }
}
