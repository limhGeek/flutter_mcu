import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';

class ImagePage extends StatefulWidget {
  final isLocal;
  final List<String> images;

  ImagePage(this.images, {this.isLocal: false});

  @override
  State<StatefulWidget> createState() {
    return _ImagePage();
  }
}

class _ImagePage extends State<ImagePage> {
  var _pageScrollerController = PageController();
  int current = 1;

  @override
  void initState() {
    super.initState();
    widget.images.forEach((img) {
      print('图片路径：${Api.BaseUrl + img}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$current/${widget.images.length}"),
      ),
      body: PageView.builder(
          controller: _pageScrollerController,
          itemCount: widget.images.length,
          scrollDirection: Axis.horizontal,
          onPageChanged: (index) {
            setState(() {
              current = index + 1;
            });
          },
          itemBuilder: (context, index) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.black87,
              child: Center(
                  child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                width: MediaQuery.of(context).size.width,
                errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                imageUrl: Api.BaseUrl + widget.images[index],
                placeholder: CircularProgressIndicator(),
              )),
            );
          }),
    );
  }
}
