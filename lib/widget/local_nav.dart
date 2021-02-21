import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/model/grid_nav_model.dart';

//StatelessElement : 纯展示，无交互逻辑
//实现一个组件

// 1.继承widget
class LocalNav extends StatelessWidget {
  // 为什么要用final修饰widget类型：StatelessWidget继承widget，而widget是 immutable不可变的
  final List<CommonModel> localNavList;

  //2. 有自己的构造方法:required 必填, 变量默认值
  LocalNav({Key key, @required this.localNavList}) : super(key: key);

  //3. 重写build方法
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: _items(context),
    );
  }

  _items(BuildContext content) {
    if (localNavList == null) return null;
    List<Widget> items = [];
    localNavList.forEach((element) {
      items.add(_item(content, element));
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: items,
    );
  }

  Widget _item(BuildContext content, CommonModel model) {
    return GestureDetector(
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.network(
            model.icon,
            width: 32,
            height: 32,
          ),
          Text(
            model.title,
            style: TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
