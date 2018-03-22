import 'package:flutter/material.dart';
import 'package:gank/base/constants.dart';
import 'package:gank/bean/tab.dart';
import 'package:gank/home_list_widget.dart';

void main() => runApp(new GankApp());

class GankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Gank客户端',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(title: 'Gank'),
    );
  }
}

const List<TabInfo> tabTitles = const <TabInfo>[
  const TabInfo(
    title: '全部',
    category: Constants.all,
  ),
  const TabInfo(
    title: 'Android',
    category: Constants.android,
  ),
  const TabInfo(
    title: 'iOS',
    category: Constants.ios,
  ),
  const TabInfo(
    title: '前端',
    category: Constants.web,
  ),
  const TabInfo(
    title: '福利',
    category: Constants.welfare,
  ),
  const TabInfo(
    title: '视频',
    category: Constants.video,
  ),
  const TabInfo(
    title: 'App',
    category: Constants.app,
  ),
  const TabInfo(
    title: '其它资源',
    category: Constants.expandResources,
  ),
];

Map<String, String> iconMap;

class HomePage extends StatelessWidget {

  final String title;

  HomePage({this.title});

  @override
  Widget build(BuildContext context) {
    
    if (iconMap == null) {
      iconMap = new Map();
      iconMap['Android'] = 'images/android.png';
      iconMap['iOS'] = 'images/ios.png';
      iconMap['休息视频'] = 'images/video.png';
      iconMap['瞎推荐'] = 'images/recommend.png';
      iconMap['App'] = 'images/app.png';
      iconMap['拓展资源'] = 'images/expand.png';
      iconMap['福利'] = 'images/welfare.png';
      iconMap['前端'] = 'images/javascript.png';
    }

    return new DefaultTabController(
      length: tabTitles.length,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            title,
            style: Theme
                .of(context)
                .textTheme
                .title
                .copyWith(color: Colors.white),
          ),
          bottom: new TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            isScrollable: true,
            tabs: tabTitles.map((tab) {
              return new Tab(
                text: tab.title,
              );
            }).toList(),
          ),
        ),
        body: new TabBarView(
          children: tabTitles.map((tab) {
            return new Container(
              child: new GankListView(
                category: tab.category, iconMap: iconMap,),
              color: new Color(4293651435),
            );
          }).toList(),
        ),
      ),
    );
  }

}
