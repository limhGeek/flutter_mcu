import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mcu/bean/Token.dart';
import 'package:flutter_mcu/bean/User.dart';
import 'package:flutter_mcu/comm/config/Config.dart';
import 'package:flutter_mcu/comm/net/Api.dart';
import 'package:flutter_mcu/comm/net/Http.dart';
import 'package:flutter_mcu/comm/redux/AppState.dart';
import 'package:flutter_mcu/comm/redux/UserRedux.dart';
import 'package:flutter_mcu/utils/sp_utils.dart';
import 'package:flutter_mcu/utils/toast_utils.dart';
import 'package:flutter_mcu/widget/view_loading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_jpeg/image_jpeg.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:redux/redux.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _userImg;
  String _coverImg;
  var _userController = TextEditingController();
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _profileController = TextEditingController();
  Token token;
  User user;
  bool _loading = false;
  String _loadMsg = "";

  @override
  void initState() {
    super.initState();
    _initParams();
  }

  Future _initParams() async {
    token = await SpUtils.getToken();
    user = await SpUtils.getUser();
    if (null != user) {
      setState(() {
        _userImg = user.imgUrl;
        _coverImg = user.coverImg;
        _userController.value =
            TextEditingValue(text: null == user.userName ? "" : user.userName);
        _phoneController.value =
            TextEditingValue(text: null == user.phone ? "" : user.phone);
        _emailController.value =
            TextEditingValue(text: null == user.email ? "" : user.email);
        _profileController.value =
            TextEditingValue(text: null == user.profile ? "" : user.profile);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (context, store) {
      return Scaffold(
        body: ProgressDialog(
          loading: _loading,
          msg: _loadMsg,
          textColor: Theme.of(context).canvasColor,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Colors.transparent,
                flexibleSpace: _sliverHeader(),
                expandedHeight: 200.0,
                actions: <Widget>[
                  FlatButton(
                      child: Text(
                        '保存',
                        style: TextStyle(color: Theme.of(context).canvasColor),
                      ),
                      onPressed: () {
                        _saveSetting(store);
                      })
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: TextField(
                    controller: _userController,
                    maxLength: 12,
                    maxLines: 1,
                    decoration: InputDecoration(labelText: "用户名"),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: TextField(
                    controller: _phoneController,
                    maxLength: 11,
                    maxLines: 1,
                    decoration: InputDecoration(labelText: "手机号"),
                    keyboardType: TextInputType.phone,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: TextField(
                    controller: _emailController,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: '请输入邮箱',
                      labelText: "邮箱",
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  child: TextField(
                    controller: _profileController,
                    maxLines: 1,
                    maxLength: 60,
                    decoration: InputDecoration(
                      hintText: '请输入个人简历',
                      labelText: "个人简历",
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _sliverHeader() {
    return Stack(
      children: <Widget>[
        CachedNetworkImage(
          width: MediaQuery.of(context).size.width,
          height: 200.0,
          fit: BoxFit.cover,
          placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
          imageUrl: null == _coverImg
              ? (_userImg == null
                  ? (Api.BaseUrl + "default_head.jpg")
                  : (Api.BaseUrl + _userImg))
              : (Api.BaseUrl + _coverImg),
          errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
        ),
        Offstage(
          offstage: null != _coverImg,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
              color: Colors.white.withOpacity(0.3),
              width: MediaQuery.of(context).size.width,
              height: 200.0,
            ),
          ),
        ),
        Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Center(
              child: Stack(
                children: <Widget>[
                  ClipOval(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      width: 72.0,
                      height: 72.0,
                      placeholder: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                      imageUrl: _userImg == null
                          ? (Api.BaseUrl + "default_head.jpg")
                          : (Api.BaseUrl + _userImg),
                      errorWidget: Image.asset(Config.ASSERT_HEAD_DEFAULT),
                    ),
                  ),
                  Container(
                    width: 72.0,
                    height: 72.0,
                    child: Center(
                      child: IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          _pickImage(false);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              null == user || user.userName == null ? "|" : user.userName,
              style: TextStyle(
                  fontSize: 20.0, color: Theme.of(context).canvasColor),
            ),
          ],
        )),
        Positioned(
            bottom: 30.0,
            right: 20.0,
            child: IconButton(
                icon: Icon(
                  Icons.camera_alt,
                  color: Theme.of(context).canvasColor,
                ),
                onPressed: () {
                  _pickImage(true);
                }))
      ],
    );
  }

  Future _pickImage(bool isCover) async {
    print('选择照片');
    List<AssetEntity> imgList = await PhotoPicker.pickAsset(
      context: context,
      themeColor: Theme.of(context).primaryColor,
      padding: 1.0,
      dividerColor: Colors.grey,
      disableColor: Colors.grey.shade300,
      itemRadio: 0.88,
      maxSelected: 1,
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
        setState(() {
          _loadMsg = "图片上传中...";
          _loading = true;
        });
        Http.upload(Api.URL_UPLOAD, params: f, successCallBack: (data) {
          print('上传结果：$data');
          Toast.show(context, '上传成功');
          setState(() {
            _loading = false;
            if (isCover) {
              _coverImg = "$data";
            } else {
              _userImg = "$data";
            }
          });
        }, errorCallBack: (msg) {
          setState(() {
            _loading = false;
          });
        });
      }
    });
  }

  Future _saveSetting(Store store) async {
    setState(() {
      _loading = true;
      _loadMsg = "正在保存...";
    });
    Map<String, String> params = Map();
    if (null != _userImg) {
      params["imgUrl"] = _userImg;
    }
    if (null != _coverImg) {
      params["coverImg"] = _coverImg;
    }

    params["profile"] = _profileController.text;
    params["userName"] = _userController.text;
    params["phone"] = _phoneController.text;
    params["email"] = _emailController.text;
    Http.put(Api.URL_USERINFO,
        header: {"Token": null == token ? "" : token.token},
        params: params, successCallBack: (data) {
      setState(() {
        _loading = false;
      });
      SpUtils.saveUser(json.encode(data));
      SpUtils.getUser().then((user) {
        store.dispatch(UpdateUserAction(user));
        Toast.show(context, "操作成功");
      });
    }, errorCallBack: (msg) {
      setState(() {
        _loading = false;
      });
      Toast.show(context, msg);
    });
  }
}
