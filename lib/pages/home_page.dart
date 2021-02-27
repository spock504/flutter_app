import 'package:flutter/material.dart';
import 'package:flutter_app/dao/home_dao.dart';
import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/model/grid_nav_model.dart';
import 'package:flutter_app/model/home_model.dart';
import 'package:flutter_app/widget/grid_nav.dart';
import 'package:flutter_app/widget/local_nav.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  List _imageUrls = [
    'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=3118158831,1502048080&fm=26&gp=0.jpg',
    'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=391552132,10057802&fm=26&gp=0.jpg',
    'https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=3551370719,1936559374&fm=26&gp=0.jpg'
  ];
  double appBarAlpha = 0;
  String resultString = '';
  List<CommonModel> localNavList = [];
  GridNavModel gridNavModel;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      appBarAlpha = alpha;
    });
    print(offset);
  }

  loadData() async {
    // 方法一
    // HomeDao.fetch().then((value) => {
    //   setState((){
    //     resultString = json.encode(value);
    //   })
    // }).catchError((e){
    //   setState((){
    //     resultString = e.toString();
    //   }) ;
    // });

    // 方法二
    try {
      HomeModel model = await HomeDao.fetch();
      print(model.gridNav);
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
      });
    } catch (e) {
      print('报错$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff2f2f2),
        body: Stack(
          children: [
            MediaQuery.removePadding(
                removeTop: true, // 移除Listview下，自带的顶部间距
                context: context,
                child: NotificationListener(
                  // 监听列表滚动
                  onNotification: (notification) {
                    if (notification is ScrollUpdateNotification &&
                        notification.depth == 0) {
                      // depth == 0，只监听ListView的滚动
                      //  滚动中 且是列表滚动时
                      _onScroll(notification.metrics.pixels);
                    }
                    return true; // 滚动不再往父元素传递
                  },
                  child: ListView(
                    // ListView作为根元素，会有顶部的padding
                    children: <Widget>[
                      Container(
                        height: 180,
                        child: Swiper(
                          itemCount: _imageUrls.length,
                          autoplay: true,
                          itemBuilder: (BuildContext content, int index) {
                            return (Image.network(
                              _imageUrls[index],
                              fit: BoxFit.fill,
                            ));
                          },
                          pagination: SwiperPagination(),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                        child: LocalNav(localNavList: localNavList),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
                        child: GridNav(gridNavModel: gridNavModel),
                      ),
                      Container(
                          height: 800,
                          child: ListTile(
                            title: Text(resultString),
                          )),
                    ],
                  ),
                )),
            Opacity(
              opacity: appBarAlpha,
              child: Container(
                height: 80,
                decoration: BoxDecoration(color: Colors.white),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text('首页'),
                  ),
                ),
              ),
            )
          ],
        ));
  }
}
