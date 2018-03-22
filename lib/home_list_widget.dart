import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gank/bean/gank_detail.dart';
import 'package:gank/gank_detail_page.dart';
import 'package:gank/photo_widget.dart';
import 'package:gank/repository/gank_repository.dart';
import 'package:cached_network_image/cached_network_image.dart';

Map<String, bool> stateMap = new Map();

class GankListView extends StatefulWidget {

  final String category;

  final Map iconMap;

  GankListView({this.category, this.iconMap});

  @override
  State<StatefulWidget> createState() {
    return new _GankListViewState();
  }

}

class _GankListViewState extends State<GankListView> {

  List<GankDetail> list = [];

  int page = 1;

  int size = 8;

  _GankListViewState();

  @override
  void initState() {
    super.initState();

    print('${widget.category}初始化');

    loadData();
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      new RefreshIndicator(child: getBody(), onRefresh: _handleRefresh);


  void _handleData(List newValue) {
    if (mounted) {
      setState(() {
        print('加载数据 ${newValue.length}');
        list = newValue;
      });
    }
  }

  void _handlePage(int newPage) {
    print('页数加一 $newPage');
    page = newPage;
    stateMap[widget.category] = false;
  }

  void loadData() async {
    GankRepository.getList(
        widget.category, size, 1, _handleData, null, null);
  }

  void loadMoreData(bool v) async {
    stateMap[widget.category] = true;
    print('加载更多数据');
    GankRepository.getList(
        widget.category, size, page + 1, _handleData, _handlePage, null);
  }

  Widget getBody() => shouldShowLoading() ? getProgressDialog() : getListView();

  Widget getProgressDialog() =>
      new Center(
        child: new CircularProgressIndicator(),
      );

  Widget getListView() =>
      new ListView.builder(
        padding: new EdgeInsets.all(8.0),
        itemCount: list.length + 1,
        itemBuilder: (context, position) {
          return getRow(position);
        },
      );


  void _handleTap(GankDetail detail) {
    print('点击了 $detail');

    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {
        if (detail.type == '福利') {
          return new GridPhotoViewer(gankDetail: detail);
        } else {
          return new GankDetailPage(gankDetail: detail,);
        }
      }, settings: new RouteSettings(
        name: detail.type == '福利' ? '/photo' : '/web',
        isInitialRoute: false,
      )),
    );
  }

  Widget getRow(int position) {
    print('当前位置：$position ${list.length}');
    if (position == list.length) {
      return new Center(
          child: new Padding(
            padding: new EdgeInsets.all(4.0),
            child: new LoadMoreIndicator(
              category: widget.category,
              onPressed: loadMoreData,
            ),
          )
      );
    } else {
      var detail = list[position];
      return new GestureDetector(
        onTap: () {
          _handleTap(detail);
        },
        child:
        new Padding(
          padding: new EdgeInsets.only(bottom: 8.0),
          child: new Card(
            child:
            new Padding(
              padding: new EdgeInsets.all(8.0),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  detail.type == '福利'
                      ? // new Image.network(detail.url)
                  new CachedNetworkImage(
                    imageUrl: detail.url,
                    placeholder: new Center(
                        child: new CircularProgressIndicator()),
                    errorWidget: new Center(
                      child: new Image.asset(
                        'images/load_failed.png',
                        width: 48.0,
                        height: 48.0,),
                    ),
                  )
                      : new Text(
                    '${detail.desc}', style: Theme
                      .of(context)
                      .textTheme
                      .body2
                      .copyWith(fontSize: 16.0),),
                  new Padding(
                    padding: new EdgeInsets.only(top: 8.0),
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        new Padding(
                          padding: new EdgeInsets.only(right: 4.0),
                          child: new Image.asset(
                            widget.iconMap[detail.type], width: 16.0,
                            height: 16.0,),
                        ),
                        new Expanded(child: new Text(detail.type)),
                        new Text('via: ${detail.who == null
                            ? "佚名"
                            : detail.who}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            color: Colors.white,
            elevation: 2.0,
          ),
        ),
      );
    }
  }

  bool shouldShowLoading() => list.length == 0;

  Future<Null> _handleRefresh() {
    Completer<Null> completer = new Completer();
    GankRepository.getList(
        widget.category, size, 1, _handleData, null, completer);
    return completer.future;
  }

}

class LoadMoreIndicator extends StatefulWidget {

  final ValueChanged<bool> onPressed;

  final String category;

  LoadMoreIndicator(
      {Key key, @required this.category, @required this.onPressed})
      :super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _LoadMoreIndicatorState();
  }

}

class _LoadMoreIndicatorState extends State<LoadMoreIndicator> {

  _LoadMoreIndicatorState();

  void _handleTap() {
    if (mounted) {
      setState(() {
        stateMap[widget.category] = true;
      });
      widget.onPressed(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isCurrentLoading = stateMap[widget.category];
    print('_LoadMoreIndicatorState $isCurrentLoading');
    if (isCurrentLoading != null && isCurrentLoading) {
      return new SizedBox(
        child: new CircularProgressIndicator(strokeWidth: 2.0,),
        width: 24.0,
        height: 24.0,
      );
    } else {
      return new GestureDetector(
        onTap: _handleTap,
        child: new Text('点击加载更多'),
      );
    }
  }

}