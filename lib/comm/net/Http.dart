import 'dart:io';

import 'package:dio/dio.dart';

import 'Api.dart';

class Http {
  static const String _GET = "get";
  static const String _POST = "post";
  static const String _PUT = "put";
  static Options _options = new Options(
      baseUrl: Api.BaseUrl, connectTimeout: 10000, receiveTimeout: 10000);

  static Dio _dio = new Dio(_options);

  //get请求
  static Future get(String url,
      {Function successCallBack,
      Map<String, String> params,
      Map<String, String> header,
      String path,
      Function errorCallBack}) async {
    await _request(url, successCallBack,
        method: _GET,
        params: params,
        header: header,
        path: path,
        errorCallBack: errorCallBack);
  }

  //post请求
  static Future post(String url,
      {Function successCallBack,
      Map<String, String> params,
      Map<String, String> header,
      String path,
      Function errorCallBack}) async {
    _request(url, successCallBack,
        method: _POST,
        params: params,
        header: header,
        path: path,
        errorCallBack: errorCallBack);
  }

  static Future put(String url,
      {Function successCallBack,
      Map<String, String> params,
      Map<String, String> header,
      String path,
      Function errorCallBack}) async {
    _request(url, successCallBack,
        method: _PUT,
        params: params,
        header: header,
        path: path,
        errorCallBack: errorCallBack);
  }

  static Future upload(String url,
      {Function successCallBack,
      dynamic params,
      Function errorCallBack}) async {
    try {
      Response response;
      int statusCode;
      String errorMsg;
      if (null != params) {
        response = await _dio.post(url, data: params);
        statusCode = response.statusCode;
        if (statusCode < 0) {
          errorMsg = "网络请求错误,状态码:" + statusCode.toString();
          _handError(errorCallBack, errorMsg);
          return;
        }
        print('上传结果：${response.data}');
        if (successCallBack != null) {
          int code = response.data['code'];
          if (code == 0) {
            successCallBack(response.data['data']);
          } else {
            _handError(errorCallBack, response.data['msg']);
          }
        }
      }
    } catch (execption) {
      _handError(errorCallBack, execption.toString());
    }
  }

  //具体的还是要看返回数据的基本结构
  //公共代码部分
  static Future _request(String url, Function callBack,
      {String method,
      Map<String, String> params,
      Map<String, String> header,
      String path,
      Function errorCallBack}) async {
    print("<net> url :<" + method + ">" + url);

    if (params != null && params.isNotEmpty) {
      print("<net> params :" + params.toString());
    }
    if (header != null && header.isNotEmpty) {
      print("<net> header :" + header.toString());
    }

    String errorMsg = "";
    int statusCode;

    try {
      Response response;
      _dio.options.contentType =
          ContentType.parse("application/x-www-form-urlencoded");
      if (header != null && header.isNotEmpty) {
        _dio.options.headers = header;
      }
      if (path != null) {
        _dio.options.path = path;
      }
      if (method == _GET) {
        //组合GET请求的参数
        if (params != null && params.isNotEmpty) {
          StringBuffer sb = new StringBuffer("?");
          params.forEach((key, value) {
            sb.write("$key" + "=" + "$value" + "&");
          });
          String paramStr = sb.toString();
          paramStr = paramStr.substring(0, paramStr.length - 1);
          url += paramStr;
        }
        response = await _dio.get(url);
      } else if (method == _PUT) {
        if (params != null && params.isNotEmpty) {
          response = await _dio.put(url, data: params);
        } else {
          response = await _dio.put(url);
        }
      } else {
        if (params != null && params.isNotEmpty) {
          response = await _dio.post(url, data: params);
        } else {
          response = await _dio.post(url);
        }
      }

      statusCode = response.statusCode;
      print('response=' + response.data.toString());
      //处理错误部分
      if (statusCode < 0) {
        errorMsg = "网络请求错误,状态码:" + statusCode.toString();
        _handError(errorCallBack, errorMsg);
        return;
      }

      if (callBack != null) {
        int code = response.data['code'];
        if (code == 0) {
          callBack(response.data['data']);
        } else {
          _handError(errorCallBack, response.data['msg']);
        }
      }
    } catch (exception) {
      _handError(errorCallBack, exception.toString());
    }
  }

  //处理异常
  static void _handError(Function errorCallback, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(errorMsg);
    }
    print("<net> errorMsg :" + errorMsg);
  }
}
