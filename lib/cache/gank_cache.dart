import 'package:gank/bean/gank_detail.dart';


class GankCache {

  static final GankCache singleton = new GankCache.internal();

  Map<String, List<GankDetail>> cache = new Map();

  GankCache.internal();

  factory GankCache()=> singleton;

  List<GankDetail> get(String key) => cache[key];

  put(String key, List<GankDetail> value) =>
      cache[key] == null ? cache[key] = value : cache[key].addAll(value);

  clear(String key) => cache[key] = null;

}