import 'package:flutter/material.dart';
import 'package:gank/bean/gank_detail.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:zoomable_image/zoomable_image.dart';

class GridPhotoViewer extends StatefulWidget {
  const GridPhotoViewer({ Key key, this.gankDetail }) : super(key: key);

  final GankDetail gankDetail;

  @override
  _GridPhotoViewerState createState() => new _GridPhotoViewerState();
}

class _GridPhotoViewerState extends State<GridPhotoViewer>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.black87,
      appBar: new AppBar(
        title: new Text('妹纸'),
      ),
      body: new SizedBox.expand(
        child: new Hero(
          tag: widget.gankDetail.url,
          child: new ZoomableImage(new CachedNetworkImageProvider(widget.gankDetail.url), scale: 4.0),
        ),
      ),
    );
  }
}