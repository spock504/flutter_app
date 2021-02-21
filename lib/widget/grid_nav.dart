
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/model/grid_nav_model.dart';

//StatelessElement : 纯展示，无交互逻辑
//实现一个组件

// 1.继承widget
class GridNav extends StatelessWidget {
 // 为什么要用final修饰widget类型：StatelessWidget继承widget，而widget是 immutable不可变的
 final GridNavModel gridNavModel;
 final String name;

  //2. 有自己的构造方法:required 必填, 变量默认值
  GridNav({Key key,@required this.gridNavModel,this.name= 'jason'}) : super();

  //3. 重写build方法
  @override
  Widget build(BuildContext context) {
    return Text(name);
  }
}