import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight } // 三种类型

class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() rightButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged; // 内容变化的回调

  SearchBar(
      {this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText = '',
      this.leftButtonClick,
      this.rightButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  bool showClear = false; // 是否显示clear按钮
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    if (widget.defaultText != null) {
      setState(() {
        textEditingController.text = widget.defaultText; // 设置默认的文字
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _getNormalSearch()
        : _getHomeSearch();
  }

  _getNormalSearch() {
    return Container(
      //左边返回，右边搜索，中间输入框
      child: Row(
        children: <Widget>[
          // 返回按钮：显示，点击事件
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
                child: widget?.hideLeft ?? false
                    ? null
                    : Icon(
                        Icons.arrow_back_ios,
                        color: Colors.grey,
                        size: 26,
                      ),
              ),
              widget.leftButtonClick),
          // 自适应输入框
          Expanded(flex: 1, child: _inputBox()),
          _wrapTap(
              Container(
                child: Text('搜索',
                    style: TextStyle(fontSize: 17, color: Colors.blue)),
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              ),
              widget.rightButtonClick)
        ],
      ),
    );
  }

  _getHomeSearch() {
    return Container(
      //左边返回，右边搜索，中间输入框
      child: Row(
        children: <Widget>[
          // 返回按钮：显示，点击事件
          _wrapTap(
              Container(
                  padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                  child: Row(
                    children: [
                      Text('上海',
                          style:
                              TextStyle(color: _homeFontColor(), fontSize: 14)),
                      Icon(Icons.expand_more,
                          color: _homeFontColor(), size: 22),
                    ],
                  )),
              widget.leftButtonClick),
          // 自适应输入框
          Expanded(flex: 1, child: _inputBox()),
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Icon(
                  Icons.comment,
                  color: _homeFontColor(),
                  size: 26,
                ),
              ),
              widget.rightButtonClick)
        ],
      ),
    );
  }

  _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffEDEDED'));
    }
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(
              widget.searchBarType == SearchBarType.normal ? 5 : 15)),
      child: Row(
        children: [
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal
                ? Color(0xffA9A9A9)
                : Colors.blue,
          ),
          Expanded(
              flex: 1,
              child: widget.searchBarType == SearchBarType.normal
                  ? TextField(
                      controller: textEditingController,
                      onChanged: _onChanged,
                      autofocus: true,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w300),
                      //输入框样式
                      decoration: InputDecoration(
                          isDense: true, // 是否使用更小的高度，默认为false
                          contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                          border: InputBorder.none,
                          hintText: widget.hint ?? '',
                          hintStyle: TextStyle(fontSize: 15)),
                    )
                  : _wrapTap(
                      Container(
                        child: Text(
                          widget.defaultText,
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ),
                      widget.inputBoxClick)),
          !showClear
              ? _wrapTap(
                  Icon(
                    Icons.mic,
                    size: 20,
                    color: widget.searchBarType == SearchBarType.normal
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  widget.speakClick)
              : _wrapTap(Icon(Icons.clear, size: 20, color: Colors.grey), () {
                  setState(() {
                    textEditingController.clear();
                  });
                  _onChanged('');
                })
        ],
      ),
    );
  }

  // 点击事件函数
  _wrapTap(Widget child, void Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) return callback();
      },
      child: child,
    );
  }

  // 输入框内容的变化
  _onChanged(String text) {
    //显示右边的清除按钮
    if (text.length > 0) {
      setState(() {
        showClear = true;
      });
    } else {
      setState(() {
        showClear = false;
      });
    }
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _homeFontColor() {
    // 高亮情况下黑色
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }
}
