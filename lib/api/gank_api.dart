import 'dart:async';
import 'dart:convert';
import 'package:gank/base/constants.dart';
import 'package:gank/bean/gank_detail.dart';
import 'package:http/http.dart' as http;

class GankApi{
  static Future<List<GankDetail>> fetchGankDetail(String category, int count,
      int page) async {
    final response = await http.get('${Constants.host}/$category/$count/$page');
    if (response.statusCode == Constants.requestSuccessCode) {
      final json = JSON.decode(response.body);
      if (json != null && json['error'] == false) {
        List<GankDetail> list = json['results'].map((obj) =>
            GankDetail.fromJson(obj)).toList();
        return list;
      }
    }
    return null;
  }
}

