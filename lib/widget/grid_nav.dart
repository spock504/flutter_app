import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/model/grid_nav_model.dart';
import 'package:flutter_app/widget/webview.dart';

// 窗格组件
class GridNav extends StatelessWidget {
  // 为什么要用final修饰widget类型：StatelessWidget继承widget，而widget是 immutable不可变的
  final GridNavModel gridNavModel;

  //2. 有自己的构造方法:required 必填, 变量默认值
  GridNav({Key key, @required this.gridNavModel}) : super();

  //3. 重写build方法
  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6), // 设置圆角
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _gridNavItems(context),
      ),
    );
  }

  _gridNavItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) return items;
    if (gridNavModel.hotel != null) {
      items.add(_gridNavItem(context, gridNavModel.hotel, true));
    }
    if (gridNavModel.flight != null) {
      items.add(_gridNavItem(context, gridNavModel.flight, false));
    }
    if (gridNavModel.travel != null) {
      items.add(_gridNavItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  _gridNavItem(BuildContext context, GridNavItem gridNavItem, isFirst) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2, true));
    items
        .add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4, false));

    List<Widget> expandItems = [];
    items.forEach((item) {
      expandItems.add(Expanded(
        child: item,
        flex: 1,
      ));
    });
    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));

    return Container(
      height: 88,
      margin: isFirst ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
          // 线性渐变
          gradient: LinearGradient(
        colors: [startColor, endColor],
      )),
      child: Row(
        children: expandItems,
      ),
    );
  }

  _mainItem(BuildContext context, CommonModel model) {
    return _wrapGesture(
        context,
        Stack(
          alignment:Alignment.topCenter,
          children: <Widget>[
            Image.network(
              model.icon,
              fit: BoxFit.contain,
              width: 121,
              height: 88,
              alignment: AlignmentDirectional.bottomEnd,
            ),
          Container(
            margin: EdgeInsets.only(top: 11),
            child:   Text(model.title,
                style: TextStyle(fontSize: 14, color: Colors.white)),
          )
          ],
        ),
        model);
  }

  _doubleItem(BuildContext context, CommonModel topModel,
      CommonModel bottomModel, bool isCenterItem) {
    return Column(
      children: <Widget>[
        Expanded(child: _item(context, topModel, true, isCenterItem)),
        Expanded(child: _item(context, bottomModel, false, isCenterItem)),
      ],
    );
  }

  _item(BuildContext context, CommonModel model, bool isFirst,
      bool isCenterItem) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
        // 撑满父布局的宽度
        widthFactor: 1,
        child: _wrapGesture(
            context,
            Container(
              decoration: BoxDecoration(
                  border: Border(
                left: borderSide,
                bottom: isFirst ? borderSide : BorderSide.none,
              )), // 左右白色边框
              child: Center(
                child: Text(model.title,
                    style: TextStyle(fontSize: 14, color: Colors.white)),
              ),
            ),
            model));
  }

  _wrapGesture(BuildContext context, Widget widget, CommonModel model) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      title: model.title,
                      url: model.url,
                      statusBarColor: model.statusBarColor,
                      hideAppBar: model.hideAppBar,
                    )));
      },
      child: widget,
    );
  }
}
