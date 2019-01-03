import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Token.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/widget/iconfont.dart';
import 'package:flutter_mcu/widget/view_loading.dart';
import 'package:image_jpeg/image_jpeg.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';

class AddTpPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddTpPage();
  }
}

class _AddTpPage extends State<AddTpPage> {
  bool hideTitle = true;
  int picCount = 0;
  bool isSend = false;
  String _msg = "";
  var pics = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  Token token = Token.empty();

  @override
  void initState() {
    super.initState();
    _initParams();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('发表话题'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _sendTopic();
              })
        ],
      ),
      body: ProgressDialog(
          loading: isSend,
          msg: _msg,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Offstage(
                    offstage: hideTitle,
                    child: TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '加个标题呦~',
                        hintStyle: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.normal),
                      ),
                      style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: '尽情发挥吧~',
                      hintStyle: TextStyle(
                          color: Theme.of(context).disabledColor,
                          letterSpacing: 2.0,
                          wordSpacing: 10.0),
                    ),
                    maxLines: 5,
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                  Container(
                      height: 100.0,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Offstage(
                            offstage: pics.isEmpty,
                            child: _imgItemView(),
                          ),
                          IconButton(
                              icon: Icon(
                                FontIcon.add,
                                size: 60.0,
                                color: Theme.of(context).highlightColor,
                              ),
                              onPressed: () {
                                _pickImage();
                              })
                        ],
                      )),
                  GestureDetector(
                    child: Container(
                      width: 80,
                      height: 24,
                      margin: EdgeInsets.only(top: 10.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).highlightColor,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Center(
                        child: Text(
                          hideTitle ? '添加标题' : "隐藏标题",
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        hideTitle = !hideTitle;
                      });
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future _initParams() async {
    token = await SpUtils.getToken();
  }

  Widget _imgItemView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: AlwaysScrollableScrollPhysics(),
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int position) {
        return Container(
          width: MediaQuery.of(context).size.width / 3,
          margin: EdgeInsets.only(right: 6.0),
          child: CachedNetworkImage(
            imageUrl: Api.BaseUrl + pics[position],
            errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
            fit: BoxFit.cover,
          ),
        );
      },
      itemCount: pics.length,
    );
  }

  Future _sendTopic() async {
    if (_contentController.text.isEmpty) {
      Toast.show(context, '话题内容不能为空');
    } else {
      setState(() {
        isSend = true;
        _msg = "发布中...";
      });
      String title = _titleController.text;
      String content = _contentController.text;
      String images = "";
      pics.forEach((pic) {
        images += "$pic,";
      });
      Map<String, String> params = Map();
      params['content'] = content;
      if (title.length != 0) {
        params["title"] = title;
      }
      if (images.length != 0) {
        params["imgsUrl"] = images.substring(0, images.length - 1);
      }
      Http.post(Api.URL_ADDTOPICS,
          header: {"Token": token.token},
          params: params, successCallBack: (data) {
        Toast.show(context, '发布成功');
        setState(() {
          isSend = false;
          Navigator.pop(context);
        });
      }, errorCallBack: (errorMsg) {
        Toast.show(context, errorMsg);
        setState(() {
          isSend = false;
        });
      });
    }
  }

  Future _pickImage() async {
    print('选择照片');
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      context: context,
      themeColor: Theme.of(context).primaryColor,
      padding: 1.0,
      dividerColor: Colors.grey,
      disableColor: Colors.grey.shade300,
      itemRadio: 0.88,
      maxSelected: 3,
      provider: I18nProvider.chinese,
      rowCount: 3,
      textColor: Colors.white,
      thumbSize: 150,
      sortDelegate: SortDelegate.common,
      checkBoxBuilderDelegate: DefaultCheckBoxBuilderDelegate(
        activeColor: Colors.white,
        unselectedColor: Colors.white,
      ),
    );
    setState(() {
      isSend = true;
      _msg = "正在上传...";
    });
    imgList.forEach((asset) async {
      File imgFile = await asset.file;
      String newfile =
          await ImageJpeg.encodeJpeg(imgFile.path, null, 70, 1360, 1360);
      if (newfile == null || newfile.isEmpty) {
        Toast.show(context, '无效文件');
      } else {
        print('文件路径:$newfile');
        print('${newfile.substring(newfile.lastIndexOf("/"))}');
        FormData f = FormData.from({
          "file": UploadFileInfo(
              new File(newfile), newfile.substring(newfile.lastIndexOf("/"))),
        });
        Http.upload(Api.URL_UPLOAD, params: f, successCallBack: (data) {
          print('上传结果：$data');
          setState(() {
            pics.add('$data');
            if (imgList.last == asset) {
              isSend = false;
            }
          });
        });
      }
    });
  }
}
