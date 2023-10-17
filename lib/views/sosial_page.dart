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
          bottom: TabBar(
            tabs: [
              Tab(text: 'Tab 1'),
              Tab(text: 'Tab 2'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text('Tab 1 Content')),
            Center(child: Text('Tab 2 Content')),
          ],
        ),
      ),
    );
  }
}
