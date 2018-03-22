import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:gank/api/gank_api.dart';
import 'package:gank/bean/gank_detail.dart';
import 'package:gank/cache/gank_cache.dart';

class GankRepository {

  static void getList(String category, int count,
      int page, ValueChanged<List<GankDetail>> onDataChanged,
      ValueChanged<int> onIndexChanged,
      Completer completer) async {
    if (completer != null) {
      GankCache.singleton.clear(category);
    }
    var list = GankCache.singleton.get(category);
    if (list != null && onIndexChanged == null) {
      onDataChanged(list);
    } else {
      GankApi.fetchGankDetail(category, count, page).then((data) {
        GankCache.singleton.put(category, data);
        // print('网络请求后取缓存 ${GankCache.singleton.get(category).length}');
        onDataChanged(GankCache.singleton.get(category));
        if (onIndexChanged != null) {
          onIndexChanged(page + 1);
        }
      }, onError: () {
        print('请求出问题了！');
      }).whenComplete(() {
        if (completer != null) {
          completer.complete();
          if (onIndexChanged != null) {
            onIndexChanged(1);
          }
        }
      });
    }
  }

}

