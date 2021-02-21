// {
// "config": {},
// "bannerList": [],
// "localNavList": [],
// "gridNav": {},
// "subNavList": [],
// "salesBox": {}
// }

import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/model/config_model.dart';
import 'package:flutter_app/model/grid_nav_model.dart';
import 'package:flutter_app/model/sales_box_model.dart';

class HomeModel {
  final ConfigModel config;
  final List<CommonModel> localNavList;
  final List<CommonModel> bannerList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;

  HomeModel({
    this.config,
    this.localNavList,
    this.bannerList,
    this.gridNav,
    this.subNavList,
    this.salesBox,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var localNavListJson = json['localNavList'] as List;
    List<CommonModel> localNavList =
        localNavListJson.map((e) => CommonModel.fromJson(e)).toList();

    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList =
        bannerListJson.map((e) => CommonModel.fromJson(e)).toList();

    var subNavListJson = json['subNavList'] as List;
    List<CommonModel> subNavList =
        subNavListJson.map((e) => CommonModel.fromJson(e)).toList();

    return json != null
        ? HomeModel(
            localNavList: localNavList,
            bannerList: bannerList,
            subNavList: subNavList,
            config: ConfigModel.fromJson(json['config']),
            gridNav: GridNavModel.fromJson(json['gridNav']),
            salesBox: SalesBoxModel.fromJson(json['salesBox']),
          )
        : null;
  }

  //  obj转string, 需要一个toJson
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['config'] = this.config;
    data['localNavList'] = this.localNavList;
    data['bannerList'] = this.bannerList;
    data['gridNav'] = this.gridNav;
    data['subNavList'] = this.subNavList;
    data['salesBox'] = this.salesBox;
    return data;
  }
}
