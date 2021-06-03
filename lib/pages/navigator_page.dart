import 'package:flutter/material.dart';
import 'package:speed_share/themes/default_theme_data.dart';

import 'dialog/select_chat_server.dart';
import 'home_page.dart';
import 'share_chat.dart';

class NavigatorPage extends StatefulWidget {
  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xffede8f8),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: fontColor,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: fontColor,
          fontSize: 12,
        ),
        unselectedIconTheme: IconThemeData(
          color: fontColor,
        ),
        enableFeedback: false,
        unselectedItemColor: fontColor,
        selectedItemColor: fontColor,
        elevation: 0.0,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Container(
              width: 64,
              height: 32,
              child: Icon(
                Icons.open_in_browser,
              ),
            ),
            activeIcon: Container(
              width: 64,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0xffcfbff7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.open_in_browser,
              ),
            ),
            label: '文件部署',
          ),
          BottomNavigationBarItem(
            activeIcon: Container(
              width: 64,
              height: 32,
              decoration: BoxDecoration(
                color: Color(0xffcfbff7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.share),
            ),
            icon: Container(
              width: 64,
              height: 32,
              child: Icon(Icons.share),
            ),
            label: '共享窗',
          ),
        ],
        currentIndex: pageIndex,
        onTap: (int index) {
          if (index == 1) {
            showDialog(
              context: context,
              builder: (_) {
                return SelectChatServer();
              },
            );

            return;
          }
          pageIndex = index;
          setState(() {});
        },
      ),
      body: [
        HomePage(),
        ShareChat(),
      ][pageIndex],
    );
  }
}
