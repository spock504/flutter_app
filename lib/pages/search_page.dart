import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/dao/search_dao.dart';
import 'package:flutter_app/model/search_model.dart';
import 'package:flutter_app/widget/search_bar.dart';
import 'package:flutter_app/widget/webview.dart';

const TYPES = [
  "channelgroup",
  "channelgs",
  "channelplane",
  "channeltrain",
  "cruise",
  "district",
  "food",
  "hotel",
  "huodong",
  "shop",
  "sight",
  "ticket",
  "travelgroup",
];
const URL =
    'http://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  SearchPage({this.hideLeft, this.searchUrl = URL, this.keyword, this.hint});

  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Column(
        children: [
          _appBar(),
          // 移除自带widget的间距
          MediaQuery.removePadding(
              removeTop: true,
              context: context,
              // ListView 需要指定高度，利用expanded 占据剩余空间
              child: Expanded(
                  flex: 1,
                  // 直接创建效率更高
                  child: ListView.builder(
                      itemCount: searchModel?.data?.length ?? 0,
                      itemBuilder: (BuildContext context, int position) {
                        return _item(position);
                      })))
        ],
      ),
    );
  }

  _appBar() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            // appbar 渐变背景色
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  _onTextChange(String text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl + text;
    SearchDao.fetch(url, text).then((SearchModel model) {
      if (model.keyword == text) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  _item(int position) {
    if (searchModel == null || searchModel.data == null) return null;
    SearchItem item = searchModel.data[position];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: item.url,
                      title: '详情',
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
        child: Row(
          children: [
            Container(
              margin: EdgeInsets.all(2),
              child: Image(
                width: 26,
                height: 26,
                image: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: [
                Container(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                  width: 300,
                  child: _subTitle(item),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _typeImage(String type) {
    if (type == null) return 'images/type_travelgroup';
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'images/type_$path.png';
  }

  _title(SearchItem item) {
    if (item == null) return null;
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpan(item.word, searchModel.keyword));
    spans.add(TextSpan(
        text: ' ' + (item.districtname ?? '') + ' ' + (item.zonename ?? ''),
        style: TextStyle(color: Colors.grey, fontSize: 16)));
    return RichText(text: TextSpan(children: spans)); // 展示富文本
  }

  _subTitle(SearchItem item) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: item.price ?? '',
          style: TextStyle(fontSize: 16, color: Colors.orange)),
      TextSpan(
          text: ' ' + (item.star ?? ''),
          style: TextStyle(fontSize: 12, color: Colors.grey)),
    ]));
  }

  // 关键字高亮显示
  _keywordTextSpan(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) return null;
    List<String> arr = word.split(keyword);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    for (int i = 0; i < arr.length; i++) {
      if ((i + 1) % 2 == 0) {
        //  根据关键字分割后，偶数项前补齐高亮关键字
        spans.add(TextSpan(text: keyword, style: keywordStyle));
      }

      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }
}
