import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/my_page.dart';
import 'package:flutter_app/pages/search_page.dart';
import 'package:flutter_app/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigator createState() => _TabNavigator();
}

//定义内部类，类名字前添加下划线 _
class _TabNavigator extends State<TabNavigator> {
  final PageController _controller = PageController(
    initialPage: 0,
  );
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          HomePage(),
          SearchPage(hideLeft: true),
          TravelPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type:
            BottomNavigationBarType.fixed, // 修复bottomNavigationBar 超过三个显示为白色的问题
        currentIndex: _currentIndex,
        onTap: (index) {
          _controller.jumpToPage(index); // 跳转指定页面
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          _item(Icons.home, '首页'),
          _item(Icons.search, '搜索'),
          _item(Icons.camera_alt, '旅拍'),
          _item(Icons.account_circle, '我的')
        ],
      ),
    );
  }

  _item(IconData icon, String label) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _defaultColor,
      ),
      activeIcon: Icon(
        icon,
        color: _activeColor,
      ),
      label: label,
    );
  }
}
